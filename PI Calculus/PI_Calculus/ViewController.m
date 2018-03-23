//
//  ViewController.m
//  PI_Calculus
//
//  Created by Alfredo on 11/20/15.
//  Copyright © 2015 Alfredo. All rights reserved.
//

#import "ViewController.h"

typedef enum : NSUInteger {
    START = 1,
    STOP = 2,
    PAUSE = 3,
} CalculatorState;

@interface ViewController ()<CalculatorDelegate>

@property(strong,nonatomic)IBOutlet UILabel* piLabel;
@property(strong,nonatomic)IBOutlet UILabel* elapsedTimeLabel;
@property(strong,nonatomic)Calculator* calculator;
@property(nonatomic, assign) NSInteger procesState;
@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) NSDate *lastStartTime;

@property(nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"dd-MM-yyyy HH:mm";
    
    self.calculator = [[Calculator alloc] init];
    self.calculator.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CalculatorDelegate

-(void)didAddAnotherDigit:(long double)pi
{
    // This will check if the state of the background task and task on the main thread are in sync.
    if(self.procesState!=STOP) {
        
        NSNumber *myDoubleNumber = [NSNumber numberWithDouble:pi];
        self.piLabel.text=[myDoubleNumber stringValue];
        NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:self.startTime];
        self.elapsedTimeLabel.text = [NSString stringWithFormat:@"%f",elapsedTime];
        
    } else {
        [self.calculator stopCalculating];
    }
}


#pragma mark - Button Events

-(IBAction)didPressedButton:(UIButton*)sender
{
    switch (sender.tag) {
            
        case START:
            if(self.lastStartTime != 0) {
                self.startTime = self.lastStartTime;
            } else {
                self.startTime = [NSDate date];
            }
            
            self.procesState = START;
            [self.calculator startCalculating];
            break;
            
        case STOP:
            self.procesState = STOP;
            self.lastStartTime = 0;
            [self.calculator stopCalculating];
            break;
            
        case PAUSE:
            self.procesState = PAUSE;
            self.lastStartTime = self.startTime;
            [self.calculator pauseCalculation];
            break;
    }
}
@end
