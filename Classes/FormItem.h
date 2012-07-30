//
//  FormItem.h
//  Sharetribe
//
//  Created by Janne Käki on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FormItemTypeTextField = 0,
    FormItemTypeTextArea,
    FormItemTypeChoice,
    FormItemTypeDate,
    FormItemTypeLocation,
    FormItemTypePhoto
} FormItemType;

@interface FormItem : NSObject

@property (assign, nonatomic) FormItemType type;
@property (strong, nonatomic) NSString *typeAsString;

@property (strong, nonatomic) NSString *formItemId;
@property (strong, nonatomic) NSString *subtitleKey;
@property (strong, nonatomic) NSString *mapsTo;
@property (assign, nonatomic) BOOL providesExplanation;
@property (assign, nonatomic) BOOL mandatory;
@property (strong, nonatomic) NSArray *alternatives;
@property (strong, nonatomic) NSString *defaultAlternative;
@property (assign, nonatomic) NSInteger defaultTimeIntervalInDays;
@property (assign, nonatomic) BOOL includeTime;
@property (assign, nonatomic) UITextAutocapitalizationType autocapitalizationType;

+ (NSArray *)formItemsFromDataArray:(NSArray *)dataArray;

- (NSString *)localizedTitle;
- (NSString *)localizedTitleForAlternative:(NSString *)alternative;
- (NSString *)localizedSubtitle;
- (NSString *)localizedExplanation;

@end
