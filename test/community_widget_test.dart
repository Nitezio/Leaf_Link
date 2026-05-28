import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:plantcare_pro/models/app_state.dart';
import 'package:plantcare_pro/services/notification_service.dart';
import 'fakes/fake_flutter_local_notifications.dart';
import 'package:plantcare_pro/screens/community_tab.dart';
import 'package:plantcare_pro/services/image_service.dart';

void main() {
  testWidgets('composer can add post with image and edit/delete', (tester) async {
    ImageService.pickOverride = () async => 'path/to/mock.jpg';

    NotificationService.instance.setTestPlugin(FakeFlutterLocalNotificationsPlugin());
    final state = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(home: Scaffold(body: CommunityTab())),
      ),
    );

    await tester.pumpAndSettle();

    // Enter post text (target composer by hint)
    final postField = find.byWidgetPredicate((w) => w is TextField && w.decoration != null && w.decoration!.hintText == 'Share your plant journey...');
    await tester.enterText(postField, 'Hello from widget test');
    await tester.pumpAndSettle();

    // Tap image icon
    final photoButton = find.widgetWithIcon(IconButton, Icons.photo_library);
    expect(photoButton, findsOneWidget);
    await tester.tap(photoButton);
    await tester.pumpAndSettle();

    // Tap Post
    final postButton = find.text('Post');
    expect(postButton, findsOneWidget);
    await tester.tap(postButton);
    await tester.pumpAndSettle();

    // Verify a new post exists
    expect(state.communityPosts.isNotEmpty, true);
    final post = state.communityPosts.first;
    expect(post.caption, contains('Hello from widget test'));
    expect(post.imageUrl, 'path/to/mock.jpg');

    // Edit post
    // open menu
    final moreIcon = find.byIcon(Icons.more_horiz_rounded).first;
    await tester.tap(moreIcon);
    await tester.pumpAndSettle();
    // select Edit (menu contains 'Edit' text)
    final editItem = find.text('Edit');
    expect(editItem, findsOneWidget);
    await tester.tap(editItem);
    await tester.pumpAndSettle();
    // in dialog, change text
    final dialogField = find.byType(TextField).last;
    await tester.enterText(dialogField, 'Edited caption');
    await tester.pumpAndSettle();
    final saveButton = find.text('Save');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(state.communityPosts.first.caption, contains('Edited caption'));

    // Delete post
    await tester.tap(moreIcon);
    await tester.pumpAndSettle();
    final deleteItem = find.text('Delete');
    expect(deleteItem, findsOneWidget);
    await tester.tap(deleteItem);
    await tester.pumpAndSettle();
    final confirmDelete = find.text('Delete').last;
    await tester.tap(confirmDelete);
    await tester.pumpAndSettle();
    expect(state.communityPosts.where((p) => p.id == post.id).isEmpty, true);

    ImageService.pickOverride = null;
  });
}
