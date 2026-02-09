//
//  YYTextDarkModeDebugExample.m
//  YYKitExample
//
//  Created by Apple on 2026/2/9.
//

#import "YYTextDarkModeDebugExample.h"
#import "YYKit.h"

@interface YYTextDarkModeDebugExample ()
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UISegmentedControl *styleControl;
@end

@implementation YYTextDarkModeDebugExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [self dynamicBackgroundColor];

    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"System", @"Light", @"Dark"]];
    control.selectedSegmentIndex = 0;
    [control addTarget:self action:@selector(styleChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    self.styleControl = control;

    YYLabel *label = [YYLabel new];
    label.numberOfLines = 0;
    label.userInteractionEnabled = YES;
    label.attributedText = [self debugText];
    [self.view addSubview:label];
    self.label = label;

    YYTextView *textView = [YYTextView new];
    textView.editable = NO;
    textView.selectable = NO;
    textView.scrollEnabled = YES;
    textView.backgroundColor = [UIColor clearColor];
    textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    textView.attributedText = [self debugText];
    [self.view addSubview:textView];
    self.textView = textView;

    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat padding = 16.0;
    CGFloat width = self.view.bounds.size.width - padding * 2.0;
    CGFloat top = padding;
    if (@available(iOS 11.0, *)) {
        top += self.view.safeAreaInsets.top;
    }

    CGFloat controlHeight = 32.0;
    self.styleControl.frame = CGRectMake(padding, top, width, controlHeight);

    CGFloat labelTop = CGRectGetMaxY(self.styleControl.frame) + 12.0;
    CGSize labelSize = [self.label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    self.label.frame = CGRectMake(padding, labelTop, width, labelSize.height);

    CGFloat textViewTop = CGRectGetMaxY(self.label.frame) + 12.0;
    CGFloat textViewHeight = self.view.bounds.size.height - textViewTop - padding;
    if (@available(iOS 11.0, *)) {
        textViewHeight -= self.view.safeAreaInsets.bottom;
    }
    if (textViewHeight < 120.0) textViewHeight = 120.0;
    self.textView.frame = CGRectMake(padding, textViewTop, width, textViewHeight);
}

- (void)styleChanged:(UISegmentedControl *)control {
    if (!@available(iOS 13.0, *)) return;
    switch (control.selectedSegmentIndex) {
        case 1:
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
            break;
        case 2:
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
            break;
        default:
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
            break;
    }
}

- (NSMutableAttributedString *)debugText {
    NSString *string = @"YYLabel / YYTextView dynamic color\nUnderline / Background / Highlight\nToggle Dark/Light above";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.font = [UIFont systemFontOfSize:16.0];
    text.color = [self dynamicTextColor];
    text.lineSpacing = 6.0;

    NSRange underlineRange = [string rangeOfString:@"Underline"];
    if (underlineRange.location != NSNotFound) {
        YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle];
        decoration.color = [self dynamicAccentColor];
        [text setTextUnderline:decoration range:underlineRange];
    }

    NSRange backgroundRange = [string rangeOfString:@"Background"];
    if (backgroundRange.location != NSNotFound) {
        YYTextBorder *border = [YYTextBorder new];
        border.fillColor = [self dynamicBadgeColor];
        border.cornerRadius = 3.0;
        border.insets = UIEdgeInsetsMake(-2, -4, -2, -4);
        [text setTextBackgroundBorder:border range:backgroundRange];
    }

    NSRange highlightRange = [string rangeOfString:@"Highlight"];
    if (highlightRange.location != NSNotFound) {
        YYTextHighlight *highlight = [YYTextHighlight new];
        YYTextBorder *highlightBorder = [YYTextBorder new];
        highlightBorder.fillColor = [self dynamicHighlightColor];
        highlightBorder.cornerRadius = 3.0;
        highlightBorder.insets = UIEdgeInsetsMake(-2, -4, -2, -4);
        [highlight setBackgroundBorder:highlightBorder];
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            NSLog(@"YYText dark mode highlight tapped");
        };
        [text setTextHighlight:highlight range:highlightRange];
    }

    return text;
}

- (UIColor *)dynamicTextColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            return traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? [UIColor whiteColor] : [UIColor blackColor];
        }];
    }
    return [UIColor blackColor];
}

- (UIColor *)dynamicAccentColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            return traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? [UIColor colorWithRed:0.90 green:0.75 blue:0.20 alpha:1.0] : [UIColor colorWithRed:0.20 green:0.35 blue:0.90 alpha:1.0];
        }];
    }
    return [UIColor colorWithRed:0.20 green:0.35 blue:0.90 alpha:1.0];
}

- (UIColor *)dynamicBadgeColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            return traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? [UIColor colorWithWhite:1.0 alpha:0.15] : [UIColor colorWithWhite:0.0 alpha:0.08];
        }];
    }
    return [UIColor colorWithWhite:0.0 alpha:0.08];
}

- (UIColor *)dynamicHighlightColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            return traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? [UIColor colorWithRed:0.30 green:0.55 blue:1.0 alpha:0.35] : [UIColor colorWithRed:0.30 green:0.55 blue:1.0 alpha:0.20];
        }];
    }
    return [UIColor colorWithRed:0.30 green:0.55 blue:1.0 alpha:0.20];
}

- (UIColor *)dynamicBackgroundColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor systemBackgroundColor];
    }
    return [UIColor whiteColor];
}

@end

