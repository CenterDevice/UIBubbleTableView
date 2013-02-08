//
//  NSBubbleData.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <Foundation/Foundation.h>
#import "BubbleTypes.h"
#import "Comment.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000 // iOS 6.0 or later
#define LINEBREAKMODE 0
#else                                         // iOS 5.X or earlier
#define LINEBREAKMODE 1
#endif

@interface NSBubbleData : NSObject

@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic) NSBubbleType type;
@property (readonly, nonatomic) NSString* author;
@property (readonly, nonatomic, strong) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) Comment* comment;

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets;
+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets;

// expansion to support author of the comment.
- (id)initWithText:(NSString *)text date:(NSDate *)date author:(NSString *)author type:(NSBubbleType)type;
+ (id)dataWithText:(NSString *)text date:(NSDate *)date author:(NSString *)author type:(NSBubbleType)type;
- (id)initWithView:(UIView *)view date:(NSDate *)date author:(NSString *)author type:(NSBubbleType)type insets:(UIEdgeInsets)insets;
- (id)dataWithComment:(Comment *)comment type:(NSBubbleType)type;

@end
