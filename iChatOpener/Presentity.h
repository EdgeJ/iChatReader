//
//  Sender.h
//  ichat2json
//
//  Created by Keyvan Fatehi on 12/9/16.
//  Copyright © 2016 Keyvan Fatehi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Presentity : NSObject <NSCoding /* Decoding only */>

@property () NSString *accountName;
@property () NSString *serviceName;

@end
