//
//  CameraViewController.swift
//  CameraDemo
//
//  Created by 陈鹏 on 2018/1/10.
//  Copyright © 2018年 penggege.CP. All rights reserved.
//https://github.com/penghero/CameraDemo.git

import UIKit
import ARKit
import Photos
import ARVideoKit



class CameraViewController: UIViewController, ARSCNViewDelegate, RenderARDelegate, RecordARDelegate {
    /* ARVideoKitDelegate */
    func frame(didRender buffer: CVPixelBuffer, with time: CMTime, using rawBuffer: CVPixelBuffer) {
        
    }
    
    func recorder(didEndRecording path: URL, with noError: Bool) {
        
    }
    
    func recorder(didFailRecording error: Error?, and status: String) {
        
    }
    
    func recorder(willEnterBackground status: RecordARStatus) {
        if status == .recording {
            recorder?.stopAndExport()
        }
    }
    

    @IBOutlet var cSceneView: ARSCNView!
    @IBOutlet var cBack: UIButton!
    @IBOutlet var cTimer: UILabel!
    @IBOutlet var cPhoto: UIButton!
    @IBOutlet var cVideo: UIButton!
    //UnityFileTypeGLArray ,UnityFileTypeCWArray ,UnityFileTypeZXArray ,UnityFileTypeXMArray ,UnityFileTypeLXArray

    var UnityFileTypeGLArray = [Any?]()
    var UnityFileTypeCWArray = [Any?]()
    var UnityFileTypeZXArray = [Any?]()
    var UnityFileTypeXMArray = [Any?]()
    
    var UnityFileTypeLXArray = [Any?]()
    var UnityFileTypeLXArrayImg = [Any?]()
    
    var fileType: UnityFileType = UnityFileType.UnityFileTypeGL
    var recorder: RecordAR?
    var isHiddenBtn: Bool = false
    let recordingQueue = DispatchQueue(label: "recordingThread", attributes: .concurrent)
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if isHiddenBtn {
            cPhoto.isHidden = true
        } else { cVideo.isHidden = true }

        //增加图片像素和录像像素
        
        recorder = RecordAR(ARSceneKit: cSceneView)
        recorder?.delegate = self
        recorder?.renderAR = self
        recorder?.onlyRenderWhileRecording = false
        recorder?.inputViewOrientations = [.landscapeLeft, .landscapeRight, .portrait]
        recorder?.deleteCacheWhenExported = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        cSceneView.session.run(configuration)
        // Prepare the recorder with sessions configuration
        recorder?.prepare(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Pause the view's session
        cSceneView.session.pause()
        if recorder?.status == .recording {
            recorder?.stopAndExport()
        }
        recorder?.onlyRenderWhileRecording = true
        recorder?.prepare(ARWorldTrackingConfiguration())
        // Switch off the orientation lock for UIViewControllers with AR Scenes
        recorder?.rest()
    }
    /* UIAlert提示 */
    func exportMessage(success: Bool, status:PHAuthorizationStatus) {
        if success {
            let alert = UIAlertController(title: "温馨提示", message: "成功保存到相册中", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if status == .denied || status == .restricted || status == .notDetermined {
            let errorView = UIAlertController(title: "温馨提示", message: "请允许访问照片库以保存此媒体文件", preferredStyle: .alert)
            let settingsBtn = UIAlertAction(title: "打开设置", style: .cancel) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                    }
                }
            }
            errorView.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: {
                (UIAlertAction)in
            }))
            errorView.addAction(settingsBtn)
            self.present(errorView, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "温馨提示", message: "导出媒体文件时出错", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    /* 拍照实现方法 */
    @IBAction func cPhotoAction(_ sender: Any) {
        if recorder?.status == .readyToRecord {
            let image = self.recorder?.photo()
            self.recorder?.export(UIImage: image) { saved, status in
                if saved {
                    self.exportMessage(success: saved, status: status)
                }
            }
            switch fileType {
            case .UnityFileTypeCW:
                let imageData: NSData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData
                UnityFileTypeCWArray.append(imageData)
                let userDef = UserDefault()
                userDef.setNormalDefault("UnityFileTypeCW", UnityFileTypeCWArray as NSArray)
                break
            case .UnityFileTypeGL:
                let imageData: NSData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData
                UnityFileTypeGLArray.append(imageData)
                let userDef = UserDefault()
                userDef.setNormalDefault("UnityFileTypeGL", UnityFileTypeGLArray as NSArray)
                break
            case .UnityFileTypeZX:
                let imageData: NSData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData
                UnityFileTypeZXArray.append(imageData)
                let userDef = UserDefault()
                userDef.setNormalDefault("UnityFileTypeZX", UnityFileTypeZXArray as NSArray)
                break
            case .UnityFileTypeXM:
                let imageData: NSData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData
                UnityFileTypeXMArray.append(imageData)
                let userDef = UserDefault()
                userDef.setNormalDefault("UnityFileTypeXM", UnityFileTypeXMArray as NSArray)
                break
            case .UnityFileTypeLX:
                
                break
            default:
                break
            }

        }
    }
    /* 录像实现方法 */
    @IBAction func cVideoAction(_ sender: Any) {
        if recorder?.status == .readyToRecord {
            cVideo.setTitle("录制结束", for: .normal)
            cVideo.setBackgroundImage(#imageLiteral(resourceName: "cstop"), for: .normal)
            recordingQueue.async {
                self.recorder?.record()
            }
            let image = self.recorder?.photo()
            let imageData: NSData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData
            UnityFileTypeLXArrayImg.append(imageData)
            let userDef = UserDefault()
            userDef.setNormalDefault("UnityFileTypeLXArrayImg", UnityFileTypeLXArrayImg as NSArray)
        }else if recorder?.status == .recording {
            cVideo.setTitle("开始录制", for: .normal)
            cVideo.setBackgroundImage(#imageLiteral(resourceName: "cstart"), for: .normal)
            recorder?.stop() { path in
                self.recorder?.export(video: path) { saved, status in
                    DispatchQueue.main.sync {
                        self.exportMessage(success: saved, status: status)
                    }
                }
                let pathString = path.absoluteString
                self.UnityFileTypeLXArray.append(pathString)
                let userDef = UserDefault()
                userDef.setNormalDefault("UnityFileTypeLX", self.UnityFileTypeLXArray as NSArray)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
