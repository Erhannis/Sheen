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

@interface GamePageScene ()
@property (strong, nonatomic) NSMutableArray *motes; // of Mote
@property (strong, nonatomic) SKNode *focus;
@property (nonatomic) CGFloat xScaleTrue;
@property (nonatomic) CGFloat yScaleTrue;
@property (nonatomic) CGFloat lastWidth;
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
#define MOTE_MIN_HEIGHT (-20.0)
#define MOTE_MAX_HEIGHT (30.0)
#define MOTE_BASE_VELOCITY (20)

#define SIDE_SPACE (0.5)

- (NSMutableArray *)motes
{
    if (!_motes) _motes = [[NSMutableArray alloc] init];
    return _motes;
}

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
        self.lastWidth = size.width;
        self.scaleMode = SKSceneScaleModeResizeFill;
        self.backgroundColor = [SKColor colorWithRed:BG_COLOR_RED green:BG_COLOR_GREEN blue:BG_COLOR_BLUE alpha:BG_COLOR_ALPHA];
        
        //  Whoa!  SKBlendModeAdd is pretty!
        //  Screen similar
        //  SKBlendModeSubtract is kinda like negative world
        SKBlendMode blendMode = SKBlendModeAlpha;
        
        Drop *drop = [[Drop alloc] initWithImageNamed:@"drop-9-green"];
        drop.position = CGPointMake(CGRectGetMidX(self.frame),
                                    CGRectGetMidY(self.frame));
        drop.zPosition = 0.0;
        drop.blendMode = blendMode;
        [self addChild:drop];
        
        for (int i = 0; i < MOTE_COUNT; i++) {
            Mote *mote = [[Mote alloc] initWithImageNamed:@"mote-purple"];
            mote.radius = (drand48() * (MOTE_MAX_RADIUS - MOTE_MIN_RADIUS)) + MOTE_MIN_RADIUS;
            mote.zPosition = (drand48() * (MOTE_MAX_HEIGHT - MOTE_MIN_HEIGHT)) + MOTE_MIN_HEIGHT;
            CGFloat dist = CAMERA_HEIGHT - mote.zPosition;
            mote.scale = CAMERA_HEIGHT / dist;
            mote.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(mote.radius * mote.scale)];
            mote.size = CGSizeMake(mote.radius * mote.scale, mote.radius * mote.scale);
            mote.position = CGPointMake(((drand48() * (1 + 2*SIDE_SPACE)) - SIDE_SPACE) * size.width, ((drand48() * (1 + 2*SIDE_SPACE)) - SIDE_SPACE) * size.height);
            mote.physicsBody.affectedByGravity = NO;
            mote.physicsBody.friction = 0.0;
            mote.physicsBody.linearDamping = 0.0;
            mote.physicsBody.collisionBitMask = 0x0;
            mote.physicsBody.categoryBitMask = 0x0;
            mote.physicsBody.contactTestBitMask = 0x0;
            mote.physicsBody.velocity = CGVectorMake(mote.scale * MOTE_BASE_VELOCITY, -(mote.scale) * MOTE_BASE_VELOCITY);
            mote.blendMode = blendMode;
            [self.motes addObject:mote];
            [self addChild:mote];
        }
        [self scaleTo:0.75];
        self.focus = drop;//self.motes.firstObject;
        NSLog(@"anchor %f,%f", self.anchorPoint.x, self.anchorPoint.y);
    }

    return self;
}

- (void)scaleBy:(CGFloat)factor
{
    [self runAction:[SKAction scaleBy:factor duration:0]];
    self.xScaleTrue *= factor;
    self.yScaleTrue *= factor;
}

- (void)scaleTo:(CGFloat)scale
{
    [self runAction:[SKAction scaleTo:scale duration:0]];
    self.xScaleTrue = scale;
    self.yScaleTrue = scale;
}

- (void)update:(NSTimeInterval)currentTime
{
    //NSLog(@"size: %@", NSStringFromCGSize(self.view.frame.size));
    if (self.view.frame.size.width != self.lastWidth) {
        CGFloat screenScale = self.lastWidth / self.view.frame.size.width;
        [self scaleBy:screenScale];
        self.lastWidth = self.view.frame.size.width;
    }
    self.anchorPoint = CGPointMake((0.5 / self.xScaleTrue) - (self.xScaleTrue * self.focus.position.x / self.frame.size.width), (0.5 / self.yScaleTrue) - (self.yScaleTrue * self.focus.position.y / self.frame.size.height));
    //TODO Consider that user zooming in and out should not affect the wrapping of the motes,
    //         because they might notice that.
    CGRect viewport = CGRectMake(self.focus.position.x - ((1 + (2 * SIDE_SPACE)) * self.size.width / 2), self.focus.position.y - ((1 + (2 * SIDE_SPACE)) * self.size.height / 2), (1 + (2 * SIDE_SPACE)) * self.size.width, (1 + (2 * SIDE_SPACE)) * self.size.height);
    for (Mote *mote in self.motes) {
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
    }
}

- (void)didChangeSize:(CGSize)oldSize {
    NSLog(@"Changed size: %@", NSStringFromCGSize(self.size));
}

@end
