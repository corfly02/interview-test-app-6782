import requests
from PIL import Image, ImageSequence
from io import BytesIO

# Constants
NUM_FRAMES = 5  # Number of frames in the GIF
GIF_FILENAME = "cat_animation.gif"
CAT_API_URL = "https://api.thecatapi.com/v1/images/search?size=small"

def fetch_cat_image():
    """Fetch a cat image from The Cat API."""
    try:
        response = requests.get(CAT_API_URL)
        response.raise_for_status()
        image_url = response.json()[0]['url']
        img_response = requests.get(image_url)
        img_response.raise_for_status()
        return Image.open(BytesIO(img_response.content))
    except Exception as e:
        print(f"Failed to fetch image: {e}")
        return None

def create_cat_gif():
    """Creates an animated cat GIF."""
    frames = []

    for _ in range(NUM_FRAMES):
        cat_img = fetch_cat_image()
        if cat_img:
            frames.append(cat_img.resize((300, 300)))  # Resize for consistency

    if frames:
        frames[0].save(
            GIF_FILENAME,
            save_all=True,
            append_images=frames[1:],
            duration=500,  # 500ms per frame
            loop=0
        )
        print(f"GIF saved as {GIF_FILENAME} 🎉")
    else:
        print("No images available to create a GIF.")

if __name__ == "__main__":
    create_cat_gif()
