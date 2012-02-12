//
//  PullToRefreshCell.m
//  AnimeUnderground
//
//  Created by Nacho Lopez on 12/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import "PullToRefreshCell.h"

@implementation PullToRefreshCell
@synthesize pullLabel = pullLabel_;
@synthesize pullActivityIndicator = pullActivityIndicator_;
@synthesize pullImage = pullImage_;

- (void)dealloc {
    [pullLabel_ release];
    [pullActivityIndicator_ release];
    [pullImage_ release];
    [super dealloc];
}
@end
