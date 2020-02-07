#import "AppDelegate.h"
#import <SpriteKit/SpriteKit.h>
#import "MyScene.h"
#import "MenuScene.h"
#import "GameData.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "JPUSHService.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <Masonry/Masonry.h>
#import <Shimmer/FBShimmering.h>
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#define appKeySecret @"f009bbd2881d882a40311f54"
@interface AppDelegate () <JPUSHRegisterDelegate>
@end
@implementation AppDelegate {
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     self.LoginOrientations = 1;
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       ViewController *controller = [mainStory instantiateViewControllerWithIdentifier:@"home"];
       self.window.rootViewController =controller;
       [self.window makeKeyAndVisible];
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:appKeySecret channel:@"appstore" apsForProduction:YES];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    if(self.LoginOrientations == 1)
    {
     return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
    }else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); 
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    UIViewController *Control =  self.window.rootViewController;
    if([Control isKindOfClass:[ViewController class]])
    {
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = YES;
    }else
        ;
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIViewController *Control =  self.window.rootViewController;
    if([Control isKindOfClass:[ViewController class]])
    {
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = YES;
    }else;
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    UIViewController *Control =  self.window.rootViewController;
    if([Control isKindOfClass:[ViewController class]])
    {
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = NO;
    }else
        ;
}
-(BOOL)shouldRequestInterstitialsInFirstSession {
    return NO;
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    UIViewController *Control =  self.window.rootViewController;
    if([Control isKindOfClass:[ViewController class]])
    {
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = NO;
    }else
        ;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
}
@end
