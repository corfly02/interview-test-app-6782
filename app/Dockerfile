FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the script and requirements
COPY cat_gif_generator.py .
COPY ./app/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "cat_gif_generator.py"]
