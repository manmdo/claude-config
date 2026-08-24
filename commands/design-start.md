# DESIGN START

Start a design session for the project: $ARGUMENTS

## Steps

1. Read `Claude-Design/brand.md` and internalize the colors, fonts, and voice. If the file does not exist, stop and tell the user to run `/design-init` first.

2. List all files in `Claude-Design/good/` and `Claude-Design/bad/` (excluding .gitkeep). Read any image files to understand the visual references. Summarize what you observe:
   - "Good references: [list]"
   - "Rejected references: [list]"

3. Tell the user: "Brand loaded. Drop a screenshot or describe the layout you want to replicate."

4. Wait for the user to share a screenshot or description.

5. Once received, respond with exactly: "Build this for $ARGUMENTS" and begin implementing — applying the brand colors, fonts, and voice from brand.md throughout.
