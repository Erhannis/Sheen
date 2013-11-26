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

@interface GamePageScene ()
@property (strong, nonatomic) NSMutableArray *motes; // of Mote
@property (strong, nonatomic) SKNode *focus;
@property (nonatomic) CGFloat xScaleTrue;
@property (nonatomic) CGFloat yScaleTrue;
@property (nonatomic) CGFloat angleTrue;
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

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
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
        drop.radius = drop.frame.size.width / 2;
        drop.position = CGPointMake(CGRectGetMidX(self.frame),
                                    CGRectGetMidY(self.frame));
        drop.lastPosition = drop.position;
        drop.zPosition = 0.0;
        drop.blendMode = blendMode;
        drop.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:drop.radius];
        drop.physicsBody.affectedByGravity = NO;
        drop.physicsBody.allowsRotation = NO;
        [self addChild:drop];
        
        for (NSString *img in @[@"drop-9-red", @"drop-9-green", @"drop-9-blue", @"drop-9-yellow", @"drop-9-cyan", @"drop-9-purple", @"drop-9-white", @"drop-9-black"]) {
            Drop *d = [[Drop alloc] initWithImageNamed:img];
            d.radius = d.frame.size.width / 2;
            d.position = CGPointMake(CGRectGetMidX(self.frame),
                                     CGRectGetMidY(self.frame));
            d.lastPosition = d.position;
            d.zPosition = 0.0;
            d.blendMode = blendMode;
            d.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:d.radius];
            d.physicsBody.affectedByGravity = NO;
            d.physicsBody.allowsRotation = NO;
            [self addChild:d];
        }
        
        UIImage *image = [UIImage imageNamed:@"mote-purple"];
        
        CIImage *ciImage = image.CIImage ? image.CIImage : [CIImage imageWithCGImage:image.CGImage];
        CGRect origExtent = ciImage.extent;
        CIFilter *filter;
        
        filter = [CIFilter filterWithName:@"CIColorMatrix"];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        [filter setValue:[CIVector vectorWithX:1 Y:0 Z:0 W:0] forKey:@"inputRVector"];
        [filter setValue:[CIVector vectorWithX:1 Y:0 Z:0 W:0] forKey:@"inputGVector"];
        [filter setValue:[CIVector vectorWithX:1 Y:0 Z:0 W:0] forKey:@"inputBVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:1] forKey:@"inputAVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBiasVector"];
        ciImage = [filter valueForKey:kCIOutputImageKey];

        ciImage = [ciImage imageByCroppingToRect:origExtent];
        CIImage *ciWhite = ciImage;
        CGImageRef cgir = [[CIContext contextWithOptions:@{}] createCGImage:ciImage fromRect:ciImage.extent];
        SKTexture *white = [SKTexture textureWithCGImage:cgir];
        
        filter = [CIFilter filterWithName:@"CIColorMatrix"];
        [filter setValue:ciWhite forKey:kCIInputImageKey];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputRVector"];
        [filter setValue:[CIVector vectorWithX:1 Y:0 Z:0 W:0] forKey:@"inputGVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:1] forKey:@"inputAVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBiasVector"];
        ciImage = [filter valueForKey:kCIOutputImageKey];
        
        ciImage = [ciImage imageByCroppingToRect:origExtent];
//        cgir = [[CIContext contextWithOptions:@{}] createCGImage:ciImage fromRect:ciImage.extent];
//        SKTexture *green = [SKTexture textureWithCGImage:cgir];

        filter = [CIFilter filterWithName:@"CIColorMatrix"];
        [filter setValue:ciWhite forKey:kCIInputImageKey];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputRVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputGVector"];
        [filter setValue:[CIVector vectorWithX:1 Y:0 Z:0 W:0] forKey:@"inputBVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:1] forKey:@"inputAVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBiasVector"];
        ciImage = [filter valueForKey:kCIOutputImageKey];
        
        ciImage = [ciImage imageByCroppingToRect:origExtent];
//        cgir = [[CIContext contextWithOptions:@{}] createCGImage:ciImage fromRect:ciImage.extent];
//        SKTexture *blue = [SKTexture textureWithCGImage:cgir];
        
//        NSArray *colors = @[red, green, blue];
        
        for (int i = 0; i < MOTE_COUNT; i++) {
//            int col = arc4random() % colors.count;
            Mote *mote = [[Mote alloc] initWithTexture:white
                                                 color:[SKColor colorWithRed:drand48()
                                                                       green:drand48()
                                                                        blue:drand48()
                                                                       alpha:1]
                                                  size:ciWhite.extent.size];
            mote.colorBlendFactor = 1.0;
            mote.radius = (drand48() * (MOTE_MAX_RADIUS - MOTE_MIN_RADIUS)) + MOTE_MIN_RADIUS;
            mote.radius = 15.0;
            mote.zPosition = (drand48() * (MOTE_MAX_HEIGHT - MOTE_MIN_HEIGHT)) + MOTE_MIN_HEIGHT;
            CGFloat dist = CAMERA_HEIGHT - mote.zPosition;
            mote.scale = CAMERA_HEIGHT / dist;
            mote.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(mote.radius * mote.scale)];
            mote.size = CGSizeMake(mote.radius * mote.scale, mote.radius * mote.scale);
            mote.position = CGPointMake(((drand48() * (1 + 2*SIDE_SPACE)) - SIDE_SPACE) * size.width, ((drand48() * (1 + 2*SIDE_SPACE)) - SIDE_SPACE) * size.height);
//            mote.realPosition = CGPointMake(mote.position.x / mote.scale, mote.position.y / mote.scale);
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
        
        SKShapeNode *wall = [[SKShapeNode alloc] init];
        wall.path = CGPathCreateWithEllipseInRect(CGRectMake(-800, -800, 1600, 1600), NULL);
        wall.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:wall.path];
        [self addChild:wall];
        
        [self scaleTo:0.75];
        self.focus = drop;
        self.anchorPoint = CGPointMake((0.5 / self.xScaleTrue) - (self.xScaleTrue * self.focus.position.x / self.frame.size.width), (0.5 / self.yScaleTrue) - (self.yScaleTrue * self.focus.position.y / self.frame.size.height));
    }

    return self;
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
    //TODO Consider that user zooming in and out should not affect the wrapping of the motes,
    //         because they might notice that.
    CGRect viewport = CGRectMake(self.focus.position.x - ((1 + (2 * SIDE_SPACE)) * self.size.width / 2), self.focus.position.y - ((1 + (2 * SIDE_SPACE)) * self.size.height / 2), (1 + (2 * SIDE_SPACE)) * self.size.width, (1 + (2 * SIDE_SPACE)) * self.size.height);
    for (Mote *mote in self.motes) {
        mote.position = CGPointMake(mote.position.x + ((1 - mote.scale) * (self.focus.position.x - ((Drop *)self.focus).lastPosition.x)), mote.position.y + ((1 - mote.scale) * (self.focus.position.y - ((Drop *)self.focus).lastPosition.y)));
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
    ((Drop *)self.focus).lastPosition = self.focus.position;
}

- (void)didChangeSize:(CGSize)oldSize {
    NSLog(@"Changed size: %@", NSStringFromCGSize(self.size));
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//    CGPoint loc = [touch locationInNode:self];
//    CGPoint ploc = [touch previousLocationInNode:self];
//    self.focus.physicsBody.velocity = CGVectorMake(PLAYER_VELOCITY_FACTOR * (ploc.x - loc.x), PLAYER_VELOCITY_FACTOR * (ploc.y - loc.y));
//}

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
//    self.zRotation = sender.rotation;
    [self runAction:[SKAction rotateToAngle:sender.rotation
                                   duration:0]];
//    NSLog(@"recognized rotation");
}

- (void)didPan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint loc = [sender translationInView:self.view];
        loc = [self convertPointFromView:loc];
        CGPoint ploc = [self convertPointFromView:CGPointZero];
        CGVector velocity = CGVectorMake(PLAYER_VELOCITY_FACTOR * (ploc.x-loc.x), PLAYER_VELOCITY_FACTOR * (ploc.y - loc.y));
        self.focus.physicsBody.velocity = velocity;
        [sender setTranslation:CGPointZero inView:self.view];
        //    NSLog(@"velocity %f,%f", self.focus.physicsBody.velocity.dx, self.focus.physicsBody.velocity.dy);
        //    NSLog(@"recognized pan");
    }
}

- (void)didLongPress:(UILongPressGestureRecognizer *)sender {
    NSLog(@"recognized long press");
}

@end
