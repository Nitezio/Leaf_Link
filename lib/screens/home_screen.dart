import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_tab.dart';
import 'garden_tab.dart';
import 'scan_tab.dart';
import 'community_tab.dart';
import 'marketplace_tab.dart';
import 'profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeTab = 0; // 0=home, 1=community, 2=scan, 3=marketplace, 4=profile

  static const _navItems = [
    {
      'icon': Icons.home_outlined,
      'activeIcon': Icons.home_rounded,
      'label': 'Home'
    },
    {
      'icon': Icons.group_outlined,
      'activeIcon': Icons.group_rounded,
      'label': 'Community'
    },
    // FAB placeholder index 2
    {
      'icon': Icons.shopping_bag_outlined,
      'activeIcon': Icons.shopping_bag_rounded,
      'label': 'Marketplace'
    },
    {
      'icon': Icons.person_outline_rounded,
      'activeIcon': Icons.person_rounded,
      'label': 'Profile'
    },
  ];

  Widget _buildTab() {
    switch (_activeTab) {
      case 0:
        return HomeTab(onGoToScan: () => setState(() => _activeTab = 2));
      case 1:
        return const CommunityTab();
      case 2:
        return const ScanTab();
      case 3:
        return const MarketplaceTab();
      case 4:
        return const ProfileTab();
      default:
        return HomeTab(onGoToScan: () => setState(() => _activeTab = 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(bottom: false, child: _buildTab()),
      bottomNavigationBar: _BottomNav(
        activeTab: _activeTab,
        onTap: (i) => setState(() => _activeTab = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.activeTab, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80 + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const maxWidth = 720.0;
            final width = constraints.maxWidth < maxWidth
                ? constraints.maxWidth
                : maxWidth;
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _navBtn(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                    _navBtn(1, Icons.group_outlined, Icons.group_rounded,
                        'Community'),

                    // Center FAB
                    GestureDetector(
                      onTap: () => onTap(2),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        height: 56,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeTab == 2
                              ? AppColors.secondary
                              : AppColors.primary,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white, size: 24),
                      ),
                    ),

                    _navBtn(3, Icons.shopping_bag_outlined,
                        Icons.shopping_bag_rounded, 'Market'),
                    _navBtn(4, Icons.person_outline_rounded,
                        Icons.person_rounded, 'Profile'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _navBtn(int idx, IconData icon, IconData activeIcon, String label) {
    final isActive = activeTab == idx;
    return GestureDetector(
      onTap: () => onTap(idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.secondary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.mutedForeground,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
