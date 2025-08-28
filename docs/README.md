# Technical Documentation — Half Bit AI (Capture)

This document explains the **approach**, **architecture**, **implementation**, **installation**, **user guide**, and **key features** of the Half Bit AI – Capture application, prepared for the Samsung EnnovateX 2025 AI Challenge submission.

> **Scope:** a demo-ready Flutter app that captures **text, image, and audio** locally, stores metadata in **Hive**, media on **device storage**, and exposes a simple extension point (**AiService**) for Team 2 to plug in AI features (LLMs, transcription, vision).

---

## 1) Approach & What Makes It Unique

- **Capture-first UX**: ultra-fast capture of text, images, and audio in one place with a single **Capture** entry point.
- **Offline-first**: all data persists locally (no network required). This improves privacy and enables demos in low-connectivity environments.
- **Lean storage**: media is stored as **files**; metadata is stored in Hive (key–value DB). This keeps the app responsive and the database small.
- **Extensible AI**: the **AiService** interface isolates the AI layer (server or on-device SDK). Team 2 can ship or swap models/APIs without touching the UI.
- **Production-friendly ergonomics**: image compression, manageable audio bitrate, and a clean UI (Material 3) make this feel like a proper product, not just a demo.

---

## 2) Technical Stack

- **Flutter (Material 3)** — cross-platform UI framework: <https://flutter.dev/>
- **Hive** + `hive_flutter` — local key-value storage: <https://docs.hivedb.dev/>
- **path_provider** — app documents directory paths: <https://pub.dev/packages/path_provider>
- **image_picker** — camera & gallery: <https://pub.dev/packages/image_picker>
- **flutter_image_compress** — JPEG compression: <https://pub.dev/packages/flutter_image_compress>
- **record (v6)** — audio recording via `AudioRecorder`: <https://pub.dev/packages/record>
- **audioplayers** — audio playback: <https://pub.dev/packages/audioplayers>
- **share_plus** — share text/files to other apps: <https://pub.dev/packages/share_plus>
- **uuid** — generate stable IDs: <https://pub.dev/packages/uuid>

> All libraries are OSS and commonly used in production Flutter apps.

---

## 3) Technical Architecture

### 3.1 Component Overview
```mermaid
flowchart TD
  A[UI — HomeScreen] --> B[CaptureSheet]
  A --> C[ItemCard List]
  C -->|tap image| D[ImageViewer]
  C -->|tap audio| E[AudioChip → audioplayers]
  B -->|save text| F[Hive Box 'items']
  B -->|save image| G[Compress → File Storage] --> F
  B -->|record audio| H[.m4a → File Storage] --> F
  B -->|invoke AI| I[AiService]
  I -->|text/image/audio| J[Backend or On-device SDK]
  A -->|listen| K[OutputBus (ValueNotifier)]
```

### 3.2 Data Model
- **VItem** fields: `id`, `type ('text'|'image'|'audio')`, `title`, `note`, `path?`, `createdAt`.
- Hive stores `VItem.toMap()`; media files live in app documents directory.

### 3.3 Storage Choices
- **Why files for media?** Faster I/O, fewer DB locks, and easy interop with OS/file-based APIs.
- **Why Hive for metadata?** Zero-boilerplate, reactive (`box.listenable()`), and perfect for small records.

### 3.4 Security & Privacy
- All data is **local** to device; nothing leaves the phone unless user explicitly shares.
- You can later add encryption-at-rest or cloud sync as needed.

### 3.5 AI Integration (Team 2)
- **Contract:** `AiService` with methods:
  - `analyzeText(String)` → summary/answer
  - `analyzeImage(String path)` → labels/caption
  - `transcribeAudio(String path)` → transcript
- Implement via **HTTP** or **on-device SDK** and return a simple `AiResult { displayText, meta? }`.
- Push results to the UI using `OutputBus.text` (ValueNotifier).

---

## 4) Implementation Details

### 4.1 Key Files
```
lib/
  data/
    boxes.dart          # Hive init + open 'items' box (Map storage)
    models.dart         # VItem model (toMap/fromMap)
  features/
    capture/capture_sheet.dart  # Save text/image/audio; compression & AAC record
    viewer/image_viewer.dart    # Full-screen image viewer with pinch-to-zoom
  widgets/
    output_box.dart     # Placeholder area to show AI output text
    item_card.dart      # List UI: share, delete, open viewer, play audio
    audio_chip.dart     # Play/Stop control using audioplayers
  services/
    ai_service.dart     # AiService interface (+ stub)
    output_bus.dart     # ValueNotifier to push AI output to UI
  main.dart             # Home screen (search, list, clear-all, FAB)
```

### 4.2 Capture Flows
- **Text**: directly saves to Hive (`type: 'text'`, `note` contains the text).
- **Image**:
  1. `image_picker` → `XFile` from camera/gallery.
  2. `flutter_image_compress` → compress to app documents dir (JPEG).
  3. Save metadata (path, title, createdAt) in Hive.
- **Audio**:
  1. `record` v6 `AudioRecorder` → start with `RecordConfig(aacLc, 128k, 16kHz, mono)`.
  2. Save `.m4a` to app documents dir.
  3. Save metadata in Hive.

### 4.3 Playback & Viewer
- **Audio**: `AudioChip` → `audioplayers` using `DeviceFileSource(path)`; toggles play/stop; listens for completion.
- **Images**: `ImageViewer` with `InteractiveViewer` (pinch-to-zoom) and `Hero` animations from list thumbnails.

### 4.4 Share & Delete
- **Share**: `share_plus` to send text or files (image/audio) to other apps.
- **Delete**: removes the file from disk (if exists) **and** the entry from Hive.

### 4.5 Error Handling
- Graceful toasts/snackbars for missing files, permission issues.
- Fallback to original image if compression returns `null`.

---

## 5) Installation Instructions

### 5.1 Prerequisites
- Flutter SDK (stable) installed; `flutter doctor` passes.
- Android Studio with SDK + Platform Tools.
- Device or emulator.

### 5.2 Project Setup
```bash
cd src/half_bit_ai
flutter pub get
# if android/ios folders are missing (moving code into template): 
flutter create .
```

### 5.3 Run (Debug)
```bash
flutter run
```

### 5.4 Runtime Permissions
- Accept prompts for **Photos/Media** and **Microphone**.
- If not prompted, enable manually in Android **App Settings → Permissions**.

### 5.5 Build APKs
- **Debug APK** (quick sharing): `flutter build apk --debug`
- **Release APK** (signed): `flutter build apk --release`
- **Split per ABI** (smaller): `flutter build apk --release --split-per-abi`
- **AAB for Play Store**: `flutter build appbundle --release`

---

## 6) User Guide

### 6.1 Capture
1. Press **Capture** (FAB).
2. Choose:
   - **Save Text**: type a note → save.
   - **Camera/Gallery**: capture or pick → auto-compress → saved.
   - **Record Audio (AAC)**: tap to start, tap **Stop & Save** to finish.

### 6.2 Browse & Find
- All items appear under the OutputBox.
- Use the **Search** field in the AppBar to filter by title or note.

### 6.3 View & Play
- Tap an **image** item to open the **full-screen viewer** (pinch to zoom).
- Tap **Play** on an **audio** item to listen; **Stop** to stop.

### 6.4 Share & Delete
- Tap the **⋮ menu** on an item:
  - **Share** image/audio files or text.
  - **Copy text** (for text items).
  - **Delete** (also removes on-disk media).

### 6.5 Clear All
- AppBar **⋮** → **Clear all** to remove all items and files.

### 6.6 Known Limitations
- No cloud sync; everything is local by design.
- Image EXIF handling minimal; compression may strip some metadata.

---

## 7) Salient Features

- Single-screen capture with modern Material 3 UI.
- Local-first architecture (privacy by default).
- Efficient storage via compression and file-based media.
- Simple, testable AI interface (server or on-device).
- Share & Delete with file cleanup.
- Clean code with comments and clear separation of concerns.

---

## 8) Screenshots

Add screenshots under `docs/images/` and reference them here:

- Home screen (list + OutputBox)  
  `![Home](./images/home.png)`

- Capture sheet (text/image/audio)  
  `![Capture](./images/capture.png)`

- Image viewer (pinch-to-zoom)  
  `![Viewer](./images/viewer.png)`

- Audio playback chip  
  `![Audio](./images/audio.png)`

> Tip: On Android Studio emulator, use the **camera** button on the side panel to take a screenshot.

---

## 9) API Integration Guide (Team 2 Hand-off)

### Dart Contract
```dart
class AiResult {
  final String displayText;
  final Map<String, dynamic>? meta;
  AiResult({required this.displayText, this.meta});
}

abstract class AiService {
  Future<AiResult> analyzeText(String text);
  Future<AiResult> analyzeImage(String imagePath);
  Future<AiResult> transcribeAudio(String audioFilePath);
}
```

- Implement via REST (multipart for image/audio) or on-device SDK.
- After each save in `capture_sheet.dart`, call the method and push results:
  ```dart
  // OutputBus.text.value = result.displayText;
  ```

- Provide base URL, token, and sample requests in `docs/apis.md` (see repo).

---

## 10) Troubleshooting

- **`flutter` not recognized** → Add `C:\src\flutter\bin` to PATH (Windows), restart terminal.
- **DevTools timeout** → Not required; disable auto-start in Android Studio settings.
- **Camera/Gallery perms** → Grant Photos/Media permission.
- **Mic recording** → Grant Microphone permission; confirm `record` v6 API usage.
- **Image missing** → File may have been deleted externally; delete stale item.
- **Audio not playing** → Verify `.m4a` exists; reinstall app if storage perms changed.

---

## 11) License & Attribution

- Built on top of widely used open-source Flutter plugins (listed above).
- If you integrate external AI models/APIs or UI kits, attribute them here.
