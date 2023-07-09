Shader "Shader100/003_ScreenPosition"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
        Cull Off

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#pragma target 3.0

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct v2f
            {
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
            CBUFFER_END

            v2f vert(
                float4 vertex : POSITION, // 頂点位置
                float2 uv : TEXCOORD0, // テクスチャ座標入力
                out float4 outpos : SV_POSITION // クリップスペース
            )
            {
                v2f o;
                outpos = TransformObjectToHClip(vertex.xyz);
                o.uv = uv;
                return o;
            }

            float4 frag(v2f i, float4 screenPos : VPOS) : SV_Target
            {
                // screenPos.xy はピクセルの整数の座標を含みます
                // それを使用して、4×4 のピクセルの
                // レンダリングを行わない碁盤模様を実装します

                // 碁盤模様の 4x4 のピクセルの
                // checker 値は負の値です
                screenPos.xy = floor(screenPos.xy * 0.25) * 0.5;
                float checker = -frac(screenPos.r + screenPos.g);

                // 値が負の場合、HLSL の clip はレンダリングを行いません
                clip(checker);

                // 維持されたピクセルが、テクスチャを読み込み、それを出力します
                float4 c = tex2D(_MainTex, i.uv);
                return c;
            }
            ENDHLSL
        }
    }
}
