# Samsung EnnovateX 2025 AI Challenge Submission
- **Problem Statement** - *Building the Untethered, Always-On AI Companion*
- **Team name** - *Ennovaters*
- **Team members (Names)** - *Kamesh yadav*, *Abhinab*, *Lahari*, *Sachin prakash*
- **Demo Video Link** - *https://youtu.be/snxva80mNSo*

### Project Artefacts
- **Technical Documentation** - [Docs](./docs) 
- **Source Code** - [Source](./src/half_bit_ai) 
### Attribution
In case this project is built on top of an existing open source project, please provide the original project link here. Also, mention what new features were developed. Failing to attribute the source projects may lead to disqualification during the time of evaluation.

---

# Half Bit AI — Capture (Text • Image • Audio)

A clean, Material 3 Flutter app that captures **text**, **images**, and **audio**, stores them locally (Hive + on‑disk files), and provides a **polished UI** including a placeholder **AI Output** area. Built to be **offline‑first**, demo‑ready, and easy for Team 2 to integrate AI features (LLM, transcription, vision).

> **Repository layout:**  
> - Project docs in [`/docs`](./docs) (architecture, APIs, build/deploy)  
> - Full Flutter source in [`/src/half_bit_ai`](./src/half_bit_ai)

## ✨ Key Features
- Text notes → instant save
- Image capture/pick → **compressed** JPEG saved to app storage
- Audio record (AAC `.m4a`) → saved to app storage
- Image viewer (full-screen, **pinch‑to‑zoom**)
- Audio playback (play/stop)
- Share / Delete with file cleanup
- Search (title/note)
- Clear‑all (deletes media + metadata)
- **AI integration hook**: simple `AiService` interface (HTTP or on-device)

## 🧱 Tech Stack
- Flutter (Material 3 UI)
- `hive`, `hive_flutter` — local metadata store
- `path_provider` — app documents directory
- `image_picker` + `flutter_image_compress` — capture & shrink images
- `record` (v6, `AudioRecorder`) — AAC voice recording
- `audioplayers` — playback
- `share_plus` — system share sheet
- `uuid` — stable item IDs

Full details: [docs/technical_documentation.md](./docs/technical_documentation.md)

## 🧭 Architecture (at a glance)

```mermaid
flowchart TD
  A[HomeScreen] --> B[CaptureSheet]
  A --> C[Items List (ItemCard)]
  C -->|tap image| D[ImageViewer (zoom)]
  C -->|tap audio| E[AudioChip → audioplayers]
  B -->|save text| F[Hive: box 'items']
  B -->|save image| G[Compress → File storage] --> F
  B -->|record audio| H[.m4a → File storage] --> F
  B -->|call AI| I[AiService]
  I --> J[Backend or On‑device SDK]
```

**Why this design?** Media files stay on disk (fast, simple). Hive stores only small metadata. The UI listens to `box.listenable()` and updates live. AI is an optional layer behind a tiny interface, so Team 2 can swap implementations without touching UI.

## 📂 Folder Structure
```
docs/                       # architecture, apis, build/deploy, technical docs
src/half_bit_ai/
  lib/
    data/                   # hive init + model
    features/
      capture/              # capture bottom sheet
      viewer/               # full-screen image viewer
    services/               # AiService contract + output bus
    widgets/                # output box, list item, audio chip
    main.dart               # app entry, search, list, clear-all
  pubspec.yaml
```

## 🛠 Installation
```bash
cd src/half_bit_ai
flutter pub get
# if android/ios folders are missing in your environment:
flutter create .
flutter run
```

**Android permissions (Android 13+):**  
Add to `android/app/src/main/AndroidManifest.xml` (see docs):
- `RECORD_AUDIO`
- `READ_MEDIA_IMAGES`
- `READ_MEDIA_AUDIO`
- (legacy) `READ_EXTERNAL_STORAGE` with `maxSdkVersion=32`

Grant **Photos/Media** and **Microphone** at runtime.

## ▶️ Quick Start (What to Demo)
1. Tap **Capture** → type a note → **Save Text** (appears in the list).  
2. Tap **Capture** → **Camera** or **Gallery** → image saves & shows thumbnail.  
3. Tap **Capture** → **Record Audio (AAC)** → **Stop & Save** → item appears.  
4. Tap an **image** → full-screen zoom; **back** to close.  
5. Tap **Play** on audio to listen.  
6. Use **Search** in AppBar to filter.  
7. Tap item **⋮** → **Share** or **Delete**.  
8. AppBar **⋮** → **Clear all**.

## 🤝 AI Integration (Team 2)
Implement `lib/services/ai_service.dart`:

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

- Use REST (multipart for image/audio) **or** on-device SDK.  
- After each save in `capture_sheet.dart`, call your method and post to the UI (see `docs/apis.md`).

## 📦 Build & Share
- **Debug APK** (fastest for friends):  
  `flutter build apk --debug` → `build/app/outputs/flutter-apk/app-debug.apk`
- **Release APK** (signed):  
  `flutter build apk --release`
- **App Bundle (Play Store)**:  
  `flutter build appbundle --release`

More: [docs/build_and_deploy.md](./docs/build_and_deploy.md)

## 🖼 Screenshots
Add PNGs under `docs/images/` and reference them here (optional):
- `![Home](./docs/images/home.png)`
- `![Capture](./docs/images/capture.png)`
- `![Viewer](./docs/images/viewer.png)`
- `![Audio](./docs/images/audio.png)`

## 📜 License & Attribution
- Built using popular open-source Flutter plugins (listed above).  
- Attribute any external datasets/models you use in your solution.
license_text = r"""MIT License

Copyright (c) 2025 The Half Bit AI contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
