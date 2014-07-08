//
//  AppToolBar.h
//  ReadAll
//
//  Created by Cheng Yi on 7/7/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttrChangedListener.h"
#import "MyReadingsPostProcess.h"
#import "SelectableCollection.h"

@interface AppToolBar : NSObject<AttrChangedListener, MyReadingsPostProcess>
@property (nonatomic) UIBarButtonItem *loginBarButton;
@property (nonatomic) UIBarButtonItem *addMyReadingsBtn;
@property (nonatomic) UIBarButtonItem *delMyReadingsBtn;
@property (nonatomic) UIBarButtonItem *selMyReadingsBBItem;

-(id) init:(id<SelectableCollection>) selectableCollection navCtrl:(UINavigationController*)navCtrl;
-(NSArray*) getButtonArray;
-(void) setMyReadingMode;

@end
