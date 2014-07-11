//
//  ReadTabViewController.m
//  ReadAll
//
//  Created by Cheng Yi on 7/7/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "ReadTabViewController.h"
#import "AppToolBar.h"
#import "CRApp.h"

@interface ReadTabViewController ()
@end

@implementation ReadTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"init tabbarviewcontroller");
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [CRApp buildTemplateCache];
    });
    
    _appToolBar = [[AppToolBar alloc]init:(id<SelectableCollection>)[self selectedViewController] navCtrl:self.navigationController];
    [self.navigationItem setRightBarButtonItems:[_appToolBar getButtonArray]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
