# Full Audit Report - PlantCare Pro (Leaf_Link)

Last updated: 2026-05-26 10:10:17 +08:00

## Scope
- Codebase: Flutter app in this repo.
- Branch: main (synced with origin/main at time of audit).
- Checks run: flutter analyze, flutter test --coverage.

## Current health
- Analyzer: informational issues remain (4 items found: 3 info-level, 1 warning).
	- Notable: `use_build_context_synchronously` info in `lib/screens/plant_detail_screen.dart`.
	- Test files use a deprecated `setMockMethodCallHandler` pattern (update to TestDefaultBinaryMessengerBinding).
- Tests: test suite ran; all tests passed in current run. Some tests mock platform plugins (shared_preferences, flutter_secure_storage) to run in the VM.
- CI: GitHub Actions runs analyze and tests on push/PR in [ .github/workflows/flutter-ci.yaml ]( .github/workflows/flutter-ci.yaml ).

## Architecture overview
- App entry and navigation: [lib/main.dart](lib/main.dart) sets up Firebase init (best-effort) and Provider, with Welcome -> Login -> Home flow.
- State management: [lib/models/app_state.dart](lib/models/app_state.dart) is the single source of truth using `ChangeNotifier`.
- Data models: [lib/models/models.dart](lib/models/models.dart) for `Plant`, `CareEvent`, `CommunityPost`, `MarketplaceItem`, `CartItem`, `ScanResult`.
- Persistence: [lib/services/persistence_service.dart](lib/services/persistence_service.dart) uses SharedPreferences.
- Secure storage wrapper: [lib/services/secure_storage_service.dart](lib/services/secure_storage_service.dart) is used for auth-session fallback storage.
- Firebase adapters: [lib/services/firestore_service.dart](lib/services/firestore_service.dart), [lib/services/storage_service.dart](lib/services/storage_service.dart), [lib/services/auth_service.dart](lib/services/auth_service.dart), [lib/services/firebase_service.dart](lib/services/firebase_service.dart).
- Images: [lib/services/image_service.dart](lib/services/image_service.dart) wraps ImagePicker and supports a test override.
- Theme/responsive: [lib/theme/app_theme.dart](lib/theme/app_theme.dart), [lib/widgets/responsive_body.dart](lib/widgets/responsive_body.dart).

## What is implemented (done)
- Core shell and navigation: Welcome, Login, Home with bottom navigation and a scan FAB ([lib/main.dart](lib/main.dart), [lib/screens/home_screen.dart](lib/screens/home_screen.dart)).
- Local auth flow: sign-in/sign-up validations with session persistence, secure-storage fallback, sign-out state, and login feedback ([lib/screens/login_screen.dart](lib/screens/login_screen.dart), [lib/models/app_state.dart](lib/models/app_state.dart)).
- Plant management: list, add/edit, detail view, watering action, care history, streak updates, and local watering reminder scheduling ([lib/screens/garden_tab.dart](lib/screens/garden_tab.dart), [lib/screens/add_edit_plant_screen.dart](lib/screens/add_edit_plant_screen.dart), [lib/screens/plant_detail_screen.dart](lib/screens/plant_detail_screen.dart)).
- Community: feed UI, search/filter chips, composer with image attach, edit/delete posts, add/delete comments, and comment edit UX ([lib/screens/community_tab.dart](lib/screens/community_tab.dart)).
- Marketplace: search, categories, item details sheet, cart sheet, add/increment/decrement/remove, cart persistence, and checkout stock validation ([lib/screens/marketplace_tab.dart](lib/screens/marketplace_tab.dart), [lib/models/app_state.dart](lib/models/app_state.dart)).
- Scan/AR UI: interactive mock flows for scan, AR placement, growth predictor, recent scans ([lib/screens/scan_tab.dart](lib/screens/scan_tab.dart)).
- Profile + settings: gamification panel, profile edit, vacation/notifications/dark mode toggles, and secure session handling ([lib/screens/profile_tab.dart](lib/screens/profile_tab.dart), [lib/screens/settings_screen.dart](lib/screens/settings_screen.dart), [lib/screens/edit_profile_screen.dart](lib/screens/edit_profile_screen.dart)).
- CI pipeline: analyze + tests on push/PR ([ .github/workflows/flutter-ci.yaml ]( .github/workflows/flutter-ci.yaml )).

## Partially implemented or missing
- Real authentication: Firebase Auth service exists but UI still uses local-only flow; no real backend login or password reset ([lib/services/auth_service.dart](lib/services/auth_service.dart), [lib/screens/login_screen.dart](lib/screens/login_screen.dart)).
- Secure storage usage: session data now prefers `SecureStorageService`, but broader secret management and backend session sync are still local-only ([lib/services/secure_storage_service.dart](lib/services/secure_storage_service.dart)).
- Firebase config: no `firebase_options.dart` found, so Firebase init is best-effort and likely fails without platform config ([lib/main.dart](lib/main.dart)).
- Community moderation and persistence: comment edit UX exists, but moderation workflows and Firestore-backed moderation actions are still missing ([lib/models/app_state.dart](lib/models/app_state.dart), [lib/screens/community_tab.dart](lib/screens/community_tab.dart)).
- Marketplace checkout: checkout validation and inventory decrement exist, but no receipt history or payment flow is implemented ([lib/screens/marketplace_tab.dart](lib/screens/marketplace_tab.dart)).
- Scan/AR real integrations: scan and AR are UI-only placeholders with simulated results ([lib/screens/scan_tab.dart](lib/screens/scan_tab.dart)).
- Notifications and watering scheduler: watering reminder UI exists, but real platform notification scheduling is still a placeholder/no-op.
- Accessibility and localization: no explicit a11y review or localization support is implemented.

## Known issues and risks
- Plant reminder scheduling currently relies on local UI state and a no-op notification service; reminders will not fire as OS notifications yet ([lib/services/notification_service.dart](lib/services/notification_service.dart), [lib/screens/plant_detail_screen.dart](lib/screens/plant_detail_screen.dart)).
- Plant reminder UI still uses local `use_build_context_synchronously` ignores around picker dialogs; this should be refactored to remove the suppression ([lib/screens/plant_detail_screen.dart](lib/screens/plant_detail_screen.dart)).
- Test files currently use deprecated `setMockMethodCallHandler`; the tests pass, but the mocking approach should be modernized ([test/scheduling_test.dart](test/scheduling_test.dart), [test/marketplace_checkout_test.dart](test/marketplace_checkout_test.dart)).
- Firestore sync assumes documents include an `id` field in data; if external data omits it, `CommunityPost.fromMap` will fail ([lib/models/models.dart](lib/models/models.dart), [lib/services/firestore_service.dart](lib/services/firestore_service.dart)).
- Firebase config is still absent, so backend-related features remain best-effort on non-configured devices ([lib/main.dart](lib/main.dart)).

## Severity-ranked findings
1. High - Authentication remains local-only.
	- Firebase Auth exists as a service, but the UI still routes through a local session flow.
	- Password reset, account recovery, and true backend session state are missing.
	- Affected files: [lib/services/auth_service.dart](lib/services/auth_service.dart), [lib/screens/login_screen.dart](lib/screens/login_screen.dart), [lib/models/app_state.dart](lib/models/app_state.dart).

2. Medium - Firestore data contracts are not hardened.
	- The app expects Firestore documents to contain all required fields in a specific shape.
	- Missing or malformed fields will surface as runtime parse errors during sync.
	- Affected files: [lib/models/models.dart](lib/models/models.dart), [lib/services/firestore_service.dart](lib/services/firestore_service.dart).

3. Medium - Notifications are still a placeholder.
	- Reminder UI exists, but there is no real scheduled-notification implementation yet.
	- Affected files: [lib/services/notification_service.dart](lib/services/notification_service.dart), [lib/screens/plant_detail_screen.dart](lib/screens/plant_detail_screen.dart).

4. Medium - Some analyzer suppressions remain in the plant reminder flow.
	- The date/time picker flow still relies on local `use_build_context_synchronously` ignores.
	- This is safe enough for now, but it should be refactored so the report can stay clean without suppressions.
	- Affected file: [lib/screens/plant_detail_screen.dart](lib/screens/plant_detail_screen.dart).

5. Low - Several features are still UI-only prototypes.
	- Scan/AR flows and broader backend syncing are represented in the UI but not yet fully integrated.
	- Affected files: [lib/screens/scan_tab.dart](lib/screens/scan_tab.dart), [lib/models/app_state.dart](lib/models/app_state.dart).

## Prioritized remediation plan
1. Decide the authentication direction.
	- Either wire `AuthService` into the login flow or remove the unused Firebase auth surface until backend auth is ready.
	- If backend auth is the goal, add explicit session storage and a reset-password path.

2. Harden backend contracts.
	- Add defensive parsing and validation for Firestore documents.
	- Consider a small DTO layer if Firestore data becomes more complex.

3. Finish the remaining product gaps.
	- Add real notification scheduling behind `NotificationService`.
	- Add receipt history or explicit preview labeling for marketplace checkout.
	- Add accessibility and localization review before release.

4. Remove the remaining analyzer suppressions in the plant reminder flow.
	- Refactor the date/time picker callbacks so the local ignore comments can be deleted.
	- Keep analyzer clean without suppressions.

5. Add integration tests for plugin-backed features.
	- Cover secure storage, shared preferences, and image picker behavior on device/emulator.

## Feature completion (estimate)
Percentages are subjective and reflect implementation depth, not design polish.

| Area | Completion | Notes |
| --- | --- | --- |
| App shell + navigation | 85% | Stable shell and responsive layout; deep links, back-button handling, and a11y polish are still missing. |
| Auth + session | 70% | Local flow works; session data now prefers secure storage, but Firebase Auth is not wired. |
| Plant management | 88% | CRUD, care history, streaks, and reminder scheduling; real notifications still missing. |
| Community | 85% | Composer, posts, comments, post edit/delete, and comment edit UX; moderation flows are still missing. |
| Marketplace | 82% | Search, cart, persistence, and checkout validation; no receipt history or payment flow. |
| Scan/AR | 30% | UI-only simulation, no device integration. |
| Profile + settings | 80% | Profile edit, gamification, toggles, and secure session handling; cloud sync remains missing. |
| Persistence + storage | 80% | SharedPreferences plus secure storage fallback and local file upload fallback; broader secret sync is still local-only. |
| Backend sync | 55% | Firestore + Storage adapters exist, but Firebase config and defensive DTO parsing are incomplete. |
| Testing + CI | 85% | Unit + widget tests and CI; plugin-backed integration tests are still missing. |
| Accessibility + localization | 20% | No explicit a11y or i18n work yet. |

## Test coverage (current)
- Unit tests
	- [test/app_state_test.dart](test/app_state_test.dart): sign-out and profile persistence.
	- [test/care_history_test.dart](test/care_history_test.dart): watering adds care events and streak updates.
	- [test/community_test.dart](test/community_test.dart): add/edit/delete posts and comments.
	- [test/scheduling_test.dart](test/scheduling_test.dart): scheduling updates local watering reminders.
	- [test/marketplace_checkout_test.dart](test/marketplace_checkout_test.dart): checkout reduces stock and clears cart.
- Widget tests
	- [test/community_widget_test.dart](test/community_widget_test.dart): composer, image attach, edit/delete post.
	- [test/marketplace_widget_test.dart](test/marketplace_widget_test.dart): search, add to cart, cart sheet actions.
	- [test/widget_test.dart](test/widget_test.dart): core flows for home, plant detail, add plant, settings toggle.

## Dependencies and tooling
- State management: provider.
- Storage: shared_preferences, flutter_secure_storage.
- Firebase: firebase_core, firebase_auth, cloud_firestore, firebase_storage, google_sign_in.
- Images: cached_network_image, image_picker.
- Logging: logger.

## Recommended next actions
1. Wire Firebase Auth in the UI and session management (or remove unused auth service).
2. Harden Firestore parsing and add DTO validation before enabling sync.
3. Replace the local notification placeholder with real scheduling.
4. Remove the remaining analyzer suppressions in the plant reminder flow.
5. Add integration tests for plugin-backed features (secure storage, prefs, image picker).
6. Add deep links, back-button handling, and a11y polish for the app shell.

## Deep Audit (2026-05-27)

- Audit performed: repo-wide grep + analyzer + focused test runs; generated a full text report at [docs/FULL_AUDIT_REPORT.txt](docs/FULL_AUDIT_REPORT.txt).
- TODO list updated to reflect recent work (plant management marked completed; other items set to in-progress/not-started as appropriate).
- Quick deltas since last report:
	- Added local scheduling UI for plants and persisted marketplace stock handling.
	- Migrated auth-session persistence to prefer `flutter_secure_storage` with prefs fallback.
	- Added a no-op `NotificationService` wrapper (placeholder for later `flutter_local_notifications` integration).
	- Added unit tests for scheduling and marketplace checkout and mocked platform channels for test stability.

See `docs/FULL_AUDIT_REPORT.txt` for the full audit, evidence, and prioritized remediation plan.
