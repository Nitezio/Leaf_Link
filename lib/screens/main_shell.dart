import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import 'home_screen.dart';
import 'social_feed_screen.dart';
import 'scan_screen.dart';
import 'marketplace_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SocialFeedScreen(),
    const ScanScreen(),
    const MarketplaceScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, LucideIcons.home, 'Home'),
            _buildNavItem(1, LucideIcons.users, 'Community'),
            // Center FAB
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () => _onTabTapped(2),
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 32), // Elevated
                    decoration: BoxDecoration(
                      color: _currentIndex == 2 ? AppColors.secondary : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.camera, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
            _buildNavItem(3, LucideIcons.shoppingBag, 'Marketplace'),
            _buildNavItem(4, LucideIcons.user, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.secondary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isActive ? AppColors.primary : AppColors.mutedForeground, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isActive ? AppColors.primary : AppColors.mutedForeground,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
