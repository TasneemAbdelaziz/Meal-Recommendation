# Meal_Recommendation_V2 🍽️

A futuristic Flutter application that leverages Gemini AI as the intelligent engine to fetch and recommend personalized recipes from the Spoonacular API.

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com/TasneemAbdelaziz/Meal-Recommendation) 
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web-blue)](https://flutter.dev)

---

## 📖 Table of Contents
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Setup & Installation](#-setup--installation)
- [Environment Variables](#-environment-variables)
- [Backend & AI Integration](#-backend--ai-integration)
- [Database Schema](#-database-schema)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [Contact](#-contact)

---

## ✨ Features
- **AI-Powered Recommendations:** Exclusive meal suggestions powered by Gemini AI. Get recipes based on your natural language patterns and chat interactions from the Spoonacular API.
- **Recipe Management:** Browse detailed recipe information including instructions and nutritional value.
- **Favorites System:** Save your favorite recipes for quick access.
- **Secure Authentication:** User signup and login powered by Supabase Auth (includes Google Sign-In support).
- **User Profiles:** Personalized profiles with avatar uploads and settings.
- **Clean UI/UX:** Modern, responsive design with smooth animations and a premium feel.

---

## 📸 Screenshots
> Add screenshots of the app UI here

| Screen | Preview |
|-------|---------|
|Splash Screen| (https://github.com/user-attachments/assets/582ec353-bd63-4f2b-b60d-7cd0fcac9803) |
|[Home Screen |(https://github.com/user-attachments/assets/9d63f3f0-8e32-4555-be12-00b5d3ad456a)|
| Meal Details | ![Details](screenshots/details.png) |
| Ai Chat | ![Results](screenshots/results.png) |
| Profile | ![Profile](screenshots/profile.png) |

> [!NOTE]
> Create a `screenshots/` folder in the root directory and place your images there to see them in this README.

---

## 🛠 Tech Stack
- **Frontend:** [Flutter](https://flutter.dev) (Dart)
- **Backend/DB:** [Supabase](https://supabase.com) (Auth, PostgreSQL, Storage, RLS)
- **AI Orchestration:** [Gemini API](https://ai.google.dev) (google_generative_ai)
- **Recipe Data Source:** [Spoonacular API](https://spoonacular.com/food-api)
- **State Management:** [BLoC](https://pub.dev/packages/flutter_bloc) / Cubit
- **Dependency Injection:** [Get_It](https://pub.dev/packages/get_it)
- **Functional Programming:** [fpdart](https://pub.dev/packages/fpdart)
- **Networking:** [http](https://pub.dev/packages/http)
- **Design:** Google Fonts, QuickAlert, Animated Splash, Smooth Page Indicator.

---

## 🏗 Architecture
The project follows **Clean Architecture** principles to ensure scalability and maintainability.

### Folder Structure
```text
lib/
├── core/                  # Core utilities and shared logic
│   ├── common/            # Shared entities and models
│   ├── secrets/           # API Keys & Sensitive config
│   ├── theme/             # App theme data
│   ├── usecase/           # Base UseCase interface
│   └── init_dependencies  # Dependency injection setup
├── features/              # Modular features (Clean Architecture)
│   ├── auth/              # Authentication (Supabase & Google)
│   ├── ai_chat/           # Gemini AI & Recipe search
│   ├── home/              # Main dashboard
│   ├── favorite/          # Favorites management
│   ├── add_recipe/        # Custom recipe creation
│   └── profile/           # User bio and settings
├── onboarding/            # Splash and intro screens
├── recipe_description/    # Detailed recipe view (Clean Arch)
├── translation/           # Navigation & translation logic
└── main.dart              # Application entry point
```

Each feature is divided into:
- **Data Layer:** Models, DataSources, and Repositories implementations.
- **Domain Layer:** Entities, Repositories interfaces, and UseCases.
- **Presentation Layer:** BLoCs/Cubits, Pages, and Widgets.

---

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK: `^3.6.2`
- Dart SDK: `^3.6.0`
- A Supabase Project
- A Gemini API Key

### Steps
1. **Clone the repository:**
   ```bash
   git clone https://github.com/TasneemAbdelaziz/Meal-Recommendation.git
   cd Meal-Recommendation
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables:**
   Create a `lib/core/secrets/app_secrets.dart` (or use a `.env` file) as shown in the [Environment Variables](#-environment-variables) section.

4. **Run the app:**
   ```bash
   # For Android/iOS
   flutter run

   # For Web
   flutter run -d chrome
   ```

---

## 🔑 Environment Variables

> [!IMPORTANT]
> Never commit your real API keys to version control. Ensure `app_secrets.dart` or `.env` is added to your `.gitignore`.

### `.env.example`
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
GEMINI_API_KEY=your-gemini-key
SPOONACULAR_API_KEY=your-spoonacular-key
GOOGLE_WEB_CLIENT_ID=your-google-client-id
```

If using `app_secrets.dart`:
```dart
class AppSecrets {
  static const supabaseUrl = "YOUR_URL";
  static const supabaseAnonKey = "YOUR_ANON_KEY";
  static const geminiApiKey = "YOUR_GEMINI_KEY";
}


## 💾 Database Schema (Supabase)

The project uses PostgreSQL with Row Level Security (RLS) to protect user data.

- **`profiles`**: Stores user metadata (id, username, avatar_url, bio).
- **`recipes`**: Stores custom recipes added by users.
- **`favorites`**: Links users to their saved recipes.

### RLS Policies
- Users can only read/write their own profile data.
- Public recipes are readable by everyone.



---

## 🗺 Roadmap
- [ ] **AI Vision:** Detect meals via camera and estimate calories automatically using Gemini Vision.
- [ ] **Advanced Filtering:** Add support for dietary preferences (Vegan, Keto, Gluten-free) across all searches.
- [ ] **Meal Planning:** Goal-based weekly meal scheduler.
- [ ] **Offline Access:** Cache favorite recipes for viewing without internet.

---

## 🤝 Contributing
Contributions are welcome! Please follow these steps:
1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.


---

## 👤 Contact
**Tasneem AbdElaziz** - [GitHub](https://github.com/TasneemAbdelaziz)  
Project Link: [https://github.com/TasneemAbdelaziz/Meal-Recommendation](https://github.com/TasneemAbdelaziz/Meal-Recommendation)

---
*Made with ❤️ using Flutter and Gemini AI*
