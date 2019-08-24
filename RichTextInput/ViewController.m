//
//  ViewController.m
//  RichTextInput
//
//  Created by walen on 2019/7/29.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "ViewController.h"
#import "RichTextInputView.h"

@interface ViewController ()

@property (nonatomic, strong)RichTextInputView *inputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.inputView];
}

#pragma mark - property
 - (RichTextInputView *)inputView
{
    if (!_inputView) {
        _inputView = [[RichTextInputView alloc] init];
    }
    return _inputView;
}


@end
