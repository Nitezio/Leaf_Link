import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../services/image_service.dart';
import '../services/storage_service.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../widgets/responsive_body.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({super.key});

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  final TextEditingController _postCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedFeed = 'All';
  String? _attachedImagePath;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _postCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _submitPost(AppState state) {
    final text = _postCtrl.text.trim();
    if (text.isEmpty && (_attachedImagePath == null || _attachedImagePath!.isEmpty)) {
      return;
    }
    // If attached image is a local path, attempt to upload to Storage and get URL.
    Future<void> doPost() async {
      String? imageUrl = _attachedImagePath;
      if (imageUrl != null && !imageUrl.startsWith('http')) {
        try {
          imageUrl = await StorageService.uploadFile(imageUrl);
        } catch (_) {
          // fallback to local path
        }
      }
      state.addCommunityPost(text, imageUrl: imageUrl);
    }
    doPost();
    _postCtrl.clear();
    setState(() => _attachedImagePath = null);
    FocusScope.of(context).unfocus();
  }

  Future<void> _pickImage() async {
    final path = await ImageService.pickFromGallery();
    if (path != null) setState(() => _attachedImagePath = path);
  }

  Future<void> _showComments(BuildContext context, CommunityPost post) async {
    final controller = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
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
                  SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Comments',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Consumer<AppState>(
                      builder: (context, state, _) {
                        final updated = state.getCommunityPost(post.id) ?? post;
                        final comments = updated.comments;
                        if (comments.isEmpty) {
                          return Center(
                            child: Text(
                              'No comments yet. Be the first to reply.',
                              style: TextStyle(
                                  color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                                  fontSize: 13),
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: comments.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(radius: 16, backgroundColor: AppColors.chart3, child: Text('🧑', style: TextStyle(fontSize: 14))),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline)),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(comment.author, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                                      SizedBox(height: 4),
                                      Text(comment.text, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface, height: 1.3)),
                                      SizedBox(height: 6),
                                      Text(comment.timeLabel, style: TextStyle(fontSize: 10, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                                    ]),
                                  ),
                                ),
                                if (comment.author == 'You')
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final app = context.read<AppState>();
                                          final editCtrl = TextEditingController(text: comment.text);
                                          final edited = await showDialog<String>(
                                            context: sheetContext,
                                            builder: (dctx) => AlertDialog(
                                              title: Text('Edit comment'),
                                              content: TextField(controller: editCtrl, maxLines: 3),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(dctx, null), child: Text('Cancel')),
                                                TextButton(onPressed: () => Navigator.pop(dctx, editCtrl.text), child: Text('Save')),
                                              ],
                                            ),
                                          );
                                          if (edited != null && edited.trim().isNotEmpty) {
                                            app.editCommunityComment(post.id, comment.id, edited.trim());
                                          }
                                        },
                                        icon: Icon(Icons.edit_outlined, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                                      ),
                                      IconButton(onPressed: () => context.read<AppState>().deleteCommunityComment(post.id, comment.id), icon: Icon(Icons.delete_outline, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                                    ],
                                  ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.chart3,
                          child: Text('🧑', style: TextStyle(fontSize: 14)),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
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
                          icon: Icon(Icons.send_rounded,
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

  List<CommunityPost> _filteredPosts(List<CommunityPost> posts) {
    final query = _searchCtrl.text.trim().toLowerCase();
    return posts.where((post) {
      final matchesQuery = query.isEmpty ||
          post.caption.toLowerCase().contains(query) ||
          post.userName.toLowerCase().contains(query);
      final matchesFeed = switch (_selectedFeed) {
        'Moderation' => post.hidden || post.reportCount > 0,
        'Saved' => post.bookmarked,
        'Trending' => post.likeCount >= 100,
        _ => !post.hidden,
      };
      return matchesQuery && matchesFeed;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final posts = _filteredPosts(state.communityPosts);

    return ResponsiveBody(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Text(
                'Community',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search community posts…',
                  prefixIcon: Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['All', 'Trending', 'Saved', 'Moderation'].map((feed) {
                  final selected = feed == _selectedFeed;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(feed),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedFeed = feed),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      backgroundColor: Theme.of(context).cardColor,
                      side: BorderSide(
                        color: selected ? AppColors.primary : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Composer
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.chart3,
                          child: Text('🧑', style: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _postCtrl,
                            maxLines: 4,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Share your plant journey...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Posting as You',
                          style: TextStyle(
                              fontSize: 12, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                        ),
                        Spacer(),
                        if (_attachedImagePath != null)
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: kIsWeb || _attachedImagePath!.startsWith('http')
                                ? Image.network(_attachedImagePath!, height: 48, width: 72, fit: BoxFit.cover)
                                : Image.file(File(_attachedImagePath!), height: 48, width: 72, fit: BoxFit.cover),
                          ),
                        IconButton(
                          onPressed: _pickImage,
                          icon: Icon(Icons.photo_library, color: AppColors.primary),
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _postCtrl,
                          builder: (context, value, _) {
                            final canPost = value.text.trim().isNotEmpty;
                            return ElevatedButton(
                              onPressed: (canPost || _attachedImagePath != null) ? () => _submitPost(state) : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: StadiumBorder(),
                                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              child: Text('Post'),
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
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['You', 'Alice', 'Marco', 'Mia', 'Lena', 'Chris']
                    .map((name) {
                  final isYou = name == 'You';
                  return Padding(
                    padding: EdgeInsets.only(right: 14),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isYou ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.9) : AppColors.secondary,
                              width: 2.5,
                            ),
                          ),
                          child: isYou
                              ? CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                                  child: Icon(Icons.add_rounded,
                                      color: AppColors.secondary),
                                )
                              : CircleAvatar(
                                  backgroundColor: AppColors.chart3,
                                  child: Text(name[0],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary)),
                                ),
                        ),
                        SizedBox(height: 4),
                        Text(name,
                            style: TextStyle(
                                fontSize: 11,
                                color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Divider(color: Theme.of(context).colorScheme.outline, height: 1),
            SizedBox(height: 8),

            // Posts
            if (posts.isEmpty)
              Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No posts match this filter yet.',
                    style: TextStyle(color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                  ),
                ),
              )
            else
              ...posts.map(
                (post) => _PostCard(
                  post: post,
                  onLike: () => state.toggleCommunityLike(post.id),
                  onComment: () => _showComments(context, post),
                  onBookmark: () => state.toggleCommunityBookmark(post.id),
                  onReport: () => state.toggleCommunityReport(post.id),
                  onHide: () => state.toggleCommunityHidden(post.id),
                  onResolve: () => state.clearCommunityModeration(post.id),
                ),
              ),
            SizedBox(height: 16),
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
  final VoidCallback onReport;
  final VoidCallback onHide;
  final VoidCallback onResolve;

  _PostCard({
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onBookmark,
    required this.onReport,
    required this.onHide,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.chart3,
                  radius: 20,
                  child:
                      Text(post.avatar, style: TextStyle(fontSize: 18)),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.userName,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface)),
                    Text(post.timeLabel,
                        style: TextStyle(
                            fontSize: 11, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                  ],
                ),
                Spacer(),
                PopupMenuButton<String>(
                  onSelected: (choice) async {
                    final app = context.read<AppState>();
                    final localContext = context;
                    if (choice == 'edit') {
                      final ctrl = TextEditingController(text: post.caption);
                      String? newImage = post.imageUrl;
                      final result = await showDialog<Map<String, String?>>(
                        context: localContext,
                        builder: (dctx) => AlertDialog(
                          title: Text('Edit post'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(controller: ctrl),
                              SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () async {
                                  final p = await ImageService.pickFromGallery();
                                  if (p != null) newImage = p;
                                },
                                icon: Icon(Icons.photo_library),
                                label: Text('Change image'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(dctx, null), child: Text('Cancel')),
                            TextButton(
                              onPressed: () => Navigator.pop(dctx, {'caption': ctrl.text, 'image': newImage}),
                              child: Text('Save'),
                            ),
                          ],
                        ),
                      );
                      if (result != null) {
                        String? imageToSave = result['image'];
                        if (imageToSave != null && !imageToSave.startsWith('http')) {
                          try {
                            imageToSave = await StorageService.uploadFile(imageToSave);
                          } catch (_) {}
                        }
                        app.editCommunityPost(post.id, caption: result['caption'] ?? post.caption, imageUrl: imageToSave);
                      }
                    } else if (choice == 'delete') {
                      final confirmed = await showDialog<bool>(
                        context: localContext,
                        builder: (dctx) => AlertDialog(
                          title: Text('Delete post?'),
                          content: Text('This will remove the post.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(dctx, false), child: Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(dctx, true), child: Text('Delete')),
                          ],
                        ),
                      );
                      if (confirmed == true) app.deleteCommunityPost(post.id);
                    } else if (choice == 'report') {
                      onReport();
                    } else if (choice == 'hide') {
                      onHide();
                    } else if (choice == 'resolve') {
                      onResolve();
                    }
                  },
                  itemBuilder: (_) => [
                    if (post.userName == 'You')
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                    if (post.userName == 'You')
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    if (post.userName != 'You')
                      PopupMenuItem(
                        value: 'report',
                        child: Text(post.reportedByMe ? 'Remove Report' : 'Report'),
                      ),
                    PopupMenuItem(
                      value: 'hide',
                      child: Text(post.hidden ? 'Show in feed' : 'Hide from feed'),
                    ),
                    if (post.reportCount > 0)
                      PopupMenuItem(value: 'resolve', child: Text('Resolve reports')),
                  ],
                  child: Icon(Icons.more_horiz_rounded, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                ),
              ],
            ),
          ),

          if (post.hidden || post.reportCount > 0)
            Padding(
              padding: EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (post.hidden)
                    _Badge(label: 'Hidden', color: AppColors.destructive),
                  if (post.reportCount > 0)
                    _Badge(label: 'Reported ${post.reportCount}', color: AppColors.secondary),
                ],
              ),
            ),

          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            (kIsWeb || post.imageUrl!.startsWith('http'))
                ? Image.network(
                    post.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 200, color: AppColors.chart4),
                  )
                : Image.file(File(post.imageUrl!), height: 200, width: double.infinity, fit: BoxFit.cover),

          // Caption + actions
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.caption,
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.4)),
                SizedBox(height: 12),
                Row(
                  children: [
                    _ActionButton(
                      onTap: onLike,
                      child: Row(
                        children: [
                          AnimatedScale(
                            duration: Duration(milliseconds: 120),
                            scale: post.likedByMe ? 1.1 : 1.0,
                            child: Icon(
                              post.likedByMe
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 20,
                              color: post.likedByMe
                                  ? AppColors.destructive
                                  : (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${post.likeCount}',
                            style: TextStyle(
                                fontSize: 13, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    _ActionButton(
                      onTap: onComment,
                      child: Row(
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded,
                              size: 18, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                          SizedBox(width: 4),
                          Text('${post.commentCount}',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                        ],
                      ),
                    ),
                    Spacer(),
                    _ActionButton(
                      onTap: onBookmark,
                      child: Icon(
                        post.bookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: 20,
                        color: post.bookmarked
                            ? AppColors.secondary
                            : (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
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

  _ActionButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: child,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Removed unused _CommentTile widget.

