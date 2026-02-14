# Build the Flutter web application
FROM ghcr.io/cirruslabs/flutter:latest AS build

WORKDIR /app

# Copy the entire project structure
COPY . .

# Get dependencies for all packages in the packages directory
RUN for dir in packages/*; do \
    if [ -f "$dir/pubspec.yaml" ]; then \
    echo "Getting dependencies for $dir" && \
    cd "/app/$dir" && flutter pub get && cd /app; \
    fi \
    done

# Navigate to the web app directory
WORKDIR /app/apps/super_up_app

# Get dependencies and build
RUN flutter pub get
RUN flutter build web --release --no-tree-shake-icons

# Serve with lightweight Python server
FROM python:3.11-alpine

WORKDIR /usr/share/app

# Copy built files
COPY --from=build /app/apps/super_up_app/build/web .

# Expose port
EXPOSE 8080

# Serve the static files
CMD ["python", "-m", "http.server", "8080"]