//
//  MyCGRect.m
//  Flipismo
//
//  Created by User on 11/9/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "MyCGRect.h"

@implementation MyCGRect

- (instancetype)initWithCGRect:(CGRect)cgRect {
    self = [super init];
    
    if (self) {
        self.cgRect = cgRect;
    }
    
    return self;
}

@end
