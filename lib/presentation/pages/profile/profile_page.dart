import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);

    final initial = (user?.email.isNotEmpty ?? false)
        ? user!.email[0].toUpperCase()
        : "?";

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0C0C),
        elevation: 0,
        title: const Text("Profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // AVATAR
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white24,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // EMAIL USER
            Text(
              user?.email ?? "Tidak ada email",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            const Spacer(),

            // LOGOUT BUTTON
            ElevatedButton(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Center(
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
