//
//  UIImage+Mask.h
//  AnimeUnderground
//
//  Created by Nacho Lopez on 20/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Mask)
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
@end
