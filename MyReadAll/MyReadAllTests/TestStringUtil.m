//
//  TestStringUtil.m
//  ReadAll
//
//  Created by Cheng Yi on 6/14/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StringUtil.h"

@interface TestStringUtil : XCTestCase

@end

@implementation TestStringUtil

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetStringFromNum {
    NSString* ret = [StringUtil getStringFromNum:23 digitCount:3];
    XCTAssertTrue([@"023" isEqual:ret]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
