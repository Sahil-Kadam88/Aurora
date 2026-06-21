# Aurora Local AI

Run open-source AI models entirely on your device. No cloud dependency. No refusals. No subscriptions.

- On-device inference via Flutter + llama.cpp
- GGUF model management with in-app download, import, and catalog
- Local OpenAI-compatible API server on `127.0.0.1:4891`
- Chat history, temperature control, system prompts, dark/light theme

> Android is the primary target. Desktop builds compile via Flutter but require community testing and polish — contributions welcome.

---

## Screenshots

Place app screenshots in this section once available (chat view, model library, settings, logs).

---

## Installation & Build

### Prerequisites
- Flutter SDK (stable channel) compatible with Dart `^3.11.4`
- Android SDK (for Android builds)
- Xcode (for iOS/macOS)
- CMake + Ninja (for Linux/Windows)

### Clone
```bash
git clone https://github.com/Sahil-Kadam88/Aurora.git
cd Aurora
flutter pub get
```

### Run
```bash
flutter run -d android
flutter run -d ios
flutter run -d macos
flutter run -d linux
flutter run -d windows
```

---

## Architecture

`portable_ai_flutter` is a Flutter app with GetX state management and Hive local storage.

### Core layers
- **Screens** — `lib/screens/` (chat, model library, settings, logs, splash)
- **Widgets** — `lib/widgets/` (chat bubbles, sidebar, model cards, typing indicator)
- **Controllers** — `lib/controllers/` (chat, model, theme)
- **Services** — `lib/services/`
  - `llm_service.dart` — GGUF inference via llamadart
  - `model_manager.dart` — catalog, downloads, file import, move/delete
  - `local_api_server_service.dart` — OpenAI-compatible HTTP server
  - `chat_storage_service.dart` — persistent Hive-backed chat history
  - `wakelock_service.dart` — battery optimization + foreground task helpers
  - `log_service.dart` — app logging
  - `background_optimizer_service.dart` — Android battery optimization handling
- **Models** — `lib/models/` (chat model, message model, download state)
- **Bindings** — `lib/bindings/app_bindings.dart` — GetX dependency injection
- **Theme** — `lib/theme/` (colors + theme data)

### Key behaviors
- `llm_service.dart` performs prompt building, stop-token cleanup, and speed tracking
- `model_manager.dart` supports download, resume, file/folder/URL import, and custom catalog entries
- `local_api_server_service.dart` exposes `/healthz`, `/v1/models`, and `/v1/chat/completions`

---

## Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| Android | Primary | Actively tested |
| iOS | Supported | Flutter build available |
| macOS | Supported | Community tested |
| Linux | Supported | Community tested |
| Windows | Supported | Community tested |

---

## Supported Models

In-app model catalog is managed by `assets/models_catalog.json`. You can import any GGUF model via file, folder, or URL.

Example models:

| Model | Size | RAM Required | Type |
|-------|------|--------------|------|
| Gemma 2 2B Abliterated | ~1.6 GB | Min 4 GB | Uncensored |
| Gemma 4 E4B Heretic | ~5.34 GB | Min 8 GB | Uncensored |
| Dolphin 2.9 Llama 3 8B | ~4.9 GB | Min 8 GB | Uncensored |

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Model fails to load | Close app, clear cache in **Settings → Clear Temporary Cache**, retry |
| App crashes at startup | Ensure port `4891` is not already in use |
| Desktop build fails | Run `flutter doctor` and resolve platform issues first |
| Slow generation on Android | Use a smaller model; close background apps to free RAM |
| Battery optimization kills inference | Enable **Disable battery optimization** in Settings |

---

## Local API Server

Built-in REST API compatible with OpenAI-standard clients.

### Setup
1. Load a model in the app
2. Toggle **Local API Server** ON in Settings
3. Base URL: `http://127.0.0.1:4891/v1`

### External Access
Toggle **Allow External Connections** to listen on `0.0.0.0`. Warning: anyone on your network can access the loaded model.

### Endpoints

```bash
# Health
curl http://127.0.0.1:4891/healthz

# Models
curl http://127.0.0.1:4891/v1/models

# Chat completion (non-streaming)
curl http://127.0.0.1:4891/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"local","messages":[{"role":"user","content":"Tell me something true that no one wants to hear."}]}'

# Chat completion (streaming)
curl -N http://127.0.0.1:4891/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"local","stream":true,"messages":[{"role":"user","content":"Write a brutally honest analysis of social media."}]}'
```

> API key: use `local` for clients requiring a non-empty key.

---

## Roadmap

| Feature | Status |
|---------|--------|
| On-device GGUF chat | Launched |
| Model download + import | Launched |
| Cancel / unload models | Launched |
| Persistent chat history | Launched |
| Local OpenAI-compatible API | Launched |
| External network access | Launched |
| Global system prompt | Launched |
| Temperature control | Launched |
| Dark / Light mode | Launched |
| Tokens/sec metrics | Launched |
| Multi-platform compile support | Launched |
| AI Agent Mode | In Progress |
| Web search integration | Planned |
| Voice interaction | Planned |
| Image/vision inputs | Planned |

---

## Contributing

Help is especially welcome on desktop packaging, installer scripts, and notarization.

### Development workflow

```bash
git checkout -b fix/windows-model-loading
git commit -m "fix: resolve model path on Windows"
git push origin fix/windows-model-loading
# Open a Pull Request
```

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.

---

## License

Licensed under the **Apache License, Version 2.0**. See [LICENSE](LICENSE) for full details.
