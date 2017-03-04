Shader "Unlit/DistortBackground"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DistortionTex ("Distortion Map", 2D) = "white" {}
		_Intensity ("Intensity", Range (0.0, 10.0)) = 1.0
		[Toggle(HORIZONTAL)] _HORIZONTAL ("Distort horizontally", Float) = 1.0
		[Toggle(VERTICAL)] _VERTICAL ("Distort vertically", Float) = 1.0
	}
	SubShader
	{
		// Draw ourselves after all opaque geometry
        Tags { "Queue" = "Transparent" }
		
		GrabPass
		{
			"_BackgroundTexture"
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature HORIZONTAL
			#pragma shader_feature VERTICAL
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				half2 screenuv : TEXCOORD1;
			};

			sampler2D _BackgroundTexture;
			sampler2D _BackgroundTexture_ST;
			sampler2D _DistortionTex;
			float _Intensity;
			float4 _DistortionTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				half4 screenpos = ComputeGrabScreenPos(o.vertex);
                o.screenuv = screenpos.xy / screenpos.w;
				return o;
			}
			
			fixed3 frag (v2f IN) : SV_Target
			{
				float2 uv = IN.screenuv;
				float2 uvDistored = float2(uv);
				uvDistored.x = fmod(uvDistored.x + _Time.x, 1);
				uvDistored.y = uvDistored.y;
				fixed3 colDistored = tex2D(_DistortionTex, uvDistored).rgb;
				
				colDistored.x = (colDistored.x * 2 - 1) / 100;
				colDistored.y = (colDistored.y * 2 - 1) / 100;

				#if HORIZONTAL
				uv.x = uv.x + colDistored.x * _Intensity;
				#endif

				#if VERTICAL
				uv.y = uv.y + colDistored.y * _Intensity;
				#endif

				fixed3 col = tex2D(_BackgroundTexture, uv).rgb;

				return col;
			}
			ENDCG
		}
	}
}
