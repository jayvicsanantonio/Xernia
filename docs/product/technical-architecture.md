# Technical Architecture

## Platform Direction

Xernia should be an iOS-first app built with SwiftUI. A macOS app can be added later as a companion workspace for deeper review, document workflows, and exports.

Recommended stack:

- SwiftUI for UI.
- Swift Charts for visualizations.
- SwiftData or Core Data for local structured data.
- HealthKit for Apple Health access on iOS.
- Google AI Edge / LiteRT-LM, or the most current supported Google on-device inference stack, for local Gemma inference.
- Local model storage and model lifecycle management.
- Keychain for app secrets if needed.
- Local encrypted file storage for documents.
- Background processing for imports, extraction, and sync.

## Platform Split

iOS app:

- Primary user experience.
- Requests Apple Health permissions through HealthKit.
- Reads approved Apple Health types.
- Hosts Today, Ask, Timeline, Experiments, Settings, manual logs, reminders, and notifications.
- Stores local health context and memories.
- Runs Gemma 4 locally on device for chat.

Mac companion app:

- Later companion workspace.
- Larger timeline and chart review.
- Document and lab review.
- Export and clinician packet generation.
- Does not read Apple Health directly from HealthKit.

## Apple Health Scope

HealthKit is the only structured health data integration for MVP.

MVP read categories should be conservative and user-facing:

- Sleep.
- Workouts.
- Steps.
- Active energy.
- Heart rate.
- Resting heart rate.
- HRV.
- Walking/running distance.
- Mindfulness or mood-related data where available and explicitly authorized.
- Nutrition fields only when already available in Apple Health and explicitly authorized.

Do not add Oura, Whoop, Garmin, Fitbit, Strava, Withings, MyFitnessPal, Eight Sleep, Terra, FHIR, or EHR aggregation in MVP.

## Important macOS HealthKit Constraint

HealthKit is not directly usable as a full health data store on macOS. Apple documentation states that the framework can be present on macOS, but macOS devices do not have a HealthKit store and calls to `isHealthDataAvailable()` return `false`.

Implication:

- The Mac companion app should not depend on direct Apple Health reads.
- Health data should originate from the iOS app, then sync to Mac only with user consent.
- If there is no iOS app installed, the Mac app cannot provide live Apple Health access.

## Suggested App Architecture

High-level modules:

- App Shell
- Navigation
- Health Data Store
- HealthKit Permission Manager
- HealthKit Sync Engine
- Manual Log Entry
- File Vault, later
- Import Pipeline, later
- Timeline Engine
- Lab Parser, later
- AI Context Builder
- Assistant Client
- Local Model Manager
- On-Device Inference Runtime
- Memory Store
- Experiment Engine
- Reporting and Export
- Privacy and Permission Manager

## Data Model

Core entities:

- UserProfile
- Goal
- Condition
- Allergy
- Medication
- Supplement
- Symptom
- SymptomEpisode
- VitalSample
- BiomarkerResult
- SleepSession
- Workout
- NutritionEntry
- MoodEntry
- JournalEntry
- HealthFile
- Appointment
- Experiment
- Insight
- HealthMemory
- DataSource
- ConsentRecord
- LocalModelManifest

## Health Object Metadata

Every imported or generated health object should include:

- id
- sourceId
- originalSourceId
- startDate
- endDate
- createdAt
- updatedAt
- originalUnit
- normalizedUnit
- value
- confidence
- tags
- notes
- linkedFileIds

## Import Pipeline

Document import is not required for the first iOS MVP. When added later, stages should be:

1. Ingest file or source payload.
2. Store raw input securely.
3. Detect document or data type.
4. Extract structured entities.
5. Normalize units and dates.
6. Save extracted records with provenance.
7. Create searchable index.
8. Surface review UI for uncertain extraction.

## AI Context Builder

The assistant should not blindly send all user data to a model.

Context builder responsibilities:

- Identify relevant records.
- Limit date ranges.
- Include source metadata.
- Include user memories only when enabled and relevant.
- Summarize long histories.
- Preserve citations to local records and bundled or downloaded reference content.
- Exclude sensitive unrelated data.

## Retrieval Sources

Potential retrieval layers:

- Structured health database.
- Full-text document index.
- Embedded document chunks.
- User memories.
- Recent conversation.
- Bundled or separately downloaded trusted reference content, if added later.

## On-Device Model Strategy

The MVP should run chat locally on the iPhone.

Target model/runtime:

- Gemma 4 mobile-optimized model installed on device.
- Google AI Edge / LiteRT-LM as the preferred runtime direction.
- MediaPipe LLM Inference API only as a fallback or reference path, since Google recommends LiteRT-LM for newer production work.

The local model layer should support:

- Local context assembly.
- Streaming responses.
- Tool calls for data queries.
- Citation mapping.
- Safety classifiers or policy checks.
- Model download and installation.
- Model update and deletion.
- Model version and size metadata.
- Device compatibility checks.
- Thermal, battery, and memory-aware behavior.

Potential privacy mode:

- Local-only mode for browsing and managing data.
- Local-only chat using the installed model.
- Per-question data preview for sensitive requests.

Device requirements:

- Minimum SoC: A17 Pro or newer. This corresponds to iPhone 15 Pro, iPhone 15 Pro Max, and all iPhone 16 models.
- Minimum RAM: 8GB. All A17 Pro and later devices meet this threshold.
- iOS 17 or later is required for the LiteRT-LM runtime.
- Devices below this threshold cannot run the local model. The app should detect this at launch using a device model identifier check or a RAM check via ProcessInfo and show a graceful message explaining the requirement. Chat features should be hidden or disabled rather than silently failing.
- A lighter fallback model (such as Gemma 3 1B or a quantized 1B variant) may be offered on older supported devices in a future update, but is not required for MVP.

Model sizes and storage:

- Gemma 4 E2B (2 billion effective parameters, INT4 quantized): approximately 2.5 GB download.
- Gemma 4 E4B (4 billion effective parameters, INT4 quantized): approximately 4 GB download.
- MVP should target E2B as the default model. E4B may be offered as an optional higher-quality download for users with sufficient storage and a supported device.
- The app must request Wi-Fi before initiating any model download and must clearly communicate the file size.

Inference performance expectations:

- Gemma 4 E2B on iPhone 15 Pro: approximately 15–25 tokens per second.
- Gemma 4 E4B on iPhone 16 Pro: approximately 10–15 tokens per second.
- Health Q&A exchanges are short-burst workloads, not sustained generation, which reduces thermal and battery pressure compared to continuous use.
- Sustained inference causes measurable thermal throttling on iPhone 16 Pro (approximately 44% throughput reduction after extended runs). For typical health questions this is unlikely to be noticed, but the UI should use streaming display and avoid blocking the thread during generation.

Implementation notes:

- Do not bundle a multi-GB model in the app binary unless App Store constraints and install size make that acceptable.
- Prefer post-install model download with clear storage and Wi-Fi guidance.
- The app should work in a limited non-chat mode before the model is installed.
- After model installation, inference should work without internet.
- No Claude, Anthropic API, LM Studio local server, cloud chat provider, or local-network model host is part of the MVP.

## Integrations

MVP:

- Apple Health via HealthKit on iOS.
- Manual data entry.
- On-device Gemma 4 model installation.

Future:

- Mac companion app.
- PDF and image document import.
- Apple Health export import as fallback.
- Calendar integration.
- Additional on-device models if quality, safety, and performance justify them.

Not planned for MVP:

- Third-party wearable integrations.
- Nutrition app integrations.
- EHR/FHIR integrations.
- Terra API or wearable aggregation layers.
- Claude, Anthropic API, LM Studio, cloud chat providers, and local-network model servers.

## Reporting

Export formats:

- Markdown.
- PDF.
- CSV.
- JSON.

Report types:

- Appointment summary.
- Lab summary.
- Experiment result.
- Full data export.
- Source-specific export.
