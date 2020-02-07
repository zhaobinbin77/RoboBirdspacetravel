#import "MyScene.h"
#import "SKTUtils.h"
#import "SKEmitterNode+SKTExtras.h"
#import "SKAction+SKTExtras.h"
#import "Asteroid.h"
#import "Battery.h"
#import "StarSpecial.h"
#import "MenuScene.h"
#import "GameData.h"
#import "Star.h"
@interface MyScene () <SKPhysicsContactDelegate>
@end
@implementation MyScene {
    SKNode *_bgLayer;
    SKNode *_frontLayer;
    SKNode *_HUDLayer;
    SKSpriteNode *bg;
    float BG_POINTS_PER_SEC;
    SKSpriteNode *_player;
    SKEmitterNode *_enginePlayer;
    NSTimeInterval _dt;
    NSTimeInterval _lastUpdateTime;
    SKLabelNode * _goLabel;
    SKSpriteNode *_powerButtonOff;
    NSTimeInterval asteroidMoveSpeed;
    NSTimeInterval spawnAsteroidSpeed;
    NSTimeInterval spawnBatterySpeed;
    NSTimeInterval spawnStarSpeed;
    NSTimeInterval _starSpeed;
    NSTimeInterval _batterySpeed;
    NSTimeInterval _speedUpdate;
    SKAction *_turbo;
    SKAction *_lose;
     SKLabelNode *_gameOverLabel;
    SKLabelNode *_bestScoreLabel;
    SKSpriteNode *_finalStar;
    SKAction *_playButton;
    int _speed;
    NSString *_leaderboardIDMap;
    SKSpriteNode *_replayButton;
    SKLabelNode *_tapHereToFlapLabel;
    SKLabelNode *_tapHereToBoostLabel;
}
-(id)initWithSize:(CGSize)size volume:(BOOL)volume{
    if (self = [super initWithSize:size]) {
         self.physicsWorld.contactDelegate = self;
         self.backgroundColor = [SKColor blackColor];
        self.volume = volume;
        _speed = 0;
       _leaderboardIDMap = @"grp.com.PabloBrizuela.StarsCollected";
         [self setupLayers];
        for (int i = 0; i < 2; i++) {
            if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen]bounds].size.width == 480)) {
                bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg-planet4"];
            } else {
                bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg-planet"];
            }
            bg.anchorPoint = CGPointZero;
            bg.zPosition = -10;
            bg.position = CGPointMake(i * bg.size.width, 30);
            bg.name = @"bg";
            [_bgLayer addChild:bg];
        }
        SKNode *worldBoundaries = [SKNode node];
        worldBoundaries.position = CGPointMake(0, 0);
        worldBoundaries.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-self.size.width / 2, 30, self.frame.size.width + self.size.width / 2, self.size.height - 30)];
        worldBoundaries.physicsBody.categoryBitMask = CollisionCategoryWorld;
        worldBoundaries.physicsBody.collisionBitMask = 0;
        worldBoundaries.physicsBody.contactTestBitMask = 0;
        [self addChild:worldBoundaries];
        SKNode *leftBoundarie1 = [SKNode node];
        leftBoundarie1.position = CGPointMake(-25, 0);
        leftBoundarie1.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-25, 0) toPoint:CGPointMake(-26, self.size.height)];
        leftBoundarie1.physicsBody.categoryBitMask = CollisionCategoyBoundaries;
        leftBoundarie1.physicsBody.collisionBitMask = 0;
        leftBoundarie1.physicsBody.contactTestBitMask = 0;
        [self addChild:leftBoundarie1];
        SKNode *leftBoundarie2 = [SKNode node];
        leftBoundarie2.position = CGPointMake(-45, 0);
        leftBoundarie2.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-45, 0) toPoint:CGPointMake(-46, self.size.height)];
        leftBoundarie2.physicsBody.categoryBitMask = CollisionCategoyBoundaries;
        leftBoundarie2.physicsBody.collisionBitMask = 0;
        leftBoundarie2.physicsBody.contactTestBitMask = 0;
        [self addChild:leftBoundarie2];
        [self createPlayerAtPosition:CGPointMake(100, 100)];
        [self configureParticlesForPlayer];
        [self startPlayerAction];
         self.powerActivated = NO;
        _startBgMoving = YES;
          _gameOver = NO;
        [self goLabel];
        [self pauseLabelconfiguration];
        [self goLabelAction];
        [self StarsLabel];
        [self labelDistance];
        [self instructionsLabels];
        [[GameData sharedGameData] reset];
        [self pauseButtonsMenu];
        [self powerButtons];
        spawnAsteroidSpeed = 0.2;
        spawnBatterySpeed = 9.3;
        spawnStarSpeed = 0.3;
        BG_POINTS_PER_SEC = 170;
        _speedUpdate = 1.0;
        asteroidMoveSpeed = 5.0;
        _starSpeed = 6.0;
        _batterySpeed = 4.4;
        [self spawnBattery];
        [self spawnAsteroid];
        [self spawnStarSpecial];
        [self spawnStar];
        [self updateLabelSpeed];
        [self setupAnimations];
        [self shieldAnimation];
        _turbo = [SKAction playSoundFileNamed:@"boost.wav" waitForCompletion:NO];
       self.explosionAsteroid = [SKAction playSoundFileNamed:@"explosion_large.wav" waitForCompletion:NO];
        self.specialStar = [SKAction playSoundFileNamed:@"coin1.wav" waitForCompletion:NO];
        self.battery = [SKAction playSoundFileNamed:@"shierld.wav" waitForCompletion:NO];
        _lose = [SKAction playSoundFileNamed:@"game_over.wav" waitForCompletion:NO];
        self.star = [SKAction playSoundFileNamed:@"shootingStar.wav" waitForCompletion:NO];
        _playButton = [SKAction playSoundFileNamed:@"button_press.wav" waitForCompletion:NO];
        [self startBackgroundMusic];
        SKAction *scale = [SKAction scaleBy:2.0 duration:0.1];
        SKAction *reduce = [SKAction scaleTo:1.0 duration:0.1];
        self.starEffect = [SKAction sequence:@[scale, reduce]];
        [self gameOverScreen];
            }
    return self;
}
-(void)setupLayers {
    _bgLayer = [SKNode node];
    [self addChild:_bgLayer];
    _frontLayer = [SKNode node];
    [self addChild:_frontLayer];
    _HUDLayer = [SKNode node];
    [self addChild:_HUDLayer];
}
#pragma mark - creating sprites
-(void)createPlayerAtPosition:(CGPoint)position {
    _player = [SKSpriteNode spriteNodeWithImageNamed:@"roboBird"];
    _player.position = position;
    _player.name = @"player";
    _player.zPosition = 103;
    _player.size = CGSizeMake(40, 30);
    _player.zPosition = 100;
    _player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(_player.size.height / 2) ];
    _player.physicsBody.dynamic = YES;
    _player.physicsBody.allowsRotation = NO;
    _player.physicsBody.restitution = 0.0f; 
    _player.physicsBody.friction = 0;
    _player.physicsBody.angularDamping = 0;
    _player.physicsBody.angularVelocity = 0;
    _player.physicsBody.linearDamping = 0;
    _player.physicsBody.usesPreciseCollisionDetection = YES;
    _player.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    _player.physicsBody.collisionBitMask =  CollisionCategoryWorld | CollisionCategoyBoundaries | CollisionCategoryAsteroid;
    _player.physicsBody.contactTestBitMask = CollisionCategoryStarSpecial | CollisionCategoryBatteryGreen | CollisionCategoryAsteroid | CollisionCategoyBoundaries | CollisionCategoryStar;
    [_frontLayer addChild:_player];
}
-(void)powerButtons {
    _powerButtonOff = [SKSpriteNode spriteNodeWithImageNamed:@"powerUpButtonOff"];
    _powerButtonOff.position = CGPointMake(50, 70);
    _powerButtonOff.zPosition = 107;
    [self addChild:_powerButtonOff];
    _powerButtonOn = [SKSpriteNode spriteNodeWithImageNamed:@"powerUpButton"];
    _powerButtonOn.position = CGPointMake(50, 70);
    _powerButtonOn.zPosition = 107;
    [_powerButtonOn setHidden:YES];
    [self addChild:_powerButtonOn];}
-(void)pauseButtonsMenu {
    _pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButton"];
    _pauseButton.position = CGPointMake(30, self.size.height - 25);
    _pauseButton.size = CGSizeMake(_pauseButton.size.width -10, _pauseButton.size.width - 10);
    _pauseButton.zPosition = 102;
    [self addChild:_pauseButton];
    _playButtonPauseMenu = [SKSpriteNode spriteNodeWithImageNamed:@"playButton"];
    _playButtonPauseMenu.size = CGSizeMake(_playButtonPauseMenu.size.width, _playButtonPauseMenu.size.height);
    _playButtonPauseMenu.position = CGPointMake((self.size.width / 2) + 7, 170);
    _playButtonPauseMenu.zPosition = 106;
    _playButtonPauseMenu.hidden = YES;
    [self addChild:_playButtonPauseMenu];
}
-(void)spawnAsteroid {
    SKAction *spawn = [SKAction runBlock:^{
        Asteroid *asteroid = [[Asteroid alloc] initWithAsteroidType:arc4random_uniform(NumAsteroidTypes)];
        asteroid.name = @"asteroid";
        asteroid.zPosition = 90;
        asteroid.position = CGPointMake(self.size.width * 2, RandomFloatRange(30, self.size.height));
        [_frontLayer addChild:asteroid];
        SKAction *move = [SKAction moveTo:CGPointMake(-self.size.width/2, asteroid.position.y) duration:asteroidMoveSpeed];;
        SKAction *remove = [SKAction runBlock:^{
            [asteroid cleanup];
        }];
        [asteroid runAction:[SKAction sequence:@[move,remove]]];
    }];
    [self runAction:[SKAction repeatActionForever:
                     [SKAction sequence:@[spawn,
                                          [SKAction waitForDuration:spawnAsteroidSpeed]]]]];
}
-(void)spawnStarSpecial {
    SKAction *spawn = [SKAction runBlock:^{
        StarSpecial * stars =[[StarSpecial alloc] initWithImageNamed:@"StarSpecial"];
        stars.name = @"starSpecial";
        stars.zPosition = 103;
        stars.position = CGPointMake(self.size.width * 2, RandomFloatRange(60, self.size.height - 30));
        [_frontLayer addChild:stars];
        SKAction *move = [SKAction moveTo:CGPointMake(-self.size.width/2, stars.position.y) duration:_starSpeed];
        SKAction *remove = [SKAction runBlock:^{
            [stars cleanup];
        }];
        [stars runAction:[SKAction sequence:@[move,remove]]];
    }];
    [self runAction:[SKAction repeatActionForever:
                     [SKAction sequence:@[spawn,
                                          [SKAction waitForDuration:5]]]]];
}
-(void)spawnStar {
    SKAction *spawn = [SKAction runBlock:^{
        Star * star =[[Star alloc] initWithImageNamed:@"Star"];
        star.name = @"star";
        star.zPosition = 101;
        star.position = CGPointMake(self.size.width * 2, RandomFloatRange(60, self.size.height - 30));
        [_frontLayer addChild:star];
        SKAction *move = [SKAction moveTo:CGPointMake(-self.size.width/2, star.position.y) duration:_starSpeed];
        SKAction *remove = [SKAction runBlock:^{
            [star cleanup];
        }];
        [star runAction:[SKAction sequence:@[move,remove]]];
    }];
    [self runAction:[SKAction repeatActionForever:
                     [SKAction sequence:@[spawn,
                                          [SKAction waitForDuration:spawnStarSpeed]]]]];
}
-(void)spawnBattery {
    SKAction *spawn = [SKAction runBlock:^{
        Battery *battery =[[Battery alloc] initWithImageNamed:@"battery"];
        battery.name = @"battery";
        battery.zPosition = 104;
        battery.position = CGPointMake(self.size.width * 2, RandomFloatRange(60, self.size.height - 30 ));
        [_frontLayer addChild:battery];
        SKAction *move = [SKAction moveTo:CGPointMake(-self.size.width/2, battery.position.y) duration:_batterySpeed];
        SKAction *remove = [SKAction runBlock:^{
            [battery cleanup];
        }];
        [battery runAction:[SKAction sequence:@[move,remove]]];
    }];
    [self runAction:[SKAction repeatActionForever:
                     [SKAction sequence:@[spawn,
                                          [SKAction waitForDuration:spawnBatterySpeed]]]]];
}
-(void)gameOverScreen {
    _asteroidOver = [SKSpriteNode spriteNodeWithImageNamed:@"endSceneAsteroid"];
    _asteroidOver.position = CGPointMake(self.size.width / 2, 165);
    _asteroidOver.hidden = YES;
    _asteroidOver.zPosition = 105;
    _asteroidOver.size = CGSizeMake(_asteroidOver.size.width - 50, _asteroidOver.size.height - 50);
    [self addChild:_asteroidOver];
    _replayButton = [SKSpriteNode spriteNodeWithImageNamed:@"replayButton"];
    _replayButton.zPosition = 106;
    _replayButton.hidden = YES;
    _replayButton.position = CGPointMake((self.size.width / 2) - 70, 100);
    [self addChild:_replayButton];
    _menuButton = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    _menuButton.hidden = YES;
    _menuButton.position = CGPointMake((self.size.width / 2) + 85 , 100);
    _menuButton.zPosition = 106;
    [self addChild:_menuButton];
    _gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Transformers Movie"];
    _gameOverLabel.hidden = YES;
    _gameOverLabel.fontSize =  50;
    _gameOverLabel.zPosition = 106;
    _gameOverLabel.fontColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.9];
    _gameOverLabel.position = CGPointMake((self.size.width / 2) + 5, self.size.height - 70);
    _gameOverLabel.text = @"Game Over";
    [self addChild:_gameOverLabel];
    _bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Starjedi"];
    _bestScoreLabel.fontSize = 30;
    _bestScoreLabel.fontColor = [SKColor greenColor];
    _bestScoreLabel.alpha = 0.8;
    _bestScoreLabel.zPosition = 106;
    _bestScoreLabel.hidden = YES;
    _bestScoreLabel.position = CGPointMake(self.size.width / 2, 150);
    _bestScoreLabel.text = [NSString stringWithFormat:@" Best: %li", [GameData sharedGameData].highScore];
    [self addChild:_bestScoreLabel];
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Starjedi"];
    _scoreLabel.fontSize = 30;
    _scoreLabel.hidden = YES;
    _scoreLabel.fontColor = [SKColor cyanColor];
    _scoreLabel.alpha = 0.7;
    _scoreLabel.zPosition = 106;
    _scoreLabel.position = CGPointMake((self.size.width / 2) +  20, 193);
    _scoreLabel.text = [NSString stringWithFormat:@"x %li",[GameData sharedGameData].score];
    [self addChild:_scoreLabel];
    _shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"shareButton"];
    _shareButton.hidden = YES;
    _shareButton.zPosition = 106;
    _shareButton.position = CGPointMake((self.size.width / 2) + 7, 100);
    [self addChild:_shareButton];
    _finalStar = [SKSpriteNode spriteNodeWithImageNamed:@"StarFinal"];
    _finalStar.hidden = YES;
    _finalStar.position = CGPointMake((self.size.width /2)- 40, 205);
    _finalStar.zPosition  = 106;
    [self addChild:_finalStar];
}
#pragma mark - Labels
-(void)instructionsLabels {
    _tapHereToFlapLabel = [SKLabelNode labelNodeWithFontNamed:@"Starjedi"];
    _tapHereToFlapLabel.text = @"Tap here to Flap!";
    _tapHereToFlapLabel.position = CGPointMake((self.size.width /2) + 150, self.size.height /2);
    _tapHereToFlapLabel.zPosition = 101;
    _tapHereToFlapLabel.fontSize = 13;
    _tapHereToFlapLabel.fontColor = [SKColor redColor];
    [self addChild:_tapHereToFlapLabel];
   _tapHereToBoostLabel = [SKLabelNode labelNodeWithFontNamed:@"Starjedi"];
    _tapHereToBoostLabel.text = @"Tap here to Boost!";
    _tapHereToBoostLabel.position = CGPointMake((self.size.width /2) - 150, self.size.height /2);
    _tapHereToBoostLabel.zPosition = 101;
    _tapHereToBoostLabel.fontSize = 13;
    _tapHereToBoostLabel.fontColor = [SKColor greenColor];
    [self addChild:_tapHereToBoostLabel];
}
-(void)pauseLabelconfiguration {
    _pauseLabel = [SKLabelNode labelNodeWithFontNamed:@"Transformers Movie"];
    _pauseLabel.hidden = YES;
    _pauseLabel.position = CGPointMake(self.size.width/ 2, self.size.height - 70);
    _pauseLabel.fontColor = [SKColor redColor];
    _pauseLabel.fontSize = 50;
    _pauseLabel.zPosition = 106;
    _pauseLabel.text = @"Paused";
    [self addChild:_pauseLabel];
}
-(void)goLabel {
    _goLabel = [SKLabelNode labelNodeWithFontNamed:@"Transformers Movie"];
    _goLabel.fontColor = [SKColor redColor];
    _goLabel.alpha = 0.8;
    _goLabel.fontSize = 40;
    _goLabel.position = CGPointMake(self.size.width / 2, self.size.height - 110);
    _goLabel.text = @"Go!";
    [self addChild:_goLabel];
}
-(void)goLabelAction {
    SKAction *scale = [SKAction sequence:@[[SKAction scaleTo:2.0 duration:1.0], [SKAction scaleTo:0.7 duration:0.1]]];
    [_goLabel runAction:scale completion:^{
        [_goLabel removeFromParent];
    }];
}
-(void)StarsLabel {
    _starLabelImage = [SKSpriteNode spriteNodeWithImageNamed:@"StarCopy"];
    _starLabelImage.position = CGPointMake((self.size.width / 2) - 5, self.size.height - 20);
    _starLabelImage.zPosition = 100;
    _starLabelImage.size = CGSizeMake(_starLabelImage.size.width - 10, _starLabelImage.size.height - 10);
    [_HUDLayer addChild:_starLabelImage];
    self.starLabel = [SKLabelNode labelNodeWithFontNamed:@"Starjedi"];
    self.starLabel.fontSize = 15;
    self.starLabel.zPosition = 100;
    self.starLabel.fontColor = [UIColor cyanColor];
    self.starLabel.position = CGPointMake((self.size.width / 2) + 30, self.size.height - 27);
    self.starLabel.text = @"x 0";
    [_HUDLayer addChild:self.starLabel];
}
-(SKLabelNode *)labelDistance {
    self.distanceLabel = [SKLabelNode labelNodeWithFontNamed:@"Starjedi"];
    self.distanceLabel.fontSize = 15;
    self.distanceLabel.fontColor = [UIColor greenColor];
    self.distanceLabel.zPosition = 100;
    self.distanceLabel.text = @"speed : 0 ";
    self.distanceLabel.position = CGPointMake(self.size.width - 100, self.size.height - 27);
    [_HUDLayer addChild:self.distanceLabel];
    return self.distanceLabel;
}
#pragma mark - extra adjustments
- (void)reportScoreToGameCenter {
    int64_t highStars = [GameData sharedGameData].highScore;
}
-(void)configureParticlesForPlayer {
    _enginePlayer = [SKEmitterNode skt_emitterNamed:@"playerEngine"];
    _enginePlayer.targetNode =self;
    _enginePlayer.zPosition = 103;
    _enginePlayer.position = CGPointMake(-15, -1);
    [_player addChild:_enginePlayer];
}
-(void)updateLabelSpeed {
    SKAction * wait = [SKAction waitForDuration:_speedUpdate];
    SKAction * updateLabel = [SKAction runBlock:^{
        _speed = _speed + 1;
        self.distanceLabel.text = [NSString stringWithFormat:@"speed : %d" ,_speed];
    }];
    SKAction *sequence = [SKAction sequence:@[wait,updateLabel]];
    [self runAction:[SKAction repeatActionForever:sequence]];
}
-(void)startPlayerAction {
    SKAction *jump = [SKAction moveByX:_player.position.x + 250 y:_player.position.y + 550 duration:3.5];
    [_player runAction:jump];
}
- (void)moveBg
{
    CGPoint bgVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
    CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity, _dt);
    _bgLayer.position = CGPointAdd(_bgLayer.position, amtToMove);
    _bgLayer.position = CGPointMake((int)_bgLayer.position.x, (int)_bgLayer.position.y);
    [_bgLayer enumerateChildNodesWithName:@"bg"
                              usingBlock:^(SKNode *node, BOOL *stop){
                                  SKNode * _bg = (SKNode *) node;
                                  CGPoint bgScreenPos = [_bgLayer convertPoint:_bg.position
                                                                       toNode:self];
                                  if (bgScreenPos.x <= -1136) {
                                      _bg.position = CGPointMake(_bg.position.x+ bg.size.width * 2,
                                                                 _bg.position.y);
                                  }
                              }];
}
-(void)shieldAnimation {
    self.shield = [SKSpriteNode node];
    self.shield.blendMode = SKBlendModeAdd;
    [_player addChild:self.shield];
}
-(void)setupAnimations {
    self.shieldOnFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *shieldOnAtlas = [SKTextureAtlas atlasNamed:@"shield"];
    for (int i = 0; i < 9; i++) {
        NSString *tempName = [NSString stringWithFormat:@"shield00%d",i];
        SKTexture *tempTexture = [shieldOnAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.shieldOnFrames addObject:tempTexture];
        }
    }
}
-(void)startBackgroundMusic {
    NSError *err;
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bgMusic.mp3" ofType:nil]];
    _backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
    if (err) {
        NSLog(@"error in audio play %@",[err userInfo]);
        return;
    }
    [_backgroundAudioPlayer prepareToPlay];
    _backgroundAudioPlayer.numberOfLoops = -1;
    [_backgroundAudioPlayer setVolume:0.2];
    if (_volume == YES) {
         [_backgroundAudioPlayer play];
           }
}
#pragma mark - Managing events
-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKNode *node = contact.bodyA.node;
    if ([node isKindOfClass:[GameObject class]]) {
        [(GameObject*)node collidedWith:contact.bodyB contact:contact];
    }
    node = contact.bodyB.node;
    if ([node isKindOfClass:[GameObject class]]) {
        [(GameObject*)node collidedWith:contact.bodyA contact:contact];
    }
    uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
    if (collision == (CollisionCategoryPlayer | CollisionCategoyBoundaries)) {
        [self gameOverMessage];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if ([_powerButtonOn containsPoint:location] && _powerActivated && !self.paused) {
            _shieldActivated = YES;
            _player.physicsBody.velocity = CGVectorMake(1000, _player.physicsBody.velocity.dy);
            if ([self.shield isHidden]) {
                self.shield.hidden = NO;
            }
            _powerActivated = NO;
            _powerButtonOn.hidden = YES;
            [self.shield runAction:[SKAction animateWithTextures:self.shieldOnFrames timePerFrame:0.2 resize:YES restore:YES]completion:^{
                [self.shield setHidden:YES];
                _shieldActivated = NO;
            }];
        }
        if (location.x > self.size.width / 2.0 && location.y < self.size.height - 40 && !self.paused) {
            [_player removeAllActions];
            _player.physicsBody.velocity = CGVectorMake(0, 0);
            [_player.physicsBody applyImpulse:CGVectorMake(0.3, 15)];
        } else if (location.x < self.size.width /2.0 && location.y < self.size.height - 50 && !self.paused){
            [_player removeAllActions];
            _player.physicsBody.velocity = CGVectorMake(1000, _player.physicsBody.velocity.dy);
            if (self.volume == YES) {
                [_player runAction:_turbo];
            }
        }
        if ([_pauseButton containsPoint:location] && !_pauseButton.hidden) {
            if (_volume == YES) {
                [self runAction:_playButton];
            }
            if (!self.view.isPaused) {
                self.paused = YES;
                _playButtonPauseMenu.hidden = NO;
            }
        }
        if (self.paused && [_playButtonPauseMenu containsPoint:location] && !_playButtonPauseMenu.hidden) {
            self.paused = NO;
        }
        if (!_replayButton.hidden && [_replayButton containsPoint:location]) {
            [self removeAllActions];
            [self removeAllChildren];
            [_backgroundAudioPlayer stop];
            [GameData sharedGameData].highScore = MAX([GameData sharedGameData].score, [GameData sharedGameData].highScore);
            [self reportScoreToGameCenter];
            [[GameData sharedGameData] save];
            MyScene *scene = [[MyScene alloc] initWithSize:self.size volume:_volume];
            SKTransition *trans = [SKTransition flipVerticalWithDuration:0.5];
            trans.pausesIncomingScene = NO;
            [self.view presentScene:scene transition:trans];
        }
        if (!_menuButton.hidden && [_menuButton containsPoint:location]) {
            [_backgroundAudioPlayer stop];
            [self removeAllActions];
            [self removeAllChildren];
            if (_volume == YES) {
                [self runAction:_playButton];
            }
            [GameData sharedGameData].highScore = MAX([GameData sharedGameData].score, [GameData sharedGameData].highScore);
            [self reportScoreToGameCenter];
            [[GameData sharedGameData] save];
            MenuScene *menu = [[MenuScene alloc] initWithSize:self.size volume:_volume];
            SKTransition *trans = [SKTransition flipVerticalWithDuration:0.5];
            trans.pausesIncomingScene = NO;
            [self.view presentScene:menu transition:trans];
        }
        if (!_shareButton.hidden && [_shareButton containsPoint:location]) {
            if (_volume == YES) {
                [self runAction:_playButton];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareButton" object:self];
        }
    }
}
-(void)update:(CFTimeInterval)currentTime {
    if (_gameOver) return;
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    if (_startBgMoving == YES) {
        [self moveBg];
    }
    if ([GameData sharedGameData].highScore >= 50) {
        _tapHereToBoostLabel.hidden = YES;
        _tapHereToFlapLabel.hidden = YES;
    }
    if (self.paused == YES) {
        _pauseButton.hidden = YES;
        if (_volume == YES) {
            [_backgroundAudioPlayer pause];
        }
        [_playButtonPauseMenu setHidden:NO];
        _pauseLabel.hidden = NO;
        _asteroidOver.hidden = NO;
        _menuButton.hidden = NO;
        _replayButton.hidden = NO;
        _startBgMoving = NO;
    }else {
        _pauseButton.hidden = NO;
        if (_volume == YES) {
            [_backgroundAudioPlayer play];
        }
        _pauseLabel.hidden = YES;
        _asteroidOver.hidden = YES;
        _menuButton.hidden = YES;
        _replayButton.hidden = YES;
        _playButtonPauseMenu.hidden = YES;
        _startBgMoving = YES;
    }
    if ((_speed >= 3 )&& (_speed < 10)) {
        if (_speed == 10 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 170;
        _speedUpdate = 1.0;
        asteroidMoveSpeed = 5.0;
        _starSpeed = 6.0;
        _batterySpeed = 7.0;
        _tapHereToFlapLabel.hidden = YES;
        _tapHereToBoostLabel.hidden = YES;
    } else if ((_speed >= 10 )&& (_speed < 20)) {
        if (_speed == 10 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 170;
        _speedUpdate = 1.0;
        asteroidMoveSpeed = 5.0;
        _starSpeed = 6.0;
        _batterySpeed = 7.0;
    } else if ((_speed >= 20) && (_speed < 30)) {
        if (_speed == 20 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 170;
        _speedUpdate = 1.0;
        asteroidMoveSpeed = 5.0;
        _starSpeed = 6.0;
        _batterySpeed = 7.0;
    } else if ((_speed >= 30) && (_speed < 40)) {
        if (_speed == 30 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 180;
        _speedUpdate = 1.0;
        asteroidMoveSpeed = 4.8;
        _starSpeed = 5.5;
        _batterySpeed = 6.8;
    } else if ((_speed >= 40) && (_speed < 50)) {
        if (_speed == 40 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 200;
        _speedUpdate = 0.9;
        asteroidMoveSpeed = 4.7;
        _starSpeed = 5.2;
        _batterySpeed = 6.7;
    } else if ((_speed >= 50) && (_speed < 60)) {
        if (_speed == 50 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 220;
        _speedUpdate = 0.8;
        asteroidMoveSpeed = 4.5;
        _starSpeed = 5.0;
        _batterySpeed = 6.5;
    } else if ((_speed >= 60) && (_speed < 70)) {
        if (_speed == 60 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 240;
        _speedUpdate = 0.8;
        asteroidMoveSpeed = 4.2;
        _starSpeed = 4.8;
        _batterySpeed = 6.2;
    } else if ((_speed >= 70) && (_speed < 90)) {
        if (_speed == 70 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 280;
        _speedUpdate = 0.7;
        asteroidMoveSpeed = 3.8;
        _starSpeed = 4.2;
        _batterySpeed = 5.8;
    } else if ((_speed >= 90) && (_speed < 130)) {
        if (_speed == 90 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 300;
        _speedUpdate = 0.6;
        asteroidMoveSpeed = 3.4;
        _starSpeed = 3.8;
        _batterySpeed = 5.4;
    } else if ((_speed >= 130) && (_speed < 170)) {
        if (_speed == 130 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 320;
        _speedUpdate = 0.4;
        asteroidMoveSpeed = 3.0;
        _starSpeed = 3.5;
        _batterySpeed = 5.0;
    } else if ((_speed >= 170) && (_speed < 200)) {
        if (_speed == 170 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 350;
        _speedUpdate = 0.3;
        asteroidMoveSpeed = 2.5;
        _starSpeed = 3.0;
        _batterySpeed = 4.5;
    }else if ((_speed >= 200) && (_speed < 300)) {
        if (_speed == 200 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 380;
        _speedUpdate = 0.2;
        asteroidMoveSpeed = 2.0;
        _starSpeed = 2.5;
        _batterySpeed = 4.0;
    }else if ((_speed >= 300) && (_speed < 500)) {
        if (_speed == 300 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 400;
        _speedUpdate = 0.1;
        asteroidMoveSpeed = 1.5;
        _starSpeed = 2.0;
        _batterySpeed = 3.5;
    }  else if ((_speed >= 500) && (_speed < 1000)) {
        if (_speed == 500 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 430;
        _speedUpdate = 0.0;
        asteroidMoveSpeed = 1.0;
        _starSpeed = 1.5;
        _batterySpeed = 2.5;
    } else if (_speed >= 1000) {
        if (_speed == 1000 && !self.distanceLabel.hasActions){
            [self.distanceLabel runAction:self.starEffect];
        }
        BG_POINTS_PER_SEC = 460;
        _speedUpdate = 0.0;
        asteroidMoveSpeed = 0.9;
        _starSpeed = 1.2;
        _batterySpeed = 2.2;
    }
    if (_player.position.x <= -100) {
        [self gameOverMessage];
    }
    if (_player.position.x <= -200) {
        [self gameOverMessage];
    }
}
-(void)didSimulatePhysics {
    if (_player.position.x <= -60) {
        [self gameOverMessage];
    }
    if (_player.position.x <= -self.size.width / 2) {
        [self gameOverMessage];
    }
}
#pragma mark - extra scenes
-(void)gameOverMessage {
    _gameOver = YES;
    [GameData sharedGameData].highScore = MAX([GameData sharedGameData].score, [GameData sharedGameData].highScore);
    [[GameData sharedGameData] save];
      [self reportScoreToGameCenter];
    [self.shieldOnFrames removeAllObjects];
    self.shieldOnFrames = nil;
    [_player removeFromParent];
    [_enginePlayer removeFromParent];
    [_backgroundAudioPlayer stop];
    if (_volume == YES) {
        [_asteroidOver runAction:_lose];
    }
    _asteroidOver.hidden = NO;
    _scoreLabel.hidden = NO;
    _bestScoreLabel.hidden = NO;
        _menuButton.hidden = NO;
    _replayButton.hidden = NO;
    _gameOverLabel.hidden = NO;
    _shareButton.hidden = YES;
    _finalStar.hidden = NO;
    _pauseButton.hidden = YES;
    _powerButtonOff.hidden = YES;
    _powerButtonOn.hidden = YES;
    _distanceLabel.hidden = YES;
    _starLabel.hidden = YES;
}
@end
