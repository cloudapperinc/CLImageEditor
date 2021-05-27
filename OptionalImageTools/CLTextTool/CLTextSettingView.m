//
//  CLTextSettingView.m
//
//  Created by sho yakushiji on 2013/12/18.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLTextSettingView.h"

#import "UIView+Frame.h"
#import "CLImageEditorTheme.h"
#import "CLColorPickerView.h"
#import "CLFontPickerView.h"
#import "CLCircleView.h"

@interface CLTextSettingView()
<CLColorPickerViewDelegate, CLFontPickerViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIView *selectedMode;
@property (nonatomic, strong) CLCircleView *selectedCircle;
@end


@implementation CLTextSettingView
{
    UIScrollView *_scrollView;
    
    UITextView *_textView;
    CLColorPickerView *_colorPickerView;
    
    CLFontPickerView *_fontPickerView;
    UIView *_fontPanel;
    CLCircleView *_arialFont;
    UILabel *_arialFontLabel;

    CLCircleView *_courierFont;
    UILabel *_courierFontLabel;

    CLCircleView *_tnrFont;
    UILabel *_tnrFontLabel;

    CLCircleView *_robotoFont;
    UILabel *_robotoLabel;

    CLCircleView *_montserratFont;
    UILabel *_montserratLabel;

    CLCircleView *_boldFont;
    UILabel *_boldLabel;
    
    CLCircleView *_mediumFont;
    UILabel *_mediumLabel;

    CLCircleView *_italicFont;
    UILabel *_italicLabel;

    CLCircleView *_regularFont;
    UILabel *_regularLabel;
 
    UIView *_colorPanel;
    CLCircleView *_fillCircle;
    CLCircleView *_pathCircle;
    UISlider *_pathSlider;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)setColorPanel
{
    _colorPickerView = [[CLColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 160)];
    _colorPickerView.delegate = self;
    _colorPickerView.center = CGPointMake(_colorPanel.width/2 - 10, _colorPickerView.height/2 - 5);
    [_colorPanel addSubview:_colorPickerView];
    
    _pathSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, _colorPickerView.width*0.8, 34)];
    _pathSlider.center = CGPointMake(_colorPickerView.center.x, _colorPickerView.bottom + 5);
    _pathSlider.minimumValue = 0;
    _pathSlider.maximumValue = 1;
    _pathSlider.value = 0;
    [_pathSlider addTarget:self action:@selector(pathSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [_colorPanel addSubview:_pathSlider];
    
    _pathCircle = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _pathCircle.right = _colorPanel.width - 10;
    _pathCircle.bottom = _pathSlider.center.y;
    _pathCircle.radius = 0.6;
    _pathCircle.borderWidth = 2;
    _pathCircle.borderColor = [UIColor blackColor];
    _pathCircle.color = [UIColor clearColor];
    [_colorPanel addSubview:_pathCircle];
    
    _fillCircle = [[CLCircleView alloc] initWithFrame:_pathCircle.frame];
    _fillCircle.bottom = _pathCircle.top;
    _fillCircle.radius = 0.6;
    [_colorPanel addSubview:_fillCircle];
    
    [_pathCircle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modeViewTapped:)]];
    [_fillCircle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modeViewTapped:)]];
    
    _fillCircle.tag = 0;
    _pathCircle.tag = 1;
    self.selectedMode = _fillCircle;
}

- (void)setFontPanel
{
    _fontPickerView = [[CLFontPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 160)];
    _fontPickerView.delegate = self;
    _fontPickerView.center = CGPointMake(_fontPanel.width/2 - 10, _colorPickerView.height/2 - 5);
    [_fontPanel addSubview:_fontPickerView];
     
    _arialFont = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _arialFont.left = 10;
    _arialFont.top = _fontPickerView.top + 20;
    _arialFont.radius = 0.4;
    _arialFont.borderWidth = 2;
    _arialFont.borderColor = [UIColor blackColor];
    _arialFont.color = [UIColor clearColor];
    [_fontPanel addSubview:_arialFont];
    
    _arialFontLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    _arialFontLabel.left = _arialFont.right;
    _arialFontLabel.top = _arialFont.top;
    _arialFontLabel.text = @"Arial";
    [_fontPanel addSubview:_arialFontLabel];
 
    _courierFont = [[CLCircleView alloc] initWithFrame:_arialFont.frame];
    _courierFont.top = _arialFont.bottom - 10;
    _courierFont.radius = 0.4;
    _courierFont.borderWidth = 2;
    _courierFont.borderColor = [UIColor blackColor];
    _courierFont.color = [UIColor clearColor];
    [_fontPanel addSubview:_courierFont];

    _courierFontLabel = [[UILabel alloc] initWithFrame:_arialFontLabel.frame];
    _courierFontLabel.left = _courierFont.right;
    _courierFontLabel.top = _courierFont.top;
    _courierFontLabel.text = @"Courier New";
    [_fontPanel addSubview:_courierFontLabel];
   
    _tnrFont = [[CLCircleView alloc] initWithFrame:_arialFont.frame];
    _tnrFont.top = _courierFont.bottom - 10;
    _tnrFont.radius = 0.4;
    _tnrFont.borderWidth = 2;
    _tnrFont.borderColor = [UIColor blackColor];
    _tnrFont.color = [UIColor clearColor];
    [_fontPanel addSubview:_tnrFont];
    
    _tnrFontLabel = [[UILabel alloc] initWithFrame:_arialFontLabel.frame];
    _tnrFontLabel.left = _tnrFont.right;
    _tnrFontLabel.top = _tnrFont.top;
    _tnrFontLabel.text = @"Times New Roman";
    [_fontPanel addSubview:_tnrFontLabel];
    
    _robotoFont = [[CLCircleView alloc] initWithFrame:_arialFont.frame];
    _robotoFont.top = _tnrFont.bottom - 10;
    _robotoFont.radius = 0.4;
    _robotoFont.borderWidth = 2;
    _robotoFont.borderColor = [UIColor blackColor];
    _robotoFont.color = [UIColor clearColor];
    [_fontPanel addSubview:_robotoFont];
    
    _robotoLabel = [[UILabel alloc] initWithFrame:_arialFontLabel.frame];
    _robotoLabel.left = _robotoFont.right;
    _robotoLabel.top = _robotoFont.top;
    _robotoLabel.text = @"Roboto";
    [_fontPanel addSubview:_robotoLabel];
    
    _montserratFont = [[CLCircleView alloc] initWithFrame:_arialFont.frame];
    _montserratFont.top = _robotoFont.bottom - 10;
    _montserratFont.radius = 0.4;
    _montserratFont.borderWidth = 2;
    _montserratFont.borderColor = [UIColor blackColor];
    _montserratFont.color = [UIColor clearColor];
    [_fontPanel addSubview:_montserratFont];
    
    _montserratLabel = [[UILabel alloc] initWithFrame:_arialFontLabel.frame];
    _montserratLabel.left = _montserratFont.right;
    _montserratLabel.top = _montserratFont.top;
    _montserratLabel.text = @"Verdana";
    [_fontPanel addSubview:_montserratLabel];
     
     

//    _fillCircleF = [[CLCircleView alloc] initWithFrame:_pathCircleF.frame];
//    _fillCircleF.bottom = _pathCircleF.top;
//    _fillCircleF.radius = 0.6;
//    [_fontPanel addSubview:_fillCircleF];
    
    self.selectedCircle = _arialFont;
    
    _arialFont.tag = 0;
    _courierFont.tag = 1;
    _tnrFont.tag = 2;
    _robotoFont.tag = 3;
    _montserratFont.tag = 4;
    
    [_arialFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
    [_courierFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
    [_tnrFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
    [_robotoFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
    [_montserratFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
  
}
- (void)customInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.width-42, 80)];
    _textView.delegate = self;
    UIColor *color = [UIColor lightGrayColor];
    color = [color colorWithAlphaComponent:0.5f];
    _textView.backgroundColor = color;
    [_scrollView addSubview:_textView];
    
    _colorPanel = [[UIView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
    _colorPanel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_colorPanel];
    [self setColorPanel];
    
    _fontPanel = [[UIView alloc] initWithFrame:CGRectMake(self.width * 2, 0, self.width, self.height)];
    _fontPanel.backgroundColor =  [UIColor colorWithRed:214.0/255.0 green:238.0/255.0 blue:247.0/255.0 alpha:0.7];
    [_scrollView addSubview:_fontPanel];
    [self setFontPanel];
    
    _scrollView.contentSize = CGSizeMake(self.width * 3, self.height);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTextColor:(UIColor*)textColor
{
    _fontPickerView.textColor = textColor;
    _textView.textColor = textColor;
}

- (BOOL)isFirstResponder
{
    return _textView.isFirstResponder;
}

- (BOOL)becomeFirstResponder
{
    return [_textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [_textView resignFirstResponder];
}

- (void)modeViewTapped:(UITapGestureRecognizer*)sender
{
    self.selectedMode = sender.view;
}

- (void)fontModeViewTapped:(UITapGestureRecognizer*)sender
{
    self.selectedCircle = sender.view;
}


#pragma mark - Properties

- (void)setSelectedCircle:(CLCircleView *)selectedCircle
{
    if(selectedCircle != _selectedCircle){
        _selectedCircle.color = [UIColor clearColor];
        _selectedCircle = selectedCircle;
        selectedCircle.color = [UIColor blackColor];
        
        UIFont *font;
        switch (selectedCircle.tag) {
            case 0:
                font = [UIFont fontWithName: @"ArialMT" size: 14];
                break;
            case 1:
                font = [UIFont fontWithName: @"Courier" size: 14];
                break;
            case 2:
                font = [UIFont fontWithName: @"TimesNewRomanPSMT" size: 14];
                break;
            case 3:
                font = [UIFont fontWithName: @"Roboto-Regular" size: 14];
                break;
            case 4:
                font = [UIFont fontWithName: @"Verdana" size: 14];
                break;
            default:
               break;
        }
         
 
        [self didSelectFont: font];
    }
}


- (void)setSelectedMode:(UIView *)selectedMode
{
    if(selectedMode != _selectedMode){
        _selectedMode.backgroundColor = [UIColor clearColor];
        _selectedMode = selectedMode;
        _selectedMode.backgroundColor = [[CLImageEditorTheme theme] toolbarSelectedButtonColor];
        
        if(_selectedMode==_fillCircle){
            _colorPickerView.color = _fillCircle.color;
        }
        else{
            _colorPickerView.color = _pathCircle.borderColor;
        }
    }
}

- (void)setSelectedText:(NSString *)selectedText
{
    _textView.text = selectedText;
}

- (NSString*)selectedText
{
    return _textView.text;
}

- (void)setSelectedFillColor:(UIColor *)selectedFillColor
{
    _fillCircle.color = selectedFillColor;
    
    if(self.selectedMode==_fillCircle){
        _colorPickerView.color = _fillCircle.color;
    }
}

- (UIColor*)selectedFillColor
{
    return _fillCircle.color;
}

- (void)setSelectedBorderColor:(UIColor *)selectedBorderColor
{
    _pathCircle.borderColor = selectedBorderColor;
    
    if(self.selectedMode==_pathCircle){
        _colorPickerView.color = _pathCircle.borderColor;
    }
}

- (UIColor*)selectedBorderColor
{
    return _pathCircle.borderColor;
}

- (void)setSelectedBorderWidth:(CGFloat)selectedBorderWidth
{
    _pathSlider.value = selectedBorderWidth;
}

- (CGFloat)selectedBorderWidth
{
    return _pathSlider.value;
}

- (void)setSelectedFont:(UIFont *)selectedFont
{
    _fontPickerView.font = selectedFont;
}

- (UIFont*)selectedFont
{
    return _fontPickerView.font;
}

- (void)setFontPickerForegroundColor:(UIColor*)foregroundColor
{
    _fontPickerView.foregroundColor = foregroundColor;
}

- (void)showSettingMenuWithIndex:(NSInteger)index animated:(BOOL)animated
{
    [_scrollView setContentOffset:CGPointMake(index * self.width, 0) animated:animated];
}

#pragma mark - keyboard events

- (void)keyBoardWillShow:(NSNotification *)notificatioin
{
    [self keyBoardWillChange:notificatioin withTextViewHeight:80];
    [_textView scrollRangeToVisible:_textView.selectedRange];
}

- (void)keyBoardWillHide:(NSNotification *)notificatioin
{
    [self keyBoardWillChange:notificatioin withTextViewHeight:self.height - 20];
}

- (void)keyBoardWillChange:(NSNotification *)notificatioin withTextViewHeight:(CGFloat)height
{
    CGRect keyboardFrame = [[notificatioin.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.superview convertRect:keyboardFrame fromView:self.window];
    
    UIViewAnimationCurve animationCurve = [[notificatioin.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notificatioin.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | (animationCurve<<16)
                     animations:^{
                         self->_textView.height = height;
                         CGFloat dy = MIN(0, (keyboardFrame.origin.y - self->_textView.height) - self.top);
                         self.transform = CGAffineTransformMakeTranslation(0, dy);
                     } completion:^(BOOL finished) {
                         
                     }
     ];
}

#pragma mark- Color picker delegate

- (void)colorPickerView:(CLColorPickerView *)picker colorDidChange:(UIColor *)color
{
    if(self.selectedMode==_fillCircle){
        _fillCircle.color = color;
        if([self.delegate respondsToSelector:@selector(textSettingView:didChangeFillColor:)]){
            [self.delegate textSettingView:self didChangeFillColor:color];
        }
    }
    else{
        _pathCircle.borderColor = color;
        if([self.delegate respondsToSelector:@selector(textSettingView:didChangeBorderColor:)]){
            [self.delegate textSettingView:self didChangeBorderColor:color];
        }
    }
}

#pragma mark- PathSlider event

- (void)pathSliderDidChange:(UISlider*)sender
{
    if([self.delegate respondsToSelector:@selector(textSettingView:didChangeBorderWidth:)]){
        [self.delegate textSettingView:self didChangeBorderWidth:_pathSlider.value];
    }
}

#pragma mark- Font picker

- (void)didSelectFont:(UIFont *)font
{
    _fontPickerView.font = font;
    [self.delegate textSettingView:self didChangeFont:font];
}

#pragma mark- UITextView delegate

- (void)textViewDidChange:(UITextView*)textView
{
    NSRange selection = textView.selectedRange;
    if(selection.location+selection.length == textView.text.length && textView.text.length >= 1 && [textView.text characterAtIndex:textView.text.length-1] == '\n') {
        [textView layoutSubviews];
        [textView scrollRectToVisible:CGRectMake(0, textView.contentSize.height - 1, 1, 1) animated:YES];
    }
    else {
        [textView scrollRangeToVisible:textView.selectedRange];
    }
    
    if([self.delegate respondsToSelector:@selector(textSettingView:didChangeText:)]){
        [self.delegate textSettingView:self didChangeText:textView.text];
    }
}

@end
