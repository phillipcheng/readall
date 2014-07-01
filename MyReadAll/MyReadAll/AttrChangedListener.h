//
//  AttrChangedListener.h
//  ReadAll
//
//  Created by Cheng Yi on 6/30/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

@protocol AttrChangedListener <NSObject>

-(void) attrChanged:(id) sender attrName:(NSString*) attrName oldValue:(id) oldValue newValue:(id) newValue;

@end