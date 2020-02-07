#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import  <iAd/iAd.h>
@interface ViewController : UIViewController <UINavigationControllerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic)   SKTextureAtlas *items;
@property (strong, nonatomic)  SKTextureAtlas *shield;
@property (strong, nonatomic) SKTextureAtlas *images;
-(void)shareButton;
@end
