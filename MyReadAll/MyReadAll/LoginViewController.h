//
//  LoginViewController.h
//  ReadAll
//
//  Created by Cheng Yi on 6/29/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginPostProcess.h"
#import "SignupPostProcess.h"

extern int const ALERT_TAG_LOGIN_SUCCESS;
extern int const ALERT_TAG_SIGNUP_SUCCESS;

@interface LoginViewController : UIViewController <LoginPostProcess, SignupPostProcess, UIAlertViewDelegate>
- (IBAction)signup:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UITextField *retypePassTxt;

@end
