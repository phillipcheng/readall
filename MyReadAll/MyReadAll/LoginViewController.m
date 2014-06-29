//
//  LoginViewController.m
//  ReadAll
//
//  Created by Cheng Yi on 6/29/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)signup:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    if ([_passwordTxt.text isEqualToString:_retypePassTxt.text]){
        if ([@"" isEqualToString:_passwordTxt.text]){
            alert.title = @"Error";
            alert.message=@"Password can not be null.";
            [alert show];
            return;
        }
        if ([@"" isEqualToString:_userNameTxt.text]){
            alert.title = @"Error";
            alert.message=@"Username can not be null.";
            [alert show];
            return;
        }
        
    }else{
        alert.title = @"Error";
        alert.message=@"Password retyped not equal.";
        [alert show];
        return;
    }
}

- (IBAction)login:(id)sender {
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
