# CameraDemo
Swift版的相机 由于项目需要 初学swift 请多关照
## 需真机调试
https://github.com/penghero/CameraDemo.git
# 演示GIF
![image](https://github.com/penghero/CameraDemo/blob/master/gif/Untitle2.gif)
# 概要
整体采用故事版搭建的页面 其中故事版页面的跳转方式 有必要讲一下 首先可以使用故事版内部 Segue跳转 不与多讲 仅说 用代码跳转故事版页面 直接附上代码
```
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let detailVC: DetailedModelController = story.instantiateViewController(withIdentifier: "DetailedModelController") as! DetailedModelController
        present(detailVC, animated:true, completion: nil
        //self.navigationController?.pushViewController(vc, animated: true)

```
### 数据存储方式
由于我的项目数据较少 仅存数张图片和部分视频URL链接 故 采用较为简单的UserDefaults进行存储 直接附上代码
```
    /**
     储存 对应键值
     UnityFileTypeGL ,UnityFileTypeCW ,UnityFileTypeZX ,UnityFileTypeXM ,UnityFileTypeLX
     对应数
UnityFileTypeGLArray ,UnityFileTypeCWArray ,UnityFileTypeZXArray ,UnityFileTypeXMArray ,UnityFileTypeLXArray
     - parameter key:   key
     - parameter value: value
     */
    public func setNormalDefault (_ key:String, _ value:AnyObject?) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        }
        else{
            UserDefaults.standard.setValue(value, forKey: key)
            // 同步
            UserDefaults.standard.synchronize()
        }
    }
    /**
     通过对应的key移除储存
     - parameter key: 对应key
     */
    public func removeNormalUserDefault(_ key:String?) {
        if key != nil {
            UserDefaults.standard.removeObject(forKey: key!)
            UserDefaults.standard.synchronize()
        }
    }
    /**
     通过key找到储存的value
     - parameter key: key
     - returns: AnyObject
     */
    public func getNormalDefult(_ key:String)->AnyObject? {
        return UserDefaults.standard.value(forKey: key) as AnyObject
    }

```
### 补充 图片存储方式
由于UserDefaults 它能直接存储基本数据类型数组 字典等 不能直接存储图片 需将其转化为NSData格式进行存储 直接附上代码
```
//存入
        let imageData: NSData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData
        let userDef = UserDefault()
        userDef.setNormalDefault("TemplateViewImage", imageData)
//读取
        let userDef = UserDefault()
        let imageD = userDef.getNormalDefult("TemplateViewImage") as? NSData
        if imageD != nil {
            imageData = userDef.getNormalDefult("TemplateViewImage") as? NSData
        } else { imageData = nil }
```
### 使用ARVideoKit库 进行AR景的拍照和录像
```
//拍照
        if recorder?.status == .readyToRecord {
            let image = self.recorder?.photo()
            self.recorder?.export(UIImage: image) { saved, status in
                if saved {
                    self.exportMessage(success: saved, status: status)
                }
            }
          }
//录像
  if recorder?.status == .readyToRecord {
            cVideo.setTitle("录制结束", for: .normal)
            cVideo.setBackgroundImage(#imageLiteral(resourceName: "cstop"), for: .normal)
            recordingQueue.async {
                self.recorder?.record()
            }
            cVideo.setTitle("开始录制", for: .normal)
            cVideo.setBackgroundImage(#imageLiteral(resourceName: "cstart"), for: .normal)
            recorder?.stop() { path in
                self.recorder?.export(video: path) { saved, status in
                    DispatchQueue.main.sync {
                        self.exportMessage(success: saved, status: status)
                    }
                }
            }
        }
```
# 联系 
如遇问题 请与我联系 我们一起探讨 研究  896733185@qq.com
# 感谢
特别感谢这个ARVideoKit作者 附上链接 https://github.com/AFathi/ARVideoKit
