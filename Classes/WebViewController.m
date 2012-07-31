    //
//  WebViewController.m
//  LandscapersIPad
//
//  Created by David Stevenson on 6/17/10.
//  Copyright 2010 Stevenson Software, LLC. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize webView;
@synthesize url;
@synthesize toolbar, forwardButton, backButton;

- (IBAction) goForward:(id)sender {
	[webView goForward];
}

- (IBAction) goBack:(id)sender {
	[webView goBack];
}

- (void) viewWillAppear:(BOOL)animated {
	forwardButton.enabled = NO; //webView.canGoForward;
	backButton.enabled = NO; //webView.canGoBack;

	UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	//set the initial property
	[activityIndicator stopAnimating];
	[activityIndicator hidesWhenStopped];
	//Create an instance of Bar button item with custome view which is of activity indicator
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	//Set the bar button the navigation bar
	[self navigationItem].rightBarButtonItem = barButton;
	//Memory clean up
	[activityIndicator release];
	[barButton release];
}

- (void)viewDidLoad {
	
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
	webView.delegate = self;
	
	forwardButton.enabled = NO; //webView.canGoForward;
	backButton.enabled = NO; //webView.canGoBack;
	
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)inWebView {
	[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)inWebView {	
	[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
	forwardButton.enabled = webView.canGoForward;
	backButton.enabled = webView.canGoBack;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	self.webView = nil;
	self.toolbar = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[url release];
	[webView release];
	[toolbar release];
	
    [super dealloc];
}


@end
