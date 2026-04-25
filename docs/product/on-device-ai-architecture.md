# On-Device AI Architecture

## Decision

Xernia's MVP chat should run directly on the user's iPhone using an installed Gemma 4 model. The app should not depend on Claude, Anthropic, LM Studio, cloud chat providers, or a local-network model server.

## How Offline Chat Works

Offline chat works because the model and runtime are both available on the device.

Flow:

1. User installs Xernia.
2. User connects Apple Health.
3. User downloads the mobile-optimized Gemma model.
4. Xernia stores the model in app-managed local storage.
5. Xernia builds a compact prompt from Apple Health summaries, manual logs, memories, and safety instructions.
6. The local inference runtime tokenizes the prompt.
7. The model runs on the iPhone using available hardware acceleration.
8. Generated tokens stream back into the chat UI.

After the model is installed, chat inference should work without internet. Internet may still be needed for first-time model download, model updates, optional reference-content downloads, or app updates.

## Target Runtime

Preferred direction:

- Google AI Edge.
- LiteRT.
- LiteRT-LM for production-oriented edge LLM inference.
- Gemma 4 LiteRT models from the LiteRT Community where available.

Fallback or reference path:

- MediaPipe LLM Inference API for iOS.

MediaPipe's iOS LLM Inference API remains useful as a sample/reference, but Google's documentation now recommends LiteRT-LM for newer production work.

## Model Management

The app needs a first-class model manager.

Required capabilities:

- Show model name, version, size, and status.
- Download model after install instead of bundling a multi-GB model into the app binary.
- Pause and resume download.
- Verify model integrity.
- Delete model to recover storage.
- Check for model updates.
- Warn about storage, Wi-Fi, battery, and device compatibility before download.
- Provide limited non-chat app behavior before model installation.

## Health Context Builder

The model should not receive raw HealthKit dumps.

Xernia should build compact, explainable context:

- Relevant date range.
- Selected metrics.
- Baseline comparisons.
- Recent anomalies.
- User goals.
- Medication and supplement list.
- Manual logs.
- Health memories enabled by the user.
- Safety instructions and response boundaries.

This keeps prompts smaller, improves latency, and makes "data used" easier to show.

## Offline Reference Limits

The installed model contains general learned knowledge, but it is not a live medical database.

For MVP:

- Do not promise live medical citations.
- Distinguish Apple Health observations from local model general knowledge.
- Show uncertainty clearly.
- Recommend clinician follow-up when appropriate.

Later:

- Add trusted reference-content packs if the product needs offline source citations.
- Index those packs locally.
- Cite local passages or documents from those packs.

## UX Requirements

The user should understand:

- The assistant runs on their iPhone.
- Chat works offline after model download.
- The model may use significant storage.
- Responses may be slower than cloud AI.
- Performance depends on device generation, battery, memory, and thermal state.
- No health chat content leaves the device for MVP.

## Sources

- https://github.com/google-ai-edge/gallery
- https://ai.google.dev/edge/litert-lm
- https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference/ios
- https://huggingface.co/litert-community
