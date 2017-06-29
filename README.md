# react-native-bdpush
react-native百度云推送
### 导出方法
- `monitorReceiveMessage` - 前台消息监听
    - `@callBack` - Function - 回调函数
    	- `@data` - Object - 消息内容
    	    - `@title` - String - 消息标题 (只有android存在该字段)
            - `@description` - String - 消息内容
            - `@customContentString` - Object - 附加字段

# 


- `monitorReceiveMessage` - 点击通知栏消息监听
    - `@callBack` - Function - 回调函数
    	- `@data` - Object - 消息内容
    	    - `@title` - String - 消息标题 (只有android存在该字段)
            - `@description` - String - 消息内容
            - `@customContentString` - Object - 附加字段

# 
        
- `getChannelId` - 获取ChannelId
    - `@callBack` - Function - 回调函数
    	- `@data` - String - ChannelId

# 

- `monitorMessageCancel` - 取消消息监听

# 

### 使用实例

	import BdPush from 'react-native-bdpush';
	
	constructor () {
        super();
        
        //前台消息监听
        BdPush.monitorReceiveMessage((message)=>{
          console.log("前台消息="+JSON.stringify(message));
        });
    
        //点击通知栏消息监听
        BdPush.monitorBackstageOpenMessage((message)=>{
          console.log("点击通知栏消息="+JSON.stringify(message));
        });
    
        //获取ChannelId
        BdPush.getChannelId().then((ChannelId)=>{
          console.log("ChannelId="+ChannelId);
        });
    
        //取消消息监听
        // BdPush.monitorMessageCancel();
    
    }
	 
	
#使用方法
## npm i react-native-bdpush -save
####android配置
1. 设置 `android/setting.gradle`

    ```
    ...
    include ':baidupush'
    project(':baidupush').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-bdpush/android')
	
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
    import com.example.qiepeipei.react_native_bdpush.BGBaiDuPushPackage;  // <--- 导入

    public class MainApplication extends Application implements ReactApplication {
      ......

        @Override
    	protected List<ReactPackage> getPackages() {
      		return Arrays.<ReactPackage>asList(
          			new MainReactPackage(),
          			new BGBaiDuPushPackage()      //<--- 添加
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
   
#import "BaiDuPushManager.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

  ...
  
  //注册百度云推送
  [BaiDuPushManager registerWithAppkey:@"输入你的API Key" launchOptions:launchOptions application:application];
  
  return YES;
}
// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  
  [BaiDuPushManager application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
  
  [application registerForRemoteNotifications];
  
  
}

//注册deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  
  [BaiDuPushManager application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
  
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  [BaiDuPushManager application:application didFailToRegisterForRemoteNotificationsWithError:error];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

}


   ```
#####设置 Library Search Paths $(SRCROOT)/../node_modules/react-native-bdpush/ios/normalversion/（注意如果是发布版本请添加这行 $(SRCROOT)/../node_modules/react-native-bdpush/ios/idfaversion/）

![Mou icon1](/assets/b1.png)

####打开该目录 ../node_modules/react-native-bdpush/ios


![Mou icon1](/assets/b2.png)


![Mou icon1](/assets/b3.png)


![Mou icon1](/assets/b4.png)


![Mou icon1](/assets/b2.png)


![Mou icon1](/assets/b5.png)

