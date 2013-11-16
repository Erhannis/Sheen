//
//  TitlePageScene.m
//  Sheen
//
//  Created by Matthew Ewer on 11/15/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "TitlePageScene.h"
#import "Mote.h"
#import "Drop.h"
#import "MathUtils.h"

@interface TitlePageScene ()
@property (strong, nonatomic) NSMutableArray *motes; // of Mote
@property (strong, nonatomic) AVAudioPlayer *player;
@end

@implementation TitlePageScene

#define BG_COLOR_RED     (0x00 / 255.0)
#define BG_COLOR_GREEN   (0x20 / 255.0)
#define BG_COLOR_BLUE    (0x60 / 255.0)
#define BG_COLOR_ALPHA   (0xFF / 255.0)

#define CAMERA_HEIGHT (40.0)

#define MOTE_COUNT (200)
#define MOTE_MIN_RADIUS (10.0)
#define MOTE_MAX_RADIUS (20.0)
#define MOTE_MIN_HEIGHT (-400.0)
#define MOTE_MAX_HEIGHT (30.0)
#define MOTE_BASE_VELOCITY (20)

#define SIDE_SPACE (0.1)

- (NSMutableArray *)motes
{
    if (!_motes) _motes = [[NSMutableArray alloc] init];
    return _motes;
}

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
        //start a background sound
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"_ghost_-_Reverie_(small_theme)" ofType: @"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        self.player.numberOfLoops = -1; //infinite loop
        [self.player play];
        
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
    }
    
    return self;
}

- (void)update:(NSTimeInterval)currentTime
{
    for (Mote *mote in self.motes) {
        if (mote.position.x > (1 + SIDE_SPACE) * self.size.width ||
            mote.position.x < -SIDE_SPACE * self.size.width ||
            mote.position.y > (1 + SIDE_SPACE) * self.size.height ||
            mote.position.y < -SIDE_SPACE * self.size.height) {
            //TODO Change color and maybe height:velocity, to add to the illusion
            mote.position = CGPointMake([MathUtils mod:mote.position.x
                                               between:(-SIDE_SPACE * self.size.width)
                                                   and:((1 + SIDE_SPACE) * self.size.width)],
                                        [MathUtils mod:mote.position.y
                                               between:(-SIDE_SPACE * self.size.height)
                                                   and:((1 + SIDE_SPACE) * self.size.height)]);
        }
    }
}

@end
