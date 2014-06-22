//
//  PatternResult.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/14/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

@interface PatternResult:NSObject

extern int const pt_x_s_yyy_zzz;
extern int const pt_0x_s_yyy_zzz;
extern int const pt_pxp_s_yyy_zzz;
extern int const pt_0x0y_zzz;
extern int const pt_list;

extern int const IM_INC;
extern int const IM_DEC;

@property (nonatomic) int patternType;
@property (nonatomic) int digitNum;
@property (nonatomic) int startImageCount;
@property (nonatomic) NSString* patternSuffix;
@property (nonatomic) NSString* patternPrefix;
@property (nonatomic) NSString* postFix;
@property (nonatomic) NSString* sep;
@property (nonatomic) int incMode;
@property (nonatomic) NSArray* ppUrls;

-(NSString*) toJSON;
-(void) fromJSONString:(NSString*) jsonString;
-(void) fromJSONObject:(NSDictionary*) jsonDict;
+(NSString*) guessUrl:(PatternResult*) pr atDelta:(int) delta;


@end