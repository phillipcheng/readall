//
//  LoginViewController.m
//  ReadAll
//
//  Created by Cheng Yi on 6/29/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "LoginViewController.h"
#import "CRApp.h"

int const ALERT_TAG_LOGIN_SUCCESS=1;
int const ALERT_TAG_SIGNUP_SUCCESS=2;

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
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    if ([_passwordTxt.text isEqualToString:_retypePassTxt.text]){
        if ([@"" isEqualToString:_passwordTxt.text]){
            alert.title = @"Error";
            alert.message=@"Password can not be null.";
            [alert show];
            return;
        }
        if ([@"" isEqualToString:_userNameTxt.text]||(_userNameTxt.text==nil)){
            alert.title = @"Error";
            alert.message=@"Username can not be null.";
            [alert show];
            return;
        }
        [[CRApp getWSClient]asyncSignup:_userNameTxt.text pass:_passwordTxt.text postProcessor:self];
    }else{
        alert.title = @"Error";
        alert.message=@"Password retyped not equal.";
        [alert show];
        return;
    }
}

-(void) signupPostProcess:(NSString*) userName password:(NSString*) password result:(NSString*) result err:(NSError *)err{
    NSLog(@"signupPostProcess:%@, %@, %@", userName, password, result);
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    if ([SIGN_UP_SUCCEED isEqualToString:result]){
        alert.title = @"Success";
        alert.message=@"Sign Up succeeded.";
        alert.tag = ALERT_TAG_SIGNUP_SUCCESS;
        [alert addButtonWithTitle:@"Continue to Login.."];
    }else if([USER_EXIST isEqualToString:result]){
        alert.title = @"Error";
        alert.message=@"User Exist.";
    }else{
        alert.title = @"Error";
        alert.message = [NSString stringWithFormat:@"%@:%@", result, [err description]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

- (IBAction)login:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    NSString* password = [_passwordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* username = [_userNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (([@"" isEqualToString:password]||password==nil)||
        ([@"" isEqualToString:username]||username==nil)){
        alert.title = @"Error";
        alert.message = @"Username or Password is empty.";
        [alert show];
        return;
    }else{
        [[CRApp getWSClient]asyncLogin:username pass:password postProcessor:self];
        return;
    }
}

-(void) loginPostProcess:(NSString*) userName password:(NSString*) password result:(NSString*) result err:(NSError *)err{
    NSLog(@"loginPostProcess:%@, %@, %@", userName, password, result);
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    if ([LOGIN_FAILED isEqualToString:result]){
        alert.title = @"Error";
        alert.message=@"Check user/pass";
    }else{
        alert.title = @"Succees";
        alert.message = @"Login succeeded.";
        alert.tag= ALERT_TAG_LOGIN_SUCCESS;
    }
    NSLog(@"loginPostProcess before dispatch.");
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag==ALERT_TAG_LOGIN_SUCCESS){
        if (buttonIndex==0){
            [self.navigationController popViewControllerAnimated:YES];
            //set global userid
            NSString* username = [_userNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [CRApp setUserId:username];
        }
    }else if (alertView.tag == ALERT_TAG_SIGNUP_SUCCESS){
        if (buttonIndex==1){
            [[CRApp getWSClient]asyncLogin:_userNameTxt.text pass:_passwordTxt.text postProcessor:self];
        }
    }
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
