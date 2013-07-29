//
//  MYViewController.m
//  Test
//
//  Created by Leonard Pauli on 2013-07-29.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import "MYViewController.h"
#import "MYInputMatrixView.h"

@interface MYViewController ()

@end

@implementation MYViewController

UILabel *question;
MYInputMatrixView *imvw;

- (void)newQuestion {

	question.text = @"27";
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view = [[UIView alloc] init];
	self.view.backgroundColor = [UIColor whiteColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	CGFloat width = 320;
	CGFloat height = 460;
	CGFloat imvwH = 200;
	
	question = [[UILabel alloc] initWithFrame:CGRectMake(0, (height-imvwH)/2-30, width, 50)];
	question.font = [UIFont systemFontOfSize:65];
	question.textColor = [UIColor colorWithWhite:0 alpha:0.9];
	question.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:question];
	
	imvw = [[MYInputMatrixView alloc]
							   initWithFrame:CGRectMake(0, height-imvwH, width, imvwH) 
							   rows:4
							   cols:4
							   borderWidth:3
							   buttonColor:[UIColor colorWithWhite:0 alpha:0.07]
							   higlightColor:[UIColor colorWithWhite:0 alpha:0.3]
							   textColor:[UIColor colorWithWhite:0 alpha:0.6]
							   titles:nil font:nil];
	imvw.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:imvw];
	
	[self newQuestion];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
