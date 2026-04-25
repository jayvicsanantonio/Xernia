# Xernia Product Documentation

Xernia is a macOS-first personal health intelligence app inspired by the best parts of connected health dashboards, AI research assistants, health coaching, and personal data ownership.

The product direction is not to copy any single app. The goal is to build a serious Mac-native health workspace where a person can understand their own health data, ask grounded questions, run structured self-experiments, prepare for doctor visits, and receive practical daily guidance.

## Documentation Map

- [Vision](./vision.md): Product thesis, target users, positioning, and principles.
- [Feature System](./feature-system.md): Core capabilities, MVP scope, and future feature ideas.
- [UX and UI Design](./ux-ui-design.md): App structure, navigation, visual style, and screen-level direction.
- [AI Conversation Design](./ai-conversation-design.md): Assistant modes, topic handling, response structure, and conversation patterns.
- [Data, Privacy, and Safety](./data-privacy-safety.md): Health data boundaries, consent, security, medical safety, and trust requirements.
- [Technical Architecture](./technical-architecture.md): Suggested Mac/iOS architecture, data model, integrations, and implementation notes.
- [Roadmap](./roadmap.md): Phased build plan from prototype to polished product.
- [Research Notes](./research-notes.md): Source notes and constraints from public product and platform research.

## Current Product Bet

Most health apps either show data without interpretation or give generic advice without enough personal context. Xernia should connect those two halves:

1. Gather the user's health data, files, symptoms, habits, goals, and notes.
2. Organize that information into a personal health timeline and evidence graph.
3. Let the user ask high-quality questions with citations and transparent source usage.
4. Turn insights into daily actions, experiments, and clinician-ready summaries.

The Mac app should feel like a calm command center, not a mobile app stretched across a desktop screen.

## Product Language Rule

Xernia should be plain-language by default and scientifically deep on demand. The first read should help a normal person understand what changed, why it may matter, and what they can do next. Technical terms, biomarker nuance, citations, and detailed evidence should remain available through modes, expanders, inspectors, and settings without overwhelming the default experience.
