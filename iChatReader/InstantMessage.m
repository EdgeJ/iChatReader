//
//  InstantMessage.m
//  ichat2json
//
//  Created by Keyvan Fatehi on 12/9/16.
//  Copyright © 2016 Keyvan Fatehi. All rights reserved.

#import "InstantMessage.h"

@implementation InstantMessage
- (id)initWithCoder:(NSCoder *)decoder;
{
    if (!(self = [super init]))
        return nil;

    _sender = [decoder decodeObjectForKey:@"Sender"];
    _subject = [decoder decodeObjectForKey:@"Subject"];
    _date = [decoder decodeObjectForKey:@"Time"];
    _message = [decoder decodeObjectForKey:@"MessageText"];
    _files = [[NSMutableArray alloc] init];
    _isMultiParty = false;
    _isRead = [(NSNumber*)[decoder decodeObjectForKey:@"IsRead"] integerValue] == 1 ? true : false;
    NSArray *fileIds = [self getAttributesWithKey:@"__kIMFilenameAttributeName" fromAttributedString:_message];
    NSArray *fileNames = [self getAttributesWithKey:@"__kIMFileTransferGUIDAttributeName" fromAttributedString:_message];
    [fileIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fileId = [fileIds objectAtIndex:idx];
        NSString *fileName = [fileNames objectAtIndex:idx];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:fileId, @"id", fileName, @"name", nil];
        [_files addObject:dict];
    }];
    return self;
}

- (NSArray *) getAttributesWithKey: (NSString *)attrKey fromAttributedString:(NSAttributedString *)attrStr
{
    NSRange effectiveRange = NSMakeRange(0, 0);
    NSMutableArray *mArray = [NSMutableArray array];
    id value;
    while (NSMaxRange(effectiveRange) < [attrStr length]) {
        value = [attrStr attribute:attrKey atIndex:NSMaxRange(effectiveRange) effectiveRange:&effectiveRange];
        if (value != nil) {
            [mArray addObject:value];
        }
    }
    return [mArray copy];
}

- (void)encodeWithCoder:(NSCoder *)encoder;
{ NSAssert1(NO, @"%@ does not allow encoding.", [self class]); }
@end
