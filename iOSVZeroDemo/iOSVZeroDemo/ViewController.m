//
//  ViewController.m
//  iOSVZeroDemo
//
//  Created by Prestes, Jefferson on 7/27/15.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma GetToken
- (void) getBraintreeToken    {
    
    NSURL *clientTokenServerURL = [NSURL URLWithString:@"https://www.novatrix.com.br/bhdemo/token.php"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenServerURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    NSLog(@"Initializing call to server side to get Braintree Token");
    
    [NSURLConnection sendAsynchronousRequest:clientTokenRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               self.clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"Token obtained: %@", self.clientToken);
                               
                               self.btnPay.enabled = TRUE;
                               NSLog(@"Button Pay is enabled");
                           }];
}

#pragma DropIn Call
- (void) callDropIn:(id)sender  {
    
    self.braintree = [Braintree braintreeWithClientToken:self.clientToken];
    
    BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
    
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                          target:self
                                                                                                          action:@selector(userDidCancelPayment)];
    dropInViewController.summaryTitle = @"La Gioconda Copy";
    dropInViewController.summaryDescription = @"Buy this nice and cheap copy of the famous La Gioconda picture";
    dropInViewController.displayAmount = @"$ 1000.00";
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void) dropInViewControllerDidCancel:(BTDropInViewController *)viewController     {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma Method called when DropIn returns
- (void) dropInViewController:(BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod     {
    [self postNonceToServer:paymentMethod.nonce];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) postNonceToServer:(NSString *) nonce  {
    
    NSURL *paymentUrl = [NSURL URLWithString:@"https://www.novatrix.com.br/bhdemo/checkout.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:paymentUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody: [[NSString stringWithFormat:@"payment_method_nonce=%@&amount=1000", nonce] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               NSString *title;
                               NSString *message;
                               
                               if (connectionError==nil && data != nil)     {
                                   self.transactionId = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   title = @"Braintree's return";
                                   message = self.transactionId;
                                   self.btnPay.enabled = false;
                                   self.btnPay.titleLabel.text = @"Buy it again!";
                                   [self getBraintreeToken];
                                   
                               }    else    {
                                   NSLog(@"Error when try to connect to server side to execute the transaction: %@", connectionError.description);
                                   title = @"Error";
                                   message = [NSString stringWithFormat:@"Error when try to connect to the Server: %@",connectionError.description];
                                   
                               }
                               
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                               message:message
                                                                              delegate:nil
                                                                     cancelButtonTitle:@ " OK "
                                                                     otherButtonTitles:nil];
                               [alert show];
                           }];
}

@end
