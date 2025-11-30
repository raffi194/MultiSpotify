import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);

    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/');
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password"),
            ),

            const SizedBox(height: 24),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (email.text.isEmpty || password.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Email dan password wajib diisi")),
                        );
                        return;
                      }

                      setState(() => loading = true);

                      try {
                        await ref.read(authControllerProvider.notifier).login(
                              email.text.trim(),
                              password.text.trim(),
                            );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }

                      setState(() => loading = false);
                    },
                    child: const Text("Masuk"),
                  ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => context.go('/register'),
              child: const Text("Belum punya akun? Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}
