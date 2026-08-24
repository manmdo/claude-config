# DESIGN TASK

Execute a design task with full context awareness.

Task: $ARGUMENTS

## Before generating anything

1. Read every relevant file in the project: components, stylesheets, existing screens, config files.
2. Read `Claude-Design/brand.md` — apply the brand colors, fonts, and voice to everything you build.
3. Read `Claude-Design/good/` reference screenshots to align with the preferred visual style.
4. Ask any clarifying questions before writing a single line of code. Do not assume — confirm layout, behavior, and edge cases first.

## Then build

Build: $ARGUMENTS

Apply brand consistently. Match the visual pattern of the good references. Do not introduce new colors, fonts, or styles not in brand.md.
