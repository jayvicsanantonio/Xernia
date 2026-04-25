# Roadmap

## Phase 0: Product Foundation

Goals:

- Document product vision.
- Establish information architecture.
- Define safety and privacy principles.
- Choose iOS-first technical architecture.

Deliverables:

- Product documentation.
- Initial data model.
- Initial iOS SwiftUI navigation shell.

## Phase 1: iOS Apple Health Companion

Goals:

- Make the iPhone app useful with Apple Health as the only structured health integration.

Features:

- iOS app shell with tab navigation.
- Today, Ask, Timeline, Experiments, and Settings screens.
- Local database.
- HealthKit permission flow.
- Apple Health sync for approved read categories.
- Manual health event entry.
- Basic health profile and goals.
- Medication and supplement list.
- Onboarding flow covering: connect Apple Health, set health goals, install the local Gemma model, review privacy settings.
- Detail preference setting: Simple, Standard, Advanced.

## Phase 2: Timeline, Daily Plan, and Manual Logs

Goals:

- Turn Apple Health data and manual logs into usable daily context.

Features:

- Timeline filters.
- Today view.
- Daily briefing.
- Symptom, medication, supplement, caffeine, alcohol, hydration, mood, and note logs.
- Simple health trend cards.
- Basic clinician summary.

## Phase 3: AI Assistant MVP

Goals:

- Add useful health Q&A over user-provided context.

Features:

- Ask view.
- Conversation modes.
- Context builder.
- Source chips.
- "Data used" inspector.
- Health memory manager.
- On-device Gemma 4 model download and management.
- Local inference runtime integration through Google AI Edge / LiteRT-LM or the most current supported Google on-device stack.
- Offline chat behavior after model installation.
- Plain-language default answer templates with expandable source and technical detail.

## Phase 4: Daily Plan and Experiments

Goals:

- Convert insight into repeatable action.

Features:

- Recovery and routine summary.
- Experiment creation.
- Baseline vs intervention analysis.
- Confounder logging.
- Result summaries.

## Phase 5: Mac Companion

Goals:

- Add a larger-screen companion for review, export, and document workflows.

Features:

- Secure sync between iOS and macOS.
- Larger timeline and chart review.
- Health file library.
- PDF and image document import.
- Lab result review.
- Clinician packet export.

## Phase 6: Polished Product

Goals:

- Make the app feel refined, safe, and production-ready.

Features:

- Notifications and reminders.
- Export and delete controls.
- Advanced privacy settings.
- Better local references and source labeling.
- Robust safety handling.
- Performance pass.
- Accessibility pass.

## Deferred Or Out Of Scope

- Third-party wearable connectors.
- Nutrition app connectors.
- EHR/FHIR aggregation.
- Healthcare provider matching.
- Terra API or other wearable aggregation layers.
- Claude, Anthropic API keys, LM Studio, cloud chat providers, and local-network model servers.
