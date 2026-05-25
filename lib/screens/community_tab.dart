import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  static const _posts = [
    {
      'user': 'GreenThumb_Alice',
      'avatar': '🌿',
      'time': '2 hours ago',
      'image': 'https://images.unsplash.com/photo-1636818033571-c0a5bb1f9eda?w=400',
      'caption': 'My Monstera just unfurled a new leaf! 🎉 So excited about this beauty.',
      'likes': 142,
      'comments': 23,
    },
    {
      'user': 'PlantDad_Marco',
      'avatar': '🌱',
      'time': '5 hours ago',
      'image': 'https://images.unsplash.com/photo-1463936575829-25148e1db1b8?w=400',
      'caption': 'Morning light through the succulents 🌵 Nothing better to start the day.',
      'likes': 89,
      'comments': 11,
    },
    {
      'user': 'UrbanJungle_Mia',
      'avatar': '🏡',
      'time': 'Yesterday',
      'image': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400',
      'caption': 'Finally put together my living room jungle corner! 🌿🌿',
      'likes': 210,
      'comments': 38,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Text(
              'Community',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
          ),

          // Stories row
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['You', 'Alice', 'Marco', 'Mia', 'Lena', 'Chris'].map((name) {
                final isYou = name == 'You';
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isYou ? AppColors.muted : AppColors.secondary,
                            width: 2.5,
                          ),
                        ),
                        child: isYou
                            ? const CircleAvatar(
                                backgroundColor: AppColors.muted,
                                child: Icon(Icons.add_rounded, color: AppColors.secondary),
                              )
                            : CircleAvatar(
                                backgroundColor: AppColors.chart3,
                                child: Text(name[0],
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                              ),
                      ),
                      const SizedBox(height: 4),
                      Text(name, style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 8),

          // Posts
          ..._posts.map((post) => _PostCard(post: post)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.chart3,
                  radius: 20,
                  child: Text(p['avatar'], style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['user'],
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.foreground)),
                    Text(p['time'],
                        style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_horiz_rounded, color: AppColors.mutedForeground),
              ],
            ),
          ),

          // Image
          Image.network(
            p['image'],
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              color: AppColors.chart4,
            ),
          ),

          // Caption + actions
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['caption'],
                    style: const TextStyle(fontSize: 13, color: AppColors.foreground, height: 1.4)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _liked = !_liked),
                      child: Row(
                        children: [
                          Icon(
                            _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 20,
                            color: _liked ? AppColors.destructive : AppColors.mutedForeground,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(p['likes'] as int) + (_liked ? 1 : 0)}',
                            style: const TextStyle(fontSize: 13, color: AppColors.mutedForeground),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.mutedForeground),
                        const SizedBox(width: 4),
                        Text('${p['comments']}',
                            style: const TextStyle(fontSize: 13, color: AppColors.mutedForeground)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.bookmark_border_rounded, size: 20, color: AppColors.mutedForeground),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
