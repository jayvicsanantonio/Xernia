# Feature System

## Core Product Pillars

### Unified Health Timeline

A chronological view of the user's health life.

Events may include:

- Sleep sessions.
- Workouts.
- Meals and nutrition logs.
- Symptoms.
- Mood and energy.
- Medications.
- Supplements.
- Lab results.
- Medical visits.
- Imported health files.
- Travel.
- Alcohol, caffeine, hydration, and other user-defined factors.
- Manual notes and journal entries.

The timeline should be filterable by source, date range, metric, topic, and tag.

### Ask Anything, With Context

The app should include a health assistant that can answer questions using connected data, uploaded files, memories, and cited external health information.

Example questions:

- "Why was my HRV lower this week?"
- "Compare my sleep before and after I started magnesium."
- "What changed before these headaches started?"
- "Explain this lab result in plain English."
- "Build a 4-week running plan based on my recovery data."
- "What should I ask my doctor about this result?"

Every answer should separate personal data from general medical information.

Default answers should be consumer-readable. Use terms like "recovery looks lower than usual" before terms like "autonomic strain," and expose the technical explanation only when the user asks for more detail or chooses a more advanced mode.

### Daily Plan

A concise morning briefing generated from the user's goals, schedule, recent data, and health memories.

Potential content:

- Recovery summary.
- Sleep debt.
- Training suggestion.
- Nutrition or hydration suggestion.
- Medication or supplement reminders.
- Upcoming appointment reminders.
- One behavioral focus for the day.

Example:

> Recovery is lower than your baseline, resting heart rate is elevated, and sleep debt is about 2 hours. Keep training light, hydrate early, delay caffeine, and avoid a late heavy meal.

### Health Experiments

A structured way to run personal N-of-1 experiments.

Examples:

- "Does eating after 8pm affect my sleep?"
- "Does morning sunlight improve my energy?"
- "Does creatine affect workouts, weight, or sleep?"
- "Does reducing caffeine after noon improve sleep quality?"

Experiment fields:

- Hypothesis.
- Intervention.
- Start date and end date.
- Primary metric.
- Secondary metrics.
- Confounders.
- Baseline period.
- Notes.
- Result summary.
- Confidence level.

### Nutrition Capture

Nutrition data supports training load, recovery, experiment tracking, and clinician prep. On macOS, the practical capture methods are:

- Manual meal entry (food name, macros, calories, timing).
- CSV import from nutrition apps (MyFitnessPal export, Cronometer export).
- Imported nutrition data from Apple Health exports.

A barcode or photo scanner is not appropriate for a desktop-first workspace. If nutrition logging frequency becomes a user need, the iOS companion app is the right surface for quick capture.

### Labs and Biomarkers

A dedicated lab workspace.

Capabilities:

- Upload lab PDFs.
- Extract biomarker values.
- Normalize units where safe.
- Track changes over time.
- Show reference ranges.
- Flag out-of-range results.
- Explain likely meaning in plain language.
- Suggest clinician questions.
- Link lab values to symptoms, habits, and medications.

The app should avoid definitive diagnosis and should encourage professional medical interpretation where appropriate. Lab explanations should start with a plain-language summary, then offer optional details about mechanisms, units, reference ranges, guidelines, and citations.

### Health File Library

A secure file workspace for:

- Lab reports.
- Visit summaries.
- Imaging reports.
- Medication lists.
- Insurance documents.
- Discharge summaries.
- Personal notes.
- PDFs, images, CSVs, and text files.

Files should become searchable and available to the assistant after processing.

### Clinician Prep

Generate a concise appointment packet.

Possible sections:

- Reason for visit.
- Symptom timeline.
- Recent changes.
- Current medications and supplements.
- Relevant labs.
- Wearable trends.
- Questions to ask.
- Red flags or unresolved concerns.
- User-provided notes.

Output should be exportable as PDF or Markdown.

### Health Memory

Persistent user context that the assistant can use across conversations.

Memory examples:

- Goals.
- Baselines.
- Medical conditions.
- Allergies.
- Medication list.
- Preferred training style.
- Dietary restrictions.
- Injuries.
- Important past events.
- User communication preferences.

The user must be able to inspect, edit, disable, and delete memories.

### Contradiction and Anomaly Detection

The app should notice mismatches and outliers.

Examples:

- Medication list differs across two documents.
- Lab units look inconsistent.
- Resting heart rate is unusually high relative to baseline.
- Duplicate workout imports.
- Symptom onset follows a major routine change.
- Sleep score improved but subjective energy worsened.

Anomaly labels should avoid scary or overly technical phrasing. Prefer "unusual for you" or "worth reviewing" over language that implies a diagnosis.

## MVP Feature Set

The first strong MVP should include:

- macOS SwiftUI shell.
- Local encrypted data store.
- Manual imports for PDFs, CSVs, and Apple Health exports.
- Health file library.
- Timeline.
- Basic labs view.
- Chat over imported files and structured metrics.
- User profile and goals.
- Health memories with edit/delete controls.
- Medication and supplement list (required for clinician prep and health memory).
- Daily briefing.
- Basic experiments.
- Exportable clinician summary.

## Later Features

Post-MVP features:

- iPhone companion app.
- Apple Health sync through iOS companion.
- Oura, Whoop, Garmin, Fitbit, Strava, Withings, MyFitnessPal, Eight Sleep, and other connectors.
- Medical records through FHIR or an aggregation partner.
- Menu bar companion.
- Notification and reminder system.
- Calendar integration.
- Advanced experiment analytics.
- Multi-user family/caregiver mode.
- Shareable clinician portal or read-only packet links.
