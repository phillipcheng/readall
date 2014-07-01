//
//  ReadingViewCell.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/19/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "ReadingViewCell.h"

@implementation ReadingViewCell

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
    }
    
    return self;
}

- (void) myInit{
    if ([_selReadings containsObject:_rid]) {
        [_selBtn setSelected:true];
    }else{
        [_selBtn setSelected:false];
    }
}

- (IBAction)btnClick:(id)sender {
    if (_chkSel){
        _chkSel = false;
        [_selBtn setSelected:false];
        if ([_selReadings containsObject:_rid]){
            [_selReadings removeObject:_rid];
        }
    }else{
        _chkSel = true;
        [_selBtn setSelected:true];
        [_selReadings addObject:_rid];
    }
}
@end
