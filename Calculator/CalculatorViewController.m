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
@property (nonatomic) BOOL equalSignPresentOnStackDisplay;

@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize stackDisplay = _stackDisplay;

@synthesize brain = _brain;

@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize thisIsTheFirstDecimalPoint;
@synthesize equalSignPresentOnStackDisplay;

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

-(void) enterDataIntoStackDisplay:(NSString *)dataForStackDisplay
{
    if ([dataForStackDisplay isEqualToString:@"="])
    {
        self.equalSignPresentOnStackDisplay = YES;
    }
    else if (self.equalSignPresentOnStackDisplay)
    {
        self.stackDisplay.text = [self.stackDisplay.text substringToIndex:[self.stackDisplay.text length]-1];
        self.equalSignPresentOnStackDisplay = NO;
    }
    
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:@" "];
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:dataForStackDisplay];
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    if(self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];        
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }

    
}

- (IBAction)decimalPointPressed:(UIButton *)sender
{
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
        self.display.text = [NSString stringWithFormat:@"0%@", digit];
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.thisIsTheFirstDecimalPoint = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    [self enterDataIntoStackDisplay:self.display.text];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.thisIsTheFirstDecimalPoint = NO;
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    NSString *operation = [sender currentTitle];
    
    [self enterDataIntoStackDisplay:operation];
    
    [self enterDataIntoStackDisplay:@"="];
    
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)changeSign
{
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.text = [NSString stringWithFormat:@"-%@", self.display.text];
    }
    else
    {
        [self.brain pushOperand:-1];
        double result = [self.brain performOperation:@"*"];
        self.display.text = [NSString stringWithFormat:@"%g", result];
        
        [self enterDataIntoStackDisplay:@"+/-"];
    }
}

- (IBAction)clearAllPressed
{
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.thisIsTheFirstDecimalPoint = NO;
    self.equalSignPresentOnStackDisplay = NO;
    
    [self.brain clearStack];
    
    self.stackDisplay.text = @"";
    
}

- (IBAction)backspacePressed
{
    self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
    
    if(![self.display.text length])
    {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

@end
