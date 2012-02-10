//
//  MenuCell.h
//  AnimeUnderground
//
//  Created by Nacho Lopez on 10/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell {
    
    IBOutlet UIImageView *titleImg_;
    IBOutlet UILabel *titleLbl_;
}

@property (nonatomic, retain) UIImageView *titleImg;
@property (nonatomic, retain) UILabel *titleLbl;

@end
