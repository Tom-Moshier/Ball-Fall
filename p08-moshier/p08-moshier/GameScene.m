//
//  GameScene.m
//  p08-moshier
//
//  Created by Tom Moshier on 5/8/17.
//  Copyright © 2017 Tom Moshier. All rights reserved.
//

#import "GameScene.h"

@interface GameScene () <SKPhysicsContactDelegate> {
    SKSpriteNode *aCircle;

    SKShapeNode *circleShape;
    SKShapeNode *myRectangle1;
    
    SKLabelNode* scoreLabel;
    
    SKNode* holder1;
    
    CGFloat xAcceleration;
    
    bool gameOver;
    bool touchLeft;
    bool touchRight;
    
    
    int score;
}

@end;

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    [self addBall];
    self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
    self.physicsWorld.contactDelegate = self;
    gameOver = false;
    xAcceleration = 0;
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    scoreLabel.fontSize = 30;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(0, self.frame.size.height/2 -30);
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    score = 0;
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    [self addChild:scoreLabel];
    CGPoint origin;
    origin.y = -200;
    origin.x = -200;
    [self addRectangle:origin];
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
    aCircle.position = CGPointMake(0, -self.frame.size.height/2 +100);
    [self addChild:aCircle];
}

- (void)addRectangle:(CGPoint)origin{
    CGSize size;
    size.height = 20;
    size.width = self.frame.size.width;
    CGRect rect;
    rect.origin = origin;
    rect.size = size;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    myRectangle1 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle1.strokeColor = [SKColor greenColor];
    myRectangle1.fillColor = [SKColor greenColor];
    myRectangle1.zRotation = 0;
    myRectangle1.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myRectangle1.physicsBody.affectedByGravity = false;
    [self addChild:myRectangle1];
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
    if(!gameOver && aCircle.physicsBody.dynamic == YES) {
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
        score++;
        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
        if(aCircle.position.y > self.frame.size.height/2) {
            gameOver = true;
            [self gameOver];
        }
    }
}

-(void)gameOver {
    
}

@end
