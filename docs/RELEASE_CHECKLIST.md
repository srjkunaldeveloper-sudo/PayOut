# Release Checklists

Follow these check steps before compiling production application packages.

---

## 🚦 Release Verification Lists
- Run analysis compiler checks: `flutter analyze`.
- Test package assets files and localizations strings.
- Verify security configurations (`AppConfig.isDemoMode == false`).
- Compile artifact bundles: `flutter build apk --release`.
