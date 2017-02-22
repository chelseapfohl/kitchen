Shader "Reflective/Diffuse Reflection Spec Transparent" {
	Properties {
		_Color ("基本色", Color) = (1,1,1,1)
		_SpecColor ("スペキュラー色", Color) = (0.5, 0.5, 0.5, 0)
		_Shininess ("輝度", Range (0.01, 1)) = 0.078125
		_ReflectColor ("反射色", Color) = (1,1,1,0.5)
		_MainTex ("テクスチャ(RGB)+反射強度(A)", 2D) = "white" {} 
		_Cube ("反射キューブマップ", Cube) = "_Skybox" { TexGen CubeReflect }
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
