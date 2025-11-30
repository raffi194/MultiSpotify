import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   await Supabase.initialize(
    url: "https://xrxjdqbikiuqqztshcjq.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhyeGpkcWJpa2l1cXF6dHNoY2pxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ1MjA4ODQsImV4cCI6MjA4MDA5Njg4NH0.ovPbNEiNY4qhRBkc1DXTSyfiZ5cdZVlcsrMEl4TWLwY",
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
