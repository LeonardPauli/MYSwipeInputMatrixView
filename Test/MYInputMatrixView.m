//
//  MYInputMatrixView.m
//  Test
//
//  Created by Leonard Pauli on 2013-07-29.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import "MYInputMatrixView.h"

@implementation MYInputMatrixView


CGFloat width;
CGFloat height;
CGFloat rows;
CGFloat cols;
CGFloat borderWidth;
UIColor *higlightColor;
UIColor *buttonColor;
UIColor *textColor;
NSArray *titles;
NSMutableArray *buttonsInfo;
UIFont *font;
CGSize brickSize;

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	width = frame.size.width;
	height = frame.size.height;
	brickSize = CGSizeMake((width+borderWidth)/cols-borderWidth, (height+borderWidth)/cols-borderWidth);
}

- (id)initWithFrame:(CGRect)frame rows:(NSInteger)nrRows cols:(NSInteger)nrCols borderWidth:(CGFloat)bW buttonColor:(UIColor*)col higlightColor:(UIColor*)hCol textColor:(UIColor*)tCol titles:(NSArray*)tits font:(UIFont*)f {
    self = [super init];
    if (self) {
		self.multipleTouchEnabled = NO;
		
		rows = nrRows;
		cols = nrCols;
		borderWidth = bW;
		buttonColor = col;
		higlightColor = hCol;
		textColor = tCol;
		titles = tits;
		if (titles==nil)
			titles = @[];
		buttonsInfo = [[NSMutableArray alloc] initWithCapacity:rows*cols];
		font = f;
		if (font==nil)
			font = [UIFont systemFontOfSize:25];
		self.backgroundColor = [UIColor whiteColor];
		
		for (int i=0; i<rows; i++)
			for (int j=0; j<cols; j++) {
				int idx = i*cols+j;
				if (idx==titles.count)
					titles = [titles arrayByAddingObject:[@(idx) stringValue]];
				[buttonsInfo addObject:@[@NO, @NO]];
			}
		
		[self setFrame:frame];
		
    }
    return self;
}


- (void)drawRect:(CGRect)drawRect {
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
	
    [self.backgroundColor set];
    [[UIBezierPath bezierPathWithRect:(CGRect){{0,0},self.frame.size}] fill];
	
	for (int i=0; i<rows; i++)
        for (int j=0; j<cols; j++) {
			int idx = i*cols+j;
			NSArray *btnInfo = (NSArray*)[buttonsInfo objectAtIndex:idx];
			if ([[btnInfo objectAtIndex:0] boolValue] || [[btnInfo objectAtIndex:1] boolValue])
				[higlightColor set];
			else [buttonColor set];
			
			CGPoint startPoint = (CGPoint){j*(brickSize.width+borderWidth),i*(brickSize.height+borderWidth)};
			[[UIBezierPath bezierPathWithRect:(CGRect){startPoint,brickSize}] fill];
			
			NSString *text = [titles objectAtIndex:idx];
			CGSize textSize = [text sizeWithFont:font];
			
			[textColor set];
			[text drawAtPoint:(CGPoint){
				startPoint.x+(brickSize.width-textSize.width)/2,
				startPoint.y+(brickSize.height-textSize.height)/2
			} withFont:font];
			
		}
        
    CGContextRestoreGState(ctx);
	
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = touches.anyObject;
	CGPoint loc = [touch locationInView:self];
	
	int i = loc.y/(brickSize.height+borderWidth);
	int j = loc.x/(brickSize.width+borderWidth);
	int index = i*cols+j;
	
	for (int i=0; i<rows; i++)
        for (int j=0; j<cols; j++) {
			int idx = i*cols+j;
			NSArray *btnInfo = (NSArray*)[buttonsInfo objectAtIndex:idx];
			[buttonsInfo replaceObjectAtIndex:idx withObject:@[(index==idx?@YES:@NO), (index==idx?@YES:[btnInfo objectAtIndex:1])]];
		}
	
	
	[self setNeedsDisplay];
	
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = touches.anyObject;
	CGPoint loc = [touch locationInView:self];
	
	int i = loc.y/(brickSize.height+borderWidth);
	int j = loc.x/(brickSize.width+borderWidth);
	int index = i*cols+j;
	
	for (int i=0; i<rows; i++)
        for (int j=0; j<cols; j++) {
			int idx = i*cols+j;
			NSArray *btnInfo = (NSArray*)[buttonsInfo objectAtIndex:idx];
			[buttonsInfo replaceObjectAtIndex:idx withObject:@[(index==idx?@YES:@NO), (index==idx?@YES:[btnInfo objectAtIndex:1])]];
		}
	
	
	[self setNeedsDisplay];
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	//UITouch *touch = touches.anyObject;
	//CGPoint loc = [touch locationInView:self];
	
	//int i = loc.y/(brickSize.height+borderWidth);
	//int j = loc.x/(brickSize.width+borderWidth);
	//int index = i*cols+j;
	
	for (int i=0; i<rows; i++)
        for (int j=0; j<cols; j++) {
			int idx = i*cols+j;
			[buttonsInfo replaceObjectAtIndex:idx withObject:@[@NO, @NO]];
		}
	
	
	[self setNeedsDisplay];
	
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}


@end
