# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy only requirements.txt first (for caching)
COPY Backend/requirements.txt .

# Install dependencies
RUN pip install --upgrade pip

RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY Backend /app/Backend
COPY Frontend /app/Frontend

# Set environment variables for Flask
ENV FLASK_APP=Backend/app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000

# Expose the port Flask runs on
EXPOSE 5000

# Run the Flask application
CMD ["flask", "run"]
