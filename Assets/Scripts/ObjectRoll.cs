using System;
using UnityEngine;
using UnityEngine.Tilemaps;

public class ObjectRoll : MonoBehaviour
{
    [SerializeField] private float _angleSpeed = 60;

    [SerializeField] private Vector3 _axis = Vector3.up;

    private Transform _transform;

    private void Awake()
    {
        _transform = transform;
    }

    private void Update()
    {
        var angle = _angleSpeed * Time.deltaTime;

        _transform.rotation *= Quaternion.AngleAxis(angle, _axis);
    }
}
