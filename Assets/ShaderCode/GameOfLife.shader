Shader "Custom/GameOfLife"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
            float testx;
            float testy;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        float random(float2 p)
        {
            float2 K1 = float2(
                            23.14069263277926, // e^pi (Gelfond's constant)
                            2.665144142690225 // 2^sqrt(2) (Gelfondâ€“Schneider constant)
                            );
            return frac( cos( dot(p,K1) ) * 12345.6789 );
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 uv = float3(IN.uv_MainTex.x, IN.uv_MainTex.y, 0);
            float2 uv2 = float2(uv.x, uv.y);

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            if ((uv2.x == 0) && (uv.y == 0))
            {
                IN.testx = 0;
                IN.testy = 0;
            }
            if (((uv.x > IN.testx) && (uv.x < (IN.testx + 0.01))))
            {
                if ((uv.y >  IN.testy) && (uv.y < (IN.testy + 0.01)))
                {
                    float rand = float(random(float2(0.01, 0.01)));
                    uv = float3(rand, rand, rand);
                }
            }

            /*if (((uv.x > 0.01) && (uv.x < 0.02)) && ((uv.y > 0) && (uv.y <  0.01)))
            {
                float rand = float(random(float2(0.02, 0.01)));
                uv = float3(rand, rand, rand);
            }*/

            o.Albedo = uv;

            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
