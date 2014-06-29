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

- (IBAction)btnClick:(id)sender {
    if (_chkSel){
        _chkSel = false;
        [_selBtn setSelected:false];
    }else{
        _chkSel = true;
        [_selBtn setSelected:true];
    }
}
@end
