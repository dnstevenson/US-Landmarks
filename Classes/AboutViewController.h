//
//  AboutViewController.h
//  audiobook
//
//  Created by David Stevenson on 5/17/10.
//  Copyright 2010 Stevenson Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController <UIWebViewDelegate> {
	UIWebView *webView;

}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
