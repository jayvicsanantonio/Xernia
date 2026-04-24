# Data, Privacy, and Safety

## Health Data Principles

Health data is sensitive. Xernia should treat privacy and safety as core product features, not settings buried at the end.

Principles:

- User control by default.
- Explicit consent for every connected source.
- Clear data provenance.
- Easy export and deletion.
- Minimal data collection.
- Local-first storage where feasible.
- No training on user health data unless there is explicit, separate, informed opt-in.

## Consent and Permissions

Users should be able to understand:

- What source is connected.
- What categories are imported.
- When the source last synced.
- Whether data is stored locally, synced, or sent to an AI provider.
- How to revoke access.
- How to delete imported data from the app.

Permission copy should be specific. Avoid vague phrases like "improve your experience" when asking for health access.

## Data Provenance

Every health object should retain:

- Source name.
- Source type.
- Import time.
- Original timestamp.
- Original unit.
- Normalized unit, if applicable.
- File reference, if extracted from a document.
- Confidence level for extracted data.

This is essential for trust, debugging, and medical safety.

## Local Storage

Suggested local storage properties:

- Encrypted at rest.
- Structured database for health entities.
- File vault for uploaded documents.
- Search index that can be rebuilt.
- Clear separation between raw source data and derived insights.

Potential Apple technologies:

- SwiftData or Core Data for structured records.
- File protection APIs where applicable.
- Keychain for secrets and tokens.
- CryptoKit for app-level encryption if needed.

## Sync

If syncing across devices:

- Prefer end-to-end encryption for sensitive health content.
- Make sync status visible.
- Provide per-source deletion behavior.
- Avoid hidden cloud copies.

## Medical Safety

Xernia must not present itself as a doctor, diagnosis engine, or emergency service.

Required safety behaviors:

- Display appropriate disclaimers in onboarding and relevant AI flows.
- Detect urgent red-flag symptoms.
- Encourage emergency care for urgent symptoms.
- Encourage clinician consultation for medication changes.
- Avoid definitive diagnosis.
- Avoid claiming causality from correlation.
- Show uncertainty and missing data.
- Cite credible sources for medical claims.

## High-Risk Topics

Examples of topics requiring extra caution:

- Chest pain.
- Difficulty breathing.
- Stroke-like symptoms.
- Severe allergic reaction.
- Suicidal thoughts or self-harm.
- Pregnancy complications.
- Medication overdose or interactions.
- Pediatric medical advice.
- Cancer screening or abnormal cancer markers.
- Eating disorders.
- Severe mental health symptoms.

The assistant should prioritize safety over depth in these situations.

## Trust UX

Trust-building UI elements:

- "Data used" panel.
- Source chips.
- Citation inspector.
- Memory manager.
- Permission manager.
- Export and delete controls.
- Processing status for documents.
- Confidence labels for extracted data and generated insights.

## Compliance Notes

Consumer health apps are not automatically covered by HIPAA. If Xernia later integrates with covered entities, employer plans, providers, or health information exchanges, legal review will be required.

Even if HIPAA does not apply, the product should meet a high bar for privacy, security, and user control.

