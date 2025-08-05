Firebase Task Management App
A feature-rich, modern Flutter app for managing tasks, built with Firebase (Firestore, Auth) and Bloc state management.

Features
👤 User Authentication with Firebase Auth (email/password)

🗂 Create, Edit, and Delete Tasks

Each task has title, description, due date/time, priority (Low/Medium/High), and completion status.

🌈 Task Filtering by priority and completion status

👀 Live Updates: Any changes sync instantly via Firestore streams

🔐 Per-user Data Security:

Each user sees only their own tasks (using creatorId and Firestore security rules)

📱 Responsive UI

Material 3 style, smooth experience

Project Structure
text
lib/
 ├── bloc/
 │    └── task/
 │         ├── task_bloc.dart
 │         ├── task_event.dart
 │         └── task_state.dart
 ├── models/
 │    └── tasks.dart
 ├── repositories/
 │    └── task_repository.dart
 ├── ui/
 │    └── screens/
 │         ├── task_list_screen.dart
 │         └── add_edit_task_screen.dart
 └── main.dart
Key Files
models/tasks.dart: Task model (with id, title, desc, dueDate, priority, isCompleted, creatorId)

bloc/task_bloc.dart: All task state management, using Bloc pattern

repositories/task_repository.dart: Handles Firestore reads/writes, filtering logic

ui/screens/add_edit_task_screen.dart: Form to create or update a task

ui/screens/task_list_screen.dart: Displays user’s tasks and filtering options

Firestore Database & Security Rules
Collections
/tasks

Each task is a document with a unique ID and these fields:

title, description, dueDate, priority, isCompleted, creatorId

Security Rules
js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{taskId} {
      allow create: if request.auth != null && request.resource.data.creatorId == request.auth.uid;
      allow read, update, delete: if request.auth != null && resource.data.creatorId == request.auth.uid;
    }
  }
}
Users can ONLY see and change their own tasks.

Composite Indexes
For advanced filtering (e.g. by creator AND priority AND status, ordered by dueDate), you’ll need to create a composite Firestore index.

When prompted by Firestore with an error and a direct link, follow the link and “Create Index”.

Getting Started
Clone this repo

Install dependencies:

text
flutter pub get
Set up Firebase:

Add your google-services.json (Android) and/or GoogleService-Info.plist (iOS)

Enable Email/Password Auth, and Firestore in Firebase Console

Run the app:

text
flutter run
Notes for Development
Hot Reload restores user sessions from Firebase Auth unless you explicitly sign out.

Firestore Permission Errors: Make sure your security rules and creatorId values match!

Task “disappearing” after add: Usually a creatorId mismatch—see above!

Index errors: If tasks vanish after filtering, create the suggested Firestore composite index.

Troubleshooting
permission-denied: Check Firestore rules and make sure creatorId is set and correct.

Firestore query requires an index: Follow link in Firebase error log and build the index.

Login issues: Confirm user exists in Auth, credentials are correct, or sign up anew.

Credits
Built with Flutter, firebase_auth, cloud_firestore, flutter_bloc, [intl], and [google_fonts].

Happy coding! If you have issues or suggestions, feel free to open an issue or contribute!
