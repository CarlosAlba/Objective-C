//
//  PICalculation.h
//  PI_Calculus
//
//  Created by Alfredo on 11/20/15.
//  Copyright © 2015 Alfredo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Calculator;

@protocol CalculatorDelegate <NSObject>

-(void)didAddAnotherDigit:(long double)pi;

@end

@interface Calculator : NSObject

@property(weak,nonatomic)id<CalculatorDelegate> delegate;

-(void)startCalculating;
-(void)stopCalculating;
-(void)pauseCalculation;

@end
