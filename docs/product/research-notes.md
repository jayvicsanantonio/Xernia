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

- Xernia's macOS app should not assume direct Apple Health access.
- Apple Health support likely requires an iOS companion app, Apple Health export import, or a third-party data connector.

Sources:

- https://developer.apple.com/documentation/healthkit
- https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework
- https://developer.apple.com/design/human-interface-guidelines/healthkit

## HealthMCP — Deliberate Non-Feature

Nori ships a proprietary Model Context Protocol (MCP) server called HealthMCP. It lets third-party AI assistants (Claude, ChatGPT, etc.) query a user's health data by connecting to Nori as an MCP host. This is a distribution play: Nori becomes a data source that any AI can tap.

Xernia's thesis is the inverse. Xernia is the workspace where users bring their health data to work with it directly. Xernia is not a data protocol layer for other AI assistants to consume. Building an MCP server for Xernia is deferred until the core workspace is valuable on its own. At that point it could become a future integration surface, but it should not shape the product architecture now.

## EHR Aggregation Partner Options

Perplexity Health partners with b.well Connected Health for HIPAA-compliant EHR access. b.well operates one of the largest health data networks in the US: 2.4 million providers, 350+ health plans, labs, and health organizations. This is a concrete precedent for the "aggregation partner" approach mentioned in the technical architecture.

For Xernia, direct FHIR integration and third-party aggregation partners like b.well are both viable options for post-MVP medical record access. Evaluating b.well or similar platforms (Health Gorilla, Particle Health) should happen before building a custom FHIR pipeline.

## Terra API — Wearable Aggregation Option

Perplexity Health uses Terra API to connect multiple wearable platforms through a single integration. Terra normalizes data from Fitbit, Ultrahuman, Withings, Garmin, and others into a unified schema.

For Xernia Phase 5 wearable sync, Terra API is a viable alternative to building individual vendor integrations. The build-vs-buy tradeoff: Terra reduces integration time significantly but adds a third-party dependency and ongoing cost per user. Worth evaluating before committing to individual API integrations.

## Healthcare Provider Matching — Out of Scope

Perplexity Health includes a feature to help users find appropriate healthcare providers. This is out of scope for Xernia. Xernia prepares users for healthcare conversations; it does not broker the connection to providers. This distinction keeps the product focused and avoids regulatory complexity around medical referrals.

## Differentiation Opportunity

The strongest product opportunity is not another dashboard or generic chatbot. The differentiated direction is:

- Mac-native health workspace.
- Deep file and timeline support.
- Personal health evidence graph.
- Structured self-experiment engine.
- Transparent AI answers with data provenance.
- Clinician-ready summaries.

