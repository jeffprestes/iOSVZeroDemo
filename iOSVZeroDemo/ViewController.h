//
//  ViewController.h
//  iOSVZeroDemo
//
//  Created by Prestes, Jefferson on 6/25/15.
//  Copyright (c) 2015 Prestes, Jefferson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Braintree/Braintree.h>

@interface ViewController : UIViewController

@property(nonatomic,strong) Braintree *braintree;
@property(nonatomic,strong) NSString *clientToken;
@property(nonatomic,strong) NSString *transactionID;
@property(nonatomic,strong) IBOutlet UIButton *btnPay;

- (IBAction)callDropIn:(id)sender;

@end

