//
//  ViewController.m
//  iOSVZeroDemo
//
//  Created by Prestes, Jefferson on 6/25/15.
//  Copyright (c) 2015 Prestes, Jefferson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <BTDropInViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBraintreeToken];
}

- (void) getBraintreeToken  {
    NSURL *clientTokenServerURL = [NSURL URLWithString:@"https://www.novatrix.com.br/bhdemo/token.php"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenServerURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:clientTokenRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               self.clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               self.btnPay.enabled = TRUE;
                           }];
    
}

#pragma mark call dropin
- (IBAction)callDropIn:(id)sender   {
    
    self.braintree = [Braintree braintreeWithClientToken:self.clientToken];
    
    BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
    
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                             target:self
                                                             action:@selector(userDidCancelPayment)];
    
    dropInViewController.summaryTitle = @"La Gioconda copy";
    dropInViewController.summaryDescription = @"Buy this nice and cheap copy of the famous La Gioconda picture";
    dropInViewController.displayAmount = @"$ 1000.00";
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)userDidCancelPayment    {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark receiving return from dropin
- (void) dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod    {
    [self postNonceToTheServer:paymentMethod.nonce];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) dropInViewControllerDidCancel:(BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) postNonceToTheServer:(NSString *) nonce     {
    
    NSURL *paymentURL = [NSURL URLWithString:@"https://www.novatrix.com.br/bhdemo/checkout.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:paymentURL];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody: [[NSString stringWithFormat:@"payment_method_nonce=%@&amount=1000", nonce] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (connectionError == nil && data != nil)  {
                               
                                   self.transactionID = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Braintree returns"
                                                                               message: self.transactionID
                                                                              delegate:nil
                                                                     cancelButtonTitle:@" OK "
                                                                     otherButtonTitles:nil];
                                   [alert show];
                                   [self.btnPay setEnabled:FALSE];
                                   [self.btnPay setTitle:@" Thanks! " forState:UIControlStateNormal];
                                   
                                   
                               }    else    {
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Braintree returns"
                                                                                   message: connectionError.localizedDescription
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@" OK "
                                                                         otherButtonTitles:nil];
                                   [alert show];
                               }
                               
                           }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
