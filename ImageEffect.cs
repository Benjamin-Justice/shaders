using UnityEngine;

namespace Assets
{
    public class ImageEffect : MonoBehaviour
    {
        public Material mat;

        void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            Graphics.Blit(src, dest, mat);
        }
    }
}
