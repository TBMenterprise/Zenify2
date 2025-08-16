import 'MainPages/main.dart' as entry;

/// Shim so `flutter run` (which looks for `lib/main.dart`) finds a valid entrypoint.
/// This simply forwards to the real app entry in `lib/MainPages/main.dart`.
void main() {
  // entry.main() is declared `void main() async` in the real file,
  // so don't `await` it here — just call it.
  entry.main();
}
