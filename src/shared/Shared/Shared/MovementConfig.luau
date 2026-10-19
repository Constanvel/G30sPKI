--!strict
return table.freeze({
 WalkSpeed=13, SprintSpeed=20, CrouchSpeed=6, Acceleration=95, Deceleration=120,
 JumpHeight=3.8, JumpCooldown=.25, JumpBuffer=.1, JumpGroundGrace=.1,
 CrouchDrop=1.1, CrouchTransition=.2,
 SlideStartSpeed=24, SlideEndSpeed=8, SlideMinSpeed=12, SlideDuration=.65, SlideCooldown=1.1,
 SlideMinNormalY=.55, SlideWallPadding=.3,
 WalkFOV=72, SprintFOV=78, SlideFOV=76, FOVResponse=12,
 MouseSensitivity=1, MouseRadiansPerPixel=.0025, MaxPitch=math.rad(82), WalkBob=.025, SprintBob=.04, BobRate=.65, SwayDegrees=.22,
 CameraResponse=18, LandingAmplitude=.07, LandingDuration=.12, CameraRadius=.16,
 EyeForward=.25, EyeLift=.1, BodyResponse=14, BodyBreath=.012,
 ArmReady=1.15, ElbowReady=.65, ArmInward=.3, ArmBank=.15,
 ArmSwing=.12, SprintArmSwing=.22, BodyLean=.08,
 CrouchHip=1.05, CrouchKnee=-2.1, CrouchAnkle=1.05,
 ServerInterval=.05, InputRate=24, InputBurst=12, CorrectionInterval=.1,
 ValidationInterval=.1, ValidationSpeed=28, PositionSlack=4, ValidationMaxGap=.6,
})
