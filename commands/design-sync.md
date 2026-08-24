# DESIGN SYNC

The current design looks good. Persist the brand guide into CLAUDE.md so it carries forward into every future session automatically.

## Steps

1. Read `Claude-Design/brand.md`. If it does not exist, stop and tell the user to run `/design-init` first.

2. Read the current project `CLAUDE.md` (or note that it does not exist).

3. Add or update a `## Design & Brand` section in `CLAUDE.md` with the full contents of `brand.md`. If the section already exists, replace it entirely. Place the section near the end of the file, before any trailing notes.

4. Confirm: "Brand guide synced to CLAUDE.md. Claude will now load your colors, fonts, and voice automatically at the start of every future session in this project."
