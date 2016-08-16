# react-native-bdpush
react-native百度云推送
### 导出方法
- `penetrateEvent` - 监听透传消息
    - `@param` - Function - 回调函数
    	- `@param` - String - 消息内容


# 


- `pushEvent` - 监听通知栏点击
    - `@param` - Function - 回调函数
        - `@param` - String - 消息内容
        
        
# 
        
        
- `bindChannelWithCompleteHandler` - 重新启动推送
    - `@param` - Function - 回调函数
        - `@param` - int - 状态


#    


- `unbindChannelWithCompleteHandler` - 停止推送
    - `@param` - Function - 回调函数
        - `@param` - int - 状态


#    

- `setTag` - 设置tag
	- `@param` - String - tag内容
    - `@param` - Function - 回调函数
        - `@param` - int - 状态

#    

- `delTag` - 删除tag
	- `@param` - String - tag内容
    - `@param` - Function - 回调函数
        - `@param` - int - 状态

# 


### 使用实例

	var BaiDuPush = require('react-native-bdpush');
	
	   componentDidMount(){

        //创建推送对象并初始化
        this.bdpush = new BaiDuPush((state)=> {

            if(state == 0){

                console.log("初始化成功");

                //设置tag
                // this.bdpush.setTag("hello11",(state)=>{
                //
                //     if(state == 0){
                //
                //         console.log("tag设置成功");
                //
                //     }else{
                //
                //         console.log("tag设置失败");
                //
                //     }
                //
                //
                // });


                //删除tag
                // this.bdpush.delTag("hello",(state)=>{
                //
                //   if(state == 0){
                //
                //     console.log("tag删除成功");
                //
                //   }else{
                //
                //     console.log("tag删除失败");
                //
                //   }
                //
                //
                // });


                //停止推送
                // this.bdpush.unbindChannelWithCompleteHandler((state)=>{
                //
                //     if(state == 0){
                //
                //         console.log("停止推送成功");
                //
                //     }else{
                //
                //         console.log("停止推送失败");
                //
                //     }
                //
                //
                // });

                //重新开启推送
                // this.bdpush.bindChannelWithCompleteHandler((state)=>{
                //
                //   if(state == 0){
                //
                //     console.log("重新开启推送成功");
                //
                //   }else{
                //
                //     console.log("重新开启推送失败");
                //
                //   }
                //
                //
                // });



            }else{

                console.log("初始化失败");

            }

        });

        //接收透传消息
        this.bdpush.penetrateEvent((msg)=>{

            console.log("透传消息==="+msg);

        });

        //接收通知栏点击消息
        this.bdpush.pushEvent((msg)=>{

            console.log("通知消息==="+JSON.stringify(msg));

        });

    }

	
	
# npm install react-native-bdpush
####android配置
1. 设置 `android/setting.gradle`

    ```
    ...
	include ':baidupush'
	project(':baidupush').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-bdpush/android/baidupush')

	
    ```

2. 设置 `android/app/build.gradle`

    ```
    ...
    dependencies {
        ...
        compile project(':baidupush')
    }
    ```
    
3. 注册模块 (到 MainApplication.java)

    ```
    import com.example.baidupush.PushPackage;  // <--- 导入

    public class MainApplication extends Application implements ReactApplication {
      ......

        @Override
    	protected List<ReactPackage> getPackages() {
      		return Arrays.<ReactPackage>asList(
          			new MainReactPackage(),
          			new PushPackage()      //<--- 添加
      		);
    	} 

      ......

    }
    ```
    
![Mou icon1](/assets/a1.png)
	
![Mou icon1](/assets/a2.png)

![Mou icon1](/assets/a3.png)

###ios配置
####添加下面这段代码到AppDelegate.m下

   ```
   
   #define APPKEY @"当前用户的apiKey"
   
   	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:	(NSDictionary *)launchOptions{
    ...
	// 注册APNS
  	[self registerUserNotification];
  	  [BaiDuPush registerChannel:launchOptions apiKey:APPKEY pushMode:BPushModeDevelopment];
  
  [BaiDuPush disableLbs];
  
  // App 是用户点击推送消息启动
  NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (userInfo) {
    //[BPush handleNotification:userInfo];
    [BaiDuPush handleNotification:userInfo];

  }

  //角标清0
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  

}


	/** 注册用户通知 */
- (void)registerUserNotification {
  
  /*
   注册通知(推送)
   申请App需要接受来自服务商提供推送消息
   */
  
  // iOS8 下需要使用新的 API
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
  }else {
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
  }
  

}


// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  completionHandler(UIBackgroundFetchResultNewData);

  // 应用在前台，不跳转页面，让用户选择。
  if (application.applicationState == UIApplicationStateActive) {
    
    NSDictionary* data = [userInfo objectForKey:@"aps"];
    NSString* msg = [data objectForKey:@"alert"];
    [BaiDuPush receivePushMessages:msg];
  }
  
  //杀死状态下，直接跳转到跳转页面。
  if (application.applicationState == UIApplicationStateInactive)
  {

    NSDictionary* data = [userInfo objectForKey:@"aps"];
    NSString* msg = [data objectForKey:@"alert"];
    [BaiDuPush pushNotificationMessages:msg];

  }
  

}


// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
  
  [application registerForRemoteNotifications];
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  NSLog(@"test:%@",deviceToken);
  [BaiDuPush registerDeviceToken:deviceToken];

}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  NSLog(@"DeviceToken 获取失败，原因：%@",error);
}


   ```



####打开该目录 ../node_modules/react-native-bdpush/ios/baidupush


![Mou icon1](/assets/b1.png)


![Mou icon1](/assets/b2.png)

###../node_modules/react-native-bdpush/ios/baidupush/Push-Bridging-Header.h

![Mou icon1](/assets/b3.png)
