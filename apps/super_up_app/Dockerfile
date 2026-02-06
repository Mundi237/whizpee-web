# Stage 1: Build the Flutter web application
FROM ghcr.io/cirruslabs/flutter:3.27.0 AS build

WORKDIR /app

# Copy the entire project to maintain relative path dependencies (packages/)
COPY . .

# Change directory to the web app
WORKDIR /app/apps/super_up_app

# Get dependencies
RUN flutter pub get

# Build the web application
# --release for production build
# --no-tree-shake-icons to avoid icon font issues in some cases, though usually optional
RUN flutter build web --release --no-tree-shake-icons

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Copy the build artifacts from the build stage
COPY --from=build /app/apps/super_up_app/build/web /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
