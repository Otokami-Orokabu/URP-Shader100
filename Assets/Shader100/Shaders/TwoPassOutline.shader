Shader "Shader100/004_TwoPassOutline"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _MainColor ("BaseColor", color) = (1, 1, 1, 1)

        _OutLineColor ("OutlineColor", color) = (1, 1, 1, 1)
        _Scale ("OutlineScale", Range(0, 0.1)) = 0.005
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
            float3 normal : NORMAL;
        };

        struct v2f
        {
            float2 uv : TEXCOORD0;
            float4 vertex : SV_POSITION;
        };

        sampler2D _MainTex;
        CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            float4 _OutLineColor;  // Moved the _Color definition here
            float4 _MainColor;
            float _Scale;
        CBUFFER_END

        // First pass
        v2f vert1(appdata v)
        {
            v2f o;
            float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
            float3 pos = v.vertex.xyz + norm * _Scale;
            o.vertex = TransformObjectToHClip(pos);
            return o;
        }

        float4 frag1(v2f i) : SV_Target
        {
            return _OutLineColor;
        }

        // Second pass
        v2f vert2(appdata v)
        {
            v2f o;
            o.vertex = TransformObjectToHClip(v.vertex.xyz);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            return o;
        }

        float4 frag2(v2f i) : SV_Target
        {
            float4 color = tex2D(_MainTex, i.uv) * _MainColor;
            return color;
        }
        ENDHLSL

        // First pass Outline
        Pass
        {
            Name "OUTLINE"

            Tags { "LightMode" = "UniversalForward" }
            Cull Front

            HLSLPROGRAM
            #pragma vertex vert1
            #pragma fragment frag1
            ENDHLSL
        }

        // Second pass Render
        Pass
        {
            Name "Base"

            Blend SrcAlpha OneMinusSrcAlpha
            HLSLPROGRAM
            #pragma vertex vert2
            #pragma fragment frag2
            ENDHLSL
        }
    }
}
