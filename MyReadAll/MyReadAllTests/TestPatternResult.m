//
//  TestPatternResult.m
//  ReadAll
//
//  Created by Cheng Yi on 6/14/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../MyReadAll/PatternResult.h"

@interface TestPatternResult : XCTestCase

@end

@implementation TestPatternResult

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJson {
    PatternResult* pr = [[PatternResult alloc]init];
    pr.patternType = pt_list;
    pr.digitNum =2;
    pr.startImageCount=1;
    pr.patternSuffix=@".jpg";
    pr.patternPrefix=@"http://";
    NSMutableArray* ppUrl = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++){
        NSString* str = [[NSString alloc] initWithFormat:@"%d", i];
        [ppUrl addObject:str];
    }
    pr.ppUrls = ppUrl;
    NSString * ret = [pr toJSON];
    XCTAssertNotNil(ret);
    
    PatternResult* pr2 = [[PatternResult alloc]init];
    [pr2 fromJSONString:ret];
    [pr2 toJSON];
    
    XCTAssertTrue([pr isEqual: pr2]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
