//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jaime Machuca on 6/29/12.
//  Copyright (c) 2012 Jaime Machuca. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"


@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL thisIsTheFirstDecimalPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize brain = _brain;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize thisIsTheFirstDecimalPoint;

- (CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if(self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];        
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }

    
}
- (IBAction)decimalPointPressed:(UIButton *)sender {

    NSString *digit = [sender currentTitle];
    if (userIsInTheMiddleOfEnteringANumber) {
        if (!thisIsTheFirstDecimalPoint) {
            self.display.text = [self.display.text stringByAppendingString:digit];
            self.thisIsTheFirstDecimalPoint = YES;
        } else {
            /* Send Alert View */
 			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Floating Point" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
			[alertView show];
        }
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.thisIsTheFirstDecimalPoint = YES;
    }
}

- (IBAction)enterPressed
{
    if([self.display.text isEqualToString:@"π"])
        {
        [self.brain pushOperand:3.14159];
        }
    else
        {
        [self.brain pushOperand:[self.display.text doubleValue]];
        }
        self.userIsInTheMiddleOfEnteringANumber = NO;
    self.thisIsTheFirstDecimalPoint = NO;
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}


@end
