//
//  MenuCell.m
//  AnimeUnderground
//
//  Created by Nacho Lopez on 10/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

@synthesize titleImg = titleImg_;
@synthesize titleLbl = titleLbl_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)dealloc {
    [titleImg_ release];
    [titleLbl_ release];
    [super dealloc];
}
@end
