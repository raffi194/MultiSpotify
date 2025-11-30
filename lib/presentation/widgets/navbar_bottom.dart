import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavbarBottom extends StatelessWidget {
  final int index;

  const NavbarBottom({super.key, required this.index});

  void _onTap(BuildContext context, int i) {
    switch (i) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/songs');
        break;
      case 2:
        context.go('/playlists');
        break;
      case 3:
        context.go('/favorites');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.greenAccent,
      unselectedItemColor: Colors.white54,
      currentIndex: index,
      onTap: (i) => _onTap(context, i),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Songs'),
        BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Playlist'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
      ],
    );
  }
}
