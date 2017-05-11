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
    SKLabelNode* timeNode;
    SKLabelNode* levelNode;
    
    SKNode* holder;
    
    CGFloat xAcceleration;
    
    bool gameOver;
    bool touchLeft;
    bool touchRight;
    
    double speed;
    int time;
    int score;
    int level;
    
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
    level = 1;
    score = 0;
    time = 0;
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    scoreLabel.fontSize = 40;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(0, self.frame.size.height/2 -50);
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    timeNode = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    timeNode.fontSize = 40;
    timeNode.fontColor = [SKColor whiteColor];
    timeNode.position = CGPointMake(-self.frame.size.width/2 +50, self.frame.size.height/2 -50);
    timeNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    timeNode.text = [NSString stringWithFormat:@"%d", time];
    
    levelNode = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    levelNode.fontSize = 40;
    levelNode.fontColor = [SKColor whiteColor];
    levelNode.position = CGPointMake(self.frame.size.width/2 -50, self.frame.size.height/2 -50);
    levelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    levelNode.text = [NSString stringWithFormat:@"%d", level];
    
    holder = [SKNode node];
    int y = -self.size.height/2;
    while(y <= self.size.height/2-200) {
        [self addRectangle:y];
        y+=100;
    }
    [self addRectangle:y];
    [self addChild:scoreLabel];
    [self addChild:levelNode];
    [self addChild:timeNode];
    
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
    [self addChild:holder];
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
    CGPathRef bodyPath = CGPathCreateWithEllipseInRect(CGRectMake(-[aCircle size].width / 2, -[aCircle size].height / 2, [aCircle size].width, [aCircle size].width), nil);
    
    
    circleShape = [SKShapeNode node];
    [circleShape setFillColor:[UIColor redColor]];
    [circleShape setLineWidth:0];
    [circleShape setPath:bodyPath];
    [aCircle addChild:circleShape];
    CGPathRelease(bodyPath);
    circleShape.fillColor = [SKColor whiteColor];
    aCircle.position = CGPointMake(0, self.frame.size.height/2 -66);
    [self addChild:aCircle];
    
    aCircle.physicsBody.usesPreciseCollisionDetection = YES;
    aCircle.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    aCircle.physicsBody.collisionBitMask = CollisionCategoryRegularPlatform;
    aCircle.physicsBody.contactTestBitMask = CollisionCategoryRegularPlatform;
}

- (void)addRectangle:(int)y{
    CGSize size;
    size.height = 20;
    size.width = self.frame.size.width;
    CGRect rect;
    CGRect rect2;
    int x = [self getRandomNumberBetween:self.size.width/8 to:self.size.width];
    NSLog(@"x: %d\n",x);
    CGPoint origin;
    CGPoint origin2;
    origin.x = x;
    origin.y = y;
    rect.origin = origin;
    origin2.x = x -850;
    origin2.y = y;
    rect2.origin = origin2;
    rect.size = size;
    rect2.size = size;
    
    SKSpriteNode *Rectangle1 = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:rect.size];
    SKPhysicsBody *rectBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
    [rectBody setDynamic:NO];
    [rectBody setUsesPreciseCollisionDetection:YES];
    Rectangle1.physicsBody = rectBody;
    Rectangle1.physicsBody.collisionBitMask = CollisionCategoryPlayer;
    Rectangle1.physicsBody.categoryBitMask = CollisionCategoryRegularPlatform;
    Rectangle1.physicsBody.contactTestBitMask = CollisionCategoryPlayer;
    Rectangle1.position = origin;
    Rectangle1.name = @"Rect";
    
    SKSpriteNode *Rectangle2 = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:rect2.size];
    SKPhysicsBody *rectBody2 = [SKPhysicsBody bodyWithRectangleOfSize:rect2.size];
    [rectBody2 setDynamic:NO];
    [rectBody2 setUsesPreciseCollisionDetection:YES];
    Rectangle2.physicsBody = rectBody2;
    Rectangle2.physicsBody.collisionBitMask = CollisionCategoryPlayer;
    Rectangle2.physicsBody.categoryBitMask = CollisionCategoryRegularPlatform;
    Rectangle2.physicsBody.contactTestBitMask = CollisionCategoryPlayer;
    Rectangle2.position = origin2;
    Rectangle2.name = @"Rect";
    
    [holder addChild:Rectangle1];
    [holder addChild:Rectangle2];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

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
            xAcceleration = (xAcceleration += 0.03);
        }
        if(touchLeft) {
            xAcceleration = (xAcceleration += -0.03);
        }
        if(!touchRight && !touchLeft) {
            NSLog(@"Acceleration: %f",xAcceleration);
            if(xAcceleration > 0) {
                xAcceleration = (xAcceleration -= 0.01);
            }
            else if(xAcceleration < 0){
                xAcceleration = (xAcceleration += 0.01);
            }
        }
        if(xAcceleration > 1.3) {
            xAcceleration = 1.3;
        }
        if(xAcceleration < -1.3) {
            xAcceleration = -1.3;
        }
        score += 1*level;
        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
        if(aCircle.position.y < -self.frame.size.height/2) {
            [holder removeFromParent];
            holder = [SKNode node];
            [self addChild:holder];
            int y = -self.size.height/2;
            while(y <= self.size.height/2-200) {
                [self addRectangle:y];
                y+=100;
            }
            level++;
            levelNode.text = [NSString stringWithFormat:@"%d", level];
            aCircle.position = CGPointMake(aCircle.position.x, self.frame.size.height/2);
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
