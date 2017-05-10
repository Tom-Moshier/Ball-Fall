//
//  GameScene.m
//  p08-moshier
//
//  Created by Tom Moshier on 5/8/17.
//  Copyright © 2017 Tom Moshier. All rights reserved.
//

#import "GameScene.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryPlayer   = 0x1 << 0,
    CollisionCategoryRegularPlatform = 0x1 << 1,
};

@interface GameScene () <SKPhysicsContactDelegate> {
    SKSpriteNode *aCircle;

    SKShapeNode *circleShape;
    SKShapeNode *topBar;
    
    SKLabelNode* scoreLabel;
    SKLabelNode* gameOverLabel;
    SKLabelNode* finalScore;
    SKLabelNode* startNode;
    
    SKNode* holder;
    
    CGFloat xAcceleration;
    
    bool gameOver;
    bool touchLeft;
    bool touchRight;
    
    double speed;
    int score;
}

@end;

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    [self setUp];
}

-(void)setUp {
    self.backgroundColor = [SKColor blackColor];
    [self addBall];
    self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
    self.physicsWorld.contactDelegate = self;
    gameOver = false;
    xAcceleration = 0;
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    scoreLabel.fontSize = 40;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(0, self.frame.size.height/2 -50);
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    score = 0;
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    holder = [SKNode node];
    int y = -self.size.height/2;
    while(y <= self.size.height/2-50) {
        [self addRectangle:y];
        y+=100;
    }
    [self addChild:holder];
    [self addChild:scoreLabel];
    
    CGSize size;
    size.height = 2;
    size.width = self.frame.size.width;
    CGRect rect;
    CGPoint origin;
    origin.x = -self.frame.size.width/2;
    origin.y = self.frame.size.height/2 -65;
    rect.origin = origin;
    rect.size = size;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    topBar = [SKShapeNode shapeNodeWithPath:path.CGPath];
    topBar.strokeColor = [SKColor whiteColor];
    topBar.fillColor = [SKColor whiteColor];
    [self addChild:topBar];
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
    aCircle.position = CGPointMake(0, -self.frame.size.height/2 +50);
    [self addChild:aCircle];
    
    aCircle.physicsBody.usesPreciseCollisionDetection = YES;
    aCircle.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    aCircle.physicsBody.collisionBitMask = 0; // will simulate using predetmined actions by platforms
    aCircle.physicsBody.contactTestBitMask = CollisionCategoryRegularPlatform;
}

- (void)addRectangle:(int)y{
    CGSize size;
    size.height = 20;
    size.width = self.frame.size.width;
    CGRect rect;
    CGRect rect2;
    int x = [self getRandomNumberBetween:-self.size.width/2+50 to:self.size.width/2-50];
    NSLog(@"x: %d\n",x);
    CGPoint origin;
    origin.x = x;
    origin.y = y;
    rect.origin = origin;
    origin.x += -850;
    rect2.origin = origin;
    rect.size = size;
    rect2.size = size;
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:rect2];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    SKShapeNode *myRectangle1;
    SKShapeNode *myRectangle2;
    
    myRectangle1 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle1.strokeColor = [SKColor greenColor];
    myRectangle1.fillColor = [SKColor greenColor];
    myRectangle1.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myRectangle1.physicsBody.dynamic = YES;
    myRectangle1.physicsBody.affectedByGravity = NO;
    myRectangle1.name = @"Rect";
    
    myRectangle1.physicsBody.collisionBitMask = 0;
    [holder addChild:myRectangle1];
    
    myRectangle2 = [SKShapeNode shapeNodeWithPath:path2.CGPath];
    myRectangle2.strokeColor = [SKColor greenColor];
    myRectangle2.fillColor = [SKColor greenColor];
    myRectangle2.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path2.CGPath)];
    myRectangle2.physicsBody.dynamic = YES;
    myRectangle2.physicsBody.affectedByGravity = NO;
    myRectangle2.physicsBody.collisionBitMask = 0;
    myRectangle2.name = @"Rect";
    [holder addChild:myRectangle2];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

-(void) moveRectangles:(int)number {
    SKAction *rotation = [SKAction rotateByAngle:2*M_PI duration:number];
    SKAction *repeat = [SKAction repeatActionForever:rotation];
    [holder runAction:repeat withKey:@"rotation"];
}

/*
- (void) changeSpeed {
    if (speed > 1) {
        if(changeSpeedNum == 0) {
            speed -=1;
            [holder1 removeActionForKey:@"rotation"];
            [self rotateCircle:speed];
            speedNum += 1;
            NSLog(@"Speed: %f",speed);
            speedLabelNum.text = [NSString stringWithFormat:@"%d", speedNum];
            changeSpeedNum = 1;
        }
        else {
            [holder2 removeActionForKey:@"rotation"];
            [self rotateRectangle:speed];
            NSLog(@"Speed: %f",speed);
            changeSpeedNum = 0;
        }
    }
}
 */

-(void) didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if([secondBody.node.name  isEqual:@"Rect"]){
        NSLog(@"Bottom on table");
    }
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
    else {
        for(SKNode *node in [self children]) {
            [node removeFromParent];
        }
        [self setUp];
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
        if(aCircle.position.y > self.frame.size.height/2 -65) {
            gameOver = true;
            for (SKNode *node in [self children]) {
                [node removeFromParent];
            }
            [self gameOver];
        }
    }
}

-(void)gameOver {
    gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    gameOverLabel.fontSize = 70;
    gameOverLabel.fontColor = [SKColor whiteColor];
    gameOverLabel.position = CGPointMake(0.0f, 250.0f);;
    gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [gameOverLabel setText:@"Game Over"];
    [self addChild:gameOverLabel];
    
    finalScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    finalScore.fontSize = 70;
    finalScore.fontColor = [SKColor whiteColor];
    finalScore.position = CGPointMake(0.0f, 0.0f);
    finalScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [finalScore setText:[NSString stringWithFormat:@"Final Score: %d", score]];
    [self addChild:finalScore];
    
    startNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    startNode.fontSize = 55;
    startNode.fontColor = [SKColor whiteColor];
    startNode.position = CGPointMake(0.0f, -250.0f);
    startNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [startNode setText:@"Tap to Try Again"];
    [self addChild:startNode];
}

@end
