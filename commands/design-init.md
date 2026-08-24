# DESIGN INIT

Initialize a design workspace in the current project directory.

## Steps

1. Create the following folder structure:
   - `Claude-Design/brand.md`
   - `Claude-Design/good/.gitkeep`
   - `Claude-Design/bad/.gitkeep`

2. Write `Claude-Design/brand.md` with this template (do not fill in the values yet):

```
# Brand Guide

## Colors
- Primary:
- Secondary:
- Accent:
- Background:
- Text:

## Fonts
- Heading:
- Body:
- Display:

## Voice & Tone

```

3. Ask the user for each brand value one section at a time:
   - First ask: "What are your brand colors? (provide hex codes for primary, secondary, accent, background, text)"
   - Then ask: "What are your fonts? (heading, body, display)"
   - Then ask: "Describe your brand voice and tone (e.g. professional, playful, minimal, bold)"

4. Update `Claude-Design/brand.md` with their answers.

5. After saving, tell the user:
   - "Claude-Design/ is ready. Now do two things before your first session:"
   - "1. Drop 5 screenshots of designs you LIKE into Claude-Design/good/"
   - "2. Drop 5 screenshots of designs you REJECTED into Claude-Design/bad/"
   - "These teach Claude your visual taste. Run /design-start [project] when ready."
