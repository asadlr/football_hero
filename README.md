# FootballHero

FootballHero is an innovative mobile application designed to revolutionize how football (soccer) players, coaches, parents, mentors, and community managers interact and develop within the sport. Built with Flutter and Supabase, the platform offers sophisticated video-sharing capabilities, team management tools, and role-based features tailored to the specific needs of each user type.

![FootballHero App Screenshot](assets/images/app_screenshot.png)

## Core Features

- **Role-Based Experience**: Tailored interfaces for Players, Coaches, Parents, Mentors, and Community Managers
- **Video Sharing Platform**: Easy upload, management, and sharing of football skills and training videos
- **Team Management**: Comprehensive tools for team organization and player development
- **Performance Tracking**: Statistics and metrics to monitor player progress
- **Community Engagement**: News feeds and fan zone integration with professional football clubs
- **Full RTL Support**: Complete Hebrew language interface with proper RTL layout
- **Modern UI**: Vibrant, youthful design with gradient support and optimized user experience

## Development Framework

### Frontend

- **Framework**: Flutter (>=3.7.0)
- **Language**: Dart
- **State Management**: Provider pattern
- **UI/UX**: Custom component library with gradient support and RTL optimization
- **Testing**:
  - Integration Testing: Flutter integration test package
  - Unit Testing: Mockito

### Backend

- **Platform**: Supabase
  - Authentication: Supabase Auth with email verification and password reset
  - Database: PostgreSQL with 22-table schema
  - Storage: Supabase Storage for media files and coach certificates
  - Security: Row Level Security (RLS) for data protection

### Additional Services

- **Notifications**: Firebase Cloud Messaging
- **Content Moderation**: Google Perspective API
- **Payment Processing**: Isracard/PayPlus integration
- **Security Testing**: OWASP ZAP for CSRF & XSS detection

## Features By User Role

### Player Features
- Performance metrics dashboard
- Achievement tracking (challenges, stars, player card completion)
- Team discovery and joining
- Video sharing and skills showcasing
- Activity feed with upcoming events

### Coach Features
- Team management interface
- Player performance analytics
- Training session scheduling
- Team statistics visualization
- Coaching resources access

### Parent Features
- Child activity monitoring
- Multiple children management
- Permission management
- Event scheduling notifications
- Payment tracking for team activities

### Mentor Features
- Mentee tracking dashboard
- Session scheduling tools
- Skill development tracking
- Resources for player development
- Direct communication with mentees

### Community Manager Features
- Community overview dashboard
- Multi-team management
- Member statistics and metrics
- Event coordination across teams
- Content moderation tools

## UI/UX Design System

The application features a vibrant, youthful design system with:

- **Modern Color Palette**: Semi-transparent colors with gradient effects
- **Card Components**: Consistent styling across different sections
- **RTL Support**: Full Hebrew language support with proper layout
- **Optimized Navigation**: Icon-based navigation with visual feedback

## Getting Started

### Prerequisites

- Flutter SDK (>=3.7.0)
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

```
football_hero/
├── android/                  # Native Android implementation
├── ios/                      # Native iOS implementation
├── web/                      # Web-related files
├── assets/                   # Static assets
│   ├── images/               # Application images
│   ├── fonts/                # Custom typography
│   └── icon/                 # App iconography
├── lib/                      # Core application code
│   ├── main.dart             # Application entry point
│   ├── localization/         # Localization support
│   │   └── app_strings.dart  # Hebrew string resources
│   ├── logger/               # Debugging utilities
│   ├── models/               # Data structures
│   ├── screens/              # User interface screens
│   │   ├── home.dart         # Main home screen controller
│   │   └── onboarding/       # Role-specific onboarding
│   ├── state/                # State management
│   ├── theme/                # Theme system
│   │   └── app_colors.dart   # Color and gradient definitions
│   └── widgets/              # Reusable components
│       ├── common/           # Shared widgets
│       └── home/             # Role-specific content
├── test/                     # Testing resources
└── pubspec.yaml              # Dependencies and configuration
```

## UI Components

The app includes several reusable UI components:

- **CustomCard**: Base card component with gradient support
- **AchievementBox**: Compact metrics display
- **TeamCard**: Team information display
- **ActivityItem**: Event listing with type-based styling
- **FanClubNewsCard**: News feed component for football clubs
- **UpcomingEventsCard**: Calendar events display

## Security Considerations

- Row Level Security (RLS) implemented in Supabase
- All error logs are sanitized to prevent leaking sensitive information
- User IDs and personal information are not exposed in logs
- Password reset tokens are handled securely
- Form validation is robust to prevent injection attacks

## RTL Support

The app features comprehensive RTL support for Hebrew language:

- Global directionality control
- Component-level RTL adaptation
- Proper text alignment and padding
- Consistent visual hierarchy in RTL context

## Performance Optimization

- Efficient API call batching
- Strategic caching mechanisms
- Lazy loading for media-heavy screens
- Memory usage optimization
- Minimal widget rebuilds

## Screenshots

### Player Dashboard
![Player Dashboard](assets/images/player_dashboard.png)

### Team Management
![Team Management](assets/images/team_management.png)

### Achievement Tracking
![Achievement Tracking](assets/images/achievements.png)

## Contributing

We welcome contributions to the FootballHero project. Please read our [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines on how to contribute.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- The Flutter team for their amazing framework
- Supabase for providing a powerful backend solution
- All the football enthusiasts who provided feedback during development