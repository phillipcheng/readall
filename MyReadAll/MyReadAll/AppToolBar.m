//
//  AppToolBar.m
//  ReadAll
//
//  Created by Cheng Yi on 7/7/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "AppToolBar.h"
#import "CRApp.h"
#import "FirstViewController.h"
#import "LoginViewController.h"

@interface AppToolBar()
@property(nonatomic) CRBookWSClient* wsClient;
@property(nonatomic) id<SelectableCollection> selCol;
@property(nonatomic) UINavigationController* navCtrl;
@end

@implementation AppToolBar

-(id) init:(id<SelectableCollection>) selectableCollection navCtrl:(UINavigationController*)navCtrl{
    _selCol = selectableCollection;
    _navCtrl = navCtrl;
    _wsClient = [CRApp getWSClient];
    [CRApp addAttrChangedListener:self];
    return self;
}

//for attribute changed listener
-(void) attrChanged:(id) sender attrName:(NSString*) attrName oldValue:(id) oldValue newValue:(id) newValue{
    if (sender==[CRApp class]){
        if ([attrName isEqualToString:@"userId"]){
            [self setUserId];
        }
    }
}

- (NSArray*) getButtonArray;
{
    NSString* loginTitle=@"Login";
    NSString* userId = [CRApp getUserId];
    if (userId!=nil && ![@"" isEqualToString:userId]){
        loginTitle = userId;
    }
    
    _loginBarButton = [[UIBarButtonItem alloc] initWithTitle:loginTitle style:UIBarButtonItemStyleBordered target:self action:@selector(loginClick)];
    
    _selMyReadingsBBItem= [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStyleBordered target:self action:@selector(myReadingClick)];
    
    _addMyReadingsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addMyReadings)];
    
    _delMyReadingsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Del" style:UIBarButtonItemStyleBordered target:self action:@selector(delMyReadings)];
    
    return[[NSArray alloc] initWithObjects:_loginBarButton, _selMyReadingsBBItem, _addMyReadingsBtn, _delMyReadingsBtn, nil];
}

-(void) loginClick{
    LoginViewController* loginVC = [[_navCtrl storyboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [_navCtrl pushViewController:loginVC animated:TRUE];
}

-(void) setUserId{
    NSString* uid = [CRApp getUserId];
    if (uid!=nil && ![@"" isEqualToString:uid]){
        [_loginBarButton setTitle:uid];
        [_addMyReadingsBtn setEnabled:true];
        [_delMyReadingsBtn setEnabled:true];
    }else{
        _loginBarButton.title=@"Login";
        [_addMyReadingsBtn setEnabled:false];
        [_delMyReadingsBtn setEnabled:false];
    }
}

- (void)myReadingClick{
    //TODO: do not let go to my reading if not logged in
    BOOL nextMyReadingState = ![CRApp isMyReading];
    NSString* userId = [CRApp getUserId];
    if (nextMyReadingState){
        if (userId==nil||[@"" isEqualToString:userId]){
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.title = @"Info";
            alert.message = @"Please login to use this feature.";
            [alert show];
            return;
        }else{
            //keep catId to nil
        }
    }
    if ([CRApp isMyReading]){
        [CRApp setMyReading:false];
        _selMyReadingsBBItem.title=@"All";
    }else{
        [CRApp setMyReading:true];
        _selMyReadingsBBItem.title=@"Mine";
    }
}

- (void)addMyReadings {
    NSString* uid = [CRApp getUserId];
    if (uid!=nil && ![@"" isEqualToString:uid]) {
        [_wsClient asyncAddMyReading:uid ids:[_selCol getSelected] postProcessor:self];
    }else{
        NSLog(@"uid is nil");
    }
}

- (void)delMyReadings{
    NSString* uid = [CRApp getUserId];
    if (uid!=nil && ![@"" isEqualToString:uid]) {
        [_wsClient asyncDelMyReading:uid ids:[_selCol getSelected] postProcessor:self];
    }else{
        NSLog(@"uid is nil");
    }
}

//for myreading post process
-(void) myReadingPostProcess:(NSString*) userName ids:(NSMutableArray*) ids rowsAffected:(int) rowsAffected err:(NSError*) err{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    if (rowsAffected<=0){
        alert.title = @"Error";
        alert.message=@"might already added.";
    }else{
        alert.title = @"Succees";
        alert.message = [NSString stringWithFormat: @"%d records updated.", rowsAffected];
    }
    [ids removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

@end
