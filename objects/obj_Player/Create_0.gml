/// @description Initialize
event_inherited();

image_speed = 0;
image_index = 0;

#region Gameplay Tweaks

// enable/disable debug controls
debug = true;
// press 0 to refill health & ammo
// press 9 to face toward screen / activate elevator pose
// press 8 to set health to 10
// press 7 to acquire all abilities
// press 6 to acquire a random ability
// press 5 to enable/disable godmode
godmode = false;
// press 4 to toggle hyper beam
//no clip controls: press numpad 8,5,4,6 to move up,down,left,right


// "Arm Pumping" is a classic SM speedrunning tech
//Tapping any aim button will shift the player forward one pixel during grounded movement.
// (Default is false)
armPumping = true;

// Global speed modifier for horizontal movement. Acts as a flat addition and does not necessarily affect momentum.
//Set to 0.5 as an alternative to 60fps frame-perfect Arm Pumping. Note: Unlike arm pumping, this will affect jump and morph movement.
// (Default is 0)
globalSpeedMod = 0;

// Continue speed boosting/keep momentum, after landing (also applies to spider ball)
speedKeep = 0;
// 0 = disabled
// 1 = enabled always
// 2 = enabled, but disabled during underwater movement

// Wall jump during speed booster
speedBoostWallJump = true;

// Cancel Shine Spark mid-flight by pressing jump
shineSparkCancel = true;

// Low-level Shine Spark flight control
//press directions or angle buttons to slightly change flight direction
shineSparkFlightAdjust = false;

// High-level Shine Spark flight control when Accel Dash is enabled
//activated by holding a direction and pressing Run during flight (consumes Dash charge)
shineSparkRedirect = true;

#endregion

#region Main

enum State
{
	Stand,
	Elevator,
	Recharge,
	Crouch,
	Walk,
	Run,
	Brake,
	Morph,
	Jump,
	Somersault,
	Grip,
	Spark,
	BallSpark,
	Grapple,
	Hurt,
	DmgBoost,
	Death,
	Dodge,
	CrystalFlash
};
state = State.Stand; //stand, crouch, morph, jump, somersault, grip, spark, ballSpark, grapple, hurt
prevState = state;
lastState = prevState;

grounded = true;
notGrounded = !grounded;

wallJumpDelay = 6;
canWallJump = false;

uncrouch = 0;
//uncrouched = true;

canMorphBounce = true;
ballBounce = 0;
mockBall = false;

aimAngle = 0; //2 = verticle up, 1 = diagonal up, 0 = forward, -1 = diagonal down, -2 = vertical down
prevAimAngle = aimAngle;
lastAimAngle = prevAimAngle;
aimUpDelay = 0;

gbaAimAngle = 0;
gbaAimPreAngle = 0;

move = 0;
move2 = 0;
pMove = 0;

dir = 0; //0 = face screen, 1 = face right, -1 = face left
fDir = dir;
oldDir = dir;
lastDir = oldDir;

speedCounter = 0;
speedCounterMax = 80;//120;
speedBoost = false;
speedFXCounter = 0;
speedCatchCounter = 0;
speedKill = false;
speedKillCounter = 0;
speedKillMax = 6;

speedBoostWJ = false;
speedBoostWJCounter = 0;

shineCharge = 0;
shineDir = 0;
shineStart = 0;
shineEnd = 0;
shineEndMax = 40;//30;
shineSparkSpeed = 13;
shineFXCounter = 0;
shineRampFix = 0;

shineDownRot = 0;
shineRestart = false;
shineRestarted = false;


spiderBall = false;
spiderEdge = Edge.None;
prevSpiderEdge = spiderEdge;
spiderMove = 0;
spiderSpeed = 0;
spiderJumpDir = 0;
spiderJump_SpeedAddX = 0;
spiderJump_SpeedAddY = 0;

spiderGlowAlpha = 0;
spiderGlowNum = 1;


isChargeSomersaulting = false;
isSpeedBoosting = false;
isScrewAttacking = false;

stepSndPlayedAt = 0;

walkState = false;

//uncrouching = false;

ledgeFall = false;
ledgeFall2 = false;
justFell = false;
//fellVel = 0;

onPlatform = false;

upClimbCounter = 0;

startClimb = false;
climbTarget = 0;
climbIndex = 0;
climbIndexCounter = 0;
climbX = array(0,0,0,0,0,1,2,2,2,2,2,1,1,0,0,0,0,0,0);
climbY = array(0,6,6,5,5,4,4,2,0,0,0,0,0,0,0,0,0,0,0);

quickClimbTarget = 0;
quickClimbHeight = 0;

immuneTime = 0;
//96 default, 60 spikes
hurtTime = 0; //45
hurtSpeedX = 0;
hurtSpeedY = 0;
dmgFlash = 0;

dmgBoost = 0;
dmgBoostJump = false;

dodgePress = 0;
groundedDodge = 0;
dodgeDir = 0;
dodged = false;
dodgeLength = 0;
dodgeLengthMax = 20;//25;
canDodge = true;
dodgeRechargeMax = 20;
dodgeRecharge = dodgeRechargeMax;
dodgeRechargeRate = 0.5;

liquidState = 0;
outOfLiquid = (liquidState == 0);

liquidLevel = 0;
//gunLiquidLevel = 0;

statCharge = 0;
maxCharge = 60;

bombCharge = 0;
bombChargeMax = 30;

hSpeed = 0;
vSpeed = 0;
shootDir = 0;
shootSpeed = 10;//8;
extraSpeed_x = 0;
extraSpeed_y = 0;

shotDelayTime = 0;
bombDelayTime = 0;

enqueShot = false;

waveDir = 1;


immune = false;


cRight = false;
cLeft = false;
cUp = false;
cDown = false;
cJump = false;
cShoot = false;
cDash = false;
cAngleUp = false;
cAngleDown = false;
cAimLock = false;
cMorph = false;

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rJump = !cJump;
rShoot = !cShoot;
rDash = !cDash;
rAngleUp = !cAngleUp;
rAngleDown = !cAngleDown;
rAimLock = !cAimLock;
rMorph = !cMorph;

rMorphJump = false;

surfW = 80;
surfH = 80;
playerSurf = surface_create(surfW,surfH);

water_init(0);
CanSplash = 1;
BreathTimer = 180;
StepSplash = 0;

XRay = noone;
//XRayDying = 0;

constantDamageDelay = 0;

grapple = noone;
grappleActive = false;
grappleDist = 0;
grappleOldDist = 0;
grappleMaxDist = 160;//143;

grapAngle = 0;
grapDisVel = 0;

grapBoost = false;

grappleVelX = 0;
grappleVelY = 0;

grapWJCounter = 0;

grapWallBounceCounter = 0;
prevGrapVelocity = 0;

cFlashStartCounter = 0;
cFlashStartMove = 0;
cFlashDuration = 0;
cFlashDurationMax = 30;
cFlashStep = 15;
cFlashLastEnergy = 0;
cFlashAmmoUse = 0;

#endregion
#region Physics Vars

// Out of water
maxSpeed[0,0] = 2.75;	// Running
maxSpeed[1,0] = 4.75;	// Dashing (no speed boost)
maxSpeed[2,0] = 9.75;	// Speed Boosting
maxSpeed[3,0] = 1.25;	// Jump
maxSpeed[4,0] = 1.375;	// Somersault
maxSpeed[5,0] = 3.25;	// Morph Ball
maxSpeed[6,0] = 5.25;	// Mock Ball
maxSpeed[7,0] = 1;		// Air Morph
maxSpeed[8,0] = 1.25;	// Air Spring Ball
maxSpeed[9,0] = 5;		// Damage Boost
maxSpeed[10,0] = 7.25;	// Dodge
// Underwater
maxSpeed[0,1] = 2.75;	// Running
maxSpeed[1,1] = 4.75;	// Dashing (no speed boost)
maxSpeed[2,1] = 9.75;	// Speed Boosting
maxSpeed[3,1] = 1.25;	// Jump
maxSpeed[4,1] = 1.375;	// Somersault
maxSpeed[5,1] = 2.75;	// Morph Ball
maxSpeed[6,1] = 4.75;	// Mock Ball
maxSpeed[7,1] = 1;		// Air Morph
maxSpeed[8,1] = 1.25;	// Air Spring Ball
maxSpeed[9,1] = 3.3;	// Damage Boost
maxSpeed[10,1] = 3.25;	// Dodge
// In lava/acid
maxSpeed[0,2] = 1.75;	// Running
maxSpeed[1,2] = 3.75;	// Dashing (no speed boost)
maxSpeed[2,2] = 8.75;	// Speed Boosting
maxSpeed[3,2] = 1.25;	// Jump
maxSpeed[4,2] = 1.375;	// Somersault
maxSpeed[5,2] = 2.75;	// Morph Ball
maxSpeed[6,2] = 4.75;	// Mock Ball
maxSpeed[7,2] = 1;		// Air Morph
maxSpeed[8,2] = 1.25;	// Air Spring Ball
maxSpeed[9,2] = 3.3;	// Damage Boost
maxSpeed[10,2] = 3.25;	// Dodge

// Out of water
moveSpeed[0,0] = 0.1875;	// Normal
moveSpeed[1,0] = 0.1;		// Morph
moveSpeed[2,0] = 0.0625;	// speedboost?
// Underwater
moveSpeed[0,1] = 0.015625;	// Normal
moveSpeed[1,1] = 0.02;		// Morph
moveSpeed[2,1] = 0.015625;	// speedboost?
// In lava/acid
moveSpeed[0,2] = 0.015625;	// Normal
moveSpeed[1,2] = 0.02;		// Morph
moveSpeed[2,2] = 0.015625;	// speedboost?

frict[0] = 0.5;		// Out of water
frict[1] = 0.5;		// Underwater
frict[2] = 0.25;	// In lava/acid


// Out of water
jumpSpeed[0,0] = 4.875;	// Normal Jump
jumpSpeed[1,0] = 6;		// Hi Jump
jumpSpeed[2,0] = 4.625;	// Wall Jump
jumpSpeed[3,0] = 5.5;	// Hi Wall Jump
jumpSpeed[4,0] = 5;		// Damage Boost
// Underwater
jumpSpeed[0,1] = 1.75;			// Normal Jump
jumpSpeed[1,1] = 2.5;			// Hi Jump
jumpSpeed[2,1] = 0.375;//1.25;//0.25;	// Wall Jump
jumpSpeed[3,1] = 0.625;//2.25;//0.5;	// Hi Wall Jump
jumpSpeed[4,1] = 2;			// Damage Boost
// In lava/acid
jumpSpeed[0,2] = 2;//2.75;	// Normal Jump
jumpSpeed[1,2] = 2.75;//3.5;	// Hi Jump
jumpSpeed[2,2] = 1.5;//2.625;	// Wall Jump
jumpSpeed[3,2] = 2.5;//3.5;	// Hi Wall Jump
jumpSpeed[4,2] = 2;	// Damage Boost

// Out of water
jumpHeight[0,0] = 2; // Normal
jumpHeight[1,0] = 2; // Hi Jump
// Underwater
jumpHeight[0,1] = 2; // Normal
jumpHeight[1,1] = 2; // Hi Jump
// In lava/acid
jumpHeight[0,2] = 2; // Normal
jumpHeight[1,2] = 2; // Hi Jump

grav[0] = 0.109375;		// Out of water
grav[1] = 0.03125;		// Underwater
grav[2] = 0.03515625;	// In lava/acid

fallSpeedMax = 5; // Maximum fall speed - soft cap

// (f)inalized variables
fMaxSpeed = maxSpeed[0,0];
fMoveSpeed = moveSpeed[0,0];
fFrict = frict[0];
fGrav = grav[0];
fJumpSpeed = jumpSpeed[0,0];
fJumpHeight = jumpHeight[0,0];

jump = 0;
jumping = false;
jumpStart = false;
jumpStop = !jumpStart;

bunnyJumpMax = 3;
bunnyJump = bunnyJumpMax;

morphSpinJump = false;

bombJump = 0;
bombJumpMax[0] = 13;	// air
bombJumpMax[1] = 1;		// underwater
bombJumpMax[2] = 1;//3;		// under lava/acid

bombJumpSpeed[0] = 2;		// air
bombJumpSpeed[1] = 1;		// underwater
bombJumpSpeed[2] = 1;//0.01;	// under lava/acid
bombJumpX = 0;


//sAngle = 0;

velX = 0;
velY = 0;

//shiftX = 0;
//shiftY = 0;

fVelX = 0;
fVelY = 0;

//cosX = lengthdir_x(abs(velX),sAngle);
//sinX = lengthdir_y(abs(velX),sAngle);

carryVelX = 0;
carryVelY = 0;

#endregion
#region Animation

stateFrame = State.Stand;
//stand, crouch, walk, run, brake, morph, jump, somersault, grip, spark, grapple, hurt

dirFrame = 0;

//Run Torso Y Offset
rOffset =  array(1,0,0,1,2,2,3,2,1,1,0,0,0,1,2,2,3,2,1,1,0,0);
rOffset2 = array(0,0,0,0,1,1,2,2,1,1,0,0,0,0,1,1,2,2,1,1,0,0);

//Moon Walk Torso Y Offset
mOffset = array(0,0,0,0,1,1,1,0,0,0,1,1,1);

runYOffset = 0;
runAimSequence = array(0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1);

brake = false;
brakeFrame = 0;

enum Frame
{
	Idle = 0,
	Run = 1,
	Morph = 2,
	Ball = 3,
	JAim = 4,
	Jump = 5,
	Somersault = 6,
	Walk = 7,
	SparkV = 8,
	SparkH = 9,
	SparkStart = 10,
	GrappleLeg = 11,
	Dodge = 12,
	GrappleBody = 13,
	CFlash = 14
};

frame[14] = 0;
frameCounter[14] = 0;

idleNum = array(32,8,8,8,16,6,6,6);
idleSequence = array(0,1,2,3,4,3,2,1);

//idleNum_Low = array(12,6,6,10,6,6);
//idleSequence_Low = array(0,2,4,5,3,1);

idleNum_Low = array(12,4,4,4,10,4,4,4);
idleSequence_Low = array(0,2,4,4,5,3,3,1);

wjFrame = 0;
wjSequence = array(3,3,3,2,2,1,1,1,0);
wjAnimDelay = 0;

crouchFrame = 0;

morphFrame = 0;
unmorphing = false;
morphAlpha = 0;
ballFrame = 0;
morphNum = 0;
ballAnimDir = dir;

ballGlowIndex = 1;

aimFrame = 0;

aimSnap = 0;

aimAnimTweak = 0;

transFrame = 0;
runToStandFrame[1] = 0;

walkToStandFrame = 0;

landFrame = 0;
smallLand = false;

landSequence = array(0,4,4,4,3,3,2,2,1,0);
smallLandSequence = array(0,4,4,4,1,1,0);

crouchSequence = array(0,1,1,2,3,3);

landFinal = 0;
crouchFinal = 0;
morphFinal = 0;

crouchYOffset = array(0,3,7,10);

landYOffset = array(2,5,8,4,1);

gripFrame = 0;
gripGunReady = false;
gripAimFrame = 0;
gripGunCounter = 0;

//gripAimTarget = array(4,6,2,8,0);

climbSequence = array(0,0,1,2,3,4,5,6,7,8,9,9,9,9,10,10,11,11,11);
climbFrame = 0;

grapFrame = 3;
grapWallBounceFrame = 0;
grapMoveAnim = 0;

grapPartFrame = 0;
grapPartCounter = 0;

hurtFrame = 0;

torsoR = sprt_StandCenter;
torsoL = torsoR;
legs = -1;

sprtOffsetX = 0;
sprtOffsetY = 0;

bodyFrame = 0;
legFrame = 0;

spaceJump = 0;

recoil = false;
recoilCounter = 0;

drawMissileArm = false;
missileArmFrame = 0;
armDir = 1;
finalArmFrame = 0;

shotOffsetX = 0;
shotOffsetY = 0;
armOffsetX = 0;
armOffsetY = 0;

shootPosX = 0;
shootPosY = 0;

gunReady = false;
//gunReady2 = false;
shootFrame = false;
justShot = 0;

chargeSetFrame = 0;
chargeFrame = 0;
chargeFrameCounter = 0;

particleFrame = 0;
particleFrameMax = 4;

chargeEmit = noone;


//downV
turnArmPosX[0,0] = -9;
turnArmPosX[0,1] = -8;
turnArmPosX[0,2] = -7;
turnArmPosX[0,3] = -6;
turnArmPosX[0,4] = -4;
turnArmPosX[0,5] = -1;
turnArmPosX[0,6] = 2;
turnArmPosY[0] = 19;


//down
turnArmPosX[1,0] = -16;
turnArmPosX[1,1] = -13;
turnArmPosX[1,2] = -10;
turnArmPosX[1,3] = -7;
turnArmPosX[1,4] = -4;
turnArmPosX[1,5] = 2;
turnArmPosX[1,6] = 10;
turnArmPosY[1] = 9;


//default
turnArmPosX[2,0] = -14;
turnArmPosX[2,1] = -12;
turnArmPosX[2,2] = -9;
turnArmPosX[2,3] = -4;
turnArmPosX[2,4] = 1;
turnArmPosX[2,5] = 7;
turnArmPosX[2,6] = 12;

turnArmPosY[2,0] = 0;
turnArmPosY[2,1] = -1;
turnArmPosY[2,2] = -3;
turnArmPosY[2,3] = -4;
turnArmPosY[2,4] = -3;
turnArmPosY[2,5] = -1;
turnArmPosY[2,6] = 0;


//up
turnArmPosX[3,0] = -16;
turnArmPosX[3,1] = -13;
turnArmPosX[3,2] = -10;
turnArmPosX[3,3] = -6;
turnArmPosX[3,4] = -1;
turnArmPosX[3,5] = 6;
turnArmPosX[3,6] = 12;
turnArmPosY[3] = -20;


//upV
turnArmPosX[4,0] = -4;
turnArmPosX[4,1] = -5;
turnArmPosX[4,2] = -6;
turnArmPosX[4,3] = -6;
turnArmPosX[4,4] = -4;
turnArmPosX[4,5] = -1;
turnArmPosX[4,6] = 1;
turnArmPosY[4] = -29;

rotation = 0;
rotReAlignStep = 3;

hudBOffsetX = 0;
hudIOffsetX = 0;

dBoostFrame = 0;
dBoostFrameCounter = 0;

shineFrame = 0;
shineFrameCounter = 0;

screwFrame = 0;
screwFrameCounter = 0;


// underwater gravity suit glow
gravGlowAlpha = 0;
gravGlowNum = 10;

introAnimState = 0;
introAnimCounter = 0;
introAnimFrame = 0;
introAnimFrameCounter = 0;

cBubbleScale = 0;
cFlashFrameSequence = array(0,1,2,1);

#endregion
#region Audio

lowEnergySnd = noone;

chargeSoundPlayed = false;

somerSoundPlayed = false;
somerUWSndCounter = 0;

speedSoundPlayed = false;

screwSoundPlayed = false;

#endregion
#region Item Vars

/*energyTanks = 14;
missileTanks = 51;
superMissileTanks = 15;
powerBombTanks = 10;*/

energyMax = 99;//1499;//99 + (100 * energyTanks);
energy = energyMax;
lowEnergyThresh = 30;

damageReduct = 1;

missileMax = 0;//250;//5 * missileTanks;
missileStat = missileMax;

superMissileMax = 0;//50;//2 * superMissileTanks;
superMissileStat = superMissileMax;

powerBombMax = 0;//50;//2 * powerBombTanks;
powerBombStat = powerBombMax;

enum Suit
{
	Varia,
	Gravity
};
// 2 Suits
suit[1] = false;

enum Boots
{
	HiJump,
	SpaceJump,
	Dodge,
	SpeedBoost,
	ChainSpark
};
// 5 Boots
boots[4] = false;

enum Misc
{
	PowerGrip,
	Morph,
	Bomb,
	Spring,
	Spider,
	ScrewAttack
};
// 6 Misc
misc[5] = false;

enum Beam
{
	Charge,
	Ice,
	Wave,
	Spazer,
	Plasma
};
// 5 Beams
beam[4] = false;

enum Item
{
	Missile,
	SMissile,
	PBomb,
	Grapple,
	XRay
};
// 5 Items
item[4] = false;

hasSuit[array_length(suit)-1] = false;
hasMisc[array_length(misc)-1] = false;
hasBoots[array_length(boots)-1] = false;
hasBeam[array_length(beam)-1] = false;
hasItem[array_length(item)-1] = false;

//starting items
/*misc[Misc.PowerGrip] = true;
hasMisc[Misc.PowerGrip] = true;
misc[Misc.Morph] = true;
hasMisc[Misc.Morph] = true;
misc[Misc.Bomb] = true;
hasMisc[Misc.Bomb] = true;
beam[Beam.Charge] = true;
hasBeam[Beam.Charge] = true;*/
//boots[Boots.SpeedBoost] = true;

/*for(var i = 0; i < array_length_1d(suit); i++)
{
	suit[i] = true;
	hasSuit[i] = suit[i];
}
for(var i = 0; i < array_length_1d(misc); i++)
{
	misc[i] = true;
	hasMisc[i] = misc[i];
}
for(var i = 0; i < array_length_1d(boots); i++)
{
	boots[i] = true;
	hasBoots[i] = boots[i];
}
for(var i = 0; i < array_length_1d(beam); i++)
{
	beam[i] = true;
	hasBeam[i] = beam[i];
}
for(var i = 0; i < array_length_1d(item); i++)
{
	item[i] = true;
	hasItem[i] = item[i];
}*/

hyperBeam = false;


//beam variables

chargeMult = 5;
beamDmg = 20;
beamShot = obj_PowerBeamShot;
beamCharge = obj_PowerBeamChargeShot;
beamDelay = 6;
beamChargeDelay = 18;
beamChargeAnim = sprt_PowerBeamChargeAnim;
beamSound = snd_PowerBeam_Shot;
beamChargeSound = snd_PowerBeam_ChargeShot;
beamAmt = 1;
beamChargeAmt = 1;
beamIconIndex = 0;

beamIsWave = false;
beamWaveStyleOffset = 1;

beamFlare = sprt_PowerBeamChargeFlare;

#endregion
#region HUD

cHSelect = false;
cHCancel = false;
cHRight = false;
cHLeft = false;
cHUp = false;
cHDown = false;
cHToggle = false;

rHSelect = !cHSelect;
rHCancel = !cHCancel;
rHRight = !cHRight;
rHLeft = !cHLeft;
rHUp = !cHUp;
rHDown = !cHDown;
rHToggle = !cHToggle;

moveH = 0;
moveHPrev = 1;

itemSelected = 0;
itemHighlighted[1] = 0;

pauseSelect = false;

currentMap = global.rmMapSprt;
playerMapX = (scr_floor(x/global.resWidth) + global.rmMapX) * 8;
playerMapY = (scr_floor(y/global.resWidth) + global.rmMapY) * 8;
prevPlayerMapX = playerMapX;
prevPlayerMapY = playerMapY;
pMapOffsetX = 0;
pMapOffsetY = 0;

hudMapFlashAlpha = 0;
hudMapFlashNum = 1;

beamName[0] = "POWER BEAM";
beamName[1] = "ICE BEAM";
beamName[2] = "WAVE BEAM";
beamName[3] = "SPAZER";
beamName[4] = "PLASMA BEAM";

itemName[0] = "MISSILE";
itemName[1] = "SUPER MISSILE";
itemName[2] = "POWER BOMB";
itemName[3] = "GRAPPLE BEAM";
itemName[4] = "X-RAY VISOR";

#endregion
#region Palette

chargeReleaseFlash = 0;

shaderFlash = 0;
shaderFlashMax = 4;

palShader = pal_PowerSuit;
palIndex = 1;
palIndex2 = 1;
palDif = 0;
beamPalIndex = 0;

xRayVisorFlash = 0;
xRayVisorNum = 0;

morphPal = 0;

heatPal = 0;
heatPalNum = 1;
heatDmgPal = 0;
heatDmgPalCounter = 0;

screwPal = 0;
screwPalNum = 1;

hyperFired = 0;
//hyperFiredFrame = 0;
//hyperFiredFrameCounter = 0;
hyperPal = 0;

cFlashPal = 0;
cFlashPal2 = 0;
cFlashPalDiff = 0;
cFlashPalNum = 1;
cBubblePal = 0;

#endregion
#region After Image

afterImageNum = 10;
drawAfterImage = false;
afterImgDelay = 0;
afterImgCounter = 0;
afterImgAlphaMult = 0.625;

#endregion


#region Collision (Normal)

function entity_place_collide()
{
	/// @description entity_place_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = x,
		yy = y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	
	if(entity_place_meeting(xx+offsetX,yy+offsetY,"IPlatform") && (!spiderBall || spiderEdge == Edge.None || spiderEdge == Edge.Bottom))
	{
		if(entityPlatformCheck(offsetX,offsetY,xx,yy))
		{
			return true;
		}
	}
	
	if(isSpeedBoosting || isScrewAttacking)
	{
		var bl_list = ds_list_create();
		var bl = instance_place_list(xx+offsetX,yy+offsetY,all,bl_list,true);
		if(bl > 0)
		{
			for(var i = 0; i < bl; i++)
			{
				if(!asset_has_any_tag(bl_list[| i].object_index,"ISolid",asset_object))
				{
					continue;
				}
				
				var block = bl_list[| i];
				
				var sp = (!asset_has_any_tag(block.object_index, "ISpeedBlock", asset_object) && isSpeedBoosting),
					sc = (!asset_has_any_tag(block.object_index, "IScrewBlock", asset_object) && isScrewAttacking);
				if(place_meeting(xx+offsetX,yy+offsetY,block) && (sp || sc))
				{
					return true;
				}
			}
		}
		ds_list_destroy(bl_list);
		return false;
	}
	
	return entity_place_meeting(xx+offsetX,yy+offsetY,"ISolid");
}
function entityPlatformCheck()
{
	/// @description entityPlatformCheck
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = x,
		yy = y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	
	//var left = x-bbox_left,
	//	right = bbox_right-x,
	//	top = y-bbox_top,
	//	bottom = bbox_bottom-y;
	var pl_list = ds_list_create();
	//var pl = collision_rectangle_list(xx-left+offsetX,yy-top+offsetY,xx+right+offsetX,yy+bottom+offsetY,all,true,true,pl_list,true);
	var pl = instance_place_list(xx+offsetX,yy+offsetY,all,pl_list,true);
	if(pl > 0)
	{
		for(var i = 0; i < pl; i++)
		{
			if(!asset_has_any_tag(pl_list[| i].object_index,"IPlatform",asset_object))
			{
				continue;
			}
			
			var platform = pl_list[| i];
			if(place_meeting(xx+offsetX,yy+offsetY,platform) && !place_meeting(xx,yy,platform) && bbox_bottom < platform.bbox_top)//offsetY > 0)
			{
				return true;
			}
		}
	}
	ds_list_destroy(pl_list);
	return false;
}

function ModifyFinalVelX(fVX) { return fVX; }
function ModifyFinalVelY(fVY)
{
	var fellVel = 1;
	var shouldForceDown = (state != State.Grip && state != State.Spark && state != State.BallSpark && state != State.Dodge && jump <= 0 && bombJump <= 0 && ballBounce <= 0);
	if((entity_place_collide(0,fVY+fellVel) || (bbox_bottom+fVY+fellVel) >= room_height) && fVY >= 0)
	{
		justFell = shouldForceDown;
	}
	else
	{
		if(justFell && ledgeFall && fVY >= 0 && fVY <= fGrav && state != State.Grip && state != State.Spark && state != State.BallSpark && state != State.Dodge)
		{
			fVY += fellVel;
		}
		justFell = false;
	}
	return fVY;
}

function ModifySlopeXSteepness_Up(steepness)
{
	if((speedBoost && grounded) || ((state == State.Spark || state == State.BallSpark) && abs(shineDir) != 2))
	{
		return 4;
	}
	return 2;
}
function ModifySlopeXSteepness_Down(steepness)
{
	return 3;
}
function ModifySlopeYSteepness_Up(steepness)
{
	if(fVelY < 0)
	{
		return 2;
	}
	return 1;
}
function ModifySlopeYSteepness_Down(steepness)
{
	return 2;
}

function SlopeCheck(slope)
{
	var slopeCheck = (slope.image_yscale > 0 && (
		(sign(slope.image_xscale) == -sign(velX) && (slope.image_yscale <= 1 || abs(velX) < 1.5 || speedBoost)) ||
		(sign(slope.image_xscale) == sign(velX) && (slope.image_yscale <= 1 || abs(velX) < 1.5)))
		&& ((slope.image_xscale > 0 && bbox_left >= slope.bbox_left) || (slope.image_xscale < 0 && bbox_right <= slope.bbox_right)));
	
	return slopeCheck;
}

function OnRightCollision(fVX)
{
	
}
function OnLeftCollision(fVX)
{
	
}
function OnXCollision(fVX)
{
	if(speedBoost && speedKillCounter < speedKillMax)
	{
		if(speedBoostWJ && speedBoostWallJump)
		{
			speedKill = false;
		}
		else
		{
			speedKill = true;
		}
	}
	else
	{
		velX = 0;
	}
	fVelX = 0;
	//if(entity_place_collide(move,-3))
	//{
		move = 0;
	//}
	bombJumpX = 0;
	if((state == State.Spark || state == State.BallSpark) && shineStart <= 0)
	{
		if(boots[Boots.ChainSpark])
		{
			shineRestart = true;
			audio_stop_sound(snd_ShineSpark_Charge);
			audio_play_sound(snd_ShineSpark_Charge,0,false);
		}
		else if(shineEnd <= 0)
		{
			audio_play_sound(snd_Hurt,0,false);
		}
		shineEnd = shineEndMax;
	}
}

function CanMoveUpSlope_Bottom()
{
	if((state == State.Spark || state == State.BallSpark) && abs(shineDir) > 2)
	{
		return false;
	}
	return true;
}
function OnSlopeXCollision_Bottom(fVX)
{
	grounded = true;
	if(entityPlatformCheck(0,1))
	{
		onPlatform = true;
	}
	
	if((state == State.Spark || state == State.BallSpark) && abs(shineDir) <= 2 && shineStart <= 0 && move != 0)
	{
		shineEnd = 0;
		shineDir = 0;
		if(state == State.BallSpark)
		{
			state = State.Morph;
			mockBall = true;
		}
		else
		{
			stateFrame = State.Stand;
			mask_index = mask_Stand;
			y -= 3;
			state = State.Stand;
		}
		speedBoost = true;
		speedFXCounter = 1;
		speedCounter = speedCounterMax;
		speedCatchCounter = 6;
		audio_stop_sound(snd_ShineSpark);
		
		velY = 0;
	}
}
function CanMoveDownSlope_Bottom()
{
	return (state != State.Hurt && state != State.DmgBoost && state != State.Spark && state != State.BallSpark && grounded && ballBounce <= 0 && velY >= 0 && velY <= fGrav && jump <= 0 && bombJump <= 0);
}

function CanMoveUpSlope_Top()
{
	return (((state == State.Spark || state == State.BallSpark) && abs(shineDir) >= 2) || state == State.Dodge);
}
function OnSlopeXCollision_Top(fVX)
{
	
}
function CanMoveDownSlope_Top() { return false; }


function OnBottomCollision(fVY)
{
	grounded = true;
	
	if(entityPlatformCheck(0,fVY))
	{
		onPlatform = true;
	}
}
function OnTopCollision(fVY)
{
	
}
function OnYCollision(fVY)
{
	if((state == State.Spark || state == State.BallSpark) && shineStart <= 0)
	{
		if(abs(shineDir) >= 2 && abs(shineDir) != 4 && !entity_place_collide(2*sign(velX),0))
		{
			shineEnd = 0;
			shineDir = 0;
			if(state == State.BallSpark)
			{
				state = State.Morph;
				mockBall = true;
			}
			else
			{
				stateFrame = State.Stand;
				mask_index = mask_Stand;
				y -= 3;
				state = State.Stand;
			}
			speedFXCounter = 0;
			speedCounter = speedCounterMax;
			speedCatchCounter = 6;
			audio_stop_sound(snd_ShineSpark);
		}
		else
		{
			if(shineEnd <= 0)
			{
				audio_play_sound(snd_Hurt,0,false);
			}
			shineEnd = shineEndMax;
		}
	}
	
	// Ball Bounce
	if(canMorphBounce && velY >= (1.5 + fGrav) && state == State.Morph && morphFrame <= 0 && shineRampFix <= 0)
	{
		audio_stop_sound(snd_Land);
		audio_play_sound(snd_Land,0,false);
		
		var bounceVelY = -velY*0.25;
		if(abs(bounceVelY) < fGrav*4)
		{
			bounceVelY = 0;
		}
		velY = min(bounceVelY,0);
		
		ballBounce = ceil(abs(velY)/fGrav)*(2.1 / (1+(liquidState > 0)));
	}
	else
	{
		velY = 0;
	}
	fVelY = 0;
}

function CanMoveUpSlope_Right()
{
	if(!grounded && !onPlatform)
	{
		var yspeed = abs(fVelY);
		var ynum = 0;
		while(!entity_place_collide(0,ynum*sign(fVelY)) && ynum <= yspeed)
		{
			ynum++;
		}
		
		return (fVelY >= 0 || (fVelY < 0 && fVelX < 0) || !entity_place_collide(-1,(ynum+1)*sign(fVelY)));
	}
	return false;
}
function OnSlopeYCollision_Right(fVY)
{
	
}

function CanMoveDownSlope_Right() { return false; }

function CanMoveUpSlope_Left()
{
	if(!grounded && !onPlatform)
	{
		var yspeed = abs(fVelY);
		var ynum = 0;
		while(!entity_place_collide(0,ynum*sign(fVelY)) && ynum <= yspeed)
		{
			ynum++;
		}
		
		return (fVelY >= 0 || (fVelY < 0 && fVelX > 0) || !entity_place_collide(1,(ynum+1)*sign(fVelY)));
	}
	return false;
}
function OnSlopeYCollision_Left(fVY)
{
	
}

function CanMoveDownSlope_Left() { return false; }

/*function OnPlatformCollision(fVY)
{
	if(fVY > 0)
	{
		grounded = true;
		onPlatform = true;
	}
	
	// Ball Bounce
	if(canMorphBounce && velY >= (1.5 + fGrav) && state == State.Morph && morphFrame <= 0 && shineRampFix <= 0)
	{
		audio_stop_sound(snd_Land);
		audio_play_sound(snd_Land,0,false);
			
		var bounceVelY = -velY*0.25;
		if(abs(bounceVelY) < fGrav*4)
		{
			bounceVelY = 0;
		}
		velY = min(bounceVelY,0);
		
		ballBounce = ceil(abs(velY)/fGrav)*(2.1 / (1+(liquidState > 0)));
	}
	else
	{
		velY = 0;
	}
	fVelY = 0;
}*/

function DestroyBlock(bx,by)
{
	if(isSpeedBoosting)
	{
		scr_BreakBlock(bx,by,5);
	}
	if(isScrewAttacking)
	{
		scr_BreakBlock(bx,by,6);
	}
}

#endregion
#region Collision (SpiderBall/Crawler)

function Crawler_ModifyFinalVelX(fVX) { return fVX; }
function Crawler_ModifyFinalVelY(fVY)
{
	justFell = false;
	return fVY;
}

function Crawler_SlopeCheck(slope)
{
	return colEdge != Edge.None;
}

function Crawler_OnRightCollision(fVX)
{
	if(spiderEdge == Edge.Bottom || spiderEdge == Edge.Top || spiderEdge == Edge.None)
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = -velY;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Right;
	}
}
function Crawler_OnLeftCollision(fVX)
{
	if(spiderEdge == Edge.Bottom || spiderEdge == Edge.Top || spiderEdge == Edge.None)
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = velY;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Left;
	}
}
function Crawler_OnXCollision(fVX)
{
	if(state == State.BallSpark && shineStart <= 0)
	{
		if(abs(shineDir) != 2 && !entity_place_collide(0,2*sign(velY)) && shineEnd <= 0)
		{
			//shineEnd = 0;
			shineDir = 0;
			state = State.Morph;
			mockBall = true;
			speedFXCounter = 1;
			speedCounter = speedCounterMax;
			speedCatchCounter = 6;
			audio_stop_sound(snd_ShineSpark);
		}
		else
		{
			if(boots[Boots.ChainSpark])
			{
				shineRestart = true;
				audio_stop_sound(snd_ShineSpark_Charge);
				audio_play_sound(snd_ShineSpark_Charge,0,false);
			}
			else if(shineEnd <= 0)
			{
				audio_play_sound(snd_Hurt,0,false);
			}
			shineEnd = shineEndMax;
		}
	}
	velX = 0;
	fVelX = 0;
	move = 0;
	bombJumpX = 0;
}

function Crawler_CanMoveUpSlope_Bottom()
{
	if(state == State.BallSpark)
	{
		if(shineStart <= 0 && abs(shineDir) <= 2)
		{
			return true;
		}
	}
	else if(colEdge == Edge.Bottom || colEdge == Edge.None)
	{
		return true;
	}
	return false;
}
function Crawler_OnSlopeXCollision_Bottom(fVX)
{
	if(state == State.BallSpark)
	{
		shineEnd = 0;
		shineDir = 0;
		state = State.Morph;
		mockBall = true;
		speedFXCounter = 1;
		speedCounter = speedCounterMax;
		speedCatchCounter = 6;
		audio_stop_sound(snd_ShineSpark);
	}
	if(spiderEdge == Edge.None)
	{
		spiderSpeed = velX;
		spiderMove = sign(spiderSpeed);
		spiderEdge = Edge.Bottom;
	}
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Bottom;
	}
}
function Crawler_CanMoveDownSlope_Bottom()
{
	return (colEdge == Edge.Bottom);
}

function Crawler_CanMoveUpSlope_Top()
{
	if(state == State.BallSpark)
	{
		if(shineStart <= 0 && abs(shineDir) >= 2)
		{
			return true;
		}
	}
	else if(colEdge == Edge.Top || colEdge == Edge.None)
	{
		return true;
	}
	return false;
}
function Crawler_OnSlopeXCollision_Top(fVX)
{
	if(state == State.BallSpark)
	{
		shineEnd = 0;
		shineDir = 0;
		state = State.Morph;
		mockBall = true;
		speedFXCounter = 1;
		speedCounter = speedCounterMax;
		speedCatchCounter = 6;
		audio_stop_sound(snd_ShineSpark);
	}
	if(spiderEdge == Edge.None)
	{
		spiderSpeed = -velX;
		spiderMove = sign(spiderSpeed);
		spiderEdge = Edge.Top;
	}
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Top;
	}
}
function Crawler_CanMoveDownSlope_Top()
{
	return (colEdge == Edge.Top);
}

function Crawler_OnBottomCollision(fVY)
{
	if(spiderEdge == Edge.Left || spiderEdge == Edge.Right || spiderEdge == Edge.None)
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = velX;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Bottom;
	}
}
function Crawler_OnTopCollision(fVY)
{
	if(spiderEdge == Edge.Left || spiderEdge == Edge.Right || spiderEdge == Edge.None)
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = -velX;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Top;
	}
}
function Crawler_OnYCollision(fVY)
{
	if(state == State.BallSpark && shineStart <= 0)
	{
		if(abs(shineDir) != 0 && abs(shineDir) != 4 && !entity_place_collide(2*sign(velX),0) && shineEnd <= 0)
		{
			//shineEnd = 0;
			shineDir = 0;
			state = State.Morph;
			mockBall = true;
			speedFXCounter = 1;
			speedCounter = speedCounterMax;
			speedCatchCounter = 6;
			audio_stop_sound(snd_ShineSpark);
		}
		else
		{
			if(shineEnd <= 0)
			{
				audio_play_sound(snd_Hurt,0,false);
			}
			shineEnd = shineEndMax;
		}
	}
	
	velY = 0;
	fVelY = 0;
}

function Crawler_CanMoveUpSlope_Right()
{
	if(state == State.BallSpark)
	{
		if(shineStart <= 0 && (abs(shineDir) == 0 || abs(shineDir) == 4 || sign(shineDir) == -1))
		{
			return true;
		}
	}
	else if(colEdge == Edge.Right)// || colEdge == Edge.None)
	{
		return true;
	}
	return false;
}
function Crawler_OnSlopeYCollision_Right(fVY)
{
	if(state == State.BallSpark)
	{
		shineEnd = 0;
		shineDir = 0;
		state = State.Morph;
		mockBall = true;
		speedFXCounter = 1;
		speedCounter = speedCounterMax;
		speedCatchCounter = 6;
		audio_stop_sound(snd_ShineSpark);
	}
	if(spiderEdge == Edge.None)
	{
		spiderSpeed = -velY;
		spiderMove = sign(spiderSpeed);
		spiderEdge = Edge.Right;
	}
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Right;
	}
}
function Crawler_CanMoveDownSlope_Right()
{
	return (colEdge == Edge.Right);
}

function Crawler_CanMoveUpSlope_Left()
{
	if(state == State.BallSpark)
	{
		if(shineStart <= 0 && (abs(shineDir) == 0 || abs(shineDir) == 4 || sign(shineDir) == 1))
		{
			return true;
		}
	}
	else if(colEdge == Edge.Left)// || colEdge == Edge.None)
	{
		return true;
	}
	return false;
}
function Crawler_OnSlopeYCollision_Left(fVY)
{
	if(state == State.BallSpark)
	{
		shineEnd = 0;
		shineDir = 0;
		state = State.Morph;
		mockBall = true;
		speedFXCounter = 1;
		speedCounter = speedCounterMax;
		speedCatchCounter = 6;
		audio_stop_sound(snd_ShineSpark);
	}
	if(spiderEdge == Edge.None)
	{
		spiderSpeed = velY;
		spiderMove = sign(spiderSpeed);
		spiderEdge = Edge.Left;
	}
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Left;
	}
}
function Crawler_CanMoveDownSlope_Left()
{
	return (colEdge == Edge.Left);
}

function Crawler_DestroyBlock(bx,by)
{
	DestroyBlock(bx,by);
}

#endregion

#region ChangeState
function ChangeState(newState,newStateFrame,newMask,isGrounded)
{
	stateFrame = newStateFrame;
	
	if(mask_index != newMask)
	{
		var shift = 0;
		if(mask_index == mask_Stand)
		{
			switch(newMask)
			{
				case mask_Jump:
				{
					shift = 3;
					break;
				}
				case mask_Crouch:
				{
					shift = 11;
					break;
				}
				case mask_Morph:
				{
					shift = 11;
					break;
				}
			}
		}
		else if(mask_index == mask_Jump)
		{
			switch(newMask)
			{
				case mask_Stand:
				{
					shift = -3;
					break;
				}
				case mask_Crouch:
				{
					shift = 9;
					break;
				}
				case mask_Morph:
				{
					shift = 9;
					break;
				}
			}
		}
		else if(mask_index == mask_Crouch)
		{
			switch(newMask)
			{
				case mask_Stand:
				{
					shift = -11;
					break;
				}
				case mask_Jump:
				{
					shift = -9;
					break;
				}
				case mask_Morph:
				{
					shift = 0;
					break;
				}
			}
		}
		else if(mask_index == mask_Morph)
		{
			switch(newMask)
			{
				case mask_Stand:
				{
					shift = -11;
					break;
				}
				case mask_Jump:
				{
					shift = -9;
					break;
				}
				case mask_Crouch:
				{
					shift = 0;
					break;
				}
			}
		}
		
		mask_index = newMask;
		//for(var i = 0; i < abs(shift); i++)
		for(var i = abs(shift); i > 0; i--)
		{
			if(shift > 0)
			{
				if(!entity_place_collide(0,1) && isGrounded)
				{
					y += 1;
				}
			}
			else
			{
				if((entity_place_collide(0,0) || (onPlatform && entity_place_meeting(x,y,"IPlatform"))) && !entity_position_collide(0,bbox_top-y-1))
				{
					y -= 1;
				}
			}
		}
	}
	state = newState;
}
#endregion

#region Shoot (old)
//function Shoot(ShotIndex, Damage, Speed, CoolDown, ShotAmount, SoundIndex)
/*function Shoot()
{
	/// @description Shoot
	/// @param ShotIndex
	/// @param Damage
	/// @param Speed
	/// @param CoolDown
	/// @param ShotAmount
	/// @param SoundIndex
	/// @param SkipCenterShot=false
	var ShotIndex = argument[0],
		Damage = argument[1],
		Speed = argument[2],
		CoolDown = argument[3],
		ShotAmount = argument[4],
		SoundIndex = argument[5],
		SkipCenterShot = false;
	if(argument_count > 6)
	{
		SkipCenterShot = argument[6];
	}
	
	var spawnX = shootPosX,
		spawnY = shootPosY;

	if(SoundIndex != noone)
	{
		if(audio_is_playing(global.prevShotSndIndex))
		{
			var gain = 0;
			if(asset_get_index(audio_get_name(global.prevShotSndIndex)) != SoundIndex)
			{
				gain = audio_sound_get_gain(global.prevShotSndIndex);//*0.5;
			}
			audio_sound_gain(global.prevShotSndIndex,gain,25);
		}
		var snd = audio_play_sound(SoundIndex,1,false);
		audio_sound_gain(snd,global.soundVolume,0);
		global.prevShotSndIndex = snd;
	}

	if(ShotIndex != noone)
	{
		var shot = noone;
		for(var i = 0; i < ShotAmount; i++)
		{
			if(i != 2 || !SkipCenterShot)
			{
				shot = instance_create_layer(spawnX,spawnY,layer_get_id("Projectiles"),ShotIndex);
				shot.damage = Damage;
				shot.velocity = Speed;
				if(!shot.isBomb)
				{
					shot.direction = shootDir;
					shot.image_angle = shootDir;
				}
				shot.speed_x = extraSpeed_x;
				shot.speed_y = extraSpeed_y;
				shot.waveStyle = i;
				shot.dir = dir2;
				shot.waveDir = waveDir;
				shot.creator = object_index;
			}
		}
		shotDelayTime = CoolDown;
		if(shot.particleType >= 0 && !shot.isGrapple)
		{
			var partSys = obj_Particles.partSystemB;
			if(shot.isWave)
			{
				partSys = obj_Particles.partSystemA;
			}
		
			part_particles_create(partSys,shootPosX,shootPosY,obj_Particles.bTrails[shot.particleType],7+(5*(statCharge >= maxCharge)));
	        part_particles_create(partSys,shootPosX,shootPosY,obj_Particles.mFlare[shot.particleType],1);
		}
		waveDir *= -1;
		if(instance_exists(shot))
		{
			return shot;
		}
	}
	return noone;
}*/
#endregion
#region Shoot
//function Shoot(ShotIndex, Damage, Speed, CoolDown, ShotAmount, SoundIndex)
function Shoot()
{
	/// @description Shoot
	/// @param ShotIndex
	/// @param Damage
	/// @param Speed
	/// @param CoolDown
	/// @param ShotAmount
	/// @param SoundIndex
	/// @param IsWave=false
	/// @param WaveStyleOffset=0
	var ShotIndex = argument[0],
		Damage = argument[1],
		Speed = argument[2],
		CoolDown = argument[3],
		ShotAmount = argument[4],
		SoundIndex = argument[5],
		IsWave = false,
		WaveStyleOffset = 0;
	if(argument_count > 6)
	{
		IsWave = argument[6];
	}
	if(argument_count > 7)
	{
		WaveStyleOffset = argument[7];
	}
	
	var spawnX = shootPosX,
		spawnY = shootPosY;

	if(SoundIndex != noone)
	{
		if(audio_is_playing(global.prevShotSndIndex))
		{
			var gain = 0;
			if(asset_get_index(audio_get_name(global.prevShotSndIndex)) != SoundIndex)
			{
				gain = audio_sound_get_gain(global.prevShotSndIndex);//*0.5;
			}
			audio_sound_gain(global.prevShotSndIndex,gain,25);
		}
		var snd = audio_play_sound(SoundIndex,1,false);
		audio_sound_gain(snd,global.soundVolume,0);
		global.prevShotSndIndex = snd;
	}

	if(ShotIndex != noone)
	{
		var shot = noone;
		for(var i = 0; i < ShotAmount; i++)
		{
			//if(i != 2 || !SkipCenterShot)
			//{
				shot = instance_create_layer(spawnX,spawnY,layer_get_id("Projectiles"),ShotIndex);
				shot.damage = Damage;
				/*shot.velocity = Speed;
				if(!shot.isBomb)
				{
					shot.direction = shootDir;
					shot.image_angle = shootDir;
				}*/
				shot.velX = lengthdir_x(Speed,shootDir);
				shot.velY = lengthdir_y(Speed,shootDir);
				shot.direction = shootDir;
				shot.image_angle = shootDir+180;
				shot.speed_x = extraSpeed_x;
				shot.speed_y = extraSpeed_y;
				shot.waveStyle = i + WaveStyleOffset;
				shot.dir = dir2;
				shot.waveDir = waveDir;
				shot.creator = object_index;
			//}
		}
		if(instance_exists(shot))
		{
			shotDelayTime = CoolDown;
			if(shot.particleType >= 0 && !shot.isGrapple)
			{
				var partSys = obj_Particles.partSystemB;
				//if(shot.isWave)
				if(IsWave)
				{
					partSys = obj_Particles.partSystemA;
				}
		
				part_particles_create(partSys,shootPosX,shootPosY,obj_Particles.bTrails[shot.particleType],7+(5*(statCharge >= maxCharge)));
		        part_particles_create(partSys,shootPosX,shootPosY,obj_Particles.mFlare[shot.particleType],1);
			}
			waveDir *= -1;
			return shot;
		}
	}
	return noone;
}
#endregion

#region PlayerGrounded
function PlayerGrounded()
{
	var xdiff = 0,
		ydiff = 2;
	if(argument_count > 0)
	{
		ydiff = argument[0];
	}
	
	var bottomCollision = (entity_place_collide(xdiff,ydiff) || (y+ydiff) >= room_height);
	
	return (((bottomCollision && velY >= 0 && velY <= fGrav) || (spiderBall && spiderEdge != Edge.None)) && jump <= 0);
}
#endregion
#region PlayerOnPlatform
function PlayerOnPlatform()
{
	return (entityPlatformCheck(0,3) && fVelY >= 0 && state != State.Spark && state != State.BallSpark);
}
#endregion
#region AfterImage
function AfterImage(draw, rotation, delay, num, alpha)
{
	var echo = noone;
	
	if(draw)
	{
		if(!global.gamePaused)
		{
			afterImgCounter += 1;
		}
		if(afterImgCounter > delay)
		{
			echo = instance_create_layer(scr_round(x),scr_round(y),"Player",obj_PlayerEcho);
			echo.surfW = surfW;
			echo.surfH = surfH;
			echo.mask_index = mask_index;
			echo.fadeRate = (1 / max(num,1));
			echo.state = state;
			echo.stateFrame = stateFrame;
			echo.morphFrame = morphFrame;
			echo.morphAlpha = morphAlpha;
			echo.unmorphing = unmorphing;
			echo.dir = dir;
			echo.fDir = fDir;
			echo.torsoR = torsoR;
			echo.torsoL = torsoL;
			echo.legs = legs;
			echo.bodyFrame = bodyFrame;
			echo.legFrame = legFrame;
			echo.ballFrame = ballFrame;
			echo.sprtOffsetX = sprtOffsetX;
			echo.sprtOffsetY = sprtOffsetY;
			echo.runYOffset = runYOffset;
			echo.itemSelected = itemSelected;
			echo.itemHighlighted = itemHighlighted;
			echo.missileArmFrame = missileArmFrame;
			echo.drawMissileArm = drawMissileArm;
			echo.finalArmFrame = finalArmFrame;
			echo.armDir = armDir;
			echo.armOffsetX = armOffsetX;
			echo.armOffsetY = armOffsetY;
			echo.rotation = rotation;
			echo.alpha2 = alpha;
			echo.palShader = palShader;
			echo.palIndex = palIndex;
			echo.palIndex2 = palIndex2;
			echo.palDif = palDif;
			echo.item = item;
			echo.misc = misc;
			echo.climbIndex = climbIndex;
			echo.gripFrame = gripFrame;
			echo.gripAimFrame = gripAimFrame;
			echo.liquidState = liquidState;
			echo.dmgFlash = dmgFlash;
			echo.immuneTime = immuneTime;
			//echo.velX = x-xprevious;
			//echo.velY = y-yprevious;
			//if((state == "stand" || state == "crouch") && prevState != state)
			//{
			//	echo.velY = 0;
			//}
			afterImgCounter = 0;
		}
	}
	else
	{
		afterImgCounter = 0;
	}
	
	return echo;
}
#endregion

#region SpiderEnable
function SpiderEnable(flag)
{
	if(spiderBall != flag)
	{
		spiderBall = flag;
		audio_play_sound(snd_SpiderStart,0,false);
		if(flag)
		{
			if(!audio_is_playing(snd_SpiderLoop))
			{
				audio_play_sound(snd_SpiderLoop,0,true);
			}
			if(grounded)
			{
				spiderEdge = Edge.Bottom;
				spiderSpeed = velX;
			}
		}
		else
		{
			audio_stop_sound(snd_SpiderLoop);
			spiderEdge = Edge.None;
		}
	}
}
#endregion
#region SpiderMovement (old)
/*function SpiderMovement()
{
	var edge = spiderEdge;
	var angle = 270;
	if(edge == Edge.Right)
	{
	    angle = 0;
	}
	if(edge == Edge.Top)
	{
	    angle = 90;
	}
	if(edge == Edge.Left)
	{
	    angle = 180;
	}
	var angle2 = angle;

	var num = 4;
	while(spiderMove != 0 && place_collide(scr_ceil(lengthdir_x(1,angle)),scr_ceil(lengthdir_y(1,angle))) && num > 0)
	{
	    angle += 45*spiderMove;
	    num -= 1;
	}

	var xa = lengthdir_x(spiderMove!=0,angle),
	    ya = lengthdir_y(spiderMove!=0,angle),
	    xv = lengthdir_x(1,angle2),
	    yv = lengthdir_y(1,angle2);

	if(edge == Edge.Bottom || edge == Edge.Top)
	{
	    if(!place_collide(xa,0))
	    {
	        x += xa;
	    }
	    else if(!place_collide(xa,ya))
	    {
	        y += ya;
	        x += xa;
	    }
	}

	if(edge == Edge.Left || edge == Edge.Right)
	{
	    if(!place_collide(0,ya))
	    {
	        y += ya;
	    }
	    else if(!place_collide(xa,ya))
	    {
	        x += xa;
	        y += ya;
	    }
	}

	if(!place_collide(xv,yv))
	{
	    x += xv;
	    y += yv;
	}
	if(place_collide(0,0))
	{
	    x -= xv;
	    y -= yv;
	}
}*/
#endregion
#region SpiderBall (old)
/*function SpiderBall()
{
	if(spiderEdge != Edge.None)
	{
	    velX = 0;
	    fVelX = 0;
	    velY = 0;
	    fVelY = 0;
	    var moveX = (cRight-cLeft),
	        moveY = (cDown-cUp);

	    if(moveX == 0 && moveY == 0)
	    {
	        spiderMove = 0;
	    }
	    if(spiderMove == 0)
	    {
	        if(spiderEdge == Edge.Bottom)
	        {
	            spiderMove = moveX;
	        }
	        if(spiderEdge == Edge.Top)
	        {
	            spiderMove = -moveX;
	        }
	        if(spiderEdge == Edge.Left)
	        {
	            spiderMove = moveY;
	        }
	        if(spiderEdge == Edge.Right)
	        {
	            spiderMove = -moveY;
	        }
	    }
    
	    switch(spiderEdge)
	    {
	        case Edge.Bottom:
	        {
	            SpiderMovement();

	            if(place_collide(spiderMove,0))
	            {
	                if(spiderMove > 0)
	                {
	                    spiderEdge = Edge.Right;
	                }
	                if(spiderMove < 0)
	                {
	                    spiderEdge = Edge.Left;
	                }
	            }
	            else
	            {
	                if(!place_collide(0,1) && place_collide(1,1))
	                {
	                    spiderEdge = Edge.Right;
	                }
	                if(!place_collide(0,1) && place_collide(-1,1))
	                {
	                    spiderEdge = Edge.Left;
	                }
	            }
	            break;
	        }
	        case Edge.Left:
	        {
	            SpiderMovement();

	            if(place_collide(0,spiderMove))
	            {
	                if(spiderMove > 0)
	                {
	                    spiderEdge = Edge.Bottom;
	                }
	                if(spiderMove < 0)
	                {
	                    spiderEdge = Edge.Top;
	                    dir *= -1;
	                }
	            }
	            else
	            {
	                if(!place_collide(-1,0) && place_collide(-1,-1))
	                {
	                    spiderEdge = Edge.Top;
	                    dir *= -1;
	                }
	                if(!place_collide(-1,0) && place_collide(-1,1))
	                {
	                    spiderEdge = Edge.Bottom;
	                }
	            }
	            break;
	        }
	        case Edge.Top:
	        {
	            SpiderMovement();

	            if(place_collide(-spiderMove,0))
	            {
	                if(spiderMove < 0)
	                {
	                    spiderEdge = Edge.Right;
	                    dir *= -1;
	                }
	                if(spiderMove > 0)
	                {
	                    spiderEdge = Edge.Left;
	                    dir *= -1;
	                }
	            }
	            else
	            {
	                if(!place_collide(0,-1) && place_collide(-1,-1))
	                {
	                    spiderEdge = Edge.Left;
	                    dir *= -1;
	                }
	                if(!place_collide(0,-1) && place_collide(1,-1))
	                {
	                    spiderEdge = Edge.Right;
	                    dir *= -1;
	                }
	            }
	            break;
	        }
	        case Edge.Right:
	        {
	            SpiderMovement();

	            if(place_collide(0,-spiderMove))
	            {
	                if(spiderMove > 0)
	                {
	                    spiderEdge = Edge.Top;
	                    dir *= -1;
	                }
	                if(spiderMove < 0)
	                {
	                    spiderEdge = Edge.Bottom;
	                }
	            }
	            else
	            {
	                if(!place_collide(1,0) && place_collide(1,-1))
	                {
	                    spiderEdge = Edge.Top;
	                    dir *= -1;
	                }
	                if(!place_collide(1,0) && place_collide(1,1))
	                {
	                    spiderEdge = Edge.Bottom;
	                }
	            }
	            break;
	        }
	    }

	    if(!collision_rectangle(bbox_left-4,bbox_top-4,bbox_right+3,bbox_bottom+3,obj_Tile,1,0))
	    {
	        spiderEdge = Edge.None;
	    }
	}
	else
	{
	    spiderMove = 0;
	    if(place_collide(1,0))
	    {
	        spiderEdge = Edge.Right;
	    }
	    if(place_collide(-1,0))
	    {
	        spiderEdge = Edge.Left;
	    }
	    if(place_collide(0,1))
	    {
	        spiderEdge = Edge.Bottom;
	    }
	    if(place_collide(0,-1))
	    {
	        spiderEdge = Edge.Top;
	    }
	}
}*/
#endregion
#region SpiderActive
function SpiderActive()
{
	if(argument_count > 0)
	{
		return (spiderBall && spiderEdge == argument[0]);
	}
	return (spiderBall && spiderEdge != Edge.None);
}
#endregion

#region player_water
function player_water()
{
	var xVel = x - xprevious,
		yVel = y - yprevious;

	if(justFell)
	{
		yVel = velY;
	}
    
	WaterBot = bbox_bottom-y;
	if(state == State.Grip && !startClimb)
	{
		WaterBot += 4;
	}

	water_update(2,xVel,yVel);

	//PhysState = ((water_at(x,y-12)) && !oControl.Power[17]);

	/*if (State == "JUMPING" or (State == "DASH" && !get_check("GROUND",1,0)))
	{
		WaterBot = -12;
	}

	if (State == "GRAPPLE")
	{
		WaterBot = 16;
	}

	if (PhysState != 0)
	{
		DashTime = 0;
		Dash = 0;
		DashPhase = 0;
		DashSpeed = 0;
	}*/

	/// -- Extra Splash -- \\\

	CanSplash ++;

	if (CanSplash > 65535)
	{
		CanSplash = 0;
	}

	if (in_water() && !in_water_top() && (CanSplash mod 2 == 0))
	{
		var splashx = x+random_range(4,-4);
		if(state == State.Grip && !startClimb)
		{
		    splashx -= 4*dir;
		}
		Splash = instance_create_layer(splashx,SplashY,"Liquids_fg",obj_SplashFXAnim);
		Splash.Speed = .25;
		Splash.sprite_index = sprt_WaterSplashSmall;
		Splash.image_alpha = 0.4;
		Splash.depth = 65;
		Splash.Splash = 1;
		Splash.image_index = 3;
		Splash.image_xscale = choose(1,-1);
    
		/*if (state == "grapple" && abs(grapAngVel) > 1 && abs(angle_difference(grapAngle,0)) < 90)//(State == "GRAPPLE" && abs(GrappleAngleVel)>1 && abs(angle_difference(GrappleAngle,0))<90 && Sprite != sSCrouch)
		{
		    Splash.sprite_index = sprt_WaterSplashLarge;
		    Splash.image_alpha = .5;
		    Splash.image_yscale = min(max(abs(grapAngVel)/7,.1),.7);
		    Splash.image_index = 0;
		}
		else*/
		if (xVel == 0 && abs(yVel) < 2)
		{
		    /*Splash.image_yscale = .65;
		    Splash.image_index = 5;
		    Splash.image_xscale = .75;*/
		    Splash.image_yscale = choose(.3,.5,.7,1);
		    Splash.image_index = 0;
		    Splash.image_xscale = choose(1.4,1);
		    Splash.sprite_index = sprt_WaterSplashTiny;
		    Splash.x += irandom(4) - 2;
		}
		else if (abs(xVel) > 0 && !StepSplash)
		{
		    Splash.sprite_index = sprt_WaterSkid;
		    Splash.image_alpha = 0.6;
		    Splash.depth = 65;
		    Splash.image_index = 1;
		    Splash.image_xscale = choose(1,-1);
		    Splash.Splash = 0;
		    Splash.x += xVel * 2;
		    Splash.xVel = xVel/4.5;
		    Splash.image_yscale = (.4 + min(.6,abs(xVel)/10)) * (choose(1, .5 + random(.4)));//.8 + random(.2);
		    Splash.y --;
        
		    StepSplash = 2;
        
		    /*if (choose(0,1,1) == 0)
		    {
		        Splash.image_yscale *= .1;
		        StepSplash = 1;
		    }*/
		}
    
		if(((state == State.Spark || state == State.BallSpark) && shineStart <= 0 && shineEnd <= 0) || speedBoost)// (State == "SUPERJUMP" or DashPhase >= 2)
		{
		    if (CanSplash mod 2 == 0)
		    {
		        Splash.sprite_index = sprt_WaterSkidLarge;
		        Splash.Speed = .5;
		        Splash.image_yscale = 1;
		        Splash.image_index = 0;
		        Splash.image_xscale = 1;
		        Splash.image_index = 0;
		        Splash.image_alpha = .5;
		        Splash.Splash = 0;
		        Splash.x -= xVel;
		        repeat (3)
		        {
		            Drop = instance_create_layer(x,SplashY-4,"Liquids_fg",obj_WaterDrop);
		            Drop.xVel = -2.25+random(4.5);
		            Drop.yVel = -.5-random(2.5);
		            Drop.xVel += (xVel)/2;
		        }
            
		        if (CanSplash mod 4 == 0)
		        {
		            //sound_play_pos(sndSplashTiny,x,y,0);
		            //audio_play_sound(snd_SplashTiny,0,false);
		            audio_play_sound(snd_SplashSkid,0,false);
		        }
		    }
		}

		if ((!audio_is_playing(WaterShuffleSoundID[WaterShuffleCount]) or (abs(xVel > 0) && irandom(7) == 0))) && ((abs(xVel) > 0) or (irandom(23) == 0))
		{
		    audio_play_sound(WaterShuffleSoundID[WaterShuffleCount],0,false);
		    WaterShuffleCount = choose(0,1,2,3);
		}
	}


	/// -- Underwater Bubbles -- \\\ 
	
	var maxDashSpeed = maxSpeed[1,liquidState];
	if ((EnteredWater || (abs(xVel) >= maxDashSpeed && InWater)) && choose(1,1,1,0) == 1)
	{
		Bubble = instance_create_layer(x-8+random(16),bbox_top+random(bbox_bottom-bbox_top),"Liquids_fg",obj_WaterBubble);
    
		if (yVel > 0)
		{
		    Bubble.yVel += yVel/4;
		}
    
		if (EnteredWater < 60 && (state != State.Stand || abs(xVel) < maxDashSpeed))
		{
		    Bubble.Alpha *= (EnteredWater/60);
		    Bubble.AlphaMult *= (EnteredWater/60);
		} 
	}

	/// -- Leaving Drops

	if (LeftWater && choose(1,1,1,0,0) == 1)
	{
		Drop = instance_create_layer(x-8+random(16),y+4,"Liquids_fg",obj_WaterDrop);
 
		if (state == State.Somersault)
		{
			Drop.xVel = -random(7) + 3.5;
			Drop.yVel = -random(5) + 1;
		}
 
		with (Drop)
		{
			if (water_at(x,y))
			{
				Dead = 1;
				instance_destroy();
			}
		}
	}

	if (LeftWaterTop && choose(1,1,1,0,0) == 1)
	{
		Drop = instance_create_layer(x-8+random(16),bbox_bottom+random(bbox_top-y+4),"Liquids_fg",obj_WaterDrop);
 
		if (state == State.Somersault)
		{
			Drop.xVel = -random(6) + 3;
			Drop.yVel = -random(6) + 1;
		}
 
		with (Drop)
		{
			if (water_at(x,y))
			{
				Dead = 1;
				instance_destroy();
			}
		}
	}

	/// -- Breathing Bubbles --
	
	if(!instance_exists(obj_Lava))
	{
		BreathTimer --;
		if (BreathTimer < 16)
		{
			if (BreathTimer < 0)
			{
			    BreathTimer = choose(110,150,160);
			}
			else if (BreathTimer == 15 && InWaterTop)
			{
			    audio_play_sound(choose(snd_Breath_0,snd_Breath_1,snd_Breath_2),0,false);
			}
     
			if (InWaterTop && (BreathTimer mod 8 == 0))
			{
			    Bubble = instance_create_layer(x + 4*dir,bbox_top + 7, "Liquids_fg", obj_WaterBubble);
			    Bubble.xVel = dir/2 -.15 + random(.3);
			    Bubble.yVel = .2+random(.1);
			    Bubble.Breathed = 0.15;
			    Bubble.image_xscale /= choose(1.3,1.5);
			    Bubble.image_yscale = Bubble.image_xscale;
			    Bubble.xVel += (x - xprevious)/2;
			    Bubble.sprite_index = sprt_WaterBubbleSmall;
        
			    if (state == State.Grip)
			    {
			        Bubble.x -= (dir * 6);
			    }
			}
		}

		/// -- Screw Attack boiling nearby water --

		if (state == State.Somersault && misc[Misc.ScrewAttack] && suit[Suit.Gravity])
		{
			if (InWater)
			{
			    repeat (3)
			    {
			        D = instance_create_layer(x + random_range(16,-16), y+2 + random_range(16,-16), "Liquids_fg", obj_WaterBubble);
			        D.Delete = 1;
			        D.CanSpread = 0;
			    }
			}
		}

		if(((state == State.Spark || state == State.BallSpark) && shineStart <= 0 && shineEnd <= 0) || speedBoost || state == State.Dodge)
		{
			if (InWater)
			{
			    repeat (3)
			    {
			        D = instance_create_layer(random_range(bbox_left,bbox_right), random_range(bbox_top,bbox_bottom), "Liquids_fg", obj_WaterBubble);
			        D.Delete = 1;
			        D.CanSpread = 0;
			    }
			}
		}
		
		if(InWater && stateFrame == State.Brake && brakeFrame >= 9)
		{
			//D = instance_create_layer(x-8+random(16),bbox_bottom,"Liquids_fg",obj_WaterBubble);
			D = instance_create_layer(x-random(12)*dir,bbox_bottom+4-random(8),"Liquids_fg",obj_WaterBubble);
			D.Delete = 1;
			D.CanSpread = 0;
		}
	}
}
#endregion

#region Set Beams
function Set_Beams()
{
	beamShot = obj_PowerBeamShot;
	beamCharge = obj_PowerBeamChargeShot;
	beamChargeAnim = sprt_PowerBeamChargeAnim;
	beamSound = snd_PowerBeam_Shot;
	beamChargeSound = snd_PowerBeam_ChargeShot;
	beamAmt = 1;
	beamChargeAmt = 1;
	beamIconIndex = 0;
	beamFlare = sprt_PowerBeamChargeFlare;
	
	beamIsWave = false;
	beamWaveStyleOffset = 1;
	
	var noBeamsActive = ((beam[Beam.Ice]+beam[Beam.Wave]+beam[Beam.Spazer]+beam[Beam.Plasma]) <= 0);
	
	if(beam[Beam.Wave] || (noBeamsActive && itemHighlighted[0] == 2))
	{
		beamIsWave = true;
	}
	
	if(beam[Beam.Spazer] || (noBeamsActive && itemHighlighted[0] == 3))
	{
		// Spazer
		beamShot = obj_SpazerBeamShot;
		beamCharge = obj_SpazerBeamChargeShot;
		beamChargeAnim = sprt_SpazerChargeAnim;
		beamSound = snd_Spazer_Shot;
		beamChargeSound = snd_Spazer_ChargeShot;
		beamAmt = 3;
		beamChargeAmt = 3;
		beamIconIndex = 4;
		beamFlare = sprt_SpazerChargeFlare;
		
		beamWaveStyleOffset = 0;
		if(beam[Beam.Ice])
		{
			// Ice Spazer
			beamShot = obj_IceSpazerBeamShot;
			beamCharge = obj_IceSpazerBeamChargeShot;
			beamChargeAnim = sprt_IceBeamChargeAnim;
			beamSound = snd_IceComboShot;
			beamChargeSound = snd_IceBeam_ChargeShot;
			beamIconIndex = 5;
			beamFlare = sprt_IceBeamChargeFlare;
			if(beam[Beam.Wave])
			{
				// Ice Wave Spazer
				beamShot = obj_IceWaveSpazerBeamShot;
				beamCharge = obj_IceWaveSpazerBeamChargeShot;
				beamIconIndex = 7;
				if(beam[Beam.Plasma])
				{
					// Ice Wave Spazer Plasma
					beamShot = obj_IceWaveSpazerPlasmaBeamShot;
					beamCharge = obj_IceWaveSpazerPlasmaBeamChargeShot;
					beamIconIndex = 15;
				}
			}
			else if(beam[Beam.Plasma])
			{
				// Ice Spazer Plasma
				beamShot = obj_IceSpazerPlasmaBeamShot;
				beamCharge = obj_IceSpazerPlasmaBeamChargeShot;
				beamIconIndex = 13;
			}
		}
		else if(beam[Beam.Wave])
		{
			// Wave Spazer
			beamShot = obj_WaveSpazerBeamShot;
			beamCharge = obj_WaveSpazerBeamChargeShot;
			beamChargeAnim = sprt_WaveBeamChargeAnim;
			beamIconIndex = 6;
			beamFlare = sprt_WaveBeamChargeFlare;
			if(beam[Beam.Plasma])
			{
				// Wave Spazer Plasma
				beamShot = obj_WaveSpazerPlasmaBeamShot;
				beamCharge = obj_WaveSpazerPlasmaBeamChargeShot;
				beamChargeAnim = sprt_PlasmaBeamChargeAnim;
				beamSound = snd_PlasmaBeam_Shot;
				beamChargeSound = snd_PlasmaBeam_ChargeShot;
				beamIconIndex = 14;
				beamFlare = sprt_PlasmaBeamChargeFlare;
			}
		}
		else if(beam[Beam.Plasma])
		{
			// Spazer Plasma
			beamShot = obj_SpazerPlasmaBeamShot;
			beamCharge = obj_SpazerPlasmaBeamChargeShot;
			beamChargeAnim = sprt_PlasmaBeamChargeAnim;
			beamSound = snd_PlasmaBeam_Shot;
			beamChargeSound = snd_PlasmaBeam_ChargeShot;
			beamIconIndex = 12;
			beamFlare = sprt_PlasmaBeamChargeFlare;
		}
	}
	else if(beam[Beam.Ice] || (noBeamsActive && itemHighlighted[0] == 1))
	{
		// Ice
		beamShot = obj_IceBeamShot;
		beamCharge = obj_IceBeamChargeShot;
		beamChargeAnim = sprt_IceBeamChargeAnim;
		beamSound = snd_IceBeam_Shot;
		beamChargeSound = snd_IceBeam_ChargeShot;
		beamIconIndex = 1;
		beamFlare = sprt_IceBeamChargeFlare;
		if(beam[Beam.Wave])
		{
			// Ice Wave
			beamShot = obj_IceWaveBeamShot;
			beamCharge = obj_IceWaveBeamChargeShot;
			beamChargeAmt = 2;
			beamIconIndex = 3;
			if(beam[Beam.Plasma])
			{
				// Ice Wave Plasma
				beamShot = obj_IceWavePlasmaBeamShot;
				beamCharge = obj_IceWavePlasmaBeamChargeShot;
				beamSound = snd_IceComboShot;
				beamIconIndex = 11;
			}
		}
		else if(beam[Beam.Plasma])
		{
			// Ice Plasma
			beamShot = obj_IcePlasmaBeamShot;
			beamCharge = obj_IcePlasmaBeamChargeShot;
			beamSound = snd_IceComboShot;
			beamIconIndex = 9;
		}
	}
	else if(beam[Beam.Wave] || (noBeamsActive && itemHighlighted[0] == 2))
	{
		// Wave
		beamShot = obj_WaveBeamShot;
		beamCharge = obj_WaveBeamChargeShot;
		beamChargeAnim = sprt_WaveBeamChargeAnim;
		beamSound = snd_WaveBeam_Shot;
		beamChargeSound = snd_WaveBeam_ChargeShot;
		beamChargeAmt = 2;
		beamIconIndex = 2;
		beamFlare = sprt_WaveBeamChargeFlare;
		if(beam[Beam.Plasma])
		{
			// Wave Plasma
			beamShot = obj_WavePlasmaBeamShot;
			beamCharge = obj_WavePlasmaBeamChargeShot;
			beamChargeAnim = sprt_PlasmaBeamChargeAnim;
			beamSound = snd_PlasmaBeam_Shot;
			beamChargeSound = snd_PlasmaBeam_ChargeShot;
			beamIconIndex = 10;
			beamFlare = sprt_PlasmaBeamChargeFlare;
		}
	}
	else if(beam[Beam.Plasma] || (noBeamsActive && itemHighlighted[0] == 4))
	{
		// Plasma
		beamShot = obj_PlasmaBeamShot;
		beamCharge = obj_PlasmaBeamChargeShot;
		beamChargeAnim = sprt_PlasmaBeamChargeAnim;
		beamSound = snd_PlasmaBeam_Shot;
		beamChargeSound = snd_PlasmaBeam_ChargeShot;
		beamIconIndex = 8;
		beamFlare = sprt_PlasmaBeamChargeFlare;
	}
	
	beamDmg = 20;
	beamDelay = 8;
	beamChargeDelay = 20;
	var iceDelay = 4,
		waveDelay = 0,//2,
		spazerDelay = 0,//-2,
		plasmaDelay = 3;
	if(beam[Beam.Ice] || (noBeamsActive && itemHighlighted[0] == 1))
	{
		// Ice
		beamDmg = 30;
		beamDelay += iceDelay;
		beamChargeDelay += iceDelay;
		if(beam[Beam.Wave])
		{
			// Ice Wave
			beamDmg = 60;
			beamDelay += waveDelay;
			beamChargeDelay += waveDelay;
			if(beam[Beam.Plasma])
			{
				// Ice Wave Plasma
				beamDmg = 300;
				beamDelay += plasmaDelay;
				beamChargeDelay += plasmaDelay;
			}
		}
		else if(beam[Beam.Plasma])
		{
			// Ice Plasma
			beamDmg = 200;
			beamDelay += plasmaDelay;
			beamChargeDelay += plasmaDelay;
		}
	}
	else if(beam[Beam.Wave] || (noBeamsActive && itemHighlighted[0] == 2))
	{
		// Wave
		beamDmg = 50;
		beamDelay += waveDelay;
		beamChargeDelay += waveDelay;
		if(beam[Beam.Plasma])
		{
			// Wave Plasma
			beamDmg = 250;
			beamDelay += plasmaDelay;
			beamChargeDelay += plasmaDelay;
		}
	}
	else if(beam[Beam.Plasma] || (noBeamsActive && itemHighlighted[0] == 4))
	{
		// Plasma
		beamDmg = 150;
		beamDelay += plasmaDelay;
		beamChargeDelay += plasmaDelay;
	}
	if(beam[Beam.Spazer] || (noBeamsActive && itemHighlighted[0] == 3))
	{
		// Spazer
		beamDmg *= (2/3);
		beamDelay += spazerDelay;
		beamChargeDelay += spazerDelay;
	}
}
#endregion

#region ConstantDamage
function ConstantDamage(damage,delay)
{
	// heat 0.25 dmg per frame
	// lava 0.5 dmg per frame
	// acid 1.5 dmg per frame
	
	if(constantDamageDelay <= 0)
	{
		if(damage >= energy)
		{
			energy = max(energy - damage, 0);
			state = State.Death;
		}
		else
		{
			energy = max(energy - damage, 0);
		}
		constantDamageDelay = delay;
	}
	constantDamageDelay = max(constantDamageDelay - 1,0);
}
#endregion

#region ArmPos
function ArmPos(px, py)
{
	armOffsetX = px;
	armOffsetY = py;
}
#endregion
#region SetArmPosStand
function SetArmPosStand()
{
	switch scr_round(aimFrame)
	{
		case -4:
		{
			ArmPos((8+(dir == -1))*dir, 19);
			if(recoilCounter > 0)
			{
				armOffsetY -= 1;
			}
			break;
		}
		case -3:
		{
			ArmPos((13+(3*(dir == -1)))*dir, 14+(2*(dir == -1)));
			break;
		}
		case -2:
		{
			ArmPos(20*dir,10);
			if(recoilCounter > 0)
			{
				armOffsetX -= 1*dir;
				armOffsetY -= 1;
			}
			break;
		}
		case -1:
		{
			ArmPos(19*dir, 4 + (dir == -1));
			break;
		}
		case 1:
		{
			ArmPos((20 - (2*(dir == -1)))*dir, -(15 - (2*(dir == -1))));
			break;
		}
		case 2:
		{
			ArmPos(21*dir, -(21 + (dir == -1)));
			if(recoilCounter > 0)
			{
				armOffsetX -= 1*dir;
				armOffsetY += 1;
			}
			break;
		}
		case 3:
		{
			ArmPos(13*dir,-(26 + (dir == -1)));
			break;
		}
		case 4:
		{
			ArmPos(2*dir, -28);
			if(recoilCounter > 0)
			{
				armOffsetY += 1;
			}
			break;
		}
		default:
		{
			ArmPos(15*dir,1);
			if(recoilCounter > 0)
			{
				armOffsetX -= 1*dir;
			}
			break;
		}
	}
}
#endregion
#region SetArmPosJump
function SetArmPosJump()
{
	switch scr_round(aimFrame)
	{
	    case -4:
	    {
	        ArmPos((7+(dir == -1))*dir, 19);
	        if(recoilCounter > 0)
	        {
	            armOffsetY -= 1;
	        }
	        break;
	    }
	    case -3:
	    {
	        ArmPos((13+(dir == -1))*dir, 14);
	        break;
	    }
	    case -2:
	    {
	        ArmPos(18*dir,8);
	        if(recoilCounter > 0 && stateFrame != State.Walk && stateFrame != State.Run)
	        {
	            armOffsetX -= 1*dir;
	            armOffsetY -= 1;
	        }
	        break;
	    }
	    case -1:
	    {
	        ArmPos(17*dir, 5);
	        break;
	    }
	    case 1:
	    {
	        ArmPos(18*dir, -13);
	        break;
	    }
	    case 2:
	    {
	        ArmPos(17*dir, -20);
	        if(recoilCounter > 0 && stateFrame != State.Walk && stateFrame != State.Run)
	        {
	            armOffsetX -= 1*dir;
	            armOffsetY += 1;
	        }
	        break;
	    }
	    case 3:
	    {
	        ArmPos((11+(2*(dir == -1)))*dir,-(26+(dir == -1)));
	        break;
	    }
	    case 4:
	    {
	        ArmPos(2*dir, -28);
	        if(recoilCounter > 0)
	        {
	            armOffsetY += 1;
	        }
	        break;
	    }
	    default:
	    {
	        ArmPos(15*dir,1);
	        if(recoilCounter > 0)
	        {
	            armOffsetX -= 1*dir;
	        }
	        break;
	    }
	}
}
#endregion
#region SetArmPosTrans
function SetArmPosTrans()
{
	switch scr_round(aimFrame)
	{
	    case -2:
	    {
	        ArmPos(19*dir,8+(dir == -1));
	        break;
	    }
	    case 2:
	    {
	        ArmPos((20 - (dir == -1))*dir, -21);
	        break;
	    }
	    default:
	    {
	        SetArmPosJump();
	        break;
	    }
	}
}
#endregion
#region SetArmPosGrip (old)
/*function SetArmPosGrip()
{
	switch scr_round(gripAimFrame)
	{
	    case 1:
	    {
	        ArmPos(-(18 + 2*(gripFrame >= 2) + gripFrame)*dir, 13 + (gripFrame >= 3));
	        if(dir == -1)
	        {
	            ArmPos(-(18 + clamp(gripFrame-1,0,1))*dir, 13 + clamp(gripFrame-1,0,2));
	        }
	        break;
	    }
	    case 2:
	    {
	        ArmPos(-(23 + (gripFrame >= 1) + gripFrame)*dir, 9);
	        if(dir == -1)
	        {
	            ArmPos(-(23 + clamp(gripFrame-1,0,2))*dir,9 + (gripFrame >= 3));
	        }
	        armOffsetX += (recoilCounter > 0 && gripFrame >= 3)*dir;
	        armOffsetY -= (recoilCounter > 0 && gripFrame >= 3);
	        break;
	    }
	    case 3:
	    {
	        ArmPos(-(26 + (gripFrame >= 1) + 3*(gripFrame >= 2))*dir, 1);
	        if(dir == -1)
	        {
	            ArmPos(-(27 + clamp(gripFrame-1,0,2))*dir, 1);
	        }
	        break;
	    }
	    case 4:
	    {
	        ArmPos(-(26 + gripFrame + (gripFrame >= 2))*dir,-(5 + (gripFrame >= 2)));
	        if(dir == -1)
	        {
	            ArmPos(-(28 + 2*clamp(gripFrame-1,0,2))*dir,-(6 + 2*(gripFrame >= 2)));
	        }
	        armOffsetX += (recoilCounter > 0 && gripFrame >= 3)*dir;
	        break;
	    }
	    case 5:
	    {
	        ArmPos(-(27+ gripFrame)*dir, -(16));
	        if(dir == -1)
	        {
	            ArmPos(-(28 + clamp(gripFrame-1,0,2))*dir, -(17 + (gripFrame >= 3)));
	        }
	        break;
	    }
	    case 6:
	    {
	        ArmPos(-(24+gripFrame)*dir, -21);
	        if(dir == -1)
	        {
	            ArmPos(-(24 + clamp(gripFrame-1,0,2))*dir, -21);
	        }
	        armOffsetX += (recoilCounter > 0 && gripFrame >= 3)*dir;
	        armOffsetY += (recoilCounter > 0 && gripFrame >= 3);
	        break;
	    }
	    case 7:
	    {
	        ArmPos(-(20 + gripFrame)*dir,-(27 + (gripFrame >= 3)));
	        if(dir == -1)
	        {
	            ArmPos(-(21 + clamp(gripFrame-1,0,2))*dir,-(27 + (gripFrame >= 3)));
	        }
	        break;
	    }
	    case 8:
	    {
	        ArmPos(-(10 + (gripFrame >= 1) + (gripFrame >= 3))*dir, -(30 + (gripFrame >= 2)));
	        if(dir == -1)
	        {
	            ArmPos(-(11 + (gripFrame >= 2))*dir, -(30 + (gripFrame >= 3)));
	        }
	        armOffsetY += (recoilCounter > 0 && gripFrame >= 3);
	        break;
	    }
	    default:
	    {
	        ArmPos(-(8+gripFrame)*dir, 15+clamp(gripFrame-1,0,2));
	        if(dir == -1)
	        {
	            ArmPos(-(9 + (gripFrame >= 2))*dir, 15 + gripFrame);
	        }
	        armOffsetY -= (recoilCounter > 0 && gripFrame >= 3);
	        break;
	    }
	}
}*/
#endregion
#region SetArmPosGrip
function SetArmPosGrip()
{
	if(gripFrame < 3)
	{
		switch scr_round(gripFrame)
		{
			case 0:
			{
				ArmPos(-1*dir,9);
				break;
			}
			case 1:
			{
				ArmPos(-5*dir,12);
				break;
			}
			case 2:
			{
				ArmPos(-6*dir,12);
				break;
			}
		}
	}
	else
	{
		switch scr_round(gripAimFrame)
		{
		    default:
		    {
		        ArmPos(-11, 17);
		        if(dir == -1)
		        {
		            ArmPos(10, 18);
		        }
		        armOffsetY -= (recoilCounter > 0);
		        break;
		    }
		    case 1:
		    {
		        ArmPos(-21, 14);
		        if(dir == -1)
		        {
		            ArmPos(18, 15);
		        }
		        break;
		    }
		    case 2:
		    {
		        ArmPos(-27, 9);
		        if(dir == -1)
		        {
		            ArmPos(25,10);
		        }
		        armOffsetX += (recoilCounter > 0)*dir;
		        armOffsetY -= (recoilCounter > 0);
		        break;
		    }
		    case 3:
		    {
		        ArmPos(-30, 1);
		        if(dir == -1)
		        {
		            ArmPos(29, 1);
		        }
		        break;
		    }
		    case 4:
		    {
		        ArmPos(-30,-6);
		        if(dir == -1)
		        {
		            ArmPos(32,-8);
		        }
		        armOffsetX += (recoilCounter > 0)*dir;
		        break;
		    }
		    case 5:
		    {
		        ArmPos(-30, -16);
		        if(dir == -1)
		        {
		            ArmPos(30, -18);
		        }
		        break;
		    }
		    case 6:
		    {
		        ArmPos(-27, -21);
		        if(dir == -1)
		        {
		            ArmPos(26, -21);
		        }
		        armOffsetX += (recoilCounter > 0)*dir;
		        armOffsetY += (recoilCounter > 0);
		        break;
		    }
		    case 7:
		    {
		        ArmPos(-23,-28);
		        if(dir == -1)
		        {
		            ArmPos(23,-28);
		        }
		        break;
		    }
		    case 8:
		    {
		        ArmPos(-12, -31);
		        if(dir == -1)
		        {
		            ArmPos(12, -31);
		        }
		        armOffsetY += (recoilCounter > 0);
		        break;
		    }
		}
	}
}
#endregion
#region SetArmPosClimb
function SetArmPosClimb()
{
	switch (climbFrame)
	{
	    case 0:
	    {
	        ArmPos(5*dir,7);
	        break;
	    }
	    case 1:
	    {
	        ArmPos(5*dir,10);
	        break;
	    }
	    case 2:
	    {
	        ArmPos(7*dir,13);
	        break;
	    }
	    case 3:
	    {
	        ArmPos(9*dir,16);
	        break;
	    }
	    case 4:
	    {
	        ArmPos(9*dir,17);
	        break;
	    }
	    case 5:
	    {
	        ArmPos(8*dir,17);
	        break;
	    }
	    case 6:
	    {
	        ArmPos(7*dir,20);
	        break;
	    }
	    case 7:
	    {
	        ArmPos(7*dir,20);
	        break;
	    }
	    case 8:
	    {
	        ArmPos(8*dir,19);
	        break;
	    }
	    case 9:
	    {
	        ArmPos(9*dir,16);
	        break;
	    }
	    case 10:
	    {
	        ArmPos(9*dir,13);
	        break;
	    }
	    case 11:
	    {
	        ArmPos(15*dir,5);
	        break;
	    }
	}
}
#endregion
#region SetArmPosSpark
function SetArmPosSpark(rotation)
{
	armOffsetX = -9 * dsin(22.5 * max(bodyFrame-1,0));
	armOffsetY = 3;
	
	armOffsetX = lengthdir_x(armOffsetX,rotation);
	armOffsetY = lengthdir_y(armOffsetY,rotation);
}
#endregion
#region SetArmPosSomersault
function SetArmPosSomersault(sFrameMax, degNum, frame6)
{
	var rotPos = -((360/(sFrameMax-2)) * max(frame6-2,0) + degNum);
	switch bodyFrame
	{
		case 0:
		{
			ArmPos(2*dir,7);
			break;
		}
		case 1:
		{
			ArmPos(6*dir,10);
			break;
		}
		default:
		{
			ArmPos(lengthdir_x(10*dir,rotPos),lengthdir_y(10,rotPos));
			break;
		}
	}
}
#endregion

#region PreDrawPlayer
function PreDrawPlayer(xx, yy, rot, alpha)
{
	/*if(stateFrame == State.Morph)
	{
		if(state == State.Morph && morphFrame <= 0 && spiderBall)
		{
			spiderGlowAlpha += 0.02 * spiderGlowNum * (!global.gamePaused);
			if(spiderGlowAlpha <= 0.1)
			{
				spiderGlowNum = max(spiderGlowNum,1);
			}
			if(spiderGlowAlpha >= 0.75)
			{
				spiderGlowNum = -1;
			}
		}
		else
		{
			spiderGlowAlpha = max(spiderGlowAlpha - (0.1*(!global.gamePaused)), 0);
			spiderGlowNum = 2;
		}
		if(spiderGlowAlpha > 0)
		{
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprt_SpiderBallFX,0,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,rot,c_white,min(spiderGlowAlpha,0.5)*alpha);
			gpu_set_blendmode(bm_normal);
		}
	}
	else
	{
		spiderGlowAlpha = 0;
		spiderGlowNum = 2;
	}*/
	
	if(cBubbleScale > 0)
	{
		if(!global.gamePaused)
		{
			cBubblePal = scr_wrap(cBubblePal-0.1,0,7);
		}
		
		pal_swap_set(pal_CrystalBubble,cBubblePal,0,0,false);
		draw_sprite_ext(sprt_CrystalBubble,0,scr_round(xx),scr_round(yy),cBubbleScale,cBubbleScale,0,c_white,alpha);
		shader_reset();
	}
	else
	{
		cBubblePal = 0;
	}
}
#endregion
#region DrawPlayer
function DrawPlayer(posX, posY, rotation, alpha)
{
	if(surface_exists(playerSurf))
	{
		surface_set_target(playerSurf);
		draw_clear_alpha(c_black,0);
		if(stateFrame != State.Morph || morphFrame > 0 || morphAlpha < 1)
		{
			var torso = torsoR;
			if(fDir == -1)
			{
				torso = torsoL;
			}
		
			if(legs != -1)
			{
				draw_sprite_ext(legs,legFrame,scr_round(surfW/2),scr_round(surfH/2),fDir,1,0,c_white,1);
			}
			draw_sprite_ext(torso,bodyFrame,scr_round(surfW/2),scr_round(surfH/2 + runYOffset),fDir,1,0,c_white,1);
		}
		if(stateFrame == State.Morph)
		{
			if(!global.gamePaused)
			{
				/*if(unmorphing)
				{
					morphAlpha = max(morphAlpha - 0.175/(1+liquidMovement), 0);
				}
				else if(morphFrame < 6)
				{
					morphAlpha = min(morphAlpha + 0.075/(1+liquidMovement), 1);
				}*/
				if(morphFrame < 4)
				{
					if(unmorphing)
					{
						morphAlpha = 0;
					}
					else
					{
						morphAlpha = 1;
					}
				}
			}
			var ballSprtIndex = sprt_MorphBall;
			//if(misc[Misc.Spring])
			if(misc[Misc.Spider])
			{
				ballSprtIndex = sprt_SpringBall;
			}
			draw_sprite_ext(ballSprtIndex,ballFrame,scr_round(surfW/2),scr_round(surfH/2),1,1,0,c_white,morphAlpha);
			//if(misc[Misc.Spring])
			if(misc[Misc.Spider])
			{
				draw_sprite_ext(sprt_SpringBall_Shine,0,scr_round(surfW/2),scr_round(surfH/2),1,1,0,c_white,morphAlpha);
			}
		}
	
		if(itemSelected == 1 && (itemHighlighted[1] == 0 || itemHighlighted[1] == 1 || itemHighlighted[1] == 3))
		{
			missileArmFrame = min(missileArmFrame + 1, 4);
		}
		else
		{
			missileArmFrame = max(missileArmFrame - 1, 0);
		}
		
		if(drawMissileArm && missileArmFrame > 0)
		{
			draw_sprite_ext(sprt_MissileArm,finalArmFrame+(9*(missileArmFrame-1)),scr_round((surfW/2)+scr_round(armOffsetX)),scr_round((surfH/2 + runYOffset)+scr_round(armOffsetY)),armDir,1,0,c_white,1);
		}
		if(!drawMissileArm)
		{
			missileArmFrame = 0;
		}
	
		if(stateFrame == State.Grip && climbIndex <= 0 && gripAimFrame == 0 && dir == -1 && dirFrame == -4)
		{
			draw_sprite_ext(sprt_ArmGripOverlay,gripFrame,scr_round(surfW/2),scr_round(surfH/2 + runYOffset),fDir,1,0,c_white,1);
		}
	
		surface_reset_target();
	
		if(dmgFlash <= 0 && immuneTime > 0 && (immuneTime&1))
		{
			gpu_set_blendmode(bm_add);
		}
		else
		{
			gpu_set_blendmode(bm_normal);
		}
		var sc = dcos(rotation),
			ss = dsin(rotation),
			sx = (surfW/2),
			sy = (surfH/2);
		var sxx = scr_round(posX)-sc*sx-ss*sy,
			syy = scr_round(posY)-sc*sy+ss*sx;
		draw_surface_ext(playerSurf,sxx+sprtOffsetX,syy+sprtOffsetY,1,1,rotation,c_white,alpha);
		gpu_set_blendmode(bm_normal);
	}
	else
	{
		playerSurf = surface_create(surfW,surfH);
		surface_set_target(playerSurf);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}
#endregion
#region PostDrawPlayer
function PostDrawPlayer(posX, posY, rot, alph)
{
	var xx = scr_round(posX),
		yy = scr_round(posY);
	
	if(introAnimState != -1)
	{
		introAnimFrameCounter++;
		if(introAnimFrameCounter > 3+(introAnimCounter >= 220))
		{
			if(introAnimCounter < 220)
			{
				introAnimFrame = scr_wrap(introAnimFrame+1,0,3);
				introAnimFrameCounter = 0;
			}
			else if(introAnimCounter < 286)
			{
				if(introAnimFrame < 8)
				{
					introAnimFrame = clamp(introAnimFrame+1,3,8);
					introAnimFrameCounter = 0;
				}
			}
			else if(introAnimFrame < 10)
			{
				introAnimFrame = clamp(introAnimFrame+1,9,10);
				introAnimFrameCounter = 0;
			}
		}
		
		if(introAnimFrameCounter < 2)
		{
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprt_IntroFX,introAnimFrame,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,0,make_color_rgb(0,255,114),alph);
			gpu_set_blendmode(bm_normal);
		}
	}
	else
	{
		introAnimFrame = 0;
		introAnimFrameCounter = 0;
	}

	//if(misc[Misc.Spring] && stateFrame == State.Morph)
	if(misc[Misc.Spider] && stateFrame == State.Morph)
	{
		var glowSpeed = 0.25;
		if(state == State.BallSpark || speedBoost)
		{
			glowSpeed = 0.375;
		}
		//else if(shineCharge > 0)
		//{
		//	glowSpeed = -0.45;
		//}
		var palSet = pal_BallGlow;
		if(suit[0])
		{
			palSet = pal_BallGlow_Varia;
		}
		if(suit[1])
		{
			palSet = pal_BallGlow_Gravity;
		}
		if(global.roomTrans)
		{
			glowSpeed *= 0.5;
		}
		else if(global.gamePaused)
		{
			glowSpeed = 0;
		}
		ballGlowIndex = scr_wrap(ballGlowIndex + glowSpeed, 1, 10);
		
		var spiderPal = 9+ballGlowIndex;//11;
		var spiderPalDiff = 0;
		if(spiderBall)
		{
			spiderPalDiff = 1;//1-clamp(spiderGlowAlpha,0,1);
		}
		
		pal_swap_set(palSet,ballGlowIndex,spiderPal,spiderPalDiff,false);
		draw_sprite_ext(sprt_SpringBall_Glow,ballFrame,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,rot,c_white,morphAlpha*alph);
		shader_reset();
	}
	else
	{
		ballGlowIndex = 1;
	}
	
	if(stateFrame == State.Morph)
	{
		if((state == State.Morph || state == State.BallSpark) && morphFrame <= 0 && spiderBall)
		{
			var minGlow = 0.1,
				maxGlow = 0.75;
			if(speedBoost)
			{
				minGlow = 0.35;
				maxGlow = 1;
			}
			spiderGlowAlpha += 0.02 * spiderGlowNum * (!global.gamePaused);
			if(spiderGlowAlpha <= minGlow)
			{
				spiderGlowNum = max(spiderGlowNum,1);
			}
			if(spiderGlowAlpha >= maxGlow)
			{
				spiderGlowNum = -1;
			}
		}
		else
		{
			spiderGlowAlpha = max(spiderGlowAlpha - (0.1*(!global.gamePaused)), 0);
			spiderGlowNum = 2;
		}
		if(spiderGlowAlpha > 0)
		{
			var maxGlow2 = 0.5;
			if(speedBoost)
			{
				maxGlow2 = 0.75;
			}
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprt_SpiderBallFX,0,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,rot,c_white,min(spiderGlowAlpha,maxGlow2)*alph);
			gpu_set_blendmode(bm_normal);
		}
	}
	else
	{
		spiderGlowAlpha = 0;
		spiderGlowNum = 2;
	}
	
	if(state == State.Dodge)
	{
		if(shineFrame < 4)
		{
			var offset = 6*dodgeDir;
			if(dodgeDir == -dir)
			{
				offset = 0;
			}
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprt_ShineSparkFX,shineFrame,xx+offset+sprtOffsetX,yy+sprtOffsetY,dodgeDir,1,0,c_lime,alph*0.75);
			gpu_set_blendmode(bm_normal);
			shineFrameCounter += 1*(!global.gamePaused);
			if(shineFrameCounter >= 2)
			{
				shineFrame++;
				shineFrameCounter = 0;
			}
		}
	}
	else if(state == State.Spark && shineStart <= 0 && shineEnd <= 0)
	{
		shineFrameCounter += 1*(!global.gamePaused);
		if(shineFrameCounter >= 2+(shineFrame == 0))
		{
			shineFrame = scr_wrap(shineFrame+1,0,3);
			shineFrameCounter = 0;
		}
		var sFrame = shineFrame;
		var shineRot = 90 - 45*shineDir;
		var len = 6;
		var shineX = scr_round(xx + lengthdir_x(len,shineRot)),
			shineY = scr_round(yy + lengthdir_y(len,shineRot));
		if(abs(shineDir) == 1 || abs(shineDir) == 3)
		{
			sFrame += 4;
			shineRot -= 45*dir;
		}
		if(dir == -1)
		{
			shineRot -= 180;
		}
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sprt_ShineSparkFX,sFrame,shineX+sprtOffsetX,shineY+sprtOffsetY,dir,1,shineRot,c_white,alph*0.9);
		gpu_set_blendmode(bm_normal);
	}
	else
	{
		shineFrame = 0;
		shineFrameCounter = 0;
	}

	if(isScrewAttacking && frame[Frame.Somersault] >= 2 && !canWallJump && wjFrame <= 0)
	{
		screwFrameCounter += 1*(!global.gamePaused);
		if(screwFrameCounter >= 2)
		{
			screwFrame = scr_wrap(screwFrame+1,0,3);
			screwFrameCounter = 0;
		}
		var a = 0.9;
		if(screwFrameCounter mod 2 != 0)
		{
			a = 0.5;
		}
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sprt_ScrewAttackFX,screwFrame,xx,yy,dir,1,0,make_color_rgb(0,255,114),alph*a);
		gpu_set_blendmode(bm_normal);
	}
	else
	{
		screwFrame = 0;
		screwFrameCounter = 0;
	}
	
	if(itemSelected == 1 && itemHighlighted[1] == 3 && item[Item.Grapple] && state != State.Morph && morphFrame <= 0 && instance_exists(grapple) && state != State.Somersault)
	{
	    var sPosX = xx+sprtOffsetX+armOffsetX,
	        sPosY = yy+sprtOffsetY+runYOffset+armOffsetY;

	    var gx = scr_round(sPosX),
	        gy = scr_round(sPosY);
	    draw_sprite_ext(sprt_GrappleBeamStart,grapPartFrame,gx,gy,1,1,0,c_white,1);
	    //part_particles_create(obj_Particles.partSystemB,gx,gy,obj_Particles.PartBeam[3],1);
	    //part_particles_create(obj_Particles.partSystemB,gx,gy,obj_Particles.PartBeam[2],1);

	    if(grapple.drawGrapDelay <= 0)
	    {
	        var sprt = sprt_GrappleBeamChain,
	            startX = scr_round(sPosX),
	            startY = scr_round(sPosY),
	            endX = scr_round(xx + (grapple.x - obj_Player.x)),
	            endY = scr_round(yy + (grapple.y - obj_Player.y));
    
	        var linklength = sprite_get_width(sprt),
	            chainX = endX - startX,
	            chainY = endY - startY;
    
	        var length = point_distance(startX, startY, endX, endY);
	        if(length >= linklength)
	        {
	            var numlinks = ceil(length/linklength);
	            linksX[numlinks] = 0;
	            linksY[numlinks] = 0;
	            var rotation2 = point_direction(startX, startY, endX, endY);
				rotation2 = scr_round(rotation2/2.8125)*2.8125;
    
	            for(var i = 1; i < numlinks+1; i++)
	            {
	                linksX[i] = startX + chainX/numlinks * i;
	                linksY[i] = startY + chainY/numlinks * i;
                
	                draw_sprite_ext(sprt,random_range(0,3),linksX[i],linksY[i],image_xscale,image_yscale,rotation2,c_white,1);
	            }
	        }
	        /*var rotation2 = point_direction(startX, startY, endX, endY);
	        grappleBeamFrame = scr_Loop(grappleBeamFrame+1,0,5);

	        draw_set_blend_mode(bm_add);
	        draw_sprite_ext(sprt_GrappleBeam,grappleBeamFrame,startX,startY,length/192,0.275,rotation2,c_white,.9);
	        draw_sprite_ext(sprt_GrappleBeamGlow,grappleBeamFrame,startX,startY,length/192,0.3, rotation2, make_color_rgb(32,128,255),.9);
	        draw_set_blend_mode(bm_normal);*/
	    }
	    if(grapPartCounter > 1)
	    {
	        grapPartFrame = scr_wrap(grapPartFrame+1,0,2);
	        grapPartCounter = 0;
	    }
	    grapPartCounter += 1;
	}
	/*else if(hyperBeam && hyperFired > 0)
	{
		var hyperFFrame = (hyperFired-11) / 11;
		var hyperFiredFrame = 5 - (5 * hyperFFrame*hyperFFrame);
		
		if(hyperFiredFrame >= 0)
		{
			pal_swap_set(sprt_HyperBeamPalette,1+obj_Main.hyperRainbowCycle,0,0,false);
			draw_sprite_ext(sprt_HyperBeamStartParticle,hyperFiredFrame,scr_round(xx+sprtOffsetX+armOffsetX),scr_round(yy+sprtOffsetY+runYOffset+armOffsetY),image_xscale,image_yscale,0,c_white,alph);
			shader_reset();
		}*/
		/*hyperFiredFrameCounter++;
		if(hyperFiredFrameCounter > 1)
		{
			hyperFiredFrame++;
			hyperFiredFrameCounter = 0;
		}
		
		if(hyperFiredFrame <= 5)
		{
			pal_swap_set(sprt_HyperBeamPalette,1+obj_Main.hyperRainbowCycle,0,0,false);
			draw_sprite_ext(sprt_HyperBeamStartParticle,hyperFiredFrame,scr_round(xx+sprtOffsetX+armOffsetX),scr_round(yy+sprtOffsetY+runYOffset+armOffsetY),image_xscale,image_yscale,0,c_white,alph);
			shader_reset();
		}
		
		if(hyperFired >= 21)
		{
			hyperFiredFrame = 0;
			hyperFiredFrameCounter = 0;
		}
	}*/
	else
	{
		particleFrameMax = floor((maxCharge - statCharge) / 10);
		if(statCharge >= 10)
		{
			if(!global.gamePaused)
			{
				chargeFrameCounter += 1;
				if(chargeFrameCounter == 1 || chargeFrameCounter == 3)
				{
					particleFrame++;
				}
				if(chargeFrameCounter > 1)
				{
					chargeFrame++;
					chargeFrameCounter = 0;
				}
			}
			chargeSetFrame = 0;
			if(statCharge >= maxCharge*0.25 && statCharge < maxCharge*0.5)
			{
				chargeSetFrame = 1;
			}
			if(statCharge >= maxCharge*0.5 && statCharge < maxCharge*0.75)
			{
				chargeSetFrame = 2;
			}
			if(statCharge >= maxCharge*0.75 && statCharge < maxCharge)
			{
				chargeSetFrame = 3;
			}
			if(statCharge >= maxCharge)
			{
				chargeSetFrame = 4;
			}
	
			if(chargeFrame >= 2)
			{
				chargeFrame = 0;
			}
			chargeSetFrame += chargeFrame;
	
			var isIce = (beamChargeAnim == sprt_IceBeamChargeAnim),
				isWave = (beamChargeAnim == sprt_WaveBeamChargeAnim),
				isSpazer = (beamChargeAnim == sprt_SpazerChargeAnim),
				isPlasma = (beamChargeAnim == sprt_PlasmaBeamChargeAnim);
	
			var partSys = obj_Particles.partSystemB;
			if(string_count("Wave",object_get_name(beamShot)) > 0)
			{
				partSys = obj_Particles.partSystemA;
			}
			if(particleFrame >= particleFrameMax && !global.roomTrans && !global.gamePaused)
			{
				var color1 = c_red, color2 = c_yellow;
				var partType = 0;
				if(isIce)
				{
					color1 = c_blue;
					color2 = c_aqua;
					partType = 1;
				}
				else if(isWave)
				{
					color1 = c_purple;
					color2 = c_fuchsia;
					partType = 2;
				}
				else if(isSpazer)
				{
					color1 = c_red;
					color2 = c_yellow;
					partType = 3;
				}
				else if(isPlasma)
				{
					color1 = c_green;
					color2 = c_lime;
					partType = 4;
				}
		
				var partRange = 24;
				var pX = xx+sprtOffsetX+armOffsetX, pY = yy+sprtOffsetY+runYOffset+armOffsetY;
				var part = instance_create_layer(pX+random_range(-partRange,partRange),pY+random_range(-partRange,partRange),"Player",obj_ChargeParticle);
				part.color1 = color1;
				part.color2 = color2;
		
				var x1 = pX-8,
					x2 = pX+8,
					y1 = pY-8,
					y2 = pY+8;
				chargeEmit = part_emitter_create(partSys);
				part_emitter_region(partSys,chargeEmit,x1,x2,y1,y2,ps_shape_ellipse,ps_distr_gaussian);
				part_emitter_burst(partSys,chargeEmit,obj_Particles.bTrails[partType],2+(statCharge >= maxCharge));
		
				particleFrame = 0;
			}
			else if(part_emitter_exists(partSys,chargeEmit))
			{
				part_emitter_destroy(partSys,chargeEmit);
			}
			if(stateFrame != State.Morph)
			{
				draw_sprite_ext(beamChargeAnim,chargeSetFrame,xx+sprtOffsetX+armOffsetX,yy+sprtOffsetY+runYOffset+armOffsetY,image_xscale,image_yscale,0,c_white,alph);
				var blend = make_color_rgb(230,120,32);
	            if(isIce)
	            {
	                blend = make_color_rgb(16,148,255);
	            }
	            else if(isWave)
	            {
	                blend = make_color_rgb(210,32,180);
	            }
	            else if(isPlasma)
	            {
	                blend = make_color_rgb(32,176,16);
	            }
	            gpu_set_blendmode(bm_add);
	            draw_sprite_ext(sprt_ChargeAnimGlow,chargeSetFrame,scr_round(xx+sprtOffsetX+armOffsetX),scr_round(yy+sprtOffsetY+runYOffset+armOffsetY),image_xscale,image_yscale,0,blend,alph*0.5);
	            gpu_set_blendmode(bm_normal);
			}
		}
		else
		{
			chargeSetFrame = 0;
			chargeFrame = 0;
			chargeFrameCounter = 0;
			particleFrame = 0;
		}
		
		//hyperFiredFrame = 0;
		//hyperFiredFrameCounter = 0;
	}
}
#endregion