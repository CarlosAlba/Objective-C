//
//  PICalculation.m
//  PI_Calculus
//
//  Created by Alfredo on 11/20/15.
//  Copyright © 2015 Alfredo. All rights reserved.
//

#import "Calculator.h"
@interface Calculator()

@property(nonatomic) NSInteger n;
@property(nonatomic) long double currentPiValue;
@property(nonatomic) BOOL isCalculating;
@property(nonatomic) BOOL shouldContinueCalculating;

@end

@implementation Calculator

-(instancetype)init
{
    if ( self = [super init]){
        [self resetValues];
        return self;
    } else {
        return nil;
    }
}
-(void)startCalculating {
    
    //Wallis Formula is used to calculate the value of PI.
    if(!self.isCalculating)
    {
        self.isCalculating = YES;
        
        if(!self.shouldContinueCalculating){
            
            self.shouldContinueCalculating = YES;
            
            __block long double currentPiValue = self.currentPiValue;
            
            dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                
                long double left;
                long double right;
                
                while (self.shouldContinueCalculating) {
                    
                    self.n++;
                    left =(2.0 * self.n)/(2.0 * self.n - 1.0);
                    right =(2.0 * self.n)/(2.0 * self.n + 1.0);
                    currentPiValue=currentPiValue*left*right;
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.currentPiValue=currentPiValue;
                        [self.delegate didAddAnotherDigit:self.currentPiValue];
                    });
                }
                
            });
        }
    }
}

-(void)stopCalculating{
    
    [self resetValues];
}

-(void)pauseCalculation {
    
    self.shouldContinueCalculating = NO;
    self.isCalculating = NO;
}

-(BOOL)isProcessRuning {
    
    return self.isCalculating;
}

#pragma mark - Helper Methods

- (void) resetValues {
    self.shouldContinueCalculating = NO;
    self.isCalculating = NO;
    self.n = 0;
    self.currentPiValue = 2.0;
}

@end
