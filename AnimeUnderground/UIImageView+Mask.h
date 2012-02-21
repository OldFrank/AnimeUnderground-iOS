//
//  UIImageView+Blocks.h
//  AnimeUnderground
//
//  Created by Nacho Lopez on 22/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"

@interface UIImageView (Mask) <SDWebImageManagerDelegate>

- (void)setImageWithURL:(NSURL *)url withMask:(UIImage*)mask;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder withMask:(UIImage*)mask;
- (void)cancelCurrentImageLoad;

@end
