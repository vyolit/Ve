//
//  VeCore.h
//  Vē
//
//  Created by Alexandra Aurora Göttlicher
//

#import <substrate.h>
#import <Foundation/Foundation.h>
#import "../../Manager/LogManager.h"

NSUserDefaults* preferences;
BOOL pfEnabled;
NSUInteger pfLogLimit;
BOOL pfSaveLocalAttachments;
BOOL pfSaveRemoteAttachments;
BOOL pfLogWithoutContent;
NSArray* pfBlockedSenders;
BOOL pfAutomaticallyDeleteLogs;

@interface BBServer : NSObject
@end
