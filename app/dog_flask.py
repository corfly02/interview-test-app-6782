import os
import requests
from flask import Flask, jsonify, send_file
from PIL import Image
from io import BytesIO

app = Flask(__name__)

# Dog API
DOG_API_URL = "https://dog.ceo/api/breeds/image/random"
NUM_FRAMES = 5
GIF_FILENAME = "dog_animation.gif"

def fetch_dog_image():
    """Fetch a random dog image from the Dog API."""
    try:
        response = requests.get(DOG_API_URL)
        response.raise_for_status()
        image_url = response.json()['message']
        img_response = requests.get(image_url)
        img_response.raise_for_status()
        return Image.open(BytesIO(img_response.content))
    except Exception as e:
        print(f"Failed to fetch dog image: {e}")
        return None

def create_dog_gif():
    """Creates an animated dog GIF."""
    frames = []
    
    for _ in range(NUM_FRAMES):
        dog_img = fetch_dog_image()
        if dog_img:
            frames.append(dog_img.resize((300, 300)))  # Resize for consistency

    if frames:
        frames[0].save(
            GIF_FILENAME,
            save_all=True,
            append_images=frames[1:],
            duration=500,
            loop=0
        )
        print(f"GIF saved as {GIF_FILENAME}")
        return GIF_FILENAME
    else:
        print("No images available to create a GIF.")
        return None

@app.route("/")
def home():
    return jsonify({"message": "Welcome to the Dog GIF Generator API! Use /generate to create a GIF."})

@app.route("/generate")
def generate_dog_gif():
    """Generate a dog GIF and return a message."""
    gif_path = create_dog_gif()
    if gif_path:
        return jsonify({"message": "Dog GIF generated! View it at /gif"})
    return jsonify({"error": "Failed to create GIF"}), 500

@app.route("/gif")
def get_gif():
    """Serve the latest generated GIF."""
    if os.path.exists(GIF_FILENAME):
        return send_file(GIF_FILENAME, mimetype="image/gif")
    return jsonify({"error": "No GIF available"}), 404

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
