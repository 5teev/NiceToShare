//
//  SEDIFYActivityProvider.m
//  NiceToShare
//
//  Created by Steve Milano on 8/2/13.
//  No Copyright (c) 2013. All rights reserved.
//

#import "SEDIFYActivityProvider.h"

@interface SEDIFYActivityProvider ()
@property (nonatomic,retain) NSString * sharingString;
@property (nonatomic,retain) UIImage * sharingImage;
@end

@implementation SEDIFYActivityProvider

@synthesize sharingString = _sharingString, sharingImage = _sharingImage;

- (id) initWithSharingString:(NSString *)_string
{
    self = [super init];
    if ( self )
    {
        _sharingString = _string;
        _sharingImage = [UIImage imageNamed:@"SaveMe"];
    }
    return self;
}

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    if ( [activityType isEqualToString:UIActivityTypeSaveToCameraRoll] )
    {
        NSLog(@"sharing an image?: %@",self.sharingImage);
        return self.sharingImage;
    }

    if ( [activityType isEqualToString:UIActivityTypeCopyToPasteboard] )
    {
        return [NSString stringWithFormat:@"You copied “%@”",self.sharingString];
    }

    if ( [activityType isEqualToString:UIActivityTypePostToWeibo] )
    {
        return [NSString stringWithFormat:@"A Weibo post about %@ #weibo",self.sharingString];
    }

    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
    {
        return [NSString stringWithFormat:@"A tweet about %@ #twitter",self.sharingString];
    }

    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
    {
        return [NSString stringWithFormat:@"A facebook post about %@",self.sharingString];
    }

    if ( [activityType isEqualToString:UIActivityTypeMessage] )
    {
        return [NSString stringWithFormat:@"SMS message about %@.",self.sharingString];
    }

    if ( [activityType isEqualToString:UIActivityTypeMail] )
    {
        return [NSString stringWithFormat:@"<html><head><title>Email about %@</title></head><body>My email about %@.<br><br>This can be <strong>long</strong> or <em>short</em>.</body></html>",self.sharingString,self.sharingString];
    }
    

    return nil;
}

- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"placeholding";
}

@end
