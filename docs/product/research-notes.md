# Research Notes

These notes capture public product and platform context used during early brainstorming. They should be revisited as the product evolves.

## Nori-Like Product Signals

Public Nori positioning emphasizes:

- A universal health data hub.
- Wearables, workouts, labs, and health apps in one place.
- Integrations such as Oura, Whoop, Garmin, Peloton, Apple Health, Strava, MyFitnessPal, Fitbod, and Eight Sleep.
- Personalized insights.
- Daily plans based on sleep, activity, heart rate, nutrition, recovery, and goals.
- Biohacker, athlete, and pattern-seeker use cases.
- Data ownership, export, and privacy.

Sources:

- https://nori.ai/
- https://apps.apple.com/us/app/nori-ai-your-health-advisor/id6746278715

## Perplexity Health-Like Product Signals

Public Perplexity Health positioning emphasizes:

- Connected medical records, wearables, wellness apps, Apple Health, and uploaded files.
- Personalized health questions using user data.
- Health hub dashboard.
- Fitness tracking.
- Biomarker tracking.
- Activity logs.
- AI-generated summaries.
- Health memories.
- Context-aware answers with medical literature and citations.
- Privacy controls and deletion.

Sources:

- https://www.perplexity.ai/help-center/en/articles/14035438-what-is-perplexity-health
- https://www.macrumors.com/2026/03/19/perplexity-apple-health-integration/

## Apple Health and macOS Constraint

Apple's documentation indicates HealthKit provides a central repository for iPhone and Apple Watch health data. Apple also notes that HealthKit is not supported as a usable health store on macOS. The framework may be available, but macOS cannot read or write HealthKit data, and `HKHealthStore.isHealthDataAvailable()` returns `false`.

Product implication:

- Xernia should be iOS-first because iPhone can read Apple Health through HealthKit.
- The Mac app should become a companion surface, not the primary Apple Health integration surface.
- The Mac app should receive health context from the iOS app only with explicit user consent.

Sources:

- https://developer.apple.com/documentation/healthkit
- https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework
- https://developer.apple.com/design/human-interface-guidelines/healthkit

## iOS-First Decision

The product direction has shifted from macOS-first to iOS-first.

Rationale:

- Apple Health access is native to iOS.
- Health logging, reminders, symptoms, and daily coaching are naturally mobile workflows.
- iPhone supports camera capture and notifications.
- Apple Watch data already flows into Apple Health.
- A Mac app remains valuable later for deeper review, exports, and document workflows.

MVP implication:

- Apple Health is the only structured data integration.
- Third-party wearable, nutrition, EHR, and provider-matching integrations are out of scope.
- The product should win by being clear, trustworthy, and useful with the data users already have on iPhone.

## On-Device Gemma Notes

Google AI Edge Gallery demonstrates the product and technical pattern Xernia should follow for local AI on iPhone:

- The user downloads a mobile-optimized Gemma model to the phone.
- The model is stored locally inside the app's managed storage.
- Inference runs on device after the model is installed.
- Chat can work without internet because prompts and generated tokens do not need a remote model server.
- Model management and benchmarking are first-class parts of the experience.

Relevant framework direction:

- Google AI Edge provides the on-device ML/GenAI ecosystem.
- LiteRT is Google's lightweight runtime for optimized edge execution.
- LiteRT-LM is the newer production-oriented framework for LLMs on edge devices and should be the preferred direction to evaluate.
- MediaPipe LLM Inference API still exists for iOS, but Google's docs recommend migrating to LiteRT-LM.
- Hugging Face LiteRT Community hosts ready-to-run LiteRT models, including Gemma 4 E2B and E4B variants.

Product implication:

- Xernia should not use Claude, Anthropic, LM Studio, or a remote chat provider for MVP.
- Xernia should include model download, storage, update, delete, and compatibility flows.
- Xernia should clearly explain that offline chat depends on the model being installed.
- Xernia should avoid promising live medical citations while offline unless trusted reference content is bundled or separately downloaded.

Sources:

- https://github.com/google-ai-edge/gallery
- https://ai.google.dev/edge/litert-lm
- https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference/ios
- https://huggingface.co/litert-community

## HealthMCP - Deliberate Non-Feature

Nori ships a proprietary Model Context Protocol (MCP) server called HealthMCP. It lets third-party AI assistants query a user's health data by connecting to Nori as an MCP host. This is a distribution play: Nori becomes a data source that outside AI tools can tap.

Xernia's thesis is the inverse. Xernia is the workspace where users bring their health data to work with it directly. Xernia is not a data protocol layer for other AI assistants to consume. Building an MCP server for Xernia is deferred until the core workspace is valuable on its own. At that point it could become a future integration surface, but it should not shape the product architecture now.

## EHR Aggregation Partner Options

Perplexity Health partners with b.well Connected Health for HIPAA-compliant EHR access. b.well operates one of the largest health data networks in the US: 2.4 million providers, 350+ health plans, labs, and health organizations. This is a concrete precedent for the "aggregation partner" approach mentioned in the technical architecture.

For Xernia, direct FHIR integration and third-party aggregation partners like b.well are not part of the MVP. These options should be revisited only after the Apple Health and AI assistant experience is useful on its own.

## Terra API - Deferred Wearable Aggregation Option

Perplexity Health uses Terra API to connect multiple wearable platforms through a single integration. Terra normalizes data from Fitbit, Ultrahuman, Withings, Garmin, and others into a unified schema.

For Xernia, Terra API is deferred. The current MVP intentionally avoids third-party wearable integrations and relies on Apple Health only.

## Healthcare Provider Matching - Out of Scope

Perplexity Health includes a feature to help users find appropriate healthcare providers. This is out of scope for Xernia. Xernia prepares users for healthcare conversations; it does not broker the connection to providers. This distinction keeps the product focused and avoids regulatory complexity around medical referrals.

## Differentiation Opportunity

The strongest product opportunity is not another dashboard or generic chatbot. The differentiated direction is:

- iOS-first Apple Health companion.
- Optional Mac companion for deep review and export workflows.
- Personal health evidence graph.
- Structured self-experiment engine.
- Transparent AI answers with data provenance.
- Clinician-ready summaries.
