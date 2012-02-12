//
//  PullToRefreshCell.h
//  AnimeUnderground
//
//  Created by Nacho Lopez on 12/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullToRefreshCell : UIView {
    
    IBOutlet UILabel *pullLabel_;
    IBOutlet UIActivityIndicatorView *pullActivityIndicator_;
    IBOutlet UIImageView *pullImage_;
}

@property (nonatomic, retain) UILabel *pullLabel;
@property (nonatomic, retain) UIActivityIndicatorView *pullActivityIndicator;
@property (nonatomic, retain) UIImageView *pullImage;

@end
