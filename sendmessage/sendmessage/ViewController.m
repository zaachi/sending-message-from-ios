//
//  ViewController.m
//  sendmessage
//
//  Created by Jiri Zachar on 10.04.13.
//  web: http://zaachi.com
//  Copyright (c) 2013 zaachi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize textEmailField;
@synthesize textPhoneNumber;

//create default values (MUST REWRITE)
NSString *messageBody = @"Message Body";
NSString *messageSubject = @"Message subject";

//view did load
- (void)viewDidLoad
{
    //set default values into inputs
    self.textEmailField.text = @"zaachi@gmail.com";
    self.textPhoneNumber.text = @"420608836498";

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 function to send message
 function validate phone number and try send message
 **/
-(IBAction)sendSms:(id)sender{
    //get phone number from input
    NSString *phone = self.textPhoneNumber.text;
    
    //try validate phone number
    if ([self validatePhone:phone] == NO) {
        [self makeAlert:@"Please enter valid phone number"];
        //set responder to this text input
        [self.textPhoneNumber becomeFirstResponder];
        
        return;
    
    }else{
        //test if this device can send message
        if([MFMessageComposeViewController canSendText] ){
            //create new instance from MFMessageComposeViewController
            MFMessageComposeViewController* comp = [[MFMessageComposeViewController alloc] init];
            
            //set properties
            comp.body = messageBody;
            comp.recipients = [NSArray arrayWithObject:phone];
            comp.messageComposeDelegate = self;
            
            //present view controller
            [self presentViewController:comp animated:YES completion:nil];
        }
        else{
            [self makeAlert:@"This device can't send message"];
        }
    }
}


/**
 function send email to recipients
 **/
-(IBAction)sendEmail:(id)sender{
    //get email address from text input
    NSString *email = self.textEmailField.text;
    
    //try validate email
    if ([self validateEmail:email] == NO) {
        [self makeAlert:@"Please enter valid email"];
        //set responder to this text input
        [self.textEmailField becomeFirstResponder];

        return;
    }else{
        //create new instane of MFMailComposeViewController
        MFMailComposeViewController* mc = [[MFMailComposeViewController alloc] init];
        //set delegate
		mc.mailComposeDelegate = self;

        //set message body
		[mc setMessageBody:messageBody isHTML:NO];
        //set message subject
		[mc setSubject:messageSubject];

        //set message recipients
        [mc setToRecipients:[NSArray arrayWithObject:email]];
    
        //open dialog
        [self presentViewController:mc animated:YES completion:nil];
    }
}

#pragma mark - mail composer delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{

    //if result is possible
	if(result == MFMailComposeResultSent || result == MFMailComposeResultSaved || result == MFMailComposeResultCancelled){

        //test result and show alert
        switch (result) {
			case MFMailComposeResultCancelled:
                [self makeAlert:@"Result Cancelled"];
				break;
			case MFMailComposeResultSaved:
                [self makeAlert:@"Result saved"];
                break;
            //message was sent
			case MFMailComposeResultSent:
                [self makeAlert:@"Result Sent"];
				break;
			case MFMailComposeResultFailed:
                [self makeAlert:@"Result Failed"];
				break;
			default:
				break;
        }
    }
    //else exists error
    else if(error != nil){
        //show error
        [self makeAlert:[error localizedDescription]];
	}

    //dismiss view
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - sms composer delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    //test result
	switch (result) {
		case MessageComposeResultCancelled:
            [self makeAlert:@"Result canceled"];
			break;
        //message was sent
		case MessageComposeResultSent:
            [self makeAlert:@"Result sent"];
			break;
		case MessageComposeResultFailed:
            [self makeAlert:@"Result Failed"];
			break;
		default:
			break;
	}

    //dismiss view
    [self dismissViewControllerAnimated:YES completion:nil];

}


/*** HELPERS  ***/


/**
 make alert from nsstring
 **/
-(void)makeAlert:(NSString *)message{
    [[[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

/**
 Validate email address
 **/
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}

/**
 Validate phone number
 **/
-(BOOL)validatePhone : (NSString *)phoneNumber{
    NSString *phoneRegex = @"[0-9]+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];

    return [test evaluateWithObject:phoneNumber];
}

@end
