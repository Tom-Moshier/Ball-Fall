//
//  GameViewController.m
//  p08-moshier
//
//  Created by Tom Moshier on 5/8/17.
//  Copyright © 2017 Tom Moshier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainMenuScene.h"
#import "GameScene.h"
#import "math.h"

//basically all this main menu scene is copied from previous projects
//nothing like reusing code

@interface MainMenuScene () {
    SKLabelNode* instruct1;
    SKLabelNode* instruct2;
    SKLabelNode* instruct3;
    SKLabelNode* instruct4;
    SKLabelNode* instruct5;
    SKSpriteNode *aCircle;
    SKShapeNode *circleShape;
    
    SKShapeNode *myRectangle1;
    SKShapeNode *myRectangle2;
    SKShapeNode *myRectangle3;
    SKShapeNode *myRectangle4;
    SKShapeNode *myRectangle5;
    SKShapeNode *myRectangle6;
    
    
}

@end

@implementation MainMenuScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    [self startScene];
}

-(void) startScene {
    [self createStartLabels];
    //https://makeapppie.com/2014/04/01/slippyflippy-1-1-adding-a-fading-in-and-out-label-with-background-in-spritekit/
    //found code here for fading in an out, then made it ran forever
    SKAction *flashAction = [SKAction sequence:@[
                                                 [SKAction fadeInWithDuration:1],
                                                 [SKAction waitForDuration:0],
                                                 [SKAction fadeOutWithDuration:1]
                                                 ]];
    SKAction *repeat = [SKAction repeatActionForever:flashAction];
    [instruct5 runAction:repeat];
    [self addRectangles];
    SKAction *fallBall = [SKAction sequence:@[
                                                 [SKAction runBlock:^{ [self fall:1]; }], [SKAction waitForDuration:.75],
                                                 [SKAction runBlock:^{ [self fall:2]; }], [SKAction waitForDuration:.75],
                                                 [SKAction runBlock:^{ [self fall:3]; }], [SKAction waitForDuration:.75],
                                                 [SKAction runBlock:^{ [self fall:4]; }], [SKAction waitForDuration:.75],
                                                 [SKAction runBlock:^{ [self fall:5]; }], [SKAction waitForDuration:.75],
                                                 [SKAction runBlock:^{ [self fall:6]; }], [SKAction waitForDuration:.75],
                                                 ]];
    SKAction *fallBallRepeat = [SKAction repeatActionForever:fallBall];
    [self runAction:fallBallRepeat];
}

-(void) createStartLabels {
    instruct1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct1.fontSize = 70;
    instruct1.fontColor = [SKColor whiteColor];
    instruct1.position = CGPointMake(0, self.frame.size.height/2 -100);
    instruct1.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct1 setText:@"Ball Fall"];
    [self addChild:instruct1];
    
    instruct2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct2.fontSize = 35;
    instruct2.fontColor = [SKColor whiteColor];
    instruct2.position = CGPointMake(0.0, -200);
    instruct2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct2 setText:@"Touch Left or Right"];
    [self addChild:instruct2];
    
    instruct3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct3.fontSize = 35;
    instruct3.fontColor = [SKColor whiteColor];
    instruct3.position = CGPointMake(0, -300);
    instruct3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct3 setText:@"You'll Move the Ball"];
    [self addChild:instruct3];
    
    instruct4 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct4.fontSize = 35;
    instruct4.fontColor = [SKColor whiteColor];
    instruct4.position = CGPointMake(0, -400);
    instruct4.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct4 setText:@"Don't Hit the Top"];
    [self addChild:instruct4];
    
    instruct5 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct5.fontSize = 70;
    instruct5.fontColor = [SKColor whiteColor];
    instruct5.position = CGPointMake(0, -self.frame.size.height/2 + 100);
    instruct5.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct5 setText:@"Tap to start"];
    [self addChild:instruct5];
    [self addBall];
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
    aCircle.position = CGPointMake(0, 0);
    [self addChild:aCircle];
}

-(void) addRectangles {
    CGSize size;
    size.height = 20;
    size.width = self.frame.size.width;
    CGRect rect;
    CGPoint origin;
    origin.y = 0;
    origin.x = 0;
    rect.origin = origin;
    rect.size = size;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    myRectangle1 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle1.strokeColor = [SKColor greenColor];
    myRectangle1.fillColor = [SKColor greenColor];
    [self addChild:myRectangle1];
    

    origin.y = 100;
    origin.x = -100;
    rect.origin = origin;
    rect.size = size;
    
    path = [UIBezierPath bezierPathWithRect:rect];
    
    myRectangle2 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle2.strokeColor = [SKColor greenColor];
    myRectangle2.fillColor = [SKColor greenColor];
    [self addChild:myRectangle2];
    
 
    origin.y = 200;
    origin.x = 100;
    rect.origin = origin;
    rect.size = size;
    
    path = [UIBezierPath bezierPathWithRect:rect];
    
    myRectangle3 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle3.strokeColor = [SKColor greenColor];
    myRectangle3.fillColor = [SKColor greenColor];
    [self addChild:myRectangle3];
    

    origin.y = 200;
    origin.x = -750;
    rect.origin = origin;
    rect.size = size;
    
    path = [UIBezierPath bezierPathWithRect:rect];
    
    myRectangle4 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle4.strokeColor = [SKColor greenColor];
    myRectangle4.fillColor = [SKColor greenColor];
    [self addChild:myRectangle4];
    
    origin.y = 100;
    origin.x = -950;
    rect.origin = origin;
    rect.size = size;
    
    path = [UIBezierPath bezierPathWithRect:rect];
    
    myRectangle5 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle5.strokeColor = [SKColor greenColor];
    myRectangle5.fillColor = [SKColor greenColor];
    [self addChild:myRectangle5];

    
    origin.y = 0;
    origin.x = -850;
    rect.origin = origin;
    rect.size = size;
    
    path = [UIBezierPath bezierPathWithRect:rect];
    
    myRectangle6 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle6.strokeColor = [SKColor greenColor];
    myRectangle6.fillColor = [SKColor greenColor];
    [self addChild:myRectangle6];
    
}

-(void) fall:(int)num {
    if(num == 1) {
        aCircle.position = CGPointMake(-100, 237);
    }
    else if(num == 2) {
        aCircle.position = CGPointMake(0, 237);
    }
    else if(num == 3) {
        aCircle.position = CGPointMake(38, 138);
    }
    else if(num == 4) {
        aCircle.position = CGPointMake(-50, 138);
    }
    else if(num == 5) {
        aCircle.position = CGPointMake(-150, 37);
    }
    else {
        aCircle.position = CGPointMake(0, 0);
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKView *skView = (SKView *)self.view;
    // Present the scene
    [skView presentScene:scene];
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
