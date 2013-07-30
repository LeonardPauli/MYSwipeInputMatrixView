MYSwipeableInputMatrixView
======================

This is a example of how to make these swipe-on-a-matrix games. The simplest way to get started is by open up the example Xcode project and look in MYViewController.m


##Setup the project

- Open Xcode, create new project (iOS: Single View Application).
- Select MYViewController.xib and delete it (Move to trash)
- In MYAppDelegate.m, change

		self.viewController = [[MYViewController alloc] initWithNibName:@"MYViewController" bundle:nil];

	to

		self.viewController = [[MYViewController alloc] init];

- Download this repo as zip, drag the folder MYSwipeableInputMatrixView into the project (sidebar)
- Check "Copy items.." and "Create Groups..", hit return.
- Click your project name in the sidebar
- Make sure that portrait only is selected


MYViewController.m:

- At top:

		#import "MYSwipeableInputMatrixView.h"
		#import "MYSwipeableBrick.h"

- Before viewDidLoad:

		MYSwipeableInputMatrixView *imvw;

- Inside viewDidLoad:

		self.view = [[UIView alloc] init];
		self.view.backgroundColor = [UIColor whiteColor];
		self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		// For iPhone 4 and 5 portrait
		CGSize size = [[UIScreen mainScreen] bounds].size;
		CGFloat width = MIN(size.width, size.height);
		CGFloat height = MAX(size.width, size.height)-20;
		CGFloat imvwH = 200;

- And now, initiate the matrix! (Still in viewDidLoad)

		imvw = [[MYSwipeableInputMatrixView alloc] initWithRows:4 cols:4];
		imvw.borderWidth = 3;
		imvw.touchBorderWidth = 7; // So you can make diagonal swipes
		imvw.frame = CGRectMake(0, height-imvwH, width, imvwH);
		imvw.backgroundColor = [UIColor clearColor];
		[self.view addSubview:imvw];
	
		// Set titles and brick colors
		for (int i=0; i<imvw.rows*imvw.cols; i++) {
			
			NSInteger nr = rndim(10, 1);
			[imvw.titles replaceObjectAtIndex:i withObject:@(nr).stringValue];
			MYSwipeableBrick *brick = [imvw.bricks objectAtIndex:i];
			
			CGFloat hue = nr/10.0;
			brick.color					= [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1];
			brick.textNormalColor		= [UIColor colorWithHue:hue saturation:0.5 brightness:1.0 alpha:1];
			brick.highlightColor		= [UIColor colorWithHue:hue saturation:1.0 brightness:0.6 alpha:1];
			brick.textHighlightColor	= [UIColor colorWithHue:hue saturation:0.5 brightness:0.6 alpha:1];
			
		}
	
		[imvw updateTitles];

- Simple and buggy code for making swipes work! (Please improve it for your needs..)

		[imvw setBrickSwipeEventBlock:^(MYSwipeEventStatus status, MYSwipeableInputMatrixView *mvw, CGPoint loc, NSInteger index, NSInteger lastIndex) {
			if (status==MYSwipeEventStatusBegan) {
				mvw.selectedBricks = [[NSMutableArray alloc] initWithCapacity:mvw.rows*mvw.cols];
			}
			
			if (status==MYSwipeEventStatusBegan || status==MYSwipeEventStatusChanged) {
				if (index==-1) return;
				
				MYSwipeableBrick *brick = [mvw.bricks objectAtIndex:index];
				brick.highlighted = YES;
				
				[mvw.selectedBricks addObject:@(index)];
				
			} else if (status==MYSwipeEventStatusEnded) {
				
				for (int i=0; i<mvw.rows*mvw.cols; i++) {
					MYSwipeableBrick *brick = [mvw.bricks objectAtIndex:i];
					brick.highlighted = NO;
				}
				
				NSString *msg = @"Select done!";
				for (int i=0; i<mvw.selectedBricks.count; i++) {
					MYSwipeableBrick *brick = [mvw.bricks objectAtIndex:[[mvw.selectedBricks objectAtIndex:i] integerValue]];
					msg = [msg stringByAppendingString:@" "];
					msg = [msg stringByAppendingString:brick.text];
				}
		 
				NSLog(@"%@", msg);
				
			}
		}];

 - Run and enjoy! :)



##More

The project is licenced under the MIT Licence included in this repo. If you plan to make an app of it, i would be glad if you told me about it. The code isn't perfect at all, but could give some insperation. Actually, in the beginning, it was my answer to the StackOverflow question http://stackoverflow.com/questions/17927534/detecting-touchdown-touchup-touchmove-events-across-4x4-ios-tiles, but later it evolved into this project.

Made by Leonard Pauli, 30 july 2013.