//
//  SignupPostProcess.h
//  ReadAll
//
//  Created by Cheng Yi on 6/29/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

@protocol SignupPostProcess <NSObject>

-(void) signupPostProcess:(NSString*) userName password:(NSString*) password result:(NSString*) result err:(NSError*) err;

@end