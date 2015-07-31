#Mobile Payments Workshop

This is the project and presentation of **Mobile Payments Workshop for iOS** using [Braintree v.zero](https://www.braintreepayments.com/v.zero) and [DropIn](https://developers.braintreepayments.com/ios+php/guides/drop-in).

Each step in this project-tutorial is branch. You can clone and checkout step1 and following the instructions to execute next ones. If you want to compare with your code or copy the code of the example, just checkout the desired step.

This tutorial does not cover the server-side part. To see server-side code used in this tutorial please look at my [Battlehack Demo](https://github.com/jeffprestes/bhdemo) where I have implemented it using PHP.

To follow this tutorial you must have installed [CocoaPods](https://guides.cocoapods.org/using/getting-started.html). 

##List of content

* Step 1 - New Project
* Step 2 - Setup Pod file with Braintree and run ``pod install`` command
* Step 3 - Open the workspace file and define URL Types at Info section
* Step 4 - Design your page and define your App Icon. Leave the Buy button disabled. It will be enabled when the App gets the Braintree Token from the Server Side.
* Step 5 - Define the URL types at _didFinishLaunchingWithOptions_ and create a method that opens an URL handled by Braintree class at ***AppDelegate*** class
* Step 6 - At ***ViewController.h*** import *Braintree* header file and create a *Braintree*, *NSString* for the clientToken, *NSString* for the transactionID, *IBOutlet* objects and define a method to handle the *IBAction*. In the ***Storyboard*** refer the button with IBOutlet and IBAction at ***ViewController.h***.
* Step 7 - Make the **ViewController.m** adopt *BTDropInViewControllerDelegate* protocol. Also, implement a method to get the Braintree Token from server side and enable the 'Pay' button if the Token succesfully obtained. Add a call to this method into *viewDidLoad* method. Implement *callDropIn*, *userDidCancelPayment*,  *dropInViewControllerDidCancel* and *dropInViewController* methods. Leave them empty for while. Run the project and you will see the 'Pay' button get enabled.
* Step 8 - At *callDropIn* method you must define details of the transaction (value, purchase information, etc), the token to the Braintree object and open DropIn. At *dropInViewControllerDidCancel* and *dropInViewController* methods implement a code to dismiss the controller.
* Step 9 - You must create a method to post the Nonce (received from DropIn) to server side. After receives the response from the Server Side - if it was successfully you must receive the transactionId - you must show a success message to the customer. This method you have created must be called from the *dropInViewController* method. The *dropInViewController* is the method called by DropIn after customer has informed his financial data.

Done.
Now you have an App with Mobile Payment enabled.

Any questions, please email me: <jefferson.prestes@braintreepayments.com>