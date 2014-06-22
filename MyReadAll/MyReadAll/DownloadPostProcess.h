//
//  DownloadPostProcess.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/19/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

@protocol DownloadPostProcess <NSObject>

-(void) postProcess:(NSString*) url result:(NSData*) result ppParam:(id) ppParam;

@end