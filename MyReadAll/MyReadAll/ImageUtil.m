//
//  ImageUtil.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/19/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageUtil.h"



int const IMAGE_TYPE_JPEG=0;
int const IMAGE_TYPE_PNG=1;
int const IMAGE_TYPE_GIF=2;
int const IMAGE_TYPE_TIFF=3;

@implementation ImageUtil

+(int) contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return IMAGE_TYPE_JPEG;
        case 0x89:
            return IMAGE_TYPE_PNG;
        case 0x47:
            return IMAGE_TYPE_GIF;
        case 0x49:
        case 0x4D:
            return IMAGE_TYPE_TIFF;
    }
    return -1;
}

@end