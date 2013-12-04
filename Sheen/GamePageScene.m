//
//  GamePageScene.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "GamePageScene.h"
#import "Mote.h"
#import "Drop.h"
#import "MathUtils.h"
#import "Debugging.h"
#import "OptionsManager.h"
#import "BeingNode.h"
#import "Player+Create.h"
#import "SpatialEntity+Create.h"
#import "Being+Create.h"
#import "Wall+Create.h"
#import "LevelInstance+Create.h"
#import "LevelTemplate+Create.h"
#import "Savegame+Create.h"

@interface GamePageScene ()
@property (strong, nonatomic) NSMutableArray *motes; // of Mote
@property (strong, nonatomic) NSMutableArray *beings; // of BeingNode
@property (strong, nonatomic) BeingNode *focus;
@property (nonatomic) CGFloat xScaleTrue;
@property (nonatomic) CGFloat yScaleTrue;
@property (nonatomic) CGFloat angleTrue;
@property (nonatomic) CGFloat lastWidth;
@property (strong, nonatomic) LevelInstance *levelInstance;
@property (strong, nonatomic) Player *player;
@end

@implementation GamePageScene

#define BG_COLOR_RED     (0x00 / 255.0)
#define BG_COLOR_GREEN   (0x20 / 255.0)
#define BG_COLOR_BLUE    (0x60 / 255.0)
#define BG_COLOR_ALPHA   (0xFF / 255.0)

#define CAMERA_HEIGHT (40.0)

#define MOTE_COUNT (200)
#define MOTE_MIN_RADIUS (10.0)
#define MOTE_MAX_RADIUS (20.0)
#define MOTE_MIN_HEIGHT (-200.0)
#define MOTE_MAX_HEIGHT (30.0)
#define MOTE_BASE_VELOCITY (0)
#define MOTE_MAX_VELOCITY (20)

#define PLAYER_VELOCITY_FACTOR (5)

#define SIDE_SPACE (1.0)
#define MIN_ZOOM (1/2.5)

- (NSMutableArray *)motes
{
    if (!_motes) _motes = [[NSMutableArray alloc] init];
    return _motes;
}

- (NSMutableArray *)beings
{
    if (!_beings) _beings = [[NSMutableArray alloc] init];
    return _beings;
}

- (id)initWithSize:(CGSize)size
     levelInstance:(LevelInstance *)levelInstance
         andPlayer:(Player *)player
{
    self = [super initWithSize:size];
    
    if (self) {
        //TODO Switch to new root node?
        
        [self loadLevelInstance:levelInstance andPlayer:player withViewSize:size];
    }

    return self;
}

- (void)addMotesWithViewSize:(CGSize)size
                andBlendMode:(SKBlendMode)blendMode
{
    UIImage *image = [UIImage imageNamed:@"mote-white"];
    SKTexture *white = [SKTexture textureWithCGImage:image.CGImage];
    
    for (int i = 0; i < MOTE_COUNT; i++) {
        Mote *mote = [[Mote alloc] initWithTexture:white
                                             color:[SKColor colorWithRed:drand48()
                                                                   green:drand48()
                                                                    blue:drand48()
                                                                   alpha:1]
                                              size:image.size];
        mote.colorBlendFactor = 1.0;
        mote.radius = (drand48() * (MOTE_MAX_RADIUS - MOTE_MIN_RADIUS)) + MOTE_MIN_RADIUS;
        mote.radius = 15.0;
        mote.zPosition = (drand48() * (MOTE_MAX_HEIGHT - MOTE_MIN_HEIGHT)) + MOTE_MIN_HEIGHT;
        CGFloat dist = CAMERA_HEIGHT - mote.zPosition;
        mote.scale = CAMERA_HEIGHT / dist;
        mote.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(mote.radius * mote.scale)];
        mote.size = CGSizeMake(mote.radius * mote.scale, mote.radius * mote.scale);
        mote.position = CGPointMake(((drand48() * (1 + 2*SIDE_SPACE)) - SIDE_SPACE) * size.width, ((drand48() * (1 + 2*SIDE_SPACE)) - SIDE_SPACE) * size.height);
        mote.lastPosition = mote.position;
        mote.physicsBody.affectedByGravity = NO;
        mote.physicsBody.friction = 0.0;
        mote.physicsBody.linearDamping = 0.0;
        mote.physicsBody.collisionBitMask = 0x0;
        mote.physicsBody.categoryBitMask = 0x0;
        mote.physicsBody.contactTestBitMask = 0x0;
        mote.physicsBody.velocity = CGVectorMake(mote.scale * ((drand48() - 0.5) * MOTE_MAX_VELOCITY + MOTE_BASE_VELOCITY), -(mote.scale) * ((drand48() - 0.5) * MOTE_MAX_VELOCITY + MOTE_BASE_VELOCITY));
        mote.blendMode = blendMode;
        [self.motes addObject:mote];
        [self addChild:mote];
    }
}

- (void)scaleBy:(CGFloat)factor
{
    __weak GamePageScene *weakself = self;
    //TODO This might leave open a loophole.
    if (self.xScaleTrue * factor >= MIN_ZOOM) {
        [self runAction:[SKAction scaleBy:factor duration:0] completion:^{
            weakself.xScaleTrue *= factor;
            weakself.yScaleTrue *= factor;
        }];
    }
}

- (void)scaleTo:(CGFloat)scale
{
    __weak GamePageScene *weakself = self;
    if (scale >= MIN_ZOOM) {
        [self runAction:[SKAction scaleTo:scale duration:0] completion:^{
            weakself.xScaleTrue = scale;
            weakself.yScaleTrue = scale;
        }];
    }
}

- (void)rotateTo:(CGFloat)angle
{
    __weak GamePageScene *weakself = self;
    [self runAction:[SKAction rotateToAngle:angle duration:0] completion:^{
        weakself.angleTrue = angle;
    }];
}

- (void)update:(NSTimeInterval)currentTime
{
}

- (void)didSimulatePhysics
{
    if (self.view.frame.size.width != self.lastWidth) {
        NSLog(@"resize: %f -> %f", self.lastWidth, self.view.frame.size.width);
        CGFloat screenScale = self.lastWidth / self.view.frame.size.width;
        [self scaleBy:screenScale];
        self.lastWidth = self.view.frame.size.width;
    }
    self.anchorPoint = CGPointMake((0.5 / self.xScaleTrue) - (self.xScaleTrue * self.focus.position.x / self.frame.size.width), (0.5 / self.yScaleTrue) - (self.yScaleTrue * self.focus.position.y / self.frame.size.height));
    CGRect viewport = CGRectMake(self.focus.position.x - ((1 + (2 * SIDE_SPACE)) * self.size.width / 2), self.focus.position.y - ((1 + (2 * SIDE_SPACE)) * self.size.height / 2), (1 + (2 * SIDE_SPACE)) * self.size.width, (1 + (2 * SIDE_SPACE)) * self.size.height);
    for (Mote *mote in self.motes) {
        mote.position = CGPointMake(mote.position.x + ((1 - mote.scale) * (self.focus.position.x - self.focus.lastPosition.x)), mote.position.y + ((1 - mote.scale) * (self.focus.position.y - self.focus.lastPosition.y)));
        if (mote.position.x > (viewport.origin.x + viewport.size.width) ||
            mote.position.x < viewport.origin.x ||
            mote.position.y > (viewport.origin.y + viewport.size.height) ||
            mote.position.y < viewport.origin.y) {
            //TODO Change color and maybe height:velocity, to add to the illusion
            mote.position = CGPointMake([MathUtils mod:mote.position.x
                                               between:(viewport.origin.x + viewport.size.width)
                                                   and:viewport.origin.x],
                                        [MathUtils mod:mote.position.y
                                               between:(viewport.origin.y + viewport.size.height)
                                                   and:viewport.origin.y]);
        }
        mote.lastPosition = mote.position;
    }
    self.focus.lastPosition = self.focus.position;
}

- (void)didChangeSize:(CGSize)oldSize {
    NSLog(@"Changed size: %@", NSStringFromCGSize(self.size));
}

- (void)didTap:(UITapGestureRecognizer *)sender {
    [sender locationInView:self.view];
    NSLog(@"recognized tap");
}

- (void)didPinch:(UIPinchGestureRecognizer *)sender {
    [self scaleBy:sender.scale];
    sender.scale = 1.0;
    NSLog(@"recognized pinch");
}

- (void)didRotation:(UIRotationGestureRecognizer *)sender {
    if ([OptionsManager sillyFeaturesMode]) {
        [self runAction:[SKAction rotateByAngle:sender.rotation
                                       duration:0]];
        sender.rotation = 0;
    }
}

- (void)didPan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint loc = [sender translationInView:self.view];
        loc = [self convertPointFromView:loc];
        CGPoint ploc = [self convertPointFromView:CGPointZero];
        CGVector velocity = CGVectorMake(PLAYER_VELOCITY_FACTOR * (ploc.x-loc.x), PLAYER_VELOCITY_FACTOR * (ploc.y - loc.y));
        self.focus.physicsBody.velocity = velocity;
        [sender setTranslation:CGPointZero inView:self.view];
    }
}

- (void)didLongPress:(UILongPressGestureRecognizer *)sender {
    NSLog(@"recognized long press");
}

- (void)updateDatabase
{
    //TODO Better to update rather than clear and re-add?
    [self.levelInstance removeBeings:self.levelInstance.beings];
    
    // Update beings
    for (BeingNode *being in self.beings) {
        Being *newBeing = [Being blankBeingInManagedObjectContext:self.levelInstance.managedObjectContext];
        newBeing.type = [NSNumber numberWithInt:BEING_TYPE_NPC]; //TODO Make better.
        newBeing.imageFilename = being.imageFilename;
        newBeing.levelInstance = self.levelInstance;
        newBeing.spatial = [SpatialEntity createFromSKNode:being
                                    inManagedObjectContext:self.levelInstance.managedObjectContext];
    }
    
    // Update player
    //TODO Fix.
//    self.player.curHealth = ;
//    self.player.maxHealth = ;
//    self.player.curWill = ;
//    self.player.maxWill = ;
//    self.player.exp = ;
//    self.player.savegame = ;
    self.player.spatial = [SpatialEntity createFromSKNode:self.focus
                                   inManagedObjectContext:self.player.managedObjectContext];
}

- (void)loadFromDatabase
{
    Savegame *savegame = [Savegame getAutosaveInManagedObjectContext:self.player.managedObjectContext];
    Player *player = savegame.player;
    LevelInstance *levelInstance = player.curLevel;
    [self loadLevelInstance:levelInstance andPlayer:player withViewSize:self.view.frame.size];
}

- (void)loadLevelInstance:(LevelInstance *)levelInstance
                andPlayer:(Player *)player
             withViewSize:(CGSize)size
{
    [self removeAllChildren];
    [self.beings removeAllObjects];
    [self.motes removeAllObjects];
    
    self.levelInstance = levelInstance;
    self.player = player;
    self.lastWidth = size.width;
    self.xScaleTrue = 1;
    self.yScaleTrue = 1;
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.backgroundColor = [SKColor colorWithRed:BG_COLOR_RED green:BG_COLOR_GREEN blue:BG_COLOR_BLUE alpha:BG_COLOR_ALPHA];
    
    //  Whoa!  SKBlendModeAdd is pretty!
    //  Screen similar
    //  SKBlendModeSubtract is kinda like negative world
    SKBlendMode blendMode = SKBlendModeAlpha;
    
    Drop *drop = [[Drop alloc] initWithImageNamed:@"drop-9-green"];
    drop.imageFilename = @"drop-9-green";
    drop.radius = drop.frame.size.width / 2;
    drop.position = CGPointMake(player.spatial.xPos.doubleValue, player.spatial.yPos.doubleValue);
    drop.lastPosition = drop.position;
    drop.zPosition = 0.0;
    drop.blendMode = blendMode;
    drop.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:drop.radius];
    drop.physicsBody.affectedByGravity = NO;
    drop.physicsBody.allowsRotation = NO;
    drop.physicsBody.velocity = CGVectorMake(player.spatial.xVelocity.doubleValue, player.spatial.yVelocity.doubleValue);
    [self addChild:drop];
    
    for (Being *being in levelInstance.beings) {
        Drop *d = [[Drop alloc] initWithImageNamed:being.imageFilename];
        d.imageFilename = being.imageFilename;
        d.radius = d.frame.size.width / 2;
        d.position = CGPointMake(being.spatial.xPos.doubleValue,
                                 being.spatial.yPos.doubleValue);
        d.lastPosition = d.position;
        d.zPosition = 0.0;
        d.blendMode = blendMode;
        d.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:d.radius];
        d.physicsBody.affectedByGravity = NO;
        d.physicsBody.allowsRotation = NO;
        d.physicsBody.velocity = CGVectorMake(being.spatial.xVelocity.doubleValue, being.spatial.yVelocity.doubleValue);
        [self.beings addObject:d];
        [self addChild:d];
    }
    
    [self addMotesWithViewSize:size
                  andBlendMode:blendMode];
    
    for (Wall *wall in levelInstance.template.walls) {
        SKShapeNode *wallNode = [[SKShapeNode alloc] init];
        wallNode.path = [Wall pathFromData:wall.shape];
        wallNode.position = CGPointMake(wall.location.xPos.doubleValue, wall.location.yPos.doubleValue);
        wallNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:wallNode.path];
        //TODO Consider allowing walls to have velocity.
        [self addChild:wallNode];
    }
    
    [self scaleTo:0.75];
    self.focus = drop;
    self.anchorPoint = CGPointMake((0.5 / self.xScaleTrue) - (self.xScaleTrue * self.focus.position.x / self.frame.size.width), (0.5 / self.yScaleTrue) - (self.yScaleTrue * self.focus.position.y / self.frame.size.height));
}

@end
