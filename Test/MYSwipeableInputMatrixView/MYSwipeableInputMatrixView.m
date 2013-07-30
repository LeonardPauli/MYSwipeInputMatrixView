//
//  MYSwipeableInputMatrixView.m
//  Test
//
//  Created by Leonard Pauli on 2013-07-29.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import "MYSwipeableInputMatrixView.h"
#import "MYSwipeableBrick.h"

@implementation MYSwipeableInputMatrixView

@synthesize bricks, titles, selectedBricks;
@synthesize width, height;
@synthesize rows, cols;
@synthesize borderWidth, brickSize, touchBorderWidth;
@synthesize brickSwipeEventBlock;
@synthesize lastIndex;




- (void)updateTitles {

	for (int i=0; i<rows*cols; i++) {
		MYSwipeableBrick *brick = [bricks objectAtIndex:i];
		brick.text = i<titles.count?[titles objectAtIndex:i]:@(i).stringValue;
	}
	
}



- (NSInteger)brickIndexForTouchPoint:(CGPoint)p {
	
	int ix = p.x/brickSize.width;
	int dx  = (int)p.x % (int)brickSize.width;
	if (dx<touchBorderWidth ||
		dx>brickSize.width-touchBorderWidth)
		return -1;
	
	int iy = p.y/brickSize.height;
	int dy  = (int)p.y % (int)brickSize.height;
	if (dy<touchBorderWidth ||
		dy>brickSize.height-touchBorderWidth)
		return -1;
	
	NSInteger index = iy*cols+ix;
	if (index>=rows*cols)
		return -1;
	
	return index;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = touches.anyObject;
	CGPoint loc = [touch locationInView:self];
	NSInteger index = [self brickIndexForTouchPoint:loc];
	
	if (brickSwipeEventBlock) {
		brickSwipeEventBlock(MYSwipeEventStatusBegan, self, loc, index, lastIndex);
	}
	
	lastIndex = index;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = touches.anyObject;
	CGPoint loc = [touch locationInView:self];
	NSInteger index = [self brickIndexForTouchPoint:loc];
	
	if (brickSwipeEventBlock) {
		brickSwipeEventBlock(MYSwipeEventStatusMoved, self, loc, index, lastIndex);
		if (index!=lastIndex) {
			brickSwipeEventBlock(MYSwipeEventStatusChanged, self, loc, index, lastIndex);
		}
	}
	
	lastIndex = index;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = touches.anyObject;
	CGPoint loc = [touch locationInView:self];
	NSInteger index = [self brickIndexForTouchPoint:loc];
	
	if (brickSwipeEventBlock) {
		brickSwipeEventBlock(MYSwipeEventStatusEnded, self, loc, index, lastIndex);
	}
	
	lastIndex = index;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}








- (void)setCols:(NSInteger)cols_ {
	cols = cols_;
	
	for (int r=0; r<rows; r++)
		for (int c=0; c<cols; c++) {
			int idx = r*cols+c;
			if (titles.count==idx)
				[titles addObject:@(idx).stringValue];
			if (bricks.count==idx) {
				MYSwipeableBrick *brick = [[MYSwipeableBrick alloc] init];
				brick.text = [titles objectAtIndex:idx];
				[self addSubview:brick];
				[bricks addObject:brick];
			}
		}
	
	int i = bricks.count-1;
	while (i>=rows*cols) {
		[[bricks objectAtIndex:i] removeFromSuperview];
		[bricks removeObjectAtIndex:i];
		i--;
	}

}

- (void)setRows:(NSInteger)rows_ {
	rows = rows_;
	self.cols = cols;
}


- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	width = frame.size.width;
	height = frame.size.height;
	brickSize = CGSizeMake((width+borderWidth)/cols, (height+borderWidth)/cols);
	
	for (int r=0; r<rows; r++)
		for (int c=0; c<cols; c++) {
			int idx = r*cols+c;
			MYSwipeableBrick *brick = [bricks objectAtIndex:idx];
			CGPoint startPoint = (CGPoint){(int)c*brickSize.width,(int)r*brickSize.height};
			brick.frame = (CGRect){startPoint,{(int)brickSize.width-borderWidth, (int)brickSize.height-borderWidth}};
		}
	
}

- (void)setWidth:(CGFloat)w {
	self.frame = (CGRect){self.frame.origin, {w, height}};
}

- (void)setHeight:(CGFloat)h {
	self.frame = (CGRect){self.frame.origin, {width, h}};
}


- (void)setup {
	
	titles = [[NSMutableArray alloc] init];
	bricks = [[NSMutableArray alloc] init];
	lastIndex = -1;
	rows = 1;
	self.cols = 1;
	touchBorderWidth = 4;
	[self updateTitles];
	
}


- (id)initWithRows:(NSInteger)r cols:(NSInteger)c {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setup];
		rows = r;
		self.cols = c;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setup];
		[self setFrame:frame];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


@end
