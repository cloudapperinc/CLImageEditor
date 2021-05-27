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
@property (nonatomic, strong) CLCircleView *selectedFontName;
@property (nonatomic, strong) CLCircleView *selectedFontType;

@end


@implementation CLTextSettingView
{
    UIScrollView *_scrollView;
    
    UITextView *_textView;
    CLColorPickerView *_colorPickerView;
    
    UIView *_bgPanel;
    UIColor *backGroundColor;
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

    CLCircleView *_verdanaFont;
    UILabel *_verdanaLabel;

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





- (void)setBgPanel
{
    //colors

    // first 11 from schedule other from the random list
    NSArray *colorsHex  = @[@"#D50000", @"#E67C73", @"#F4511E", @"#F6BF26", @"#33B679", @"#0B8043", @"#039BE5", @"#3F51B5", @"#7986CB", @"#8E24AA", @"#616161", @"#FF7C00", @"#5358E2", @"#00BE8E",
                            @"#5AD0F9", @"#05A6D8", @"#826DCC",
                            @"#FF5C4A"];
    
    NSMutableArray *colors = [NSMutableArray array];
    
    for (int i = 0; i <= 17; i++) {
        NSString *colorHex = [colorsHex objectAtIndex:i];
        UIColor *color = [self colorWithHexString: colorHex alpha: 1.0];
        [colors addObject:color];
    }
    
    for (int i = 0; i <= 2; i++)
    {
        for (int j = 0; j <= 5; j++)
        {
            UILabel *testLabel;
            testLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + j*60, 35+ i*50, 35, 35)];
            UIColor *color =  [colors objectAtIndex:(i*6) + j];
            testLabel.backgroundColor = color;
            testLabel.layer.cornerRadius = 8;
            testLabel.layer.masksToBounds = true;
            [_bgPanel addSubview: testLabel];
            testLabel.userInteractionEnabled = YES;
            [testLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgModeViewTapped:)]];
//            NSLog(@"%d", ((i*6) + j));
        }
    }
 
    
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
    
        _verdanaFont = [[CLCircleView alloc] initWithFrame:_arialFont.frame];
            _verdanaFont.top = _robotoFont.bottom - 10;
            _verdanaFont.radius = 0.4;
            _verdanaFont.borderWidth = 2;
            _verdanaFont.borderColor = [UIColor blackColor];
            _verdanaFont.color = [UIColor clearColor];
        [_fontPanel addSubview:    _verdanaFont];
        
        _verdanaLabel = [[UILabel alloc] initWithFrame:_arialFontLabel.frame];
        _verdanaLabel.left =     _verdanaFont.right;
        _verdanaLabel.top =     _verdanaFont.top;
        _verdanaLabel.text = @"Verdana";
        [_fontPanel addSubview:_verdanaLabel];
         
        _regularFont = [[CLCircleView alloc] initWithFrame:_arialFont.frame];
        _regularFont.top = _arialFont.top;
        _regularFont.left = _arialFontLabel.right + 20;
        _regularFont.radius = 0.4;
        _regularFont.borderWidth = 2;
        _regularFont.borderColor = [UIColor blackColor];
        _regularFont.color = [UIColor clearColor];
        [_fontPanel addSubview: _regularFont];

        _regularLabel = [[UILabel alloc] initWithFrame:_arialFontLabel.frame];
        _regularLabel.left = _regularFont.right;
        _regularLabel.top = _regularFont.top;
        _regularLabel.text = @"Regular";
        [_fontPanel addSubview:_regularLabel];
            
        _boldFont = [[CLCircleView alloc] initWithFrame:_arialFont.frame];
        _boldFont.top = _regularFont.bottom - 10;
        _boldFont.left = _arialFontLabel.right + 20;
        _boldFont.radius = 0.4;
        _boldFont.borderWidth = 2;
        _boldFont.borderColor = [UIColor blackColor];
        _boldFont.color = [UIColor clearColor];
        [_fontPanel addSubview:    _boldFont];

        _boldLabel = [[UILabel alloc] initWithFrame:_arialFontLabel.frame];
        _boldLabel.left = _boldFont.right;
        _boldLabel.top = _boldFont.top;
        _boldLabel.text = @"Bold";
        [_fontPanel addSubview:_boldLabel];
     
     

//    _fillCircleF = [[CLCircleView alloc] initWithFrame:_pathCircleF.frame];
//    _fillCircleF.bottom = _pathCircleF.top;
//    _fillCircleF.radius = 0.6;
//    [_fontPanel addSubview:_fillCircleF];
    
    self.selectedFontName = _arialFont;
    self.selectedFontType = _regularFont;
    
    _regularFont.tag = -1;
    _boldFont.tag = -2;
    
    _arialFont.tag = 0;
    _courierFont.tag = 1;
    _tnrFont.tag = 2;
    _robotoFont.tag = 3;
    _verdanaFont.tag = 4;
    
    [_regularFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
    [_boldFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
    
    [_arialFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
    [_courierFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
    [_tnrFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
    [_robotoFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
    [_verdanaFont addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontModeViewTapped:)]];
  
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
 
    _textView.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:238.0/255.0 blue:247.0/255.0 alpha:0.7];
    [_scrollView addSubview:_textView];
    
    _colorPanel = [[UIView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
    _colorPanel.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:238.0/255.0 blue:247.0/255.0 alpha:0.7];
    [_scrollView addSubview:_colorPanel];
    [self setColorPanel];
    
    _fontPanel = [[UIView alloc] initWithFrame:CGRectMake(self.width * 2, 0, self.width, self.height)];
    _fontPanel.backgroundColor =  [UIColor colorWithRed:214.0/255.0 green:238.0/255.0 blue:247.0/255.0 alpha:0.7];
    [_scrollView addSubview:_fontPanel];
    [self setFontPanel];
    
    _bgPanel = [[UIView alloc] initWithFrame:CGRectMake(self.width * 3, 0, self.width, self.height)];
    _bgPanel.backgroundColor =  [UIColor colorWithRed:214.0/255.0 green:238.0/255.0 blue:247.0/255.0 alpha:0.7];
    [_scrollView addSubview:_bgPanel];
    [self setBgPanel];
 
    _scrollView.contentSize = CGSizeMake(self.width * 4, self.height);
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

- (UIColor *)colorWithHexString:(NSString *)str_HEX  alpha:(CGFloat)alpha_range{
    int red = 0;
    int green = 0;
    int blue = 0;
    sscanf([str_HEX UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    return  [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha_range];
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

- (void)bgModeViewTapped:(UITapGestureRecognizer*)sender
{
    backGroundColor = sender.view.backgroundColor;
    [self.delegate textSettingView:self didChangeBgColor:backGroundColor];
}
 
- (void)fontModeViewTapped:(UITapGestureRecognizer*)sender
{
    CLCircleView *selected = (CLCircleView *)sender.view;
    
    if (selected.tag < 0) {
        self.selectedFontType = sender.view;
    } else {
        self.selectedFontName = sender.view;
    }
}


#pragma mark - Properties

-(UIFont*) changeFont: (CLCircleView *)selectedFontName :(CLCircleView *)selectedFontType {
    
    UIFont *font;
    switch (selectedFontName.tag) {
        case 0:
            switch (selectedFontType.tag) {
                case -1:
                    font = [UIFont fontWithName: @"ArialMT" size: 14];
                    break;
                case -2:
                    font = [UIFont fontWithName: @"Arial-BoldMT" size: 14];
                    break;
                case -3:
                    font = [UIFont fontWithName: @"Arial-ItalicMT" size: 14];
                case -4:
                    font = [UIFont fontWithName: @"Arial-BoldItalicMT" size: 14];
                default:
                break;
            }
            break;
        case 1:
            switch (selectedFontType.tag) {
                case -1:
                    font = [UIFont fontWithName: @"Courier" size: 14];
                    break;
                case -2:
                    font = [UIFont fontWithName: @"Courier-BoldMT" size: 14];
                    break;
                case -3:
                    font = [UIFont fontWithName: @"Arial-ItalicMT" size: 14];
                case -4:
                    font = [UIFont fontWithName: @"Arial-BoldItalicMT" size: 14];
                default:
                break;
            }
            break;
        case 2:
            switch (selectedFontType.tag) {
                case -1:
                    font = [UIFont fontWithName: @"TimesNewRomanPSMT" size: 14];
                    break;
                case -2:
                    font = [UIFont fontWithName: @"TimesNewRomanPS-BoldMT" size: 14];
                    break;
                case -3:
                    font = [UIFont fontWithName: @"Arial-ItalicMT" size: 14];
                case -4:
                    font = [UIFont fontWithName: @"Arial-BoldItalicMT" size: 14];
                default:
                break;
            }
            break;
        case 3:
            switch (selectedFontType.tag) {
                case -1:
                    font = [UIFont fontWithName: @"Roboto-Regular" size: 14];
                    break;
                case -2:
                    font = [UIFont fontWithName: @"TimesNewRomanPS-BoldMT" size: 14];
                    break;
                case -3:
                    font = [UIFont fontWithName: @"Arial-ItalicMT" size: 14];
                case -4:
                    font = [UIFont fontWithName: @"Arial-BoldItalicMT" size: 14];
                default:
                break;
            }
            break;
        case 4:
            switch (selectedFontType.tag) {
                case -1:
                    font = [UIFont fontWithName: @"Verdana" size: 14];
                    break;
                case -2:
                    font = [UIFont fontWithName: @"Verdana-Bold" size: 14];
                    break;
                case -3:
                    font = [UIFont fontWithName: @"Arial-ItalicMT" size: 14];
                case -4:
                    font = [UIFont fontWithName: @"Arial-BoldItalicMT" size: 14];
                default:
                break;
            }
            break;
        default:
           break;
    }
    return font;
}


- (void)setSelectedFontType:(CLCircleView *)selectedFontType
{
    if(selectedFontType != _selectedFontType){
        _selectedFontType.color = [UIColor clearColor];
        _selectedFontType = selectedFontType;
        selectedFontType.color = [UIColor blackColor];
        
        UIFont *font = [self changeFont: self.selectedFontName :self.selectedFontType];
 
        [self didSelectFont: font];
    }

}


- (void)setSelectedFontName:(CLCircleView *)selectedCircle
{
    if(selectedCircle != _selectedFontName){
        _selectedFontName.color = [UIColor clearColor];
        _selectedFontName = selectedCircle;
        selectedCircle.color = [UIColor blackColor];
        
        UIFont *font = [self changeFont: self.selectedFontName :self.selectedFontType];

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

- (UIColor*)selectedBgColor
{
    return  backGroundColor;
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
