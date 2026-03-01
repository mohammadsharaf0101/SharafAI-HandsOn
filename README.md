---- SharafAI-HandsOn ----

ملاحضة ⚠️ هذه ال ReadMe مبني على اول اسبوعين من المشروع. 




🛠️ Technologies & Tools For This Project
Framework: Flutter (v3.x)

Language: Dart

Backend API: DummyJSON (REST API)

Networking: http package for RESTful communication.

Tools: VS Code / Android Studio, Git & GitHub.

📋 Project Roadmap & Tasks
Phase 1: Basic Structure & UI Design
[x] Set up the Flutter project environment.

[x] Design a dark-themed UI for better User Experience (UX).

[x] Create reusable UI components (Custom Input Decoration, SnackBars).

[x] Implement the Login Screen with branding and layout.

[x] Implement the Register Screen with full name, email, and password fields.

Phase 2: Logic, Validation & API Integration
[x] Build a dedicated ApiClient class to separate logic from UI.

[x] Implement Form Validation:

Email validation (must be @gmail.com).

Password validation (minimum 8 characters).

Confirm Password matching logic.

Name validation (Letters only, no numbers/symbols).

[x] Integrate Authentication API:

POST request for user registration.

Handling Loading states (isLoading) with visual spinners.

Error handling (No internet, wrong credentials, server errors).

[x] Build the Courses Screen:

Dynamic listing using ListView.builder.

Displaying course details (Instructor, Duration, Title).

Navigation & Logout functionality.

🚀 Execution Steps (How to setup)
Environment Setup: Ensure Flutter and Dart SDK are installed.

Clone Project:

git clone https://github.com/your-username/project-repo.git
Install Dependencies: Run flutter pub get to download the http package.

Run Application: Use flutter run on a connected emulator or real device.
📉 شو بقي حسب الخطة؟
بناءً على الملف وما تم إنجازه، تقريباً الخطة الثانية اكتملت بنسبة 90% إلى 95%.
State Management: إذا كنتم حابين نستخدم (Provider أو Bloc) بدل الـ setState العادي (حالياً الكود شغال بـ setState).

Shared Preferences: لحفظ بيانات المستخدم (Token) عشان ما يضطر يسجل دخول كل ما يفتح التطبيق.

Course Details: شاشة تفصيلية لكل كورس عند الضغط عليه.
