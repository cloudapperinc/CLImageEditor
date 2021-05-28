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
    UIStackView *fontNameSV;
    // -1:default -2: bold -3: italic -4: both
    NSInteger selectedFontWeight;
    // same as view tags 0,1,2..
    NSInteger selectedFontName;

    UIButton *arialFontBtn;
    UIButton *courierNewFontBtn;
    UIButton *timesFontBtn;
    UIButton *verdanaFontBtn;
    UIButton *helveticaNeueFontBtn;

    UIButton *boldFontBtn;
    UIButton *italicFontBtn;
    
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
    
    // adding stackViews didnt work here. First designed for iphoneSE2 (which is 375 width)
    for (int i = 0; i <= 2; i++)
    {
        for (int j = 0; j <= 5; j++)
        {
            UILabel *testLabel;
            testLabel = [[UILabel alloc] initWithFrame:CGRectMake( (_bgPanel.width-375)/2 + 15 + j*60, 35+ i*50, 35, 35)];
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
     
    arialFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   [arialFontBtn setFrame:CGRectMake(0, 0, 100, 40)];
    
   [arialFontBtn setImage:[UIImage imageNamed:@"unchecked.png"]
           forState:UIControlStateNormal];
   [arialFontBtn setImage:[UIImage imageNamed:@"radioChecked.png"]
           forState:UIControlStateSelected];

    [arialFontBtn addTarget:self
               action:@selector(chkBtnHandler:)
     forControlEvents:UIControlEventTouchUpInside];

    // Optional title change for checked/unchecked
    [arialFontBtn setTitle:@" Arial"
           forState:UIControlStateNormal];
    arialFontBtn.tintColor = [UIColor blackColor];
    [arialFontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    courierNewFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [courierNewFontBtn setFrame:CGRectMake(0, 0, 100, 40)];
    
    // courier
   [courierNewFontBtn setImage:[UIImage imageNamed:@"unchecked.png"]
           forState:UIControlStateNormal];
   [courierNewFontBtn setImage:[UIImage imageNamed:@"radioChecked.png"]
           forState:UIControlStateSelected];

    [courierNewFontBtn addTarget:self
               action:@selector(chkBtnHandler:)
     forControlEvents:UIControlEventTouchUpInside];

    // Optional title change for checked/unchecked
    [courierNewFontBtn setTitle:@" Courier New"
           forState:UIControlStateNormal];
    courierNewFontBtn.tintColor = [UIColor blackColor];
    [courierNewFontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
     timesFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   [timesFontBtn setFrame:CGRectMake(0, 0, 100, 40)];
    
    // courier
   [timesFontBtn setImage:[UIImage imageNamed:@"unchecked.png"]
           forState:UIControlStateNormal];
   [timesFontBtn setImage:[UIImage imageNamed:@"radioChecked.png"]
           forState:UIControlStateSelected];

    [timesFontBtn addTarget:self
               action:@selector(chkBtnHandler:)
     forControlEvents:UIControlEventTouchUpInside];

    // Optional title change for checked/unchecked
    [timesFontBtn setTitle:@" Times New Roman"
           forState:UIControlStateNormal];
    timesFontBtn.tintColor = [UIColor blackColor];
    [timesFontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // verdana
    verdanaFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   [verdanaFontBtn setFrame:CGRectMake(0, 0, 100, 40)];
    
   [verdanaFontBtn setImage:[UIImage imageNamed:@"unchecked.png"]
           forState:UIControlStateNormal];
   [verdanaFontBtn setImage:[UIImage imageNamed:@"radioChecked.png"]
           forState:UIControlStateSelected];

    [verdanaFontBtn addTarget:self
               action:@selector(chkBtnHandler:)
     forControlEvents:UIControlEventTouchUpInside];

    // Optional title change for checked/unchecked
    [verdanaFontBtn setTitle:@" Verdana"
           forState:UIControlStateNormal];
    verdanaFontBtn.tintColor = [UIColor blackColor];
    [verdanaFontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // Helvetica Neue
    helveticaNeueFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   [helveticaNeueFontBtn setFrame:CGRectMake(0, 0, 100, 40)];
   [helveticaNeueFontBtn setImage:[UIImage imageNamed:@"unchecked.png"]
           forState:UIControlStateNormal];
   [helveticaNeueFontBtn setImage:[UIImage imageNamed:@"radioChecked.png"]
           forState:UIControlStateSelected];

    [helveticaNeueFontBtn addTarget:self
               action:@selector(chkBtnHandler:)
     forControlEvents:UIControlEventTouchUpInside];

    // Optional title change for checked/unchecked
    [helveticaNeueFontBtn setTitle:@" Helvetica Neue"
           forState:UIControlStateNormal];
    helveticaNeueFontBtn.tintColor = [UIColor blackColor];
    [helveticaNeueFontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  
    fontNameSV = [[UIStackView alloc] init];

    fontNameSV.axis = UILayoutConstraintAxisVertical;
    fontNameSV.distribution = UIStackViewDistributionEqualSpacing;
    fontNameSV.alignment = UIStackViewAlignmentLeading;
    fontNameSV.spacing = 10;

    [fontNameSV addArrangedSubview:arialFontBtn];
    [fontNameSV addArrangedSubview:verdanaFontBtn];
    [fontNameSV addArrangedSubview:courierNewFontBtn];
    [fontNameSV addArrangedSubview:helveticaNeueFontBtn];
    [fontNameSV addArrangedSubview:timesFontBtn];

    fontNameSV.translatesAutoresizingMaskIntoConstraints = false;
    [_fontPanel addSubview:fontNameSV];

    //Layout for Stack View
    [fontNameSV.leadingAnchor constraintEqualToAnchor:_fontPanel.centerXAnchor constant: -160].active = true;
    [fontNameSV.centerYAnchor constraintEqualToAnchor:_fontPanel.centerYAnchor].active = true;
    
     
    // font weight
    
       italicFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [italicFontBtn setFrame:CGRectMake(0, 0, 100, 40)];
        
       [italicFontBtn setImage:[UIImage imageNamed:@"unchecked.png"]
               forState:UIControlStateNormal];
       [italicFontBtn setImage:[UIImage imageNamed:@"checked.png"]
               forState:UIControlStateSelected];

    [italicFontBtn addTarget:self
                   action:@selector(chkBtnHandler:)
         forControlEvents:UIControlEventTouchUpInside];

        // Optional title change for checked/unchecked
        [italicFontBtn setTitle:@" Italic"
               forState:UIControlStateNormal];
        italicFontBtn.tintColor = [UIColor blackColor];
        [italicFontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [italicFontBtn.titleLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:16.0] ];
 
        boldFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [boldFontBtn setFrame:CGRectMake(0, 0, 100, 40)];
          
        [boldFontBtn setImage:[UIImage imageNamed:@"unchecked.png"]
            forState:UIControlStateNormal];
        [boldFontBtn setImage:[UIImage imageNamed:@"checked.png"]
            forState:UIControlStateSelected];

        [boldFontBtn addTarget:self
                action:@selector(chkBtnHandler:)
      forControlEvents:UIControlEventTouchUpInside];

        // Optional title change for checked/unchecked
        [boldFontBtn setTitle:@" Bold"
            forState:UIControlStateNormal];
        boldFontBtn.tintColor = [UIColor blackColor];
        [boldFontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [boldFontBtn.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16.0]];
  
    //Stack View
        UIStackView *fontWeightSV = [[UIStackView alloc] init];

        fontWeightSV.axis = UILayoutConstraintAxisVertical;
        fontWeightSV.distribution = UIStackViewDistributionEqualSpacing;
        fontWeightSV.alignment = UIStackViewAlignmentLeading;
        fontWeightSV.spacing = 15;
 
        [fontWeightSV addArrangedSubview:boldFontBtn];
        [fontWeightSV addArrangedSubview:italicFontBtn];
 
        fontWeightSV.translatesAutoresizingMaskIntoConstraints = false;
        [_fontPanel addSubview:fontWeightSV];
 
        //Layout for Stack View
        [fontWeightSV.leadingAnchor constraintEqualToAnchor:_fontPanel.centerXAnchor constant:80].active = true;
        [fontWeightSV.centerYAnchor constraintEqualToAnchor:_fontPanel.centerYAnchor].active = true;
  
    arialFontBtn.tag = 0;
    verdanaFontBtn.tag = 1;
    courierNewFontBtn.tag = 2;
    helveticaNeueFontBtn.tag = 3;
    timesFontBtn.tag = 4;

    italicFontBtn.tag = -1;
    boldFontBtn.tag = -2;
    
    // default values
    selectedFontWeight = -1; // Regular
    selectedFontName = 0; // Arial
    
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
    
    UIView *dummyView;
    dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [_scrollView addSubview:dummyView];
    dummyView.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:238.0/255.0 blue:247.0/255.0 alpha:0.7];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.width-42, 80)];
    _textView.delegate = self;
    [_scrollView addSubview:_textView];
    _textView.backgroundColor = [UIColor clearColor];
    
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
  
- (void)chkBtnHandler:(UIButton *)sender {
    // If checked, uncheck and visa versa
    if (sender.tag < 0) {
         
        [sender setSelected:!sender.isSelected];
        // change font weight variable
        if (!boldFontBtn.isSelected && !italicFontBtn.isSelected) {
            selectedFontWeight = -1;
        } else if (boldFontBtn.isSelected && !italicFontBtn.isSelected) {
            selectedFontWeight = -2;
        } else if (!boldFontBtn.isSelected && italicFontBtn.isSelected) {
            selectedFontWeight = -3;
        } else {
            selectedFontWeight = -4;
        }
        
        // change font
        UIFont *font = [self getFont];
        [self didSelectFont: font];
        
    } else {
        
        for (UIButton *button in fontNameSV.subviews)
           {
               if (button.tag != sender.tag) {
                   [button setSelected: NO];
               } else {
                   if (!sender.isSelected) {
                       [sender setSelected: YES];
                       selectedFontName = sender.tag;
                       // change font
                       UIFont *font = [self getFont];
                       [self didSelectFont: font];
                   }
               }
           }
         
    }
     
    
}


#pragma mark - Properties

-(UIFont*) getFont {

    UIFont *font;

        switch (selectedFontName) {
                
            case 0:
                switch (selectedFontWeight) {
                    case -1:
                        font = [UIFont fontWithName: @"ArialMT" size: 14];
                        break;
                    case -2:
                        font = [UIFont fontWithName: @"Arial-BoldMT" size: 14];
                        break;
                    case -3:
                        font = [UIFont fontWithName: @"Arial-ItalicMT" size: 14];
                        break;
                    case -4:
                        font = [UIFont fontWithName: @"Arial-BoldItalicMT" size: 14];
                        break;
                    default:
                    break;
                }
                break;
            case 1:
                switch (selectedFontWeight) {
                    case -1:
                        font = [UIFont fontWithName: @"CourierNewPSMT" size: 14];
                        break;
                    case -2:
                        font = [UIFont fontWithName: @"CourierNewPS-BoldMT" size: 14];
                        break;
                    case -3:
                        font = [UIFont fontWithName: @"CourierNewPS-ItalicMT" size: 14];
                        break;
                    case -4:
                        font = [UIFont fontWithName: @"CourierNewPS-BoldItalicMT" size: 14];
                        break;
                    default:
                    break;
                }
                break;
            case 2:
                switch (selectedFontWeight) {
                    case -1:
                        font = [UIFont fontWithName: @"TimesNewRomanPSMT" size: 14];
                        break;
                    case -2:
                        font = [UIFont fontWithName: @"TimesNewRomanPS-BoldMT" size: 14];
                        break;
                    case -3:
                        font = [UIFont fontWithName: @"TimesNewRomanPS-ItalicMT" size: 14];
                        break;
                    case -4:
                        font = [UIFont fontWithName: @"TimesNewRomanPS-BoldItalicMT" size: 14];
                        break;
                    default:
                    break;
                }
                break;
            case 3:
                switch (selectedFontWeight) {
                    case -1:
                        font = [UIFont fontWithName: @"Verdana" size: 14];
                        break;
                    case -2:
                        font = [UIFont fontWithName: @"Verdana-Bold" size: 14];
                        break;
                    case -3:
                        font = [UIFont fontWithName: @"Verdana-Italic" size: 14];
                        break;
                    case -4:
                        font = [UIFont fontWithName: @"Verdana-BoldItalic" size: 14];
                        break;
                    default:
                    break;
                }
                break;
            case 4:
                switch (selectedFontWeight) {
                    case -1:
                        font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
                        break;
                    case -2:
                        font = [UIFont fontWithName: @"HelveticaNeue-Bold" size: 14];
                        break;
                    case -3:
                        font = [UIFont fontWithName: @"HelveticaNeue-Italic" size: 14];
                        break;
                    case -4:
                        font = [UIFont fontWithName: @"HelveticaNeue-BoldItalic" size: 14];
                        break;
                    default:
                    break;
                }
                break;
            default:
               break;
        }
    
        return font;
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
