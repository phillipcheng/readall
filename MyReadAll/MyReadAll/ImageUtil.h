//
//  ImageUtil.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/19/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

@interface ImageUtil : NSObject

extern int const IMAGE_TYPE_JPEG;
extern int const IMAGE_TYPE_PNG;
extern int const IMAGE_TYPE_GIF;
extern int const IMAGE_TYPE_TIFF;

+ (int) contentTypeForImageData:(NSData *)data;

@end