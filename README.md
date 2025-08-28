**-------------------------- Your Project README.md should start from here -----------------------------**
# Samsung EnnovateX 2025 AI Challenge Submission
- **Problem Statement** - *(Must exactly match one of the nine Samsung EnnovateX AI Challenge Problem Statements)*
- **Team name** - *(As provided during the time of registration)*
- **Team members (Names)** - *Member 1 Name*, *Member 2 Name*, *Member 3 Name*, *Member 4 Name*
- **Demo Video Link** - *(Upload the Demo video on Youtube as a public or unlisted video and share the link. Google Drive uploads or any other uploads are not allowed.)*

### Project Artefacts
- **Technical Documentation** - [Docs](./docs) *(All technical details must be written in markdown files inside the docs folder in the repo)*
- **Source Code** - [Source](./src/half_bit_ai) *(All source code must be added to the src folder in the repo. The code must be capable of being successfully installed/executed and must run consistently on the intended platforms.)*
- **Models Used** - *(Hugging Face links to all models used in the project. You are permitted to use open weight models.)*
- **Models Published** - *(In case you have developed a model as a part of your solution, kindly upload it on Hugging Face under appropriate open source license and add the link here.)*
- **Datasets Used** - *(Links to all datasets used in the project. You are permitted to use publicly available datasets under licenses like Creative Commons, Open Data Commons, or equivalent.)*
- **Datasets Published** - *(Links to all datasets created for the project and published on Hugging Face. You are allowed to publish any synthetic or proprietary dataset used in their project, but will be responsible for any legal compliance and permission for the same. The dataset can be published under Creative Commons, Open Data Commons, or equivalent license.)*

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
