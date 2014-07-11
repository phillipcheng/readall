//
//  WebPageViewController.h
//  ReadAll
//
//  Created by Cheng Yi on 7/11/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "PageViewController.h"
#import "CRApp.h"

@interface WebPageViewController : PageViewController< NSURLConnectionDelegate, NSURLConnectionDownloadDelegate, NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
