I'll help you enhance your README.md file to make it more comprehensive and developer-friendly:

```markdown
# FootballHero

FootballHero is a video-sharing platform built with Flutter and Supabase, designed for football players, coaches, and youth teams. The app follows a lean and efficient development approach, prioritizing essential features, video storage optimization, and cost-effective scalability.

## Development Framework

### Frontend

- **Framework**: Flutter (>=3.5.0)
- **Language**: Dart
- **Testing**:
  - Integration Testing: Flutter integration test package
  - Unit Testing: Mockito

### Backend

- **Platform**: Supabase
  - Authentication: Supabase Auth with email verification and password reset
  - Database: PostgreSQL
  - Storage: Supabase Storage for media files and coach certificates

### Additional Services

- **Notifications**: Firebase Cloud Messaging
- **Content Moderation**: Google Perspective API
- **Payment Processing**: Isracard/PayPlus integration
- **Security Testing**: OWASP ZAP for CSRF & XSS detection

## Features

- **User Roles**: Player, Parent, Coach, Community Manager, Mentor
- **Authentication**: Email-based login with password reset functionality
- **Deep Linking**: Support for password reset and app invitation flows
- **Team Management**: Team registration and player association
- **Favorites**: Ability to select and follow favorite football clubs
- **Localization**: Full Hebrew (RTL) language support

## Version Control

- **Git Repository**: [https://github.com/yourusername/football_hero.git](https://github.com/yourusername/football_hero.git)
- **Branching Strategy**: Structured branching strategy for feature development

## Getting Started

### Prerequisites

- Flutter SDK (>=3.5.0)
- Dart SDK
- Supabase account and project
- Android Studio or VS Code

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/football_hero.git
   cd football_hero
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the project root with your Supabase credentials (see Environment Variables section below)

4. Run the app:
   ```bash
   flutter run
   ```

### Building for Release

1. Create a keystore file:
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Set up your `key.properties` file in the android directory
   
3. Build the release APK:
   ```bash
   flutter build apk --release
   ```

### Software Versions Used

The following software versions were tested and confirmed to work together:

- **Flutter**: 3.27.2  
- **Dart**: 3.5.4  
- **Supabase Flutter SDK**: 2.8.1  
- **Gradle**: 8.11.1  
- **Android Studio**: Flamingo 2024.2  
- **Java**: Eclipse Adoptium JDK 17.0.13.11  
- **flutter_dotenv**: 5.2.1  

### Environment Variables
- Example `.env`:
  ```env
  SUPABASE_URL=https://your-supabase-url.supabase.co
  SUPABASE_ANON_KEY=your-supabase-anon-key
  ENV=development
  LOG_INFO=true
  LOG_WARNING=true
  LOG_ERROR=true
  ```

### Recommended Production Settings
- For Production Environment:
  ```env
  ENV=production
  LOG_INFO=false
  LOG_WARNING=true
  LOG_ERROR=true
  ```

## Deep Linking

The app supports deep linking for password reset and onboarding flows:

- Custom URL Scheme: `hoodhero://` and `footballhero://`
- Example deep link: `hoodhero://reset-password?code=123456`

## Project Structure

- `lib/` - Main application code
  - `screens/` - UI screens for different parts of the app
  - `state/` - State management
  - `logger/` - Logging utilities
  - `main.dart` - Entry point with routing configuration

## Security Considerations

- All error logs are sanitized to prevent leaking sensitive information
- User IDs and personal information are not exposed in logs
- Password reset tokens are handled securely
- Form validation is robust to prevent injection attacks

