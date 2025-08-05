import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  String _getUserDisplay(User? user) {
    if (user == null) return "";
    return user.displayName?.isNotEmpty == true
        ? user.displayName!
        : (user.email ?? "User");
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final user = FirebaseAuth.instance.currentUser;
    final username = _getUserDisplay(user);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Welcome'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: colorScheme.onPrimary),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogOutRequested());
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.secondary.withOpacity(0.16),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.secondary,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  "Hello, $username!",
                  style: GoogleFonts.oswald(
                    fontSize: 29,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome to TaskMate 👋",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    color: colorScheme.onSurface.withOpacity(.8),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Begin tracking and managing your tasks with ease. Stay organized, set priorities, and never miss a deadline.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onSurface.withOpacity(.65),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(Icons.list_alt_rounded, size: 24),
                    label: const Text('View My Tasks'),
                    onPressed: () {
                      final uid = user?.uid;
                      if (uid != null) {
                        Navigator.pushNamed(
                          context,
                          '/task_list',
                          arguments: uid,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Error: User not found (not logged in).',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
