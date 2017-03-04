// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Cull with Discard" {
	SubShader {
		Pass {
			Cull Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			struct vertexInput {
				float4 vertex : POSITION;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 posInObjectCoords : TEXCOORD0;
				float4 posInWorldCoords : TEXCOORD1;
			};

			vertexOutput vert(vertexInput input) 
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
				output.posInWorldCoords = mul(unity_ObjectToWorld, input.vertex);
				output.posInObjectCoords = input.vertex;

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				if (input.posInWorldCoords.y > 0.0)
				{
					discard;
				}
				return float4(0.0, 1.0, 0.0, 1.0);
			}

			ENDCG
		}
	}
}