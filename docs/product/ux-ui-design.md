# UX and UI Design

## Design Direction

Xernia should feel like a serious iPhone health companion: calm, fast, clear, and trustworthy.

It should not feel like a marketing page, a generic wellness app, or a dense desktop dashboard squeezed onto a phone. The experience should make the user feel oriented and capable in a few seconds.

The default interface should be easy to understand without medical training or quantified-self jargon. Advanced detail belongs in progressive disclosure: expandable sections, side inspectors, source panels, tooltips, and conversation modes.

## Information Depth

Use a layered information model:

1. Plain summary: what changed, why it may matter, and the next useful action.
2. Personal data: the metrics, files, notes, or memories behind the summary.
3. Medical context: cautious general explanation with citations.
4. Technical detail: mechanisms, guidelines, units, confidence, and caveats.

The app should never require users to configure settings before it becomes understandable. Settings can tune the level of detail, but the out-of-box experience must be approachable.

## Primary Layout

Suggested iOS layout:

- Tab bar: Today, Ask, Timeline, Experiments, Settings.
- Today as the default home surface.
- Floating or prominent Ask entry point.
- Sheet-based inspectors for sources, citations, and data used.
- Quick actions for logging symptoms, medication, supplement use, caffeine, alcohol, hydration, mood, and notes.

Future Mac companion layout:

- Sidebar navigation.
- Larger timeline and chart workspace.
- Document and lab review.
- Export and clinician packet preparation.

## Navigation

Primary sections:

- Today
- Ask
- Timeline
- Experiments
- Settings

Optional later sections:

- Labs
- Library
- Plans
- Medications
- Symptoms
- Appointments
- Reports

## Today View

Purpose:

Give the user a concise daily operating picture.

Key elements:

- Daily briefing.
- Readiness or recovery state.
- Sleep summary.
- Activity and training recommendation.
- Health reminders.
- Recent anomalies.
- Current experiment status.
- Upcoming appointments.

The Today view should prioritize one or two meaningful actions rather than flooding the user with metrics.

## Ask View

Purpose:

Let the user ask health questions with personal context, transparent data usage, and local references when available.

UI requirements:

- Chat transcript.
- Mode selector: Coach, Researcher, Analyst, Clinician Prep, Journal, Safety.
- Source chips showing data used.
- Inline charts where useful.
- Citation panel.
- "Show reasoning inputs" or "Show data used" action.
- Follow-up suggestions.
- Export answer.

Answers should clearly label:

- Personal data observations.
- General medical context.
- Uncertainty.
- Suggested next steps.
- Clinician questions.

Answer cards should show the simplest useful version first. Citations, source quality, detailed biomarker interpretation, and statistical caveats should be accessible in the inspector or expandable sections.

## Timeline View

Purpose:

Help the user see what happened, when, and what changed.

Key interactions:

- Filter by metric, source, tag, date range, and event type.
- Zoom from day to week to month.
- Add manual event.
- Link event to symptom or experiment.
- Compare two periods.

Possible visual structure:

- Date rail.
- Event rows.
- Metric overlays.
- Highlighted anomalies.

## Labs View

Purpose:

Make lab results understandable and longitudinal.

Key elements:

- Biomarker table.
- Trend charts.
- Reference ranges.
- Result source and date.
- Out-of-range flags.
- Plain-language explanation.
- Questions for clinician.
- Linked files.

Avoid alarmist colors. Use amber and red only when the product has enough confidence and the value is meaningfully abnormal.

Use friendly labels before clinical terms where possible. For example, "Blood sugar over time" can introduce "A1c," and "Iron storage" can introduce "ferritin."

## Experiments View

Purpose:

Help users test lifestyle changes without fooling themselves.

Key elements:

- Active experiment list.
- Hypothesis.
- Intervention schedule.
- Primary metric.
- Baseline vs intervention comparison.
- Confounder notes.
- Result summary.
- Confidence label.

The UI should make uncertainty visible.

## Library View

Purpose:

Provide a secure, searchable workspace for health documents.

Key elements:

- File list.
- Source, type, date, and processing status.
- Extracted entities.
- Linked labs, medications, symptoms, or appointments.
- Search.
- Preview.
- Ask about this file.

## Sources View

Purpose:

Show Apple Health permission state and local model status.

Key elements:

- Apple Health connection status.
- Data categories approved for reading.
- Last sync time.
- Reopen Health permissions.
- Local model status: not installed, downloading, installed, update available, or delete available.
- Local model name, version, size, and expected device requirements.
- Delete local imported data.
- Export local data.

## Visual Style

Recommended style:

- Native iOS controls where possible.
- White or near-white app background.
- Graphite text.
- Muted blue for primary actions.
- Green, amber, and red reserved for health states.
- Small multiples and compact charts.
- Subtle dividers.
- 8px or smaller corner radius for cards.
- Dense tables when the content is tabular.
- SF Symbols for icons.
- Tooltips or inline explainers for abbreviations and advanced terms.

Avoid:

- Oversized marketing hero sections.
- Decorative gradients.
- Vague wellness illustrations.
- One-note purple/blue palettes.
- Excessive cards inside cards.
- Alarmist visual language.
- Hidden data provenance.
- Making advanced scientific language the default reading layer.

## User Detail Preference

Settings may include a detail preference:

- Simple: everyday language, fewer metrics, more guidance.
- Standard: balanced summaries, key metrics, visible sources.
- Advanced: more biomarker detail, citations, confidence, and methodology.

This preference should tune density and wording, not hide core safety information or data provenance.

## Command Palette

The iOS app should be quick-action friendly. A keyboard command palette can be added later for iPad and Mac.

Example commands:

- Ask a question.
- Upload file.
- Log symptom.
- Log medication.
- Start experiment.
- Compare two periods.
- Create appointment summary.
- Search labs.
- Export data.

## Menu Bar Companion

Potential later feature:

- Recovery status.
- Today's focus.
- Reminder shortcut.
- Quick symptom log.
- Quick ask.
- Next appointment.
