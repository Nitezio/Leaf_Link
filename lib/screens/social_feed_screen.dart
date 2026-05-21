import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';

class SocialFeedScreen extends StatelessWidget {
  const SocialFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Community', style: Theme.of(context).textTheme.displayMedium),
          ),
          // Post Composer
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 8)],
            ),
            child: Row(
              children: [
                const CircleAvatar(backgroundColor: AppColors.muted, child: Text('👤')),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "What's growing on?",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      filled: false,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(LucideIcons.send, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPostCard(context, 'GreenThumb92', '🌿', '2h ago', 'My Monstera finally got its first fenestration! Look at those holes 😍', image: true, likes: 24, comments: 5),
                _buildPostCard(context, 'PlantLover', '🪴', '5h ago', 'Just finished repotting all my succulents. Used a new cactus mix, hoping they like it!', likes: 18, comments: 3),
                _buildPostCard(context, 'UrbanJungle', '🌱', '1d ago', 'Hit my 30-day watering streak! Consistency really pays off.', likes: 45, comments: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, String name, String avatar, String time, String text, {bool image = false, required int likes, required int comments}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: AppColors.secondary.withValues(alpha: 0.2), child: Text(avatar)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(time, style: TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          if (image) ...[
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=400'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAction(LucideIcons.heart, '$likes'),
              const SizedBox(width: 16),
              _buildAction(LucideIcons.messageCircle, '$comments'),
              const Spacer(),
              const Icon(LucideIcons.share2, size: 20, color: AppColors.mutedForeground),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.mutedForeground),
        const SizedBox(width: 6),
        Text(count, style: TextStyle(color: AppColors.mutedForeground, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
