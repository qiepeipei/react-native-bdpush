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
