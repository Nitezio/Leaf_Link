# Full Audit Report - PlantCare Pro (Leaf_Link)

Last updated: 2026-05-26 10:10:17 +08:00

## Scope
- Codebase: Flutter app in this repo.
- Branch: main (synced with origin/main at time of audit).
- Checks run: flutter analyze, flutter test --coverage.

- ## Current health
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
- Secure storage wrapper: [lib/services/secure_storage_service.dart](lib/services/secure_storage_service.dart) exists but is not wired into app state.
- Firebase adapters: [lib/services/firestore_service.dart](lib/services/firestore_service.dart), [lib/services/storage_service.dart](lib/services/storage_service.dart), [lib/services/auth_service.dart](lib/services/auth_service.dart), [lib/services/firebase_service.dart](lib/services/firebase_service.dart).
- Images: [lib/services/image_service.dart](lib/services/image_service.dart) wraps ImagePicker and supports a test override.
- Theme/responsive: [lib/theme/app_theme.dart](lib/theme/app_theme.dart), [lib/widgets/responsive_body.dart](lib/widgets/responsive_body.dart).

## What is implemented (done)
- Core shell and navigation: Welcome, Login, Home with bottom navigation and a scan FAB ([lib/main.dart](lib/main.dart), [lib/screens/home_screen.dart](lib/screens/home_screen.dart)).
- Local auth flow: sign-in/sign-up validations with local session persistence, sign-out state, and login feedback ([lib/screens/login_screen.dart](lib/screens/login_screen.dart), [lib/models/app_state.dart](lib/models/app_state.dart)).
- Plant management: list, add/edit, detail view, watering action, care history, and streak updates ([lib/screens/garden_tab.dart](lib/screens/garden_tab.dart), [lib/screens/add_edit_plant_screen.dart](lib/screens/add_edit_plant_screen.dart), [lib/screens/plant_detail_screen.dart](lib/screens/plant_detail_screen.dart)).
- Community: feed UI, search/filter chips, composer with image attach, edit/delete posts, add/delete comments, like/bookmark ([lib/screens/community_tab.dart](lib/screens/community_tab.dart)).
- Marketplace: search, categories, item details sheet, cart sheet, add/increment/decrement/remove, cart persistence ([lib/screens/marketplace_tab.dart](lib/screens/marketplace_tab.dart), [lib/models/app_state.dart](lib/models/app_state.dart)).
- Scan/AR UI: interactive mock flows for scan, AR placement, growth predictor, recent scans ([lib/screens/scan_tab.dart](lib/screens/scan_tab.dart)).
- Profile + settings: gamification panel, profile edit, vacation/notifications/dark mode toggles ([lib/screens/profile_tab.dart](lib/screens/profile_tab.dart), [lib/screens/settings_screen.dart](lib/screens/settings_screen.dart), [lib/screens/edit_profile_screen.dart](lib/screens/edit_profile_screen.dart)).
- CI pipeline: analyze + tests on push/PR ([ .github/workflows/flutter-ci.yaml ]( .github/workflows/flutter-ci.yaml )).

## Partially implemented or missing
- Real authentication: Firebase Auth service exists but UI still uses local-only flow; no real backend login or password reset ([lib/services/auth_service.dart](lib/services/auth_service.dart), [lib/screens/login_screen.dart](lib/screens/login_screen.dart)).
- Secure storage usage: `SecureStorageService` is not used for secrets or sessions ([lib/services/secure_storage_service.dart](lib/services/secure_storage_service.dart)).
- Firebase config: no `firebase_options.dart` found, so Firebase init is best-effort and likely fails without platform config ([lib/main.dart](lib/main.dart)).
- Community moderation and comment editing UI: data model and edit method exist, but no edit UI for comments ([lib/models/app_state.dart](lib/models/app_state.dart), [lib/screens/community_tab.dart](lib/screens/community_tab.dart)).
- Marketplace checkout: checkout button is a stub and no payment flow is implemented ([lib/screens/marketplace_tab.dart](lib/screens/marketplace_tab.dart)).
- Scan/AR real integrations: scan and AR are UI-only placeholders with simulated results ([lib/screens/scan_tab.dart](lib/screens/scan_tab.dart)).
- Notifications and watering scheduler: UI strings exist, but no background scheduling or push notifications.
- Accessibility and localization: no explicit a11y review or localization support is implemented.

## Known issues and risks
- Cart sheet does not react to state changes while open because it renders from a captured `state` instead of a `Consumer` ([lib/screens/marketplace_tab.dart](lib/screens/marketplace_tab.dart)).
- Cart persistence does not save quantity changes from `incrementCartItem`/`decrementCartItem` (missing `_saveCart()` calls) ([lib/models/app_state.dart](lib/models/app_state.dart)).
- Local plant images do not render in cards because `PlantCard` always uses `CachedNetworkImage` even for local paths ([lib/widgets/plant_card.dart](lib/widgets/plant_card.dart)).
- Community uses `// ignore_for_file: use_build_context_synchronously` to allow dialog flow; should be refactored to avoid suppressing lint ([lib/screens/community_tab.dart](lib/screens/community_tab.dart)).
- Firestore sync assumes documents include an `id` field in data; if external data omits it, `CommunityPost.fromMap` will fail ([lib/models/models.dart](lib/models/models.dart), [lib/services/firestore_service.dart](lib/services/firestore_service.dart)).

## Severity-ranked findings
1. High - Market cart state is not fully reactive or durable.
	- The cart sheet captures a snapshot of `AppState` instead of listening live, so quantity updates may not repaint while the sheet is open.
	- Quantity changes in `incrementCartItem` and `decrementCartItem` are not persisted immediately, which can lose state after a restart.
	- Affected files: [lib/screens/marketplace_tab.dart](lib/screens/marketplace_tab.dart), [lib/models/app_state.dart](lib/models/app_state.dart).

2. High - Authentication remains local-only.
	- Firebase Auth exists as a service, but the UI still routes through a local session flow.
	- Password reset, account recovery, and true backend session state are missing.
	- Affected files: [lib/services/auth_service.dart](lib/services/auth_service.dart), [lib/screens/login_screen.dart](lib/screens/login_screen.dart), [lib/models/app_state.dart](lib/models/app_state.dart).

3. Medium - Plant image rendering is inconsistent.
	- Local file paths are passed through a network-only image path in plant cards, so gallery-picked images may not render correctly outside detail/edit flows.
	- Affected files: [lib/widgets/plant_card.dart](lib/widgets/plant_card.dart), [lib/screens/add_edit_plant_screen.dart](lib/screens/add_edit_plant_screen.dart).

4. Medium - Community dialog flow relies on lint suppression.
	- `community_tab.dart` currently suppresses `use_build_context_synchronously` at the file level rather than refactoring every async dialog path.
	- This is not an immediate runtime failure, but it weakens maintainability and hides future mistakes.
	- Affected file: [lib/screens/community_tab.dart](lib/screens/community_tab.dart).

5. Medium - Firestore data contracts are not hardened.
	- The app expects Firestore documents to contain all required fields in a specific shape.
	- Missing or malformed fields will surface as runtime parse errors during sync.
	- Affected files: [lib/models/models.dart](lib/models/models.dart), [lib/services/firestore_service.dart](lib/services/firestore_service.dart).

6. Low - Several features are still UI-only prototypes.
	- Scan/AR flows, checkout, scheduler/notifications, and broader backend syncing are represented in the UI but not yet fully integrated.
	- Affected files: [lib/screens/scan_tab.dart](lib/screens/scan_tab.dart), [lib/screens/marketplace_tab.dart](lib/screens/marketplace_tab.dart), [lib/models/app_state.dart](lib/models/app_state.dart).

## Prioritized remediation plan
1. Fix cart reactivity and persistence first.
	- Wrap the cart sheet in a `Consumer<AppState>` and make quantity mutations persist immediately.
	- Add a focused widget test that changes quantity while the cart sheet is open.

2. Decide the authentication direction.
	- Either wire `AuthService` into the login flow or remove the unused Firebase auth surface until backend auth is ready.
	- If backend auth is the goal, add explicit session storage and a reset-password path.

3. Harden image handling.
	- Make plant cards support both network URLs and local file paths.
	- Add tests that cover gallery-picked images and offline/local image rendering.

4. Remove lint suppression by refactoring community dialogs.
	- Split async dialog callbacks so `BuildContext` is only used when safe.
	- Keep analyzer clean without file-level ignores.

5. Tighten backend contracts.
	- Add defensive parsing and validation for Firestore documents.
	- Consider a small DTO layer if Firestore data becomes more complex.

6. Finish the remaining product gaps.
	- Add checkout or explicitly mark the marketplace as preview-only.
	- Add scheduler/notification plumbing.
	- Add accessibility and localization review before release.

## Feature completion (estimate)
Percentages are subjective and reflect implementation depth, not design polish.

| Area | Completion | Notes |
| --- | --- | --- |
| App shell + navigation | 95% | Stable shell, responsive layout, no deep routing. |
| Auth + session | 60% | Local flow works; Firebase Auth exists but not wired. |
| Plant management | 80% | CRUD, care history, streaks; no scheduling/notifications. |
| Community | 80% | Composer, posts, comments, edit/delete; no comment edit UI. |
| Marketplace | 70% | Search, cart, detail sheet; no checkout or live inventory. |
| Scan/AR | 30% | UI-only simulation, no device integration. |
| Profile + settings | 75% | Profile edit, gamification, toggles; no cloud sync. |
| Persistence + storage | 70% | SharedPreferences ok; secure storage not used. |
| Backend sync | 50% | Firestore + Storage adapters exist, best-effort. |
| Testing + CI | 80% | Unit + widget tests and CI; no integration tests. |
| Accessibility + localization | 20% | No explicit a11y or i18n work yet. |

## Test coverage (current)
- Unit tests
	- [test/app_state_test.dart](test/app_state_test.dart): sign-out and profile persistence.
	- [test/care_history_test.dart](test/care_history_test.dart): watering adds care events and streak updates.
	- [test/community_test.dart](test/community_test.dart): add/edit/delete posts and comments.
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
2. Fix cart reactivity and persistence (`Consumer` in cart sheet, save increments/decrements).
3. Add local image support in `PlantCard` for non-HTTP paths.
4. Replace lint ignores by restructuring dialog flows in community.
5. Decide on secure storage usage and migrate session data if needed.
6. Add integration tests (sign-out navigation, cart persistence, community sync).

## Deep Audit (2026-05-27)

- Audit performed: repo-wide grep + analyzer + focused test runs; generated a full text report at [docs/FULL_AUDIT_REPORT.txt](docs/FULL_AUDIT_REPORT.txt).
- TODO list updated to reflect recent work (plant management marked completed; other items set to in-progress/not-started as appropriate).
- Quick deltas since last report:
	- Added local scheduling UI for plants and persisted marketplace stock handling.
	- Migrated auth-session persistence to prefer `flutter_secure_storage` with prefs fallback.
	- Added a no-op `NotificationService` wrapper (placeholder for later `flutter_local_notifications` integration).
	- Added unit tests for scheduling and marketplace checkout and mocked platform channels for test stability.

See `docs/FULL_AUDIT_REPORT.txt` for the full audit, evidence, and prioritized remediation plan.
