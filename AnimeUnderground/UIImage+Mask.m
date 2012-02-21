//
//  UIImage+Mask.m
//  AnimeUnderground
//
//  Created by Nacho Lopez on 20/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import "UIImage+Mask.h"

@implementation UIImage (Mask)

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage; 
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
}

@end
