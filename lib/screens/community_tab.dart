import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_body.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({super.key});

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  final TextEditingController _postCtrl = TextEditingController();

  @override
  void dispose() {
    _postCtrl.dispose();
    super.dispose();
  }

  void _submitPost(AppState state) {
    final text = _postCtrl.text.trim();
    if (text.isEmpty) {
      return;
    }
    state.addCommunityPost(text);
    _postCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _showComments(BuildContext context, CommunityPost post) async {
    final controller = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
            child: SizedBox(
              height: MediaQuery.of(sheetContext).size.height * 0.6,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Comments',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Consumer<AppState>(
                      builder: (context, state, _) {
                        final updated = state.getCommunityPost(post.id) ?? post;
                        final comments = updated.comments;
                        if (comments.isEmpty) {
                          return const Center(
                            child: Text(
                              'No comments yet. Be the first to reply.',
                              style: TextStyle(
                                  color: AppColors.mutedForeground,
                                  fontSize: 13),
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: comments.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return _CommentTile(comment: comment);
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: const BoxDecoration(
                      color: AppColors.card,
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.chart3,
                          child: Text('🧑', style: TextStyle(fontSize: 14)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'Write a comment...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context
                                .read<AppState>()
                                .addCommunityComment(post.id, controller.text);
                            controller.clear();
                          },
                          icon: const Icon(Icons.send_rounded,
                              color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final posts = state.communityPosts;

    return ResponsiveBody(
      child: SingleChildScrollView(
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

            // Composer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.chart3,
                          child: Text('🧑', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _postCtrl,
                            maxLines: 4,
                            minLines: 1,
                            decoration: const InputDecoration(
                              hintText: 'Share your plant journey...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Posting as You',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.mutedForeground),
                        ),
                        const Spacer(),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _postCtrl,
                          builder: (context, value, _) {
                            final canPost = value.text.trim().isNotEmpty;
                            return ElevatedButton(
                              onPressed:
                                  canPost ? () => _submitPost(state) : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 10),
                                textStyle: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              child: const Text('Post'),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stories row
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['You', 'Alice', 'Marco', 'Mia', 'Lena', 'Chris']
                    .map((name) {
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
                              color:
                                  isYou ? AppColors.muted : AppColors.secondary,
                              width: 2.5,
                            ),
                          ),
                          child: isYou
                              ? const CircleAvatar(
                                  backgroundColor: AppColors.muted,
                                  child: Icon(Icons.add_rounded,
                                      color: AppColors.secondary),
                                )
                              : CircleAvatar(
                                  backgroundColor: AppColors.chart3,
                                  child: Text(name[0],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary)),
                                ),
                        ),
                        const SizedBox(height: 4),
                        Text(name,
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.mutedForeground)),
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
            ...posts.map(
              (post) => _PostCard(
                post: post,
                onLike: () => state.toggleCommunityLike(post.id),
                onComment: () => _showComments(context, post),
                onBookmark: () => state.toggleCommunityBookmark(post.id),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onBookmark;

  const _PostCard({
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
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
                  child:
                      Text(post.avatar, style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.foreground)),
                    Text(post.timeLabel,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.mutedForeground)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_horiz_rounded,
                    color: AppColors.mutedForeground),
              ],
            ),
          ),

          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            Image.network(
              post.imageUrl!,
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
                Text(post.caption,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.foreground,
                        height: 1.4)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ActionButton(
                      onTap: onLike,
                      child: Row(
                        children: [
                          AnimatedScale(
                            duration: const Duration(milliseconds: 120),
                            scale: post.likedByMe ? 1.1 : 1.0,
                            child: Icon(
                              post.likedByMe
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 20,
                              color: post.likedByMe
                                  ? AppColors.destructive
                                  : AppColors.mutedForeground,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.likeCount}',
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.mutedForeground),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _ActionButton(
                      onTap: onComment,
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded,
                              size: 18, color: AppColors.mutedForeground),
                          const SizedBox(width: 4),
                          Text('${post.commentCount}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.mutedForeground)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _ActionButton(
                      onTap: onBookmark,
                      child: Icon(
                        post.bookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: 20,
                        color: post.bookmarked
                            ? AppColors.secondary
                            : AppColors.mutedForeground,
                      ),
                    ),
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

class _ActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ActionButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: child,
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommunityComment comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.chart3,
          child: Text('🧑', style: TextStyle(fontSize: 14)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.author,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground)),
                const SizedBox(height: 4),
                Text(comment.text,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.foreground,
                        height: 1.3)),
                const SizedBox(height: 6),
                Text(comment.timeLabel,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.mutedForeground)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
