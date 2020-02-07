#import "InstructionsScene.h"
#import "MenuScene.h"
@implementation InstructionsScene {
    SKSpriteNode *bg;
    SKSpriteNode *_menuButton;
    SKSpriteNode *_nextButton;
    SKSpriteNode *_backButton;
    SKTransition *trans;
    BOOL _volume;
    SKSpriteNode *_goalInstrucLetters;
    SKSpriteNode *_starsInstrucs1;
    SKSpriteNode *_leftScreenInstruc;
    SKSpriteNode *_rightScreenInstruc;
    SKSpriteNode *_barScreen;
    SKSpriteNode *_batteryInstruc;
    SKSpriteNode *_forceFieldInstruc;
    SKSpriteNode *_roboShieldInstruc;
    SKSpriteNode *_tipsInstruc;
    SKSpriteNode*_andLastyInstruc;
    SKSpriteNode *_wiselyInstruc;
    int _counterScreens;
    SKAction *playButton;
}
-(instancetype)initWithSize:(CGSize)size volume:(BOOL)volume{
    if (self = [super initWithSize:size]) {
        _volume = volume;
        _counterScreens = 0;
        playButton = [SKAction playSoundFileNamed:@"button_press.wav" waitForCompletion:NO];
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen]bounds].size.height == 568)) {
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"EndRoboBird"];
        } else {
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"EndRoboBird"];
        }
        bg.position = CGPointMake(0, 0);
        bg.anchorPoint = CGPointZero;
        bg.size = self.size;
        [self addChild:bg];
        _menuButton = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
        _menuButton.position = CGPointMake(self.size.width / 2, self.size.height - 30);
        [self addChild:_menuButton];
        _nextButton = [SKSpriteNode spriteNodeWithImageNamed:@"nextButton"];
        _nextButton.position = CGPointMake(self.size.width - 100, self.size.height - 40);
        [self addChild:_nextButton];
        _backButton = [SKSpriteNode spriteNodeWithImageNamed:@"backButton"];
        _backButton.hidden = YES;
        _backButton.position = CGPointMake(80, self.size.height - 40);
        [self addChild:_backButton];
        _goalInstrucLetters = [SKSpriteNode spriteNodeWithImageNamed:@"GoalInstructions"];
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen]bounds].size.height == 568)) {
            _goalInstrucLetters.size = _goalInstrucLetters.size;
        } else {
            _goalInstrucLetters.size = CGSizeMake(_goalInstrucLetters.size.width - 90, _goalInstrucLetters.size.height - 30);
        }
        _goalInstrucLetters.position = CGPointMake((self.size.width / 2) - 17, (self.size.height / 2));
        [self addChild:_goalInstrucLetters];
        _starsInstrucs1 = [SKSpriteNode spriteNodeWithImageNamed:@"StarsInstructions"];
        _starsInstrucs1.position = CGPointMake(self.size.width / 2, self.size.height - 90);
        [self addChild:_starsInstrucs1];
        _leftScreenInstruc = [SKSpriteNode  spriteNodeWithImageNamed:@"BoosterInstructions"];
        _leftScreenInstruc.hidden = YES;
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen]bounds].size.height == 568)) {
            _leftScreenInstruc.size = _leftScreenInstruc.size;
        } else {
            _leftScreenInstruc.size = CGSizeMake(_leftScreenInstruc.size.width - 30, _leftScreenInstruc.size.height );
        }
        _leftScreenInstruc.position = CGPointMake(120,150);
        [self addChild:_leftScreenInstruc];
        _rightScreenInstruc = [SKSpriteNode spriteNodeWithImageNamed:@"FlapInstructions"];
        _rightScreenInstruc.hidden = YES;
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen]bounds].size.height == 568)) {
            _rightScreenInstruc.size = _rightScreenInstruc.size;
        } else {
            _rightScreenInstruc.size = CGSizeMake(_rightScreenInstruc.size.width - 30, _rightScreenInstruc.size.height);
        }
        _rightScreenInstruc.position = CGPointMake(self.size.width - 130, 150);
        [self addChild:_rightScreenInstruc];
        _barScreen = [SKSpriteNode spriteNodeWithImageNamed:@"BarInstructions"];
        _barScreen.hidden = YES;
        _barScreen.position = CGPointMake(self.size.width/2, 100);
        [self addChild:_barScreen];
        _batteryInstruc = [SKSpriteNode spriteNodeWithImageNamed:@"BatteryInstructions"];
        _batteryInstruc.hidden = YES;
        _batteryInstruc.position = CGPointMake(150, self.size.height - 110);
        [self addChild:_batteryInstruc];
        _forceFieldInstruc = [SKSpriteNode spriteNodeWithImageNamed:@"ForcefieldInstructions"];
        _forceFieldInstruc.hidden = YES;
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen]bounds].size.height == 568)) {
            _forceFieldInstruc.size = _forceFieldInstruc.size;
        } else {
            _forceFieldInstruc.size = CGSizeMake(_forceFieldInstruc.size.width - 90, _forceFieldInstruc.size.height);
        }
        _forceFieldInstruc.position = CGPointMake(self.size.width - 245, 120);
        [self addChild:_forceFieldInstruc];
        _roboShieldInstruc = [SKSpriteNode spriteNodeWithImageNamed:@"RoboShieldInstructions"];
        _roboShieldInstruc.hidden = YES;
        _roboShieldInstruc.size = CGSizeMake(_roboShieldInstruc.size.width - 55, _roboShieldInstruc.size.height - 55);
        _roboShieldInstruc.position = CGPointMake(self.size.width - 100, 195);
        [self addChild:_roboShieldInstruc];
        _tipsInstruc = [SKSpriteNode spriteNodeWithImageNamed:@"TipsInstructions"];
        _tipsInstruc.hidden =YES;
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen]bounds].size.height == 568)) {
            _tipsInstruc.size = _tipsInstruc.size;
        } else {
            _tipsInstruc.size = CGSizeMake(_tipsInstruc.size.width - 90, _tipsInstruc.size.height);
        }
        _tipsInstruc.position = CGPointMake(self.size.width - 270, self.size.height - 120);
        [self addChild:_tipsInstruc];
        _andLastyInstruc = [SKSpriteNode spriteNodeWithImageNamed:@"AndLastlyInstructions"];
        _andLastyInstruc.hidden = YES;
        _andLastyInstruc.position = CGPointMake(self.size.width - 300, 130);
        [self addChild:_andLastyInstruc];
        _wiselyInstruc = [SKSpriteNode spriteNodeWithImageNamed:@"WiselyInstructions"];
        _wiselyInstruc.hidden = YES;
        _wiselyInstruc.position = CGPointMake(self.size.width - 180, 90);
        [self addChild:_wiselyInstruc];
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    if ([_menuButton containsPoint:location]) {
        if (_volume == YES) {
            [self runAction:playButton];
        }
        MenuScene *menuScene = [[MenuScene alloc] initWithSize:self.size volume:_volume];
        trans = [SKTransition flipVerticalWithDuration:0.5];
        trans.pausesIncomingScene = NO;
        [self.view presentScene:menuScene transition:trans];
    }
    if ([_nextButton containsPoint:location] && !_nextButton.hidden) {
        if (_volume == YES) {
            [self runAction:playButton];
        }
        if (_counterScreens <= 3) {
             _counterScreens = _counterScreens + 1;
        }
           }
    if ([_backButton containsPoint:location] && !_backButton.hidden) {
        if (_volume == YES) {
            [self runAction:playButton];
        }
        if (_counterScreens >= 0) {
            _counterScreens = _counterScreens - 1;
        }
        }
     }
-(void)update:(NSTimeInterval)currentTime{
    if (_counterScreens < 1) {
        _backButton.hidden = YES;
          _nextButton.hidden = NO;
        _goalInstrucLetters.hidden = NO;
        _starsInstrucs1.hidden = NO;
        _leftScreenInstruc.hidden = YES;
        _rightScreenInstruc.hidden = YES;
        _barScreen.hidden = YES;
    }
    if (_counterScreens == 1) {
        _backButton.hidden = NO;
          _nextButton.hidden = NO;
        _goalInstrucLetters.hidden = YES;
        _starsInstrucs1.hidden = YES;
        _leftScreenInstruc.hidden = NO;
        _rightScreenInstruc.hidden = NO;
        _barScreen.hidden = NO;
        _batteryInstruc.hidden = YES;
        _forceFieldInstruc.hidden =YES;
        _roboShieldInstruc.hidden = YES;
    }
    if (_counterScreens == 2) {
        _backButton.hidden = NO;
         _nextButton.hidden = NO;
        _goalInstrucLetters.hidden = YES;
        _starsInstrucs1.hidden = YES;
        _leftScreenInstruc.hidden = YES;
        _rightScreenInstruc.hidden = YES;
        _barScreen.hidden = YES;
        _batteryInstruc.hidden = NO;
        _forceFieldInstruc.hidden =NO;
        _roboShieldInstruc.hidden = NO;
        _tipsInstruc.hidden = YES;
        _andLastyInstruc.hidden = YES;
        _wiselyInstruc.hidden = YES;
    }
    if (_counterScreens == 3) {
        _backButton.hidden = NO;
        _nextButton.hidden = YES;
        _goalInstrucLetters.hidden = YES;
        _starsInstrucs1.hidden = YES;
        _leftScreenInstruc.hidden = YES;
        _rightScreenInstruc.hidden = YES;
        _barScreen.hidden = YES;
        _batteryInstruc.hidden = YES;
        _forceFieldInstruc.hidden =YES;
        _roboShieldInstruc.hidden = YES;
        _tipsInstruc.hidden = NO;
        _andLastyInstruc.hidden = NO;
        _wiselyInstruc.hidden = NO;
    }
}
@end
