# FootballHero Styling Documentation

## Fonts
The following fonts are used in the FootballHero app:

### Main Fonts
- **RubikDirt**: Used for buttons (e.g., "Join the Team" and "Log In").
  - **Size**: 28px
  - **Style**: Italic, lighter weight (w300)
  - **Color**: White for the "Join the Team" button and black for the "Log In" button.

- **VarelaRound**: Used for informational text and links (e.g., HoodHero Info Link).
  - **Size**: 16px
  - **Style**: Italic, lighter weight (w300)
  - **Color**: White with underline for emphasis.

## Theme Preferences

### Colors
- **Primary Gradient for Buttons**:
  - Start: `Colors.blue.shade300`
  - End: `Colors.blue.shade700`

- **Text Colors**:
  - Button Text:
    - White for "Join the Team"
    - Black for "Log In"
  - Link Text: White

### Shadows
- **Sign-Up Button**:
  - **Color**: `Colors.blue.shade900` (with 50% opacity)
  - **Blur Radius**: 10px
  - **Offset**: (3, 4)

- **Log-In Button**:
  - **Color**: Black (with 25% opacity)
  - **Blur Radius**: 10px
  - **Offset**: (3, 4)

### Accessibility
- **Font Size**: Buttons and links use large, readable sizes (28px and 16px, respectively).
- **Contrast**: Ensures sufficient contrast between text and background for readability.
- **ARIA-like Labels**:
  - Buttons include `ValueKey` identifiers for screen readers.
- **Spacing**:
  - Consistent padding and spacing (e.g., `30px` between elements) for easy navigation.

### Animations
- **AnimatedSwitcher**: Applied to button text for a smooth transition effect when buttons are interacted with.
  - **Duration**: 200ms

## Assets
- **Background Image**:
  - File: `assets/images/welcomeBackground.webp`
  - Style: Covers entire screen with `BoxFit.cover` for responsive scaling.

---

## New Screens and Features

### **Sign-Up Screen**
- A form for user registration that collects email, password, and password confirmation.
- Includes validation for:
  - Valid email format.
  - Passwords matching and meeting minimum requirements (at least 6 characters).
- Includes a checkbox to accept the terms of use with a link to: `https://hoodhero.app/footballhero/he/terms`.
- On successful sign-up, navigates to the **Success Screen** displaying the unique User ID provided by Supabase.

### **Supabase Integration**
- Supabase is integrated using the `supabase_flutter` package.
- Environment variables for the Supabase URL and Anon Key are stored securely in the `.env` file.
- Example `.env` file:
  ```env
  SUPABASE_URL=https://your-supabase-url.supabase.co
  SUPABASE_ANON_KEY=your-supabase-anon-key
  ```
- The `.env` file is loaded using the `flutter_dotenv` package, ensuring secure access to environment variables.
- The `SignUpScreen` uses the Supabase Auth API to create new users and handle errors.

---

This document provides a comprehensive guide to the current app's styling, screens, and backend integration.

