//
//  HttpRequest.h
//  01-NSURLSession
//
//  Created by vera on 16/9/9.
//  Copyright © 2016年 deli. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求成功回调
typedef void(^HttpRequestSuccessCallBack)(id responseObject);
//请求失败回调
typedef void(^HttpRequestFailureCallBack)(NSError *error);

@interface HttpRequest : NSObject

/**
 *  发送GET请求
 *
 *  @param urlString <#urlString description#>
 *  @param paramters <#paramters description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+ (void)GET:(NSString *)urlString paramters:(NSDictionary *)paramters success:(HttpRequestSuccessCallBack)success failure:(HttpRequestFailureCallBack)failure;

@end
