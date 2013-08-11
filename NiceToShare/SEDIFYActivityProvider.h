//
//  SEDIFYActivityProvider.h
//  NiceToShare
//
//  Created by Steve Milano on 8/2/13.
//  No Copyright (c) 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEDIFYActivityProvider : UIActivityItemProvider <UIActivityItemSource>

- (id) initWithSharingString:(NSString *)_string;
@end
