//
//  HttpRequest.m
//  01-NSURLSession
//
//  Created by vera on 16/9/9.
//  Copyright © 2016年 deli. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

/**
 *  把参数用&拼接到一起
 *
 *  @param paramters <#paramters description#>
 */
+ (NSString *)paramterString:(NSDictionary *)paramters
{
    NSMutableString *string = [NSMutableString string];
    
    NSArray *allKeys = paramters.allKeys;
    
    for (int i = 0; i < allKeys.count; i++)
    {
        NSString *key = allKeys[i];
        
        if (i == allKeys.count - 1)
        {
            [string appendFormat:@"%@=%@",key,paramters[key]];
        }
        else
        {
            [string appendFormat:@"%@=%@&",key,paramters[key]];
        }
    }
    
    return string;
}

/**
 *  发送GET请求
 *
 *  @param urlString <#urlString description#>
 *  @param paramters <#paramters description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+ (void)GET:(NSString *)urlString paramters:(NSDictionary *)paramters success:(HttpRequestSuccessCallBack)success failure:(HttpRequestFailureCallBack)failure
{
    /*
     NSURLSession把请求分成3种：
     1.NSURLSessionDataTask   -- 网络请求，没有进度
     2.NSURLSessionDownloadTask  -- 网络请求(下载)，有进度
     3.NSURLSessionUploadTask  -- 文件上传
     */
    
    //参数
    if (paramters)
    {
        NSString *paramterString = [self paramterString:paramters];
        
        urlString = [NSString stringWithFormat:@"%@?%@",urlString,paramterString];
    }
    
    //请求类
    NSURLSession *session = [NSURLSession sharedSession];
    
    //获取请求数据类
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlString]
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //完成请求后会触发
        
        //判断是否是主线程
        //NSLog(@"%d",[NSThread isMainThread]);
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            //请求失败
            if(error && failure)
            {
                failure(error);
            }
            else
            {
                //成功回调
                if(success)
                {
                    id presonseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    success(presonseObject);
                }
            }
        });
        
    }];
    //发送请求
    [task resume];
    
    
    /*
    [session dataTaskWithURL:<#(nonnull NSURL *)#>];
    [session dataTaskWithRequest:<#(nonnull NSURLRequest *)#>];
    [session dataTaskWithURL:<#(nonnull NSURL *)#> completionHandler:<#^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)completionHandler#>];
    [session dataTaskWithRequest:<#(nonnull NSURLRequest *)#> completionHandler:<#^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)completionHandler#>];
     */
    
    
}

@end
