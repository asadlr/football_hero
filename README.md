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
  - Authentication: Supabase Auth
  - Database: PostgreSQL
  - Storage: Supabase Storage

### Additional Services

- **Notifications**: Firebase Cloud Messaging
- **Content Moderation**: Google Perspective API
- **Payment Processing**: Isracard/PayPlus integration
- **Security Testing**: OWASP ZAP for CSRF & XSS detection

## Version Control

- **Git Repository**: [https://github.com/yourusername/football_hero.git](https://github.com/yourusername/football_hero.git)
- **Branching Strategy**: Structured branching strategy for feature development

## Getting Started

### Prerequisites

- Flutter SDK (>=3.5.0)
- Dart SDK
- Supabase account and project

### Software Versions Used

The following software versions were tested and confirmed to work together:

- **Flutter**: 3.24.5  
- **Dart**: 3.5.4  
- **Supabase Flutter SDK**: 2.8.1  
- **Gradle**: 8.11.1  
- **Android Studio**: Flamingo 2024.2  
- **Java**: Eclipse Adoptium JDK 17.0.13.11  
- **flutter_dotenv**: 5.2.1  

#### Environment Variables
- Example `.env`:
  ```env
  SUPABASE_URL=https://your-supabase-url.supabase.co
  SUPABASE_ANON_KEY=your-supabase-anon-key
  ENV=development
  LOG_INFO=true
  LOG_WARNING=true
  LOG_ERROR=true

#### Recommended Production Settings
- For Production Environment:
  ENV=production
  LOG_INFO=false
  LOG_WARNING=true
  LOG_ERROR=true

## Contributing

Contributions are welcome! Please read the [contributing guidelines](CONTRIBUTING.md) before getting started.

## License

This project is licensed under the [MIT License](LICENSE).