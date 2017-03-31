//
//  AFNetworkingViewController.m
//  Cocoa_Test
//
//  Created by feii on 17/3/23.
//  Copyright © 2017年 feii. All rights reserved.
//

#import "AFNetworkingViewController.h"
#import "AFNetworking.h"

@interface AFNetworkingViewController ()

@property (nonatomic , strong) NSMutableArray *imageArray;

@end

@implementation AFNetworkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getNetWorking];
    // Do any additional setup after loading the view.
}

-(void)obtainDataGet
{
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //前面写服务器给的域名,后面拼接上需要提交的参数，假如参数是key＝1
    NSString *domainStr = @"http://192.168.1.69/xffcol/index.php/Api/key/1/";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //以get的形式提交，只需要将上面的请求地址给GET做参数就可以
    [manager GET:domainStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 隐藏系统风火轮
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //json解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"---获取到的json格式的字典--%@",resultDic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }];
}

-(void)obtainDataPost
{
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //服务器给的域名
    NSString *domainStr = @"http://192.168.1.69/xffcol/index.php/Api/";
    
    //假如需要提交给服务器的参数是key＝1,class_id=100
    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parametersDic setObject:@"1" forKey:@"key"];
    [parametersDic setObject:@"100" forKey:@"class_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //以post的形式提交，POST的参数就是上面的域名，parameters的参数是一个字典类型，将上面的字典作为它的参数
    [manager POST:domainStr parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 隐藏系统风火轮
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //json解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"---获取到的json格式的字典--%@",resultDic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }];
}

-(void)uploadPictures{
    
    //域名
    NSString *domainStr = @"http://192.168.1.69/xffcol/index.php/Api/";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //如果还需要上传其他的参数，参考上面的POST请求，创建一个可变字典，存入需要提交的参数内容，作为parameters的参数提交
    [manager POST:domainStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         //_imageArray就是图片数组，我的_imageArray里面存的都是图片的data，下面可以直接取出来使用，如果存的是image，将image转换data的方法如下：NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
         if (_imageArray.count > 0 ){
             for(int i = 0;i < _imageArray.count;i ++){
                 NSData *data=_imageArray[i];
                 //上传的参数名
                 NSString *name = [NSString stringWithFormat:@"%d",i];
                 //上传的filename
                 NSString *fileName = [NSString stringWithFormat:@"%@.jpg",name];
                 [formData appendPartWithFileData:data
                                             name:name
                                         fileName:fileName
                                         mimeType:@"image/jpeg"];
             }
         }
         
     }success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //关闭系统风火轮
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         
         //json解析
         NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         NSLog(@"---resultDic--%@",resultDic);
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              // 解析失败
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          }];
}

- (void)getNetWorking{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"[http://example.com/resources.json](http://example.com/resources.json)"
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
