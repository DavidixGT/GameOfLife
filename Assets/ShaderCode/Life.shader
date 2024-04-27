Shader "Unlit/Life"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [MaterialToggle] _ShowNextStep("Show next step", Float) = 0
        _Step("Step", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct appdata members testx,testy)
#pragma exclude_renderers d3d11
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #define UNITY_MATRIX_MVP mul(unity_MatrixVP, unity_ObjectToWorld)

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _ShowNextStep;
            float _Step;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                o.worldPos = mul (unity_ObjectToWorld, v.vertex);
                return o;
            }
            
            float random(float2 p)
            {
                /*if (p.x < 0 || p.y < 0 || p.x >= 1 || p.y >= 1)
                    return 0;*/

                float2 K1 = float2(
                                23.14069263277926, // e^pi (Gelfond's constant)
                                2.665144142690225 // 2^sqrt(2) (Gelfondâ€“Schneider constant)
                                );
                float rand = frac( cos( dot(p,K1) ) * 12345.6789 );
                rand = floor(rand + 0.15);

                if (rand > 1.)
                    rand = 1.;
                    
                return rand;
            }

            float debug(float uv)
            {
                /*if ((uv.x < 0.7) || (uv.y < 0.7))
                    uv = float2(0, 0);
                else
                {
                    float2 uv2 = uv;
                    uv = float2(ps, ps);
                    if (uv2.x == 0.9 && uv2.y == 0.8)
                    {
                        //uv = float2(0, 1);
                        if (svalue == 3)
                            uv = float2(0, 1);
                        else
                            uv = float2(1, 0);
                    }
                }*/
                return 0;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float res = 10.;
                float2 uv = float2(i.uv.x, i.uv.y);
                uv *= res;
                uv.x = floor(uv.x);
                uv.y = floor(uv.y);
                uv /= res;
                float scale = 1. / res;

                float p1 = random(float2(uv.x - scale, uv.y + scale));
                float p2 = random(float2(uv.x, uv.y + scale));
                float p3 = random(float2(uv.x + scale, uv.y + scale));
                float p4 = random(float2(uv.x + scale, uv.y));
                float p5 = random(float2(uv.x + scale, uv.y - scale));
                float p6 = random(float2(uv.x, uv.y - scale));
                float p7 = random(float2(uv.x - scale, uv.y - scale));
                float p8 = random(float2(uv.x - scale, uv.y));

                float ps = random(float2(uv.x, uv.y));

                float svalue = (p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8);

                uv = float2(ps, ps);

                if (_ShowNextStep == 1)
                {
                    if (svalue > 3)
                        uv = float2(0, 0);
                    else if(svalue < 2)
                        uv = float2(0, 0);
                    else if(svalue == 3)
                        uv = float2(1, 1);
                }
                return float4(uv.x, uv.y, uv.y, 1);
            }
            ENDCG
        }
    }
}
