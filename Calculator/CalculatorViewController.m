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

/*  This Method is used for entering strings into the stack display
    it check to see if there is an equal sign on the display and removes it 
    before entering a new data. */
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

/*  This is the method called when an numbers is pressed on the calculator. It is used
    to pass the number into the display, it checks for the special case when 0 is already
    displayed */
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

/*  This method is called when a decimal point is pressed, it checks to see that the 
    resulting entered value is correct and that two decimal points are not entered
    in case to decimal points are entered a warning is displayed to the user.
    In case the decimal point is the first digit pressed then a 0 is entered first.
 */
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

/*  This is called when the enter key is pressed and is used to send the number
    To the calculator brain to be put on the stack. */
- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    [self enterDataIntoStackDisplay:self.display.text];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.thisIsTheFirstDecimalPoint = NO;
}

/*  This is called when any of the operations are pressed it is used to tell the calcualtor bran
    to perform an operation with the numbers on the stack */
- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    NSString *operation = [sender currentTitle];
    
    [self enterDataIntoStackDisplay:operation];
    
    [self enterDataIntoStackDisplay:@"="];
    
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

/*  This is called when the change sign operation is requested. This operation must behave 
    differently in the case the user is in the middle of entering a number */
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

/*  This is called when clear is pressed it resets the whole calculator and erases the 
    Stack */
- (IBAction)clearAllPressed
{
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.thisIsTheFirstDecimalPoint = NO;
    self.equalSignPresentOnStackDisplay = NO;
    
    [self.brain clearStack];
    
    self.stackDisplay.text = @"";
    
}

/*  This is called when the backspace key is pressed and is used to erase the last entered 
    character. When the last character is errased then 0 is entered in the display. */
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
