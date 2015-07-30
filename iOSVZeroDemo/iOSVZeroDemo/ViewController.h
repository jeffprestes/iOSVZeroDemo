//
//  ViewController.h
//  iOSVZeroDemo
//
//  Created by Prestes, Jefferson on 7/27/15.
//  Copyright (c) 2015 Prestes, Jefferson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Braintree/Braintree.h>

@interface ViewController : UIViewController

@property(nonatomic,strong) Braintree *braintree;
@property(nonatomic,strong) NSString *clientToken;
@property(nonatomic,strong) NSString *transactionId;
@property(nonatomic,weak) IBOutlet UIButton *btnPay;

- (IBAction)callDropIn:(id)sender;

@end

