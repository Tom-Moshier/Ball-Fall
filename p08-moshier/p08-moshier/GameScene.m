//
//  GameScene.m
//  p08-moshier
//
//  Created by Tom Moshier on 5/8/17.
//  Copyright © 2017 Tom Moshier. All rights reserved.
//

#import "GameScene.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryBall = 0x1 << 1,
    CollisionCategoryRods = 0x1 << 2,
};

@interface GameScene () <SKPhysicsContactDelegate> {
    SKSpriteNode *aCircle;
    SKShapeNode *circleShape;
    
    CGFloat xAcceleration;
    
    bool gameOver;
    bool touchLeft;
    bool touchRight;
}

@end;

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    [self addBall];
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    self.physicsWorld.contactDelegate = self;
    gameOver = false;
    xAcceleration = 0;
    NSLog(@"%f",self.frame.size.width/4);
}

- (void) addBall {
    //Add a ball with physics
    //Drawing the ball was found from here: http://stackoverflow.com/questions/24078687/draw-smooth-circle-in-ios-sprite-kit
    float radius = 15.0;
    aCircle = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(radius * 2, radius * 2)];
    SKPhysicsBody *circleBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    [circleBody setDynamic:NO];
    [circleBody setUsesPreciseCollisionDetection:YES];
    aCircle.physicsBody = circleBody;
    aCircle.physicsBody.collisionBitMask = 0;
    CGPathRef bodyPath = CGPathCreateWithEllipseInRect(CGRectMake(-[aCircle size].width / 2, -[aCircle size].height / 2, [aCircle size].width, [aCircle size].width), nil);
    circleShape = [SKShapeNode node];
    [circleShape setFillColor:[UIColor redColor]];
    [circleShape setLineWidth:0];
    [circleShape setPath:bodyPath];
    [aCircle addChild:circleShape];
    CGPathRelease(bodyPath);
    circleShape.fillColor = [SKColor whiteColor];
    circleShape.physicsBody.categoryBitMask = CollisionCategoryBall;
    aCircle.physicsBody.categoryBitMask = CollisionCategoryBall;
    aCircle.position = CGPointMake(0, -self.frame.size.height/2 +100);
    [self addChild:aCircle];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!gameOver) {
        if(aCircle.physicsBody.dynamic == NO) {
            aCircle.physicsBody.dynamic = YES;
        }
        UITouch *touch=[[event allTouches]anyObject];
        CGPoint point= [touch locationInView:self.view];
        if(point.x > self.frame.size.width/4) {
            touchRight = true;
        }
        else {
            touchLeft = true;
        }

    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    touchRight = false;
    touchLeft = false;
}



-(void)update:(CFTimeInterval)currentTime {
    if(!gameOver) {
        aCircle.physicsBody.velocity = CGVectorMake(xAcceleration * 600.0f, aCircle.physicsBody.velocity.dy);
        if (aCircle.position.x < -self.frame.size.width/2) {
            aCircle.position = CGPointMake(self.frame.size.width/2, aCircle.position.y);
        }
        else if (aCircle.position.x > self.frame.size.width/2) {
            aCircle.position = CGPointMake(-self.frame.size.width/2, aCircle.position.y);
        }
        if(touchRight) {
            xAcceleration = (xAcceleration += 0.02);
        }
        if(touchLeft) {
            xAcceleration = (xAcceleration += -0.02);
        }
        if(xAcceleration > 1.5) {
            xAcceleration = 1.5;
        }
        if(xAcceleration < -1.5) {
            xAcceleration = -1.5;
        }
    }
}

@end
