//
//  UIImageView+Mask.m
//  AnimeUnderground
//
//  Created by Nacho Lopez on 21/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import "UIImageView+Mask.h"
#import "SDWebImageManager.h"
#import "UIImage+RoundedCorner.h"
#import <objc/runtime.h>


@implementation UIImageView (Mask)

static char overviewKey;

- (void)setImageWithURL:(NSURL *)url withMask:(UIImage*)mask
{
    [self setImageWithURL:url placeholderImage:nil withMask:mask];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder withMask:(UIImage*)mask
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    objc_setAssociatedObject (self,
                              &overviewKey,
                              mask,
                              OBJC_ASSOCIATION_ASSIGN
                              );    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    UIImage *mask = (UIImage*)objc_getAssociatedObject(self, &overviewKey);
    self.image = [image roundedCornerImage:4 borderSize:1];
    
    objc_setAssociatedObject(self, &overviewKey, nil, OBJC_ASSOCIATION_ASSIGN);
}

@end
