//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Jaime Machuca on 6/29/12.
//  Copyright (c) 2012 Jaime Machuca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;

@end
