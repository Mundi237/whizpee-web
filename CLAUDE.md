# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Structure

SuperUp is a Flutter-based social media chat application with a modular monorepo structure managed by Melos. The project consists of:

### Main Applications
- **apps/super_up_app/**: Main Flutter chat application (WhatsApp-like social media app)
- **apps/super_up_admin/**: Admin panel Flutter web application for managing users and content

### Packages Architecture
The project follows a micropackage architecture with domain-specific packages:

#### VChat SDK Core Packages
- **v_chat_sdk_core/**: Core SDK with controllers, models, APIs, and socket management
- **v_chat_message_page/**: Message UI components and conversation management
- **v_chat_room_page/**: Room/chat list UI and room management
- **v_chat_input_ui/**: Message input UI components (text field, voice recording, media)
- **v_chat_media_editor/**: Media editing capabilities (image/video compression, trimming)
- **v_chat_firebase_fcm/**: Firebase push notification integration
- **v_chat_receive_share/**: Receiving shared content from other apps
- **v_chat_call_service/**: Call functionality and foreground service management

#### Application Packages
- **super_up_core/**: Shared core functionality, widgets, themes, and utilities
- **s_translation/**: Internationalization with support for 17 languages

## Development Commands

### Initial Setup
```bash
# Install Melos globally
dart pub global activate melos

# Bootstrap all packages (run pub get for all packages)
melos bs
```

### Build Commands
```bash
# Generate code for admin app
melos run g_admin

# Generate code for main app  
melos run g_app

# Build Android APK
melos run build_android

# Build for Android with distributor
melos run build_a

# Build for macOS
melos run build_mac

# Build for web (main app)
melos run build_web

# Build admin panel for web
melos run build_admin
```

### Code Quality Commands
```bash
# Run analyzer across all packages
melos run analyze

# Format code across all packages
melos run format

# Apply auto-fixes
melos run fix
```

### Testing
- For Flutter apps: Test compilation with `flutter build apk` or similar build commands
- Do not run on device unless specifically requested
- Complex features should include test.js files for validation

## Architecture Overview

### VChat Integration
The app integrates VChat SDK through `VChatController.init()` with:
- **Base URL**: Configured via `SConstants.sApiBaseUrl`
- **Push Notifications**: Firebase FCM integration 
- **Navigation**: Custom `VNavigator` with platform-specific routing
- **Message Configuration**: Configurable media size, compression, call permissions

### State Management
- Uses **ValueNotifier** and **ValueListenableBuilder** for reactive state management
- Controllers follow singleton patterns with dependency injection via GetIt

### Multi-Platform Support
- **Mobile**: iOS/Android with full feature set including calls
- **Web**: Progressive web app version
- **Desktop**: macOS/Windows support with adaptive UI using responsive_framework

### Key Features
- End-to-end messaging with media support
- Voice/video calling via Agora
- Story functionality (text and media stories)
- Group chats, broadcasts, and direct messages  
- Media compression and editing
- Push notifications and background services
- Multi-language support (17 languages)
- Admin panel for user/content management

## Development Guidelines

### Code Generation
- Run build_runner after modifying Chopper API definitions
- Use `melos run g_admin` or `melos run g_app` based on which app you're working on

### Package Dependencies
- Local packages use `path:` dependencies pointing to `../../packages/`
- External packages should use latest stable versions
- Check existing packages before adding new dependencies

### Testing Strategy
- Compile code to ensure it works (`flutter build apk`)
- Create test.js files for complex NestJS-related features
- Avoid running on physical devices unless explicitly requested

### Platform Considerations
- Mobile-specific features (calls, foreground services) are conditionally enabled
- Web version has limited call functionality
- Desktop versions use window_manager for window controls

## Key Configuration Files

- **melos.yaml**: Monorepo configuration and scripts
- **apps/super_up_app/lib/v_chat_v2/v_chat_config.dart**: VChat SDK configuration
- **packages/super_up_core/lib/src/s_constants.dart**: App constants and configuration
- **Android signing**: Uses key.properties for release builds
- **iOS/macOS**: Configured for App Store distribution with proper entitlements

## Important Notes

- The project uses custom navigation patterns via `AppNavigation.toPage()`
- Media handling includes compression, trimming, and platform-specific optimizations
- Socket connections are managed centrally through VChatController
- The app supports both light and dark themes with platform-specific styling