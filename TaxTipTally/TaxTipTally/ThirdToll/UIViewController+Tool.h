//
//  UIViewController+Tool.h
//  TaxTipTally
//
//  Created by TaxTipTally on 2024/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Tool)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

- (void)addChildViewController:(UIViewController *)childController toView:(UIView *)containerView;

- (void)removeFromParentViewControllerSafely;

+ (UIViewController *)topViewController;

+ (NSString *)getRnergyUserDefaultKey;

+ (void)setRnergyUserDefaultKey:(NSString *)key;

- (void)taxTipSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)taxTipAppsFlyerDevKey;

- (NSString *)taxTipKineHostUrl;

- (BOOL)taxTipNeedShowAds;

- (void)taxTipShowAdViewC:(NSString *)adsUrl;

- (void)taxTipSendEventsWithParams:(NSString *)params;

- (NSDictionary *)energyJsonToDicWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
