import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantcare_pro/models/app_state.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('add/edit/delete post with image and comments', () async {
    final state = AppState();
    await Future.delayed(const Duration(milliseconds: 200));

    state.addCommunityPost('Hello world', imageUrl: 'path/to/img.jpg');
    expect(state.communityPosts.isNotEmpty, isTrue);
    final post = state.communityPosts.first;
    expect(post.imageUrl, 'path/to/img.jpg');

    // edit
    state.editCommunityPost(post.id, caption: 'Edited caption');
    final edited = state.getCommunityPost(post.id)!;
    expect(edited.caption, 'Edited caption');

    // comment
    state.addCommunityComment(post.id, 'Nice post');
    final withComment = state.getCommunityPost(post.id)!;
    expect(withComment.comments.isNotEmpty, isTrue);
    final commentId = withComment.comments.first.id;

    // delete comment
    state.deleteCommunityComment(post.id, commentId);
    final afterDeleteComment = state.getCommunityPost(post.id)!;
    expect(afterDeleteComment.comments.where((c) => c.id == commentId).isEmpty, isTrue);

    // delete post
    state.deleteCommunityPost(post.id);
    expect(state.getCommunityPost(post.id), isNull);
  });
}
