# Stage 1: Build Stage
FROM python:3.9 AS build-stage

# Set the working directory inside the build container
WORKDIR /app/backend

# Copy only the requirements file first to leverage caching
COPY requirements.txt /app/backend

# Install the dependencies
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Production Stage
FROM python:3.9-slim AS production-stage

# Set the working directory for the production image
WORKDIR /app/backend

# Copy only the necessary files from the build stage
COPY --from=build-stage /root/.local /root/.local
COPY . /app/backend

# Set environment variables to prioritize the installed packages in /root/.local
ENV PATH=/root/.local/bin:$PATH

# Expose the port the app will run on
EXPOSE 8000

# Run the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
