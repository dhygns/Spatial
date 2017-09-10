Shader "Custom/Effect00" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Ratio ("Ratio", Range(0, 1)) = 0.5
	}
	SubShader {
        Tags {"Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _Ratio;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END



		//get Random function
		float rand(float2 co){
			return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
		}

		//get Arrow for perlin noise
		float2 perlinArrow(float2 uv, float t) {
			uv = frac(uv);
			const float PI = 3.1415921685;
			float rad = PI * rand(uv + 0.01) * 2.0 + t * 2.0;
			float len = 0.6 + 0.4 * sin(rand(uv + 0.02) + t * 1.0) ;
			return float2(len * sin(rad), len * cos(rad));
		}

		float perlinMix(float lo, float ro, float t) {
			return lo + smoothstep(0.0, 1.0, t) * (ro - lo);
		}

		//get grid for perlin noise.
		float perlinGrid(float2 uv, float t) {
			//seperate ecah grid
			const float2 uvscale = float2(3.0, 3.0);
			const float2 griduv = floor(uv * uvscale) / uvscale;

			const float2 grid00 = perlinArrow(griduv + float2(0.0, 0.0) / uvscale, t);
			const float2 grid10 = perlinArrow(griduv + float2(1.0, 0.0) / uvscale, t);
			const float2 grid01 = perlinArrow(griduv + float2(0.0, 1.0) / uvscale, t);
			const float2 grid11 = perlinArrow(griduv + float2(1.0, 1.0) / uvscale, t);

			const float2 uv00 = (uv - griduv) * uvscale;
			const float2 uv10 = float2(-1.0 + uv00.x, 0.0 + uv00.y);
			const float2 uv01 = float2( 0.0 + uv00.x,-1.0 + uv00.y);
			const float2 uv11 = float2(-1.0 + uv00.x,-1.0 + uv00.y);



			const float flow00 = dot(grid00, uv00);
			const float flow10 = dot(grid10, uv10);
			const float flow01 = dot(grid01, uv01);
			const float flow11 = dot(grid11, uv11);
			
			return perlinMix(
				perlinMix(flow00, flow10, uv00.x),
				perlinMix(flow01, flow11, uv00.x),
				uv00.y) * 0.5 + 0.5;
		}

		//get perlin Noise 
		float perlin(float2 uv) {
			return perlinGrid(uv, _Time.y);
		}


		void surf (Input IN, inout SurfaceOutputStandard o) {

			// Albedo comes from a texture tinted by color
			float cuff = smoothstep(_Ratio - 0.01, _Ratio + 0.01, perlin(IN.uv_MainTex));
			float cufc = 1.0 - abs(cuff - 0.5) * 2.0;
			float4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			c = lerp(c , float4(0.25, 0.25, 1.0, 1.0), cufc);
			o.Albedo = c.rgb;

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a * cuff;
//			o.Alpha = perlin(In.uv_MainTex);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
