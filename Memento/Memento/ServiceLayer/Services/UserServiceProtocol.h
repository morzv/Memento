//
//  UserServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

typedef void (^UserServiceCompletionBlock)(User *user, NSError *error);
typedef void (^UserServiceUploadCompletionBlock)(NSString *url, NSError *error);


@protocol UserServiceProtocol <NSObject>

- (void)obtainUserWithId:(NSString *)uid completion:(UserServiceCompletionBlock)completion;
- (void)obtainLogginedUserWithCompletion:(UserServiceCompletionBlock)completion;

- (void)postUser:(User *)user completion:(UserServiceCompletionBlock)completion;
- (void)updateProfilePhotoWithData:(NSData *)photoData uid:(NSString *)uid completion:(UserServiceUploadCompletionBlock)completion;

@end
