Shader "Shader100/005_LerpColor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)

        _LerpColorWhite ("Color White", Color) = (1, 1, 1, 1)
        _LerpColorBlack ("Color Black", Color) = (0, 0, 0, 1)

        [Toggle(_USE_LERP_COLOR)]_UseLerpColor ("Use Lerp Color", Float) = 0

        // Blend
        [Enum(UnityEngine.Rendering.BlendMode)]_BlendSrc ("Blend Src", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]_BlendDst ("Blend Dst", Float) = 10
        [Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode ("ZTest Mode", Float) = 0
        [Toggle]_ZWriteParam ("ZWrite", Float) = 0
        [Enum(UnityEngine.Rendering.CullMode)]_CullMode ("Cull Mode", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Shaders/PostProcessing/Common.hlsl"

        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float2 uv : TEXCOORD0;
            float4 vertex : SV_POSITION;
        };

        sampler2D _MainTex;
        CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            float4 _BaseColor;
            float4 _LerpColorWhite;
            float4 _LerpColorBlack;
        CBUFFER_END

        v2f vert(appdata v)
        {
            v2f o;
            o.vertex = TransformObjectToHClip(v.vertex.xyz);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            return o;
        }

        float4 frag(v2f i) : SV_Target
        {
            float4 col = tex2D(_MainTex, i.uv) * _BaseColor;
            #if _USE_LERP_COLOR
                float lum = Luminance(col.rgb);  //テクスチャの色から輝度を計算
                col = lerp(_LerpColorBlack, _LerpColorWhite, lum); //黒に入れる色、白に入れる色を輝度で補間する
            #endif
            return col;
        }
        ENDHLSL

        // pass 1
        Pass
        {
            Blend [_BlendSrc][_BlendDst]
            ZTest [_ZTestMode]
            ZWrite [_ZWriteParam]
            Cull [_CullMode]

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ _USE_LERP_COLOR
            ENDHLSL
        }
    }
    CustomEditor "LerpColorInspector"
}
