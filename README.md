# FootballHero

<div align="center">

![FootballHero Logo](assets/images/logo.webp)

A social video-sharing platform for football enthusiasts, built with Flutter and Supabase.

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.5.0-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-v2.0.0-green.svg)](https://supabase.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[Key Features](#key-features) •
[Getting Started](#getting-started) •
[Installation](#installation) •
[Documentation](#documentation) •
[Contributing](#contributing)

</div>

## About The Project

FootballHero is a TikTok-style video-sharing platform specifically designed for football players, coaches, and enthusiasts. The app facilitates sharing football videos, receiving feedback, and building a community around the sport, with a special focus on youth development and team management.

### Key Features

- 📱 **Multi-Role System**
  - Player profiles with skill tracking
  - Coach verification system
  - Parental controls for under-13 users
  - Community engagement features

- 🌐 **Dual Language Support**
  - Complete Hebrew (RTL) support
  - English interface
  - Adaptive layouts

- 🎥 **Video Sharing**
  - Easy upload and sharing
  - Team-based content organization
  - Content moderation

- 🔒 **Security & Privacy**
  - Age-appropriate content filtering
  - Parental oversight features
  - Role-based access control

### Built With

- Frontend Framework: [Flutter](https://flutter.dev/)
- Backend Services: [Supabase](https://supabase.com/)
- Authentication: Supabase Auth
- Database: PostgreSQL
- Storage: Supabase Storage

## Getting Started

### Prerequisites

- Flutter (>=3.5.0)
- Dart SDK
- Git
- A Supabase account and project

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/football_hero.git
```

2. Install dependencies
```bash
cd football_hero
flutter pub get
```

3. Create a `.env` file in the project root
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
ENV=development
LOG_INFO=true
LOG_WARNING=true
LOG_ERROR=true
```

4. Run the app
```bash
flutter run
```

## Architecture

### Database Schema

```sql
public.users
- id (uuid, PK)
- name (text)
- role (text)
- dob (date)
- parent_id (uuid, FK)
- address (text)
- city (text)

public.teams
- id (uuid, PK)
- name (text)
- address (text)
- status (team_status)
- community_id (uuid, FK)
- verified_by_coach_id (uuid, FK)

public.team_members
- team_id (uuid, FK)
- user_id (uuid, FK)
- role (text)
```

### Security Features

- Row Level Security (RLS) policies
- Role-based access control
- Parent-child account linking
- Content moderation workflow

## Documentation

### File Structure
```
lib/
├── main.dart
├── logger/
│   └── logger.dart
├── screens/
│   ├── welcome.dart
│   ├── login.dart
│   ├── signup.dart
│   └── onboarding/
│       ├── player_onboarding.dart
│       ├── coach_onboarding.dart
│       └── ...
└── widgets/
    └── team_verification_banner.dart
```

### Environment Configuration

Development environment settings:
```env
ENV=development
LOG_INFO=true
LOG_WARNING=true
LOG_ERROR=true
```

Production environment settings:
```env
ENV=production
LOG_INFO=false
LOG_WARNING=true
LOG_ERROR=true
```

## Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)

Project Link: [https://github.com/yourusername/football_hero](https://github.com/yourusername/football_hero)

## Acknowledgments

- [Flutter](https://flutter.dev/)
- [Supabase](https://supabase.com/)
- [FlutterFlow](https://flutterflow.io/)