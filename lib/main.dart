import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'UI/screens/SignUppage.dart';
import 'UI/screens/login_page.dart';
import 'ui/screens/home.dart';
import 'ui/screens/task_list_screen.dart';
import 'ui/screens/add_edit_task_screen.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/task/task_bloc.dart';
import 'firebase_options.dart';
import 'models/tasks.dart';
import 'repositories/auth_repository.dart';
import 'repositories/task_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(AuthRepository())),
        BlocProvider<TaskBloc>(
          create: (_) => TaskBloc(taskRepository: TaskRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'TaskMate',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A1B9A)),
          textTheme: GoogleFonts.oswaldTextTheme(),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6A1B9A),
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        home: const AuthWrapper(),
        routes: {
          '/home': (_) => const HomeScreen(),
          '/login': (_) => const LoginScreen(),
          '/signup': (_) => const SignUpScreen(),
          '/task_list': (context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            if (args is String && args.isNotEmpty) {
              return TaskListScreen(userId: args);
            } else {
              return Scaffold(
                body: Center(
                  child: Text(
                    'Error: userId missing! Args: $args',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
          },
          '/add_task': (context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            if (args is String && args.isNotEmpty) {
              return AddEditTaskScreen(userId: args);
            } else {
              return Scaffold(
                body: Center(
                  child: Text(
                    'Error: userId missing! Args: $args',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
          },
          '/edit_task': (context) {
            final task = ModalRoute.of(context)!.settings.arguments;
            if (task is Task) {
              return AddEditTaskScreen(existingTask: task);
            } else {
              return Scaffold(
                body: Center(
                  child: Text(
                    'Error: task missing or wrong type! Args: $task',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
          },
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeScreen();
        } else if (state is Unauthenticated || state is AuthInitial) {
          return const LoginScreen();
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthError) {
          return const LoginScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
