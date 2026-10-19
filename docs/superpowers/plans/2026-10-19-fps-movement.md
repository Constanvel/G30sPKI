# FPS movement implementation

Scope: ENAM JAM: 1949 movement, first-person camera, input and synchronization only. Keep Humanoid physics, narrative phase ownership, menu, map and historical content.

1. Audit existing Bootstrap, CinematicController, character rig and Script Sync. Confirm camera/control ownership before adding movement.
2. Add frozen MovementConfig, deterministic MovementState and shared collision/posture helpers. Validate transitions and time-step behavior.
3. Add local input/prediction/camera controller and server input validation/replicated posture. Integrate at the existing exploring phase boundary in both Bootstraps.
4. Exercise native input, sprint/slide/crouch/jump, obstruction, lifecycle and regression specs. Review trust boundaries and cleanup; repair confirmed defects.
5. Record measured evidence, remaining manual multiplayer/hardware checks and tuning. Verify source synchronization and return Studio to Edit. No commit, push or publication.

Implementation decisions established by the requested scope: desktop keyboard/mouse; no stamina; no combat/viewmodel changes; reuse existing reduced-motion preference; one physics connection and one camera callback per active local controller; server simulation at 20 Hz. Input packets contain bounded direction or action edges, never client speed or position.

User follow-up expands this same task to visible-body first person and animation polish. Use the actual character, hide head/accessories locally, retain torso/limbs, add bounded procedural joint transforms compatible with Motor6D and AnimationConstraint, and restore visibility/pose on exit. Evaluate before Animator with PreAnimation cleanup, apply after Animator in PreSimulation, and reuse the existing camera callback for visibility. Do not create a duplicate character or alter appearance, weapons or maps.
