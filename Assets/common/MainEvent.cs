using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainEvent : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void DoAction(int idx){
		Debug.Log (idx);
		SceneManager.LoadScene (idx + 1);
	}
}
