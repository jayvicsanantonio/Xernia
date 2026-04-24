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

- https://nori.health/
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

- Xernia's macOS app should not assume direct Apple Health access.
- Apple Health support likely requires an iOS companion app, Apple Health export import, or a third-party data connector.

Sources:

- https://developer.apple.com/documentation/healthkit
- https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework
- https://developer.apple.com/design/human-interface-guidelines/healthkit

## Differentiation Opportunity

The strongest product opportunity is not another dashboard or generic chatbot. The differentiated direction is:

- Mac-native health workspace.
- Deep file and timeline support.
- Personal health evidence graph.
- Structured self-experiment engine.
- Transparent AI answers with data provenance.
- Clinician-ready summaries.

