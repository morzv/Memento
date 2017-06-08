//
//  UserService.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "UserService.h"
#import "User.h"
#import "UserMapper.h"
#import "TransportLayer.h"


@interface UserService ()

@property (nonatomic, strong) UserMapper *userMapper;
@property (nonatomic, copy) NSString *path;

@end


@implementation UserService

- (NSString *)path {
    if (!_path) {
        _path = @"users";
    }
    
    return _path;
}

- (UserMapper *)userMapper {
    if (!_userMapper) {
        _userMapper = [UserMapper new];
    }
    
    return _userMapper;
}

- (void)obtainUserWithId:(NSString *)uid completion:(UserServiceCompletionBlock)completion {
    if (uid) {
        
        [self.transort obtainDataWithPath:self.path userId:uid success:^(id response) {
            User *user = [self.userMapper modelFromJsonOfObject:response];
            completion(user, nil);
            
        } failure:^(NSError *error) {
            completion(nil, error);
        }];
    }
}

- (void)obtainLogginedUserWithCompletion:(UserServiceCompletionBlock)completion {
    
    [self.transort obtainDataWithPath:self.path userId:@"" success:^(id response) {
        User *user = [self.userMapper modelFromJsonOfObject:response];
        completion(user, nil);
        
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}

- (void)postUser:(User *)user completion:(UserServiceCompletionBlock)completion {
    NSDictionary *jsonModel = [self.userMapper jsonFromModel:user];
    
    [self.transort postData:jsonModel databasePath:self.path userId:user.uid success:^(id response) {
        completion(user, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}

- (void)updateProfilePhotoWithData:(NSData *)photoData uid:(NSString *)uid completion:(UserServiceUploadCompletionBlock)completion {
    [self.transort uploadData:photoData storagePath:@"profileImages" userId:uid success:^(id response) {
        completion(response, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}

@end
