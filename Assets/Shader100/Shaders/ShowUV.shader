Shader "Shader100/002_ShowUV"
{
    Properties { }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
        Cull Off

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(vertex.xyz);
                o.uv = uv;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 col = float4(i.uv, 0, 0);
                return col;
            }
            ENDHLSL
        }
    }
}
