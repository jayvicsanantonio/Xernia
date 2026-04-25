# Technical Architecture

## Platform Direction

Xernia should be a macOS-first app built with SwiftUI.

Recommended stack:

- SwiftUI for UI.
- Swift Charts for visualizations.
- SwiftData or Core Data for local structured data.
- Keychain for credentials.
- Local encrypted file storage for documents.
- Background processing for imports, extraction, and sync.
- Optional iOS companion app for Apple Health access.

## Important Apple Health Constraint

HealthKit is not directly usable as a full health data store on macOS. Apple documentation states that the framework can be present on macOS, but macOS devices do not have a HealthKit store and calls to `isHealthDataAvailable()` return `false`.

Implication:

- The macOS app should not depend on direct Apple Health reads.
- Use an iOS companion app for Apple Health sync, or support Apple Health export imports.
- Other wearable integrations may use vendor APIs where available.

## Suggested App Architecture

High-level modules:

- App Shell
- Navigation
- Health Data Store
- File Vault
- Import Pipeline
- Timeline Engine
- Lab Parser
- AI Context Builder
- Assistant Client
- Memory Store
- Experiment Engine
- Reporting and Export
- Source Connector Layer
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

Stages:

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
- Preserve citations to local records and external sources.
- Exclude sensitive unrelated data.

## Retrieval Sources

Potential retrieval layers:

- Structured health database.
- Full-text document index.
- Embedded document chunks.
- User memories.
- Recent conversation.
- External medical knowledge or cited web/research sources.

## AI Provider Strategy

Provider abstraction should support:

- Local context assembly.
- Streaming responses.
- Tool calls for data queries.
- Citation mapping.
- Safety classifiers or policy checks.
- Future provider swapping.

Potential privacy mode:

- Local-only mode for browsing and managing data.
- Cloud AI mode requiring explicit consent.
- Per-question data disclosure preview for sensitive requests.

## Integrations

MVP:

- Manual PDF import.
- CSV import.
- Apple Health export import.
- Manual data entry.

Future:

- iOS companion for Apple Health.
- Oura.
- Whoop.
- Garmin.
- Fitbit.
- Strava.
- Withings.
- MyFitnessPal.
- Eight Sleep.
- Medical records via FHIR or aggregation partner (b.well, Health Gorilla, Particle Health are evaluated options).
- Terra API as a wearable aggregation layer — normalizes data from multiple wearable vendors through one integration instead of building individual connectors. Evaluate before committing to vendor-by-vendor integrations in Phase 5.

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

