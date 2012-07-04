//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Jaime Machuca on 6/29/12.
//  Copyright (c) 2012 Jaime Machuca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

/* Two properties are added one for the Normal display and one for the  */
/* stack display in order to be able to access thier properties         */
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *stackDisplay;

/* This method was added to avoid repeating the same cose in several places */
-(void) enterDataIntoStackDisplay:(NSString *)dataForStackDisplay;

@end
