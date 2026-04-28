# Xernia Product Documentation

Xernia is an iOS-first personal health intelligence app inspired by the best parts of Apple Health, health coaching, AI research assistants, and personal data ownership.

The product direction is not to copy any single app. The goal is to build a simple daily health companion on iPhone where a person can understand Apple Health data, ask grounded questions, run structured self-experiments, prepare for doctor visits, and receive practical daily guidance.

## Documentation Map

- [Vision](./vision.md): Product thesis, target users, positioning, and principles.
- [Feature System](./feature-system.md): Core capabilities, MVP scope, and future feature ideas.
- [UX and UI Design](./ux-ui-design.md): App structure, navigation, visual style, and screen-level direction.
- [DESIGN.md](./DESIGN.md): Lightweight design brief and visual rules for Stitch imports or other AI design tools.
- [AI Conversation Design](./ai-conversation-design.md): Assistant modes, topic handling, response structure, and conversation patterns.
- [On-Device AI Architecture](./on-device-ai-architecture.md): How local Gemma inference works on iPhone and what runtime pieces are needed.
- [Data, Privacy, and Safety](./data-privacy-safety.md): Health data boundaries, consent, security, medical safety, and trust requirements.
- [Technical Architecture](./technical-architecture.md): Suggested iOS-first architecture, data model, Apple Health integration, on-device Gemma inference, and implementation notes.
- [Roadmap](./roadmap.md): Phased build plan from prototype to polished product.
- [Research Notes](./research-notes.md): Source notes and constraints from public product and platform research.
- [iOS-First MVP Decision](./ios-first-mvp-decision.md): Current platform, integration, and on-device model decision record.

## Current Product Bet

Most health apps either show data without interpretation or give generic advice without enough personal context. Xernia should connect those two halves:

1. Gather the user's Apple Health data, symptoms, habits, goals, and notes.
2. Organize that information into a personal health timeline and evidence graph.
3. Let the user ask high-quality questions with transparent source usage and local reference citations when available.
4. Turn insights into daily actions, experiments, and clinician-ready summaries.

The iPhone app should feel like a calm daily companion, not a dense medical dashboard. A future Mac app can become the companion workspace for deeper review, document management, and exports.

## MVP Scope Decision

Xernia is iOS-first. The MVP should rely on Apple Health as the only structured health data integration and should not include third-party wearable, nutrition, EHR, or provider-matching integrations.

For chat, the MVP should support one path:

- On-device Gemma 4 running directly on iPhone through Google AI Edge / LiteRT-LM or the most current supported Google on-device inference stack.

The app should not use Claude, Anthropic API keys, LM Studio local servers, or any cloud chat provider for the MVP.

## Product Language Rule

Xernia should be plain-language by default and scientifically deep on demand. The first read should help a normal person understand what changed, why it may matter, and what they can do next. Technical terms, biomarker nuance, citations, and detailed evidence should remain available through modes, expanders, inspectors, and settings without overwhelming the default experience.
