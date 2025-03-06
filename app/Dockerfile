# Use an official lightweight Python image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the script and requirements
COPY cat_gif_generator.py .
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run the script when the container starts
CMD ["python", "cat_gif_generator.py"]
