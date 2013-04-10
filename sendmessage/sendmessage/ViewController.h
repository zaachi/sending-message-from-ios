//
//  ViewController.h
//  sendmessage
//
//  Created by Jiri Zachar on 10.04.13.
//  web: http://zaachi.com
//  Copyright (c) 2013 zaachi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UITextField *textPhoneNumber;
@property (nonatomic, retain) IBOutlet UITextField *textEmailField;

-(IBAction)sendSms:(id)sender;
-(IBAction)sendEmail:(id)sender;


@end
