//
//  WebViewController.h
//  LandscapersIPad
//
//  Created by David Stevenson on 6/17/10.
//  Copyright 2010 Stevenson Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate> {

	UIWebView *webView;
	NSURL *url;
	UIToolbar *toolbar;
	UIBarButtonItem *forwardButton;
	UIBarButtonItem *backButton;

}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;

- (IBAction) goForward:(id)sender;
- (IBAction) goBack:(id)sender;

@end
