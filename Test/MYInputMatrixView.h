//
//  MYInputMatrixView.h
//  Test
//
//  Created by Leonard Pauli on 2013-07-29.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYInputMatrixView : UIView

- (id)initWithFrame:(CGRect)frame rows:(NSInteger)nrRows cols:(NSInteger)nrCols borderWidth:(CGFloat)bW buttonColor:(UIColor*)col higlightColor:(UIColor*)hCol textColor:(UIColor*)tCol titles:(NSArray*)tits font:(UIFont*)f;

@end
