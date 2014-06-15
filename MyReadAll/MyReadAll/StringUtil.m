//
//  StringUtil.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/14/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringUtil.h"

@implementation StringUtil

+ (NSString*) getStringFromNum:(int) num digitCount:(int) minDigits{
    NSString* strNum = [NSString stringWithFormat:@"%d", num];
    NSString* retNum = @"";
    if ([strNum length]< minDigits){
        for (int i=0; i<minDigits-[strNum length]; i++){
            retNum = [NSString stringWithFormat:@"%@%d", retNum, 0];
        }
        retNum =[NSString stringWithFormat:@"%@%@", retNum, strNum];
        return retNum;
    }else{
        return strNum;
    }
}

@end
