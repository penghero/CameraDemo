//
//  UserDefault.swift
//  CameraDemo
//
//  Created by 陈鹏 on 2018/1/15.
//  Copyright © 2018年 penggege.CP. All rights reserved.
//https://github.com/penghero/CameraDemo.git

import UIKit

class UserDefault: NSObject {
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
}


