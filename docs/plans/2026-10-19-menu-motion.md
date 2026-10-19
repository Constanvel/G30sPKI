# Cinematic menu motion

Preserve the current UI layout, environment, lighting overrides, content and menu protocol.

1. Measure the existing desktop menu, then add focused checks for staged reveals, indicator retargeting, interrupted panel transitions, camera continuity and cleanup.
2. Refine the existing animation controller: overlapping intro fades, one moving navigation marker, immediate click feedback and interruptible panel transitions. Keep reduced motion.
3. Keep one time-based camera loop with a 28-second cycle and restrained brightness variation on the two existing lantern lights. Restore all temporary state on exit.
4. Run the existing menu checks, exercise real input, mobile simulators and repeated Play sessions; compare frame samples. Review the diff and verify Script Sync before documenting results.

Work in the existing checkout because native Script Sync points here. No new dependencies, map changes, commits, pushes or publication.
