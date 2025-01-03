# FootballHero App Documentation

## Project Overview
FootballHero is a video-sharing platform designed to help users manage their football journey. The app supports seamless user registration, login, and onboarding processes, along with a modern and accessible UI in both Hebrew and English.

---

## Features and Updates

### General Features
- **Localization**:
  - Fully supports **Hebrew (RTL)** and **English (LTR)** layouts.
  - Text direction and font preferences adapt to the chosen language.
- **Dynamic Role-Based Navigation**:
  - Users can register as a `player`, `parent`, `coach`, `mentor`, or `community` member.
  - Onboarding flows adapt dynamically based on the user's selected role.
- **Supabase Integration**:
  - User authentication (signup, login, password reset) is implemented with Supabase.

---

### Logging Configuration
- **Environment-Based Logging**:
  - Configurable logging based on the environment (`development` or `production`).
  - Logging settings are controlled through environment variables.

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

## Styling

### Fonts
- **RubikDirt**: Used for titles, headers, and buttons.
  - Style: Italic, lightweight (`w300`).
  - Size: 28px.
- **VarelaRound**: Used for body text and links.
  - Style: Lightweight (`w300`).
  - Size: 16px.

### Theme Preferences
- **Background Images**:
  - Welcome screen: `welcomeBackground.webp`.
  - All other screens: `mainBackground.webp`.
- **Color Palette**:
  - **Buttons**:
    - Gradient: `Colors.blue.shade300` to `Colors.blue.shade700`.
    - Shadows for depth: Blue for primary buttons and black for secondary buttons.
  - **Text**:
    - White for primary buttons and links.
    - Black for secondary buttons.

---

## Screens

### 1. Welcome Screen
- Includes:
  - A "Join the Team" button (`/signup`).
  - A "Log In" button (`/login`).
  - A footer with a link to HoodHero program information.

### 2. Login Screen
- Features:
  - Form for user login (email and password).
  - "Forgot Password?" link redirects to `/forgot-password`.
  - Validation for empty fields and login errors.

### 3. Forgot Password Screen
- Functionality:
  - Sends a password reset email through Supabase Auth API.
  - Displays appropriate feedback to the user.

### 4. Signup Screen
- Allows users to register with:
  - Email.
  - Password.
  - Confirmation of terms of service.
- Supabase handles user creation and validation.
- Redirects to `/onboarding` upon successful signup.

### 5. Onboarding Screen
- Captures additional user details:
  - Name.
  - Date of Birth (using a localized date picker).
  - Address and city.
  - Role (e.g., player, coach).
- Saves data to Supabase and calculates user age.
- Dynamic role-based navigation to specific onboarding flows based on the selected role.

---

## Backend Integration

### Supabase
- **URL and Anon Key** are securely stored in the `.env` file.

#### Features Implemented
- User authentication.
- Role-based navigation.
- Storing user metadata (e.g., age, address).

#### Example .env File
- SUPABASE_URL=https://your-supabase-url.supabase.co
- SUPABASE_ANON_KEY=your-supabase-anon-key


