//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jaime Machuca on 6/29/12.
//  Copyright (c) 2012 Jaime Machuca. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

// Here _operandStack is added to avoid having an instance variable of the samename
@synthesize operandStack = _operandStack;


// This Method is the getter for the operand Stack. Is overriding the synthesized one.
-(NSMutableArray *)operandStack{
    if(!_operandStack){
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

// This Method is used to add an object to the operand stack. It recieves a double number
// and converts it into an object format NSNumber because the NSMutableArray only stores
// Objects.
-(void)pushOperand:(double)operand{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

// This Method is used to get the top most operando on the stack and to remove it from the
// stack. 
-(double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if(operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];    
}

// This is the main method that does all of the calculations, it returns a double with the
// operation result.
-(double)performOperation:(NSString *)operation{
    double result = 0;
    
    if ([operation isEqualToString:@"+"])
    {
        result = [self popOperand] + [self popOperand];
    }
    else if ([operation isEqualToString:@"*"])
    {
        result = [self popOperand] * [self popOperand];
    }
    else if ([operation isEqualToString:@"-"])  
    {
        /* here you have to take care of the order so that the operation is done correctly */
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend; 
    }
    else if ([operation isEqualToString:@"/"])
    {
        double divisor = [self popOperand];
        
        /* In this case we have to protect against a division by 0 */
        if (divisor)
        {
            result = [self popOperand] / divisor;
        }
        else
        {
            /* Send Alert View to tell the user incorrect data is being used */
 			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Divide by 0" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
			[alertView show];    
        }
    }
    else if ([operation isEqualToString:@"SIN"])
    {
        result = sin([self popOperand]);
    }
    else if ([operation isEqualToString:@"COS"])
    {
        result = cos([self popOperand]);
    }
    else if ([operation isEqualToString:@"SQRT"])
    {
        result = sqrt([self popOperand]);
    }
    else if ([operation isEqualToString:@"π"])
    {
        result = M_PI;
    }

    
    [self pushOperand:result];
    
    return result;
}

// This method clears the operandstack
-(void)clearStack
{
    [self.operandStack removeAllObjects];
}

@end
