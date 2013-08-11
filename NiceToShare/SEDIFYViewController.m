//
//  SEDIFYViewController.m
//  NiceToShare
//
//  Created by Steve Milano on 8/2/13.
//  No Copyright (c) 2013. All rights reserved.
//

#import "SEDIFYViewController.h"
#import "SEDIFYActivityProvider.h"
#import <MessageUI/MessageUI.h>

/*
 this isn't used, but it's another approach to handling the mail form
 and setting a subject through a swizzled method
 */
#import <objc/message.h>
static void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL)
{
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method overrideMethod = class_getInstanceMethod(c, overrideSEL);

    if (class_addMethod(c, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(c, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

@implementation MFMailComposeViewController (force_subject)

- (void)setMessageBodySwizzled:(NSString*)body isHTML:(BOOL)isHTML
{
    if (isHTML == YES) {
        NSRange range = [body rangeOfString:@"<title>.*</title>" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:body];
            [scanner setScanLocation:range.location+7];
            NSString *subject = [NSString string];
            if ([scanner scanUpToString:@"</title>" intoString:&subject] == YES) {
                [self setSubject:subject];
            }
        }
    }
    [self setMessageBodySwizzled:body isHTML:isHTML];
}

@end


@interface SEDIFYViewController ()

@end

@implementation SEDIFYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapShareButton:(UIButton *)sender
{

    SEDIFYActivityProvider * activityProvider = [[SEDIFYActivityProvider alloc] initWithSharingString:@"THINGTOSHARE"];
    NSArray * items = @[activityProvider];

    UIActivityViewController * activityViewController = [[UIActivityViewController alloc]
                                                         initWithActivityItems:items applicationActivities:nil];

    // for email (only?) you must explicity set the title here because of a bug in how iOS handles UIActivitiy objects
    [activityViewController setValue:[NSString stringWithFormat:@"Check out %@",@"THINGTOSHARE"] forKey:@"subject"];
//    [activityViewController setValue:[NSString stringWithFormat:@"faker@fake.com"] forKey:@"recipient:"];

    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeSaveToCameraRoll];

    [activityViewController setCompletionHandler:^(NSString * sharingActivityIdentifier, BOOL success){
        if ( success ) {
            NSLog(@"finished sharing: %@",sharingActivityIdentifier);
        } else if ( sharingActivityIdentifier ) {
            NSLog(@"abandoned sharing via %@",sharingActivityIdentifier);
        } else {
            NSLog(@"no sharing activity selected");
        }
    }];

    [self presentViewController:activityViewController animated:YES completion:^{
        NSLog(@"this runs right after the view controller\n%@\nis presented", activityViewController);
    }];
}

@end


