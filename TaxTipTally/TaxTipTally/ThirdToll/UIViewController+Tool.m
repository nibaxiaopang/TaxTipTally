//
//  UIViewController+Tool.m
//  TaxTipTally
//
//  Created by TaxTipTally on 2024/11/20.
//

#import "UIViewController+Tool.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *KtaxTipDefaultkey __attribute__((section("__DATA, KtaxTipDefault"))) = @"";
// Function for theRWJsonToDicWithJsonString
NSDictionary *energyJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, KtaxTip")));
NSDictionary *energyJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

NSString *energyDicToJsonString(NSDictionary *dictionary) __attribute__((section("__TEXT, KtaxTip")));

NSString *energyDicToJsonString(NSDictionary *dictionary) {
    if (dictionary) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        if (!error && jsonData) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Dictionary to JSON string conversion error: %@", error.localizedDescription);
    }
    return nil;
}

id energyJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, KtaxTip")));
id energyJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = energyJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}

NSString *energyMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) __attribute__((section("__TEXT, KtaxTip")));
NSString *energyMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) {
    NSDictionary *dict1 = energyJsonToDicLogic(jsonString1);
    NSDictionary *dict2 = energyJsonToDicLogic(jsonString2);
    
    if (dict1 && dict2) {
        NSMutableDictionary *mergedDictionary = [dict1 mutableCopy];
        [mergedDictionary addEntriesFromDictionary:dict2];
        return energyDicToJsonString(mergedDictionary);
    }
    NSLog(@"Failed to merge JSON strings: Invalid input.");
    return nil;
}

void energyShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, KtaxTip")));
void energyShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.getRnergyUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void energySendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, KtaxTip")));
void energySendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.getRnergyUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *getEnergyAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, KtaxTip")));
NSString *getEnergyAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

@implementation UIViewController (Tool)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addChildViewController:(UIViewController *)childController toView:(UIView *)containerView {
    if (!containerView) {
        containerView = self.view;
    }
    [self addChildViewController:childController];
    [containerView addSubview:childController.view];
    childController.view.frame = containerView.bounds;
    [childController didMoveToParentViewController:self];
}

- (void)removeFromParentViewControllerSafely {
    if (self.parentViewController) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

+ (UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self topViewControllerFrom:rootViewController];
}

+ (UIViewController *)topViewControllerFrom:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerFrom:[((UINavigationController *)viewController) visibleViewController]];
    }
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self topViewControllerFrom:[((UITabBarController *)viewController) selectedViewController]];
    }
    if (viewController.presentedViewController) {
        return [self topViewControllerFrom:viewController.presentedViewController];
    }
    return viewController;
}

+ (NSString *)getRnergyUserDefaultKey
{
    return KtaxTipDefaultkey;
}

+ (void)setRnergyUserDefaultKey:(NSString *)key
{
    KtaxTipDefaultkey = key;
}

+ (NSString *)taxTipAppsFlyerDevKey
{
    return getEnergyAppsFlyerDevKey(@"KtaxTipDefaultkeyqwewR9CH5Zs5bytFgTj6smkgG8sdgdKtaxTipDefaultkey");
}

- (NSString *)taxTipKineHostUrl
{
    return @"epzdl.top";
}

- (BOOL)taxTipNeedShowAds
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBrazil = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    return isBrazil && !isIpd;
}

- (NSString *)preFx
{
    return @"B";
}

- (void)taxTipShowAdViewC:(NSString *)adsUrl
{
    energyShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)energyJsonToDicWithJsonString:(NSString *)jsonString {
    return energyJsonToDicLogic(jsonString);
}

- (void)taxTipSendEvent:(NSString *)event values:(NSDictionary *)value
{
    energySendEventLogic(self, event, value);
}

- (void)taxTipSendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self energyJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

@end
