import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://uyvlceukrgtycycupvvy.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV5dmxjZXVrcmd0eWN5Y3VwdnZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5MDgzNDQsImV4cCI6MjA3OTQ4NDM0NH0.cIqC74hB_eQ6KGuM0alHp4qxz2yoNEr3xK0ClY4Gk58",
  );

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: "Spotify Clone Flutter",
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.dark(),
    );
  }
}
