//
//  Decoder.m
//  iChatOpener
//
//  Created by John Edge on 4/8/23.
//

#import <Foundation/Foundation.h>
#import "InstantMessage.h"
#import "Presentity.h"
#import "StubCoder.h"

NSMutableArray * IChatDecoder(NSData * data) {
    [NSKeyedUnarchiver setClass:[InstantMessage class] forClassName:@"InstantMessage"];
    [NSKeyedUnarchiver setClass:[Presentity class] forClassName:@"Presentity"];
    
    [NSKeyedUnarchiver setClass:[StubCoder class] forClassName:@"NSFont"];
    [NSKeyedUnarchiver setClass:[StubCoder class] forClassName:@"NSMutableParagraphStyle"];
    [NSKeyedUnarchiver setClass:[StubCoder class] forClassName:@"NSTextAttachment"];
    [NSKeyedUnarchiver setClass:[StubCoder class] forClassName:@"NSColor"];
    
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray* root = [unarchiver decodeObjectForKey:@"$root"];
    NSMutableArray *ims = [NSMutableArray array];
    NSMutableSet *people = [NSMutableSet set];
    for (id object in root) {
        if ([object isKindOfClass:[NSArray class]]) {
            for (id sub in object) {
                if ([sub isKindOfClass:[InstantMessage class]]) {
                    InstantMessage *im = (InstantMessage *) sub;
                    if ([im subject] != nil)
                        [people addObject:im.subject.accountName];
                    if ([im sender] != nil)
                        [people addObject:im.sender.accountName];
                    [ims addObject:im];
                }
                if ([sub isKindOfClass:[Presentity class]]) {
                    Presentity *prs = (Presentity *) sub;
                    [people addObject:prs.accountName];
                }
            }
        }
    }
    for (InstantMessage* im in ims){
        if ([people count] > 2) {
            [im setIsMultiParty:true];
        }
        [im setParticipantIds:people];
        [im setChatId: [root lastObject]];
    }
    return ims;
}
