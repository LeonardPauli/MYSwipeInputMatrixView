//
//  MYSwipeableInputMatrixView.h
//  Test
//
//  Created by Leonard Pauli on 2013-07-29.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MYSwipeEventStatus) {
    MYSwipeEventStatusBegan,
    MYSwipeEventStatusMoved,
    MYSwipeEventStatusChanged,
    MYSwipeEventStatusEnded
};




@interface MYSwipeableInputMatrixView : UIView



@property (nonatomic, retain) NSMutableArray *bricks;
@property (nonatomic, retain) NSMutableArray *titles;
@property (nonatomic, retain) NSMutableArray *selectedBricks;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger cols;

@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat touchBorderWidth;
@property (nonatomic, readonly) CGSize brickSize;

@property (nonatomic, copy) void (^brickSwipeEventBlock)(
	MYSwipeEventStatus status,
	MYSwipeableInputMatrixView *mvw,
	CGPoint loc, NSInteger index, NSInteger lastIndex);
@property (nonatomic) NSInteger lastIndex;


- (void)updateTitles;

- (id)initWithRows:(NSInteger)r cols:(NSInteger)c;


@end
