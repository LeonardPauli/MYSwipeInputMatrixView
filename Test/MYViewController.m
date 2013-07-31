//
//  MYViewController.m
//  Test
//
//  Created by Leonard Pauli on 2013-07-29.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import "MYViewController.h"
#import "MYSwipeableInputMatrixView.h"
#import "MYSwipeableBrick.h"

#define ARC4RANDOM_MAX      0x100000000


@interface MYViewController ()

@end

@implementation MYViewController

UILabel *question;
MYSwipeableInputMatrixView *imvw;


CGFloat rndm(CGFloat max, CGFloat min) {
	CGFloat r = ((double)arc4random() / ARC4RANDOM_MAX);
	return r*(max-min)+min;
}
CGFloat rnd(CGFloat max) {
	CGFloat r = ((double)arc4random() / ARC4RANDOM_MAX);
	return r*max;
}
int rndim(int max, int min) {
	CGFloat r = ((double)arc4random() / ARC4RANDOM_MAX);
	return r*(max-min)+min;
}
int rndi(int max) {
	CGFloat r = ((double)arc4random() / ARC4RANDOM_MAX);
	return r*max;
}



- (void)newQuestion {
	
	question.text = @(rndi(100)).stringValue;
	
	for (int i=0; i<imvw.rows*imvw.cols; i++) {
		
		NSInteger nr = rndim(10, 1);
		[imvw.titles replaceObjectAtIndex:i withObject:@(nr).stringValue];
		MYSwipeableBrick *brick = [imvw.bricks objectAtIndex:i];
		
		CGFloat hue = nr/10.0*0.2;
		brick.color					= [UIColor colorWithHue:0.44+hue saturation:0.85 brightness:1 alpha:1];
		brick.textNormalColor		= [UIColor colorWithHue:0.44+hue saturation:0.8 brightness:0.5 alpha:1];
		brick.highlightColor		= [UIColor colorWithHue:0.0+hue saturation:0.80 brightness:1 alpha:1];
		brick.textHighlightColor	= [UIColor colorWithHue:0.0+hue saturation:0.10 brightness:1 alpha:1];
		
	}
	
	[imvw updateTitles];
	
	// Give the user a hint of the start brick by changing its color
	//MYSwipeableBrick *brick = [imvw.bricks objectAtIndex:0];
	//brick.text = @"#";
	//brick.color = [UIColor whiteColor];
	//brick.highlightColor = [UIColor whiteColor];
	
}


BOOL swipeLimitReached;
//BOOL badStart;
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view = [[UIView alloc] init];
	self.view.backgroundColor = [UIColor colorWithHue:0.54 saturation:0.8 brightness:1 alpha:1];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	// For iPhone 4 and	5 portrait
	CGSize size = [[UIScreen mainScreen] bounds].size;
	CGFloat width = MIN(size.width, size.height);
	CGFloat height = MAX(size.width, size.height)-20;
	CGFloat imvwH = 200;
	
	question = [[UILabel alloc] initWithFrame:CGRectMake(0, (height-imvwH)/2-30, width, 50)];
	question.font = [UIFont systemFontOfSize:65];
	question.textColor = [UIColor colorWithHue:0.6 saturation:0.8 brightness:0.9 alpha:1];
	question.backgroundColor = [UIColor clearColor];
	question.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:question];
	
	imvw = [[MYSwipeableInputMatrixView alloc] initWithRows:4 cols:4];
	imvw.borderWidth = 3;
	imvw.touchBorderWidth = 7;
	imvw.frame = CGRectMake(0, height-imvwH, width, imvwH);
	imvw.backgroundColor = [UIColor clearColor];
	[self.view addSubview:imvw];
	
	
	[imvw setBrickSwipeEventBlock:^(MYSwipeEventStatus status, MYSwipeableInputMatrixView *mvw, CGPoint loc, NSInteger index, NSInteger lastIndex) {
		
		if (status==MYSwipeEventStatusBegan) {
			mvw.selectedBricks = [[NSMutableArray alloc] initWithCapacity:mvw.rows*mvw.cols];
			
			// Only allow user to start select a brick with index 0
			//badStart = (index!=0);
		}
		
		//if (badStart) return;
		
		if (status==MYSwipeEventStatusBegan || status==MYSwipeEventStatusChanged) {
			if (index==-1) return;
			
			// Enable undo
			NSInteger prevlastidx = -1;
			if (1<mvw.selectedBricks.count)
				prevlastidx = [[mvw.selectedBricks objectAtIndex:mvw.selectedBricks.count-2] integerValue];
			
			if (index==prevlastidx) {
				NSInteger reallastidx = [mvw.selectedBricks.lastObject integerValue];
				MYSwipeableBrick *lastBrick = [mvw.bricks objectAtIndex:reallastidx];
				[mvw.selectedBricks removeLastObject];
				lastBrick.highlighted = NO;
				swipeLimitReached = NO;
				return;
			}
			
			// Limit to 4 bricks
			if (mvw.selectedBricks.count==4) {
				swipeLimitReached = YES;
				return;
			}
			
			// Prevent select selected bricks
			if ([mvw.selectedBricks indexOfObject:@(index)]!=NSNotFound)
				return;
			
			
			MYSwipeableBrick *brick = [mvw.bricks objectAtIndex:index];
			brick.highlighted = YES;
			
			[mvw.selectedBricks addObject:@(index)];
			
		} else if (status==MYSwipeEventStatusEnded) {
			
			for (int i=0; i<mvw.rows*mvw.cols; i++) {
				MYSwipeableBrick *brick = [mvw.bricks objectAtIndex:i];
				brick.highlighted = NO;
			}
			
			CGFloat answer = 0;
			for (int i=0; i<mvw.selectedBricks.count; i++) {
				MYSwipeableBrick *brick = [mvw.bricks objectAtIndex:[[mvw.selectedBricks objectAtIndex:i] integerValue]];
				answer += 1.0*[brick.text integerValue];
			}
	 
			[self newQuestion];
			question.text = @(answer).stringValue;
			
		}
	}];
	
	
	[self newQuestion];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
