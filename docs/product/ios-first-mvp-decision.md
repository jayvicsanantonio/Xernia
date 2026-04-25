# iOS-First MVP Decision

## Decision

Xernia will start as an iOS-first app.

The MVP will:

- Use Apple Health as the only structured health data integration.
- Avoid third-party wearable, nutrition, EHR, FHIR, and provider-matching integrations.
- Provide chat through an on-device Gemma 4 model installed on the iPhone.
- Use Google AI Edge / LiteRT-LM, or the most current supported Google on-device inference stack, as the target runtime.
- Keep the Mac app as a later companion for deep review, export, and document workflows.

## Rationale

iOS is the right first surface because:

- Apple Health access is native to iPhone.
- Apple Watch and many health apps already write into Apple Health.
- Daily health workflows happen on the phone: symptoms, reminders, medication, supplements, mood, workouts, meals, and quick questions.
- Notifications and camera capture are mobile-native.
- A simpler Apple Health-only integration strategy lowers MVP complexity.
- On-device inference keeps sensitive health questions and Apple Health-derived context on the user's phone.

## What This Removes From MVP

- Oura, Whoop, Garmin, Fitbit, Strava, Withings, MyFitnessPal, Eight Sleep, and similar connectors.
- Terra API or other wearable aggregation APIs.
- EHR or medical-record aggregation.
- FHIR integrations.
- Healthcare provider matching.
- PDF-heavy Mac-first document workflows.
- Claude, Anthropic API keys, LM Studio, cloud chat providers, and local-network model servers.

## On-Device Model Notes

Google AI Edge Gallery demonstrates the target interaction model: users download a mobile-optimized Gemma model to the device, the app stores the model locally, and inference runs on device without an internet connection after installation.

The product should expect:

- A large model download during onboarding or before first chat.
- A model manager for download, storage, deletion, and version updates.
- Performance that depends on iPhone generation, available memory, battery, and thermal state.
- Slower and less capable answers than large cloud models.
- No live web citations while fully offline unless the app bundles or separately downloads trusted reference content.

## Product Principle

The MVP should feel simple:

- Connect Apple Health.
- Install the local Gemma model.
- Ask questions.
- See what data was used.
- Get clear daily guidance.

Everything else should wait until that loop is useful and trustworthy.
