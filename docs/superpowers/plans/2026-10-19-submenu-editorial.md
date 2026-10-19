# Submenu Editorial Implementation Plan

> For agentic workers: use superpowers:executing-plans inline, with one fresh review at the end.

Goal: redesign only Chapters, Archive, Settings and Credits as a historical editorial interface.

Architecture: keep MainMenuView, MainMenuController and MenuAnimationController. Preserve existing control references and request/audio logic. Add CanvasGroup opacity to the existing page containers for layered reveal; keep one shared header and fixed footer.

Tech stack: Roblox GUI, Luau and TweenService; no new dependencies.

Spec: user attachment `b940baf3-a224-4d8c-94ca-1bc456f6df19/Pasted text.txt` and three submenu screenshots.

## Constraints

- Preserve main title/navigation layout, intro animation, camera, lighting, geometry and environment.
- Preserve chapter availability, archive facts, team credits, session settings and menu protocol.
- Use current Merriweather/Roboto Condensed fonts; improve submenu readability with 14–16 pixel body text.
- Keep Script Sync paths in the existing feature checkout; no commit, push or publish.

## Layout decisions

- Shared desktop inset 32; eyebrow y24/h16, title y52/h38, divider y106, body y128.
- Narrow inset 20; short landscape header uses y8/y32/y68/body84, footer56 and bottom gap12 to preserve usable content space.
- Footer remains outside the scroll area: divider 64 from bottom, Back left at bottom56, 44-pixel target.
- Chapters: numbered featured entry, availability marker, supporting description and locked summary.
- Archive: zero-source counter with editorial empty-state text, no invented documents.
- Settings: aligned label/track/value columns, stacked rows on narrow screens, separated accessibility section.
- Credits: four name/role rows, stacked on narrow screens, separate attribution section.
- Panel open 0.30 seconds; header/rule/body/footer reveal offsets 0.02/0.06/0.10/0.18, body duration0.22. Close0.24. Reduced motion uses short fades with no translation/stagger.

## Review focus

- Interrupt open/close repeatedly: the latest request wins without invisible controls remaining.
- Resize while opening: content stays on the layout grid; Back remains reachable outside scrolling content.
- Long titles, narrow credits and archive copy: TextFits and footer separation remain valid.
- Slider drag/keyboard/release and reduced-motion toggle: existing behavior remains intact.
- Main menu source sections and all unrelated source files: unchanged against the starting commit.

## Execution

- [x] Add and observe a failing SubmenuPresentation spec for footer placement, shared spacing and page groups.
- [x] Recompose submenu content in MainMenuView; update only presentation labels/footer metadata in openPanel.
- [x] Add interruptible layered panel transitions and submenu-only focus emphasis.
- [x] Run new and existing menu suites; update old panel-size/timing expectations to the documented design.
- [x] Exercise all panels and controls with real Studio input, mobile simulation, short/narrow fixtures and repeated transitions.
- [x] Review changes, verify source sync/protected scope, record actual results and limitations.

## Ledger

Ruling: retain the current checkout because native Script Sync is mapped to it; branch is already a feature branch and the working tree was clean at start.

Ruling: no research content, historical imagery or external visual assets are needed; use existing facts and restrained rules/index typography.

Ruling: native Samsung QA showed body height64 and no slider initially visible. Compact header/footer now leave96 pixels; settings note shares its section-heading row on wide, short screens. Desktop rhythm is unchanged.

Ruling: native keyboard QA exposed CoreGui moving focus left from the narrower slider to Back. Explicit self-neighbors on slider Left/Right preserve volume-key behavior without changing audio logic.

Result: RED observed for missing footer before implementation. Final suites pass415 assertions. Native chapter entry, Back, slider drag/release, keyboard volume and reduced motion verified; mobile layout/scroll/toggle checked. Review found Contextual UIStroke on the chapter button; changed to Border and covered by regression. Final review has no remaining findings.25 Studio source fingerprints match;19 unrelated source Git blobs and main-menu creation/layout sections remain unchanged.
