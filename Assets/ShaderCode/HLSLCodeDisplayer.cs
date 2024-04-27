using UnityEngine;
using System.Threading.Tasks;

public class HLSLCodeDisplayer : MonoBehaviour
{
    public ComputeShader computeShader;

    private RenderTexture resultTexture;
    [SerializeField]
    private Texture2D sourceTexture;
    [SerializeField]
    private int _width;
    [SerializeField]
    private int _height;
    [SerializeField]
    private bool _ShowNextStep;
    private bool _IsTextureCreated = false;
    private int kernelID = 0;
    public Material displayMaterial;

    private void Start()
    {
        CreateRenderTexture();
    }

    private void FixedUpdate()
    {
        //await Task.Delay(3000);
        UpdateTexture();

    }

    private void CreateRenderTexture()
    {
        if (_IsTextureCreated)
            return;
        resultTexture = new RenderTexture(_width, _height, 0);
        resultTexture.enableRandomWrite = true;
        resultTexture.filterMode = FilterMode.Point;
        resultTexture.Create();

        /*RenderTexture.active = resultTexture;
        Graphics.Blit(sourceTexture, resultTexture);
        RenderTexture.active = null;*/
    }

    private void UpdateTexture()
    {

        CreateRenderTexture();
        // Get the kernel ID from the Compute Shader
        kernelID = computeShader.FindKernel("CSMain");

        // Set the RenderTexture as a UAV in the Compute Shader
        computeShader.SetTexture(kernelID, "Result", resultTexture);
        computeShader.SetInt("_width", _width);
        computeShader.SetInt("_height", _height);
        computeShader.SetBool("_ShowNextStep", _ShowNextStep);
        computeShader.SetBool("_IsTextureCreated", _IsTextureCreated);

        // Dispatch the Compute Shader
        computeShader.Dispatch(kernelID, _width / 8, _height / 8, 1);
        displayMaterial.mainTexture = resultTexture;
        _IsTextureCreated = true;
    }
}
