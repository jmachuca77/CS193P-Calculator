//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Jaime Machuca on 6/29/12.
//  Copyright (c) 2012 Jaime Machuca. All rights reserved.
//
//  This is the main logic for the calculator, all operations are performed here
//  also the argument stack is kept here.

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)clearStack;
-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;

@end
