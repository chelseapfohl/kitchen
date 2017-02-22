Shader "Reflective/Diffuse Reflection Spec Transparent" {
	Properties {
		_Color ("��{�F", Color) = (1,1,1,1)
		_SpecColor ("�X�y�L�����[�F", Color) = (0.5, 0.5, 0.5, 0)
		_Shininess ("�P�x", Range (0.01, 1)) = 0.078125
		_ReflectColor ("���ːF", Color) = (1,1,1,0.5)
		_MainTex ("�e�N�X�`��(RGB)+���ˋ��x(A)", 2D) = "white" {} 
		_Cube ("���˃L���[�u�}�b�v", Cube) = "_Skybox" { TexGen CubeReflect }
	}
	SubShader {
		LOD 300
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transperant" }


		CGPROGRAM
		#pragma surface surf BlinnPhong alpha

		sampler2D _MainTex;
		samplerCUBE _Cube;

		fixed4 _Color;
		fixed4 _ReflectColor;
		half _Shininess;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 c = tex * _Color;
			o.Albedo = c.rgb;
			o.Gloss = tex.a;
			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
			reflcol *= tex.a;
			o.Alpha = c.a;
			o.Specular = _Shininess;
			o.Emission = reflcol.rgb * _ReflectColor.rgb * tex.a;
			
		}
		ENDCG
	}
		
	FallBack "Reflective/VertexLit"
} 
