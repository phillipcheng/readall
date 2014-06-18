//
//  TestCRBookWSClient.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/18/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../MyReadAll/CRBookWSClient.h"

@interface TestCRBookWSClient : XCTestCase
@property (nonatomic) CRBookWSClient* wsClient;
@end

@implementation TestCRBookWSClient

- (void)setUp {
    [super setUp];
    _wsClient = [[CRBookWSClient alloc]init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetVolumesByName {
    NSArray* array = [_wsClient getVolumesByName:@"三国演义" offset:0 limit:10];
    NSLog(@"%@", [array description]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
