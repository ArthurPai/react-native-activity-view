#import "ActivityView.h"
#import "RCTLog.h"

@implementation ActivityView

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(show:(NSDictionary *)args)
{
    NSMutableArray *shareObject = [NSMutableArray array];
    NSString *text = args[@"text"];
    NSURL *url = args[@"url"];
    NSString *imageUrl = args[@"imageUrl"];
    NSString *image = args[@"image"];
    NSData * imageData;
    
    // Try to fetch image
    if (imageUrl) {
        @try {
            imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
        } @catch (NSException *exception) {
            RCTLogWarn(@"Could not fetch image.");
        }
    }
    
    
    // Return if no args were passed
    if (!text && !url && !image && !imageData) {
        RCTLogError(@"[ActivityView] You must specify a text, url, image and/or imageUrl.");
        return;
    }
    
    if (text) {
        [shareObject addObject:text];
    }
    
    if (url) {
        [shareObject addObject:url];
    }
    
    if (image) {
        [shareObject addObject: [UIImage imageNamed: image]];
    } else if (imageData) {
        [shareObject addObject: [UIImage imageWithData: imageData]];
    }
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:shareObject applicationActivities:nil];
    
    // Display the Activity View
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

    /*
     * fix crash on iPad iOS 8.4
     * centering the share popup on screen without any arrows.
     */
    if ([activityView respondsToSelector:@selector(popoverPresentationController)]) {
        CGRect sourceRect = CGRectMake(ctrl.view.center.x, ctrl.view.center.y, 1, 1);
        activityView.popoverPresentationController.sourceView = ctrl.view;
        activityView.popoverPresentationController.sourceRect = sourceRect;
        activityView.popoverPresentationController.permittedArrowDirections = 0;
        [ctrl presentViewController:activityView animated:YES completion:nil];
    } else {
        [ctrl presentViewController:activityView animated:YES completion:nil];
    }
}

@end
