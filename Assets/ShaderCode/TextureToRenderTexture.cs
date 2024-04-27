using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureToRenderTexture : MonoBehaviour
{
    [SerializeField]
    private Texture2D sourceTexture;
    [SerializeField]
    private RenderTexture resultTexture;
    public Material displayMaterial;

    private void Start()
    {
        CreateRenderTexture();
        displayMaterial.mainTexture = resultTexture;
    }
    private void CreateRenderTexture()
    {
        resultTexture = new RenderTexture(32, 32, 0);
        RenderTexture.active = resultTexture;
        resultTexture.filterMode = FilterMode.Point;
        Graphics.Blit(sourceTexture, resultTexture);
        RenderTexture.active = null;
    }
}
