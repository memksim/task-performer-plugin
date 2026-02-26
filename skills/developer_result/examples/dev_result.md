# Dev Result

## Task
- ID/link: ABC-123
- Context: Fix crash when opening profile screen without internet.

## Done
- Wrapped `UserRepository.getProfile()` request in retry+timeout.
- Added `NoConnection` state display and "Retry" button.
- Fixed NPE when `avatarUrl == null`.

## Where changed (code/modules)
- Modules: `profile:impl`, `core:network`
- Files:
  - `ProfileViewModel.kt`
  - `ProfileRepository.kt`
  - `NetworkModule.kt`

## How to verify
1. Enable airplane mode.
2. Open profile.
3. Verify that "No connection" and "Retry" button are shown.
4. Disable airplane mode, press "Retry".
Expected result: profile loads, no crashes.

## Tests
- Added test `ProfileViewModel_noConnection_emitsNoConnectionState`.

## Risks and limitations
- Retry may increase API load with poor internet — limited to 2 attempts.

## Follow-up
- [ ] Add exponential backoff and retry-rate metric.

## Fix Round #1 (after Review)
Date: 25.02.2026
Basis: PR #742 comments from reviewer
Fixed
- Was: imageLoader was created inside composable
- Became: extracted to remember + DI
- Where changed: GameCard.kt
- Was: no key in LazyColumn
- Became: added key = game.id
- Where changed: GamesCatalogScreen.kt
Reason
Initial implementation was done quickly for hypothesis testing, optimizations were skipped.
- Side effects
- Reduction of unnecessary recomposition
- Improved scroll state stability
## Fix Round #2 (after QA)
Date: 26.02.2026
Basis: QA-report #1182
Fixed
- Was: scroll position was lost on screen rotation
- Became: scroll state saved via rememberSaveable
- Where changed: GamesCatalogScreen.kt
- Was: empty card sometimes displayed during fast scrolling down
- Became: added loadState check + retry
- Where changed: GamesCatalogViewModel.kt
Reason
Configuration changes scenario and race condition during page loading were not considered.
- Side effects
- Added unit test Catalog_scrollState_restored
- Added error log for Paging
⚠️ Attention:
Change affects state restoration. Check on Android 12–14.
Updated "How to verify" block (after fixes)
1. Open catalog.
2. Scroll down.
3. Rotate screen.
4. Verify that position is saved.
5. Scroll down quickly — cards should not be empty.
Follow-up
- [ ] Make prefetch distance configurable
- [ ] Add average_page_load_time metric
- [ ] Consider image caching via disk cache