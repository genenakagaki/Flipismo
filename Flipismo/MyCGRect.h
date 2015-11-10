//
//  MyCGRect.h
//  Flipismo
//
//  Created by User on 11/9/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCGRect : NSObject

- (instancetype)initWithCGRect:(CGRect)cgRect;

@property (nonatomic) CGRect cgRect;

@end
