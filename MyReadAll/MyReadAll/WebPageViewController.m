//
//  WebPageViewController.m
//  ReadAll
//
//  Created by Cheng Yi on 7/11/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "WebPageViewController.h"

@interface WebPageViewController ()

@end

NSMutableData* receivedData;
NSURLConnection *theConnection;
NSString* baseUrl;

@implementation WebPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

-(void) doMySearch:(NSString*) strUrl pageCondition:(PageCondition *)pc{
    NSString* contentXPath = [CRApp getTemplate:[self.book getId]].contentXPath;
    baseUrl = strUrl;
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
    receivedData = [NSMutableData dataWithCapacity: 0];
    theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (!theConnection) {
        // Release the receivedData object.
        receivedData = nil;
        
        // Inform the user that the connection failed.
    }
    //[_webView loadRequest:requestURL];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    theConnection = nil;
    receivedData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_webView loadData:receivedData MIMEType:@"text/html" textEncodingName:@"GBK" baseURL:nil];
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    
    theConnection = nil;
    receivedData = nil;
}

-(void) doMyPostProcess:(NSData*) result{
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
