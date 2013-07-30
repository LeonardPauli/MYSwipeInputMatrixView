//
//  MYSwipeableBrick.m
//  Test
//
//  Created by Leonard Pauli on 2013-07-29.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import "MYSwipeableBrick.h"

@implementation MYSwipeableBrick

@synthesize color, highlightColor;
@synthesize textNormalColor, textHighlightColor;


- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	
	self.backgroundColor	= highlighted?highlightColor:color;
	self.textColor			= highlighted?textHighlightColor:textNormalColor;
	
}

- (void)setColor:(UIColor *)color_ {
	color = color_;
	self.backgroundColor = self.highlighted?highlightColor:color;
}
- (void)setHighlightColor:(UIColor *)highlightColor_ {
	highlightColor = highlightColor_;
	self.backgroundColor = self.highlighted?highlightColor:color;
}

- (void)setTextNormalColor:(UIColor *)textNormalColor_ {
	textNormalColor = textNormalColor_;
	self.textColor = self.highlighted?textHighlightColor:textNormalColor;
}
- (void)setTextHighlightColor:(UIColor *)textHighlightColor_ {
	textHighlightColor = textHighlightColor_;
	self.textColor = self.highlighted?textHighlightColor:textNormalColor;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = UITextAlignmentCenter;
		self.font = [UIFont boldSystemFontOfSize:25];
		self.textColor = [UIColor whiteColor];
		
		CGFloat hue = 0.2*rand()/RAND_MAX;
		color = self.backgroundColor = [UIColor colorWithHue:0.3+hue saturation:0.85 brightness:1 alpha:1];
		textNormalColor = self.textColor = [UIColor colorWithHue:0.4+hue saturation:0.8 brightness:0.5 alpha:1];
		highlightColor = [UIColor colorWithHue:0.0+hue saturation:0.80 brightness:1 alpha:1];
		textHighlightColor = [UIColor colorWithHue:0.0+hue saturation:0.30 brightness:1 alpha:1];
    }
    return self;
}


@end
