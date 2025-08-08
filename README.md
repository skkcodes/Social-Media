# 📱 Social Media App

A full-featured **Social Media App** built using **Flutter & Firebase**, offering a modern experience with real-time updates, chat functionality, and user connections — just like your favorite social platforms!

---

## 🚀 Features

- 🔐 User Authentication (Sign Up / Login / Forgot Password)
- 🧑‍🤝‍🧑 Follow & Unfollow Users
- 💬 Real-Time Chat & Messaging
- 📝 Post Creation with Text & Image Upload
- ❤️ Like, Comment & Share Posts
- 📥 Notifications
- 🔍 Search Users & Posts
- 👤 View Profiles (Self & Others)
- 🌙 Dark Mode Support
- 🧱 Firebase Backend Integration (Auth, Firestore, Storage, Messaging)

---

## 🛠️ Tech Stack

| Category       | Technologies Used                          |
|----------------|---------------------------------------------|
| **Frontend**   | Flutter, Dart                               |
| **Backend**    | Firebase Auth, Firestore, Storage           |
| **State Mgmt** | Provider                                    |
| **Tools**      | Android Studio, VS Code, Git, GitHub        |

---

## 📸 Screenshots

| Bright Theme | Dark Theme | 
|-------|-----------|
| ![](assets/light.png) | ![](assets/dark.png) |



---

## 📦 Folder Structure (Brief)

lib/
├── auth/
│   ├── signin.dart
│   └── signup.dart
│
├── features/
│   ├── splashscreen/
│   │   └── splashscreen.dart
│   ├── chat.dart
│   ├── edit_profile.dart
│   ├── home.dart
│   ├── main_screen.dart
│   ├── message.dart
│   ├── notification.dart
│   ├── post.dart
│   ├── profile.dart
│   └── search.dart
│
├── model/
│   └── user_model.dart
│
├── provider/
│   └── user_provider.dart
│
├── widgets/
│   ├── custom_widgets.dart
│   ├── message_bubble.dart
│   ├── message_item.dart
│   ├── my_navbar.dart
│   ├── notification_item.dart
│   ├── post_item.dart
│   ├── screen_item.dart
│   └── story_item.dart
│
├── firebase_options.dart
├── main.dart
└── theme.dart

