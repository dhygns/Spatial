using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class objMotionEffect : MonoBehaviour {


	//privates Methods for controlling each vertices
	private Material _material;
	private Mesh _mesh;

	//Setup about each vertices original position
	private Vector3[] _orins;
	private Vector3[] _velos; 

	// setup before Start called
	void Awake() {
		this._material = this.GetComponent<MeshRenderer> ().material;
		this._mesh = GetComponent<MeshFilter> ().mesh;
		this._orins = this._mesh.vertices.Clone () as Vector3[];
		this._velos = new Vector3[this._mesh.vertices.Length];
	}

	// Use this for initialization
	void Start () {
		Vector3[] vertices = _mesh.vertices;

		for (int idx = 0; idx < vertices.Length; idx++) {
			vertices [idx].Set (0.0f, 0.0f, 0.0f);
			this._velos [idx].Set (
				Random.Range (0.2f, 1.0f) * 0.01f,
				Random.Range (0.2f, 1.0f) * 0.01f,
				Random.Range (0.2f, 1.0f) * 0.01f
			);
		}

		_mesh.vertices = vertices;
		_mesh.RecalculateBounds ();
	}
	  
	// Update is called once per frame
	void Update () {

//		this._material.SetFloat ("Time", Time.time);
		Vector3[] vertices = _mesh.vertices;

		for (int idx = 0; idx < vertices.Length; idx ++){
			vertices [idx].x += (this._orins [idx].x - vertices [idx].x) * Time.deltaTime;
			vertices [idx].y += (this._orins [idx].y - vertices [idx].y) * Time.deltaTime;
			vertices [idx].z += (this._orins [idx].z - vertices [idx].z) * Time.deltaTime;
			_mesh.vertices = vertices;
			_mesh.RecalculateBounds ();
		}
	}
}
