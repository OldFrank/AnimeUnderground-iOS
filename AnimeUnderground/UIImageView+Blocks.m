//
//  UIImageView+Blocks.m
//  AnimeUnderground
//
//  Created by Nacho Lopez on 20/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import "UIImageView+Blocks.h"
#import "SDWebImageManager.h"
#import <objc/runtime.h>


@implementation UIImageView (Blocks)

static char overviewKey;

- (void)setImageWithURL:(NSURL *)url andExecuteAtCompletion:(CustomBlock)block;
{
    [self setImageWithURL:url placeholderImage:nil andExecuteAtCompletion:block];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder andExecuteAtCompletion:(CustomBlock)block;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    objc_setAssociatedObject (self,
                              &overviewKey,
                              block,
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
    CustomBlock block = (CustomBlock)objc_getAssociatedObject(self, &overviewKey);
    self.image = image;
    if (block) {
        block(); 
    }
    objc_setAssociatedObject(self, &overviewKey, nil, OBJC_ASSOCIATION_ASSIGN);
}

@end
