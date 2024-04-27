Shader "GrassWaving/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#pragma geometry geo
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

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
            };


            sampler2D _MainTex;
            float4 _MainTex_ST;

            /*struct geometryOutput
            {
                float4 pos : SV_POSITION;
            };
            [maxvertexcount(3)]
            void geo(triangle float4 IN[3] : SV_POSITION, inout TriangleStream<geometryOutput> triStream)
            {
                geometryOutput o;

o.pos = float4(0.5, 0, 0, 1);
triStream.Append(o);

o.pos = float4(-0.5, 0, 0, 1);
triStream.Append(o);

o.pos = float4(0, 1, 0, 1);
triStream.Append(o);
            }*/

            [maxvertexcount(0)]
            v2f vert (appdata v, uint id : SV_VertexID)
            {
                v2f o;
                
                // Assign different vertex positions based on id
                if (id == 0)
                    o.vertex = UnityObjectToClipPos(float4(0.5, 0, 0, 1));
                else if (id == 1)
                    o.vertex = UnityObjectToClipPos(float4(-0.5, 0, 0, 1));
                else if (id == 2)
                    o.vertex = UnityObjectToClipPos(float4(0, 1, 0, 1));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
