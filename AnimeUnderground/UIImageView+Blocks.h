//
//  UIImageView+Blocks.h
//  AnimeUnderground
//
//  Created by Nacho Lopez on 20/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"

typedef void(^CustomBlock)(void);

@interface UIImageView (Blocks) <SDWebImageManagerDelegate>

- (void)setImageWithURL:(NSURL *)url andExecuteAtCompletion:(CustomBlock)block;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder andExecuteAtCompletion:(CustomBlock)block;
- (void)cancelCurrentImageLoad;

@end
