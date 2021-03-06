/**
* Copyright (C) 2013 Andrew Rifken
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software
* and associated documentation files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge, publish, distribute,
* sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or
* substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
* NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
* DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
*/

#import <QuartzCore/QuartzCore.h>
#import "SignInView.h"


@implementation SignInView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //---------------------------------------- View setup ------------------------------------------------------

        self.backgroundColor = [UIColor whiteColor];

        self.layer.cornerRadius = 8.0;
        self.clipsToBounds = NO;
        self.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor];
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowRadius = 6.0;

        self.promptLabel = [[UILabel alloc] init];
        self.promptLabel.text = @"Sign In";
        self.promptLabel.textAlignment = NSTextAlignmentCenter;
        self.promptLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.promptLabel];

        self.clientIdField = [[UITextField alloc] init];
        self.clientIdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.clientIdField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.clientIdField.borderStyle = UITextBorderStyleRoundedRect;
        self.clientIdField.delegate = self;
        self.clientIdField.placeholder = @"Username";
        self.clientIdField.returnKeyType = UIReturnKeyJoin;
        [self addSubview:self.clientIdField];

        self.signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.signInButton addTarget:self action:@selector(signInTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
        [self addSubview:self.signInButton];


        //---------------------------------------- Auto layout ------------------------------------------------------

        UIView *pl = self.promptLabel;
        UIView *fld = self.clientIdField;
        UIView *btn = self.signInButton;

        pl.translatesAutoresizingMaskIntoConstraints = NO;
        fld.translatesAutoresizingMaskIntoConstraints = NO;
        btn.translatesAutoresizingMaskIntoConstraints = NO;


        NSMutableArray *layoutConstraints = [[NSMutableArray alloc] init];
        NSDictionary *metrics = @{
                @"margin" : [NSNumber numberWithFloat:12.0],
                @"gutter" : [NSNumber numberWithFloat:8.0],
        };


        [layoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[pl]-(gutter)-[fld]-(gutter)-[btn]-(>=margin)-|"
                                                                                       options:NSLayoutFormatAlignAllCenterX
                                                                                       metrics:metrics
                                                                                         views:NSDictionaryOfVariableBindings(pl, fld, btn)]];

        [layoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[pl(>=0)]-(margin)-|"
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:NSDictionaryOfVariableBindings(pl)]];

        [layoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[fld(>=0)]-(margin)-|"
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:NSDictionaryOfVariableBindings(fld)]];

        [self addConstraints:layoutConstraints];

    }

    return self;
}


- (CGSize)intrinsicContentSize {
    [self layoutIfNeeded];

    CGFloat height = CGRectGetMaxY(self.signInButton.frame) + 12.0;
    return CGSizeMake(250, height);
}

#pragma mark -
#pragma mark Events
//============================================================================================================

- (void)signInTapped:(id)signInTapped {
    [self.delegate signInView:self didLoginWithClientID:self.clientIdField.text];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.delegate signInView:self didLoginWithClientID:textField.text];
    return NO;
}



@end