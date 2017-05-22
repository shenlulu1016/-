//
//  DialogBoxView.h
//  HuanXinDemo
//
//  Created by 申露露 on 16/7/17.
//  Copyright © 2016年 申露露. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClicked)(NSString * draftText);

@interface DialogBoxView : UIView
@property (nonatomic, copy) ButtonClicked buttonClicked;

@end
