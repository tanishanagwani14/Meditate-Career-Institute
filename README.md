# 📱 Meditate Career Institute — Multi-App EdTech Suite

An enterprise-grade cross-platform EdTech platform built with **Flutter**, **Dart**, and **Firebase**. Designed as a scalable monorepo hosting 4 specialized applications for student learning, teacher management, institute administration, and super-admin oversight. Built during my engineering internship at Ekagad Ventures.

---

## 🏗️ Monorepo Architecture

| App Role | Subfolder Directory | Core Functionality |
| :--- | :--- | :--- |
| **Student** | `edulearn_student_app` | Mobile app for course view, real-time tracking, and video lectures. |
| **Teacher** | `edtech_teacher_app` | Mobile app for content uploading, live sessions, and student management. |
| **Institute Admin** | `premium_saas_admin_dashboard_app` | Web/Desktop dashboard for institute metrics, batch management, and billing. |
| **Super Admin** | `enterprise_super_admin_dashboard_app` | Global system control panel for platform metrics and multi-tenant management. |

---

## ✨ Key Technical Highlights
- **Monorepo Architecture:** Clean modular codebase supporting cross-app state sharing and unified backend integration.
- **Firebase Authentication & Firestore:** Multi-role client authentication and real-time database synchronization across all 4 apps.
- **Dynamic Content Delivery:** Scalable REST and real-time data flow for courses and announcements.
- **Push Notifications:** Automated engagement alerts integrated via Firebase Cloud Messaging (FCM).
- **Responsive Layouts:** Optimized rendering across Android, iOS, Web, and Desktop viewports.

---

## 🛠️ Tech Stack
- **Framework:** Flutter (Dart)
- **Backend & Cloud:** Firebase (Auth, Firestore, Cloud Messaging, Storage)
- **Architecture:** Monorepo / Multi-App Package Management
- **Developer Tools:** Git, Cursor / VS Code, Android Studio

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.

### Running an Application
1. Clone the repository:
   ```bash
   git clone https://github.com/tanishanagwani14/Meditate-Career-Institute.git
   cd Meditate-Career-Institute
   ```
2. Open any of the four app folders:
   ```bash
   cd edulearn_student_app   # or edtech_teacher_app, premium_saas_admin_dashboard_app, enterprise_super_admin_dashboard_app
   ```
3. Install dependencies and run:
   ```bash
   flutter pub get
   flutter run
   ```
