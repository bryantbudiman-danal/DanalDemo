//
//  HTTPRequester.h
//  DanalMobile
//
//  Created by BENJAMIN BRYANT BUDIMAN on 05/09/18.
//  Copyright © 2018 Danal, Inc. All rights reserved.
//

#ifndef HTTPRequester_h
#define HTTPRequester_h

#import <Foundation/Foundation.h>

@interface HTTPRequester : NSObject
+ (NSString *)performGetRequest:(NSURL *)url;
@end

#endif /* HTTPRequester_h */
