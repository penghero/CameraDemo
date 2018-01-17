//
//  DetailedModelController.swift
//  CameraDemo
//
//  Created by 陈鹏 on 2018/1/12.
//  Copyright © 2018年 penggege.CP. All rights reserved.
//https://github.com/penghero/CameraDemo.git

import UIKit
import AVFoundation
import MobileCoreServices

class DetailedModelController: UIViewController {

    @IBOutlet var detailCollectionView: UICollectionView!
    @IBOutlet var detailBack: UIButton!
    @IBOutlet var detailPhotoOrVideo: UIButton!
    var dataSourceArray: NSArray = []
    var dataImgLX: NSArray = []
    
    var fileType: UnityFileType = UnityFileType.UnityFileTypeGL
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let user = UserDefault()
        let type:Int = user.getNormalDefult("type") as! Int
        switch type {
        case 0:
            fileType = .UnityFileTypeGL
            break
        case 1:
            fileType = .UnityFileTypeCW
            break
        case 2:
            fileType = .UnityFileTypeZX
            break
        case 3:
            fileType = .UnityFileTypeXM
            break
        case 4:
            fileType = .UnityFileTypeLX
            break
        default:
            break
        }
        
        switch fileType {
        case .UnityFileTypeCW:
            let userDef = UserDefault()
            let array = userDef.getNormalDefult("UnityFileTypeCW") as? NSArray
            if array != nil {
                dataSourceArray = userDef.getNormalDefult("UnityFileTypeCW") as! NSArray
            } else { dataSourceArray = [] }
//            dataSourceArray = ["1","2","3","4","5"]
            break
        case .UnityFileTypeGL:
            let userDef = UserDefault()
            let array = userDef.getNormalDefult("UnityFileTypeGL") as? NSArray
            if array != nil {
                dataSourceArray = userDef.getNormalDefult("UnityFileTypeGL") as! NSArray
            } else { dataSourceArray = [] }
//            dataSourceArray = ["1","2","3","4"]
            break
        case .UnityFileTypeZX:
            let userDef = UserDefault()
            let array = userDef.getNormalDefult("UnityFileTypeZX") as? NSArray
            if array != nil {
                dataSourceArray = userDef.getNormalDefult("UnityFileTypeZX") as! NSArray
            } else { dataSourceArray = [] }
//            dataSourceArray = ["1","2","3"]
            break
        case .UnityFileTypeXM:
            let userDef = UserDefault()
            let array = userDef.getNormalDefult("UnityFileTypeXM") as? NSArray
            if array != nil {
                dataSourceArray = userDef.getNormalDefult("UnityFileTypeXM") as! NSArray
            } else { dataSourceArray = [] }
//            dataSourceArray = ["1","2"]
            break
        case .UnityFileTypeLX:
            let userDef = UserDefault()
            let array = userDef.getNormalDefult("UnityFileTypeLX") as? NSArray
            if array != nil {
                dataSourceArray = userDef.getNormalDefult("UnityFileTypeLX") as! NSArray
            } else { dataSourceArray = [] }
//            dataSourceArray = ["1"]
            
            let arrayImg = userDef.getNormalDefult("UnityFileTypeLXArrayImg") as? NSArray
            if arrayImg != nil {
                dataImgLX = userDef.getNormalDefult("UnityFileTypeLXArrayImg") as! NSArray
            } else { dataImgLX = [] }
            
            break
        }
        self.detailCollectionView?.register(UINib.init(nibName: "CommonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CommonCollectionViewCell.cellID)
    }
/* 跳转到相机 */
    @IBAction func nextToCamera(_ sender: Any) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let cameraVC: CameraViewController = story.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        cameraVC.fileType = fileType
        if fileType == UnityFileType.UnityFileTypeLX {
            cameraVC.isHiddenBtn = true
        } else {
            cameraVC.isHiddenBtn = false }
        print(cameraVC.fileType,cameraVC.isHiddenBtn)
        present(cameraVC, animated:true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
/* cellectionView 代理方法和数据源 以及相册的代理 */
extension DetailedModelController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
//   返回单元格数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataSourceArray.count == nil {
            return 0
        } else {
            return (self.dataSourceArray.count) }
    }
//    定制单元格内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCollectionViewCell.cellID, for: indexPath) as! CommonCollectionViewCell
        if fileType == UnityFileType.UnityFileTypeLX {
/*
            DispatchQueue.global().async {
                //主队列
                //获取网络视频
                let url = self.dataSourceArray[indexPath.row] as! NSString
                let videoURL = NSURL(string: url as String)!
                let avAsset = AVURLAsset.init(url: videoURL as URL)
                //生成视频截图
                let generator = AVAssetImageGenerator(asset: avAsset)
                generator.appliesPreferredTrackTransform = true
                let time = CMTimeMakeWithSeconds(0.0,600)
                var actualTime:CMTime = CMTimeMake(0,0)
                /*
                 Thread 1: Fatal error: 'try!' expression unexpectedly raised an error: Error Domain=NSURLErrorDomain Code=-1100 "The requested URL was not found on this server." UserInfo={NSLocalizedDescription=The requested URL was not found on this server., NSUnderlyingError=0x1c445aee0 {Error Domain=NSPOSIXErrorDomain Code=2 "No such file or directory"}}
                 
                 Thread 4: Fatal error: 'try!' expression unexpectedly raised an error: Error Domain=NSURLErrorDomain Code=-1100 "The requested URL was not found on this server." UserInfo={NSLocalizedDescription=The requested URL was not found on this server., NSUnderlyingError=0x1c424aec0 {Error Domain=NSPOSIXErrorDomain Code=2 "No such file or directory"}}
                 
                 */
                let imageRef: CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
                let frameImg = UIImage.init(cgImage: imageRef)
                DispatchQueue.main.async {
                    cell.cellImage.image = frameImg
                }
            }
 */
            cell.playBtn.isHidden = false
            let imageData:NSData = dataImgLX[indexPath.row] as! NSData
            let image:UIImage = NSKeyedUnarchiver.unarchiveObject(with: imageData as Data) as! UIImage
            cell.cellImage.image = image
        } else {
            let imageData:NSData = dataSourceArray[indexPath.row] as! NSData
            let image:UIImage = NSKeyedUnarchiver.unarchiveObject(with: imageData as Data) as! UIImage
            cell.cellImage.image = image
        }
        cell.backgroundColor = .red
        return cell
    }
//    选中代理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openAlbum()
    }
//    设置单元格大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: UIScreen.main.bounds.size.width / 4, height: UIScreen.main.bounds.size.width / 4)
    }
//    设置边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    }
     //打开相册
   private func openAlbum(){
        //判断设置是否支持图片库
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
        let picker = UIImagePickerController()
            //设置代理
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            //指定图片控制器类型 选择器访问的是相册(如果是访问相机则将.photoLibrary改为.camera)
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //设置是否允许编辑
        picker.allowsEditing = false
            //弹出控制器，显示界面
        self.present(picker, animated: true, completion: nil)
        } else {
            print("读取相册错误")
        }
    }
    //选择图片成功后代理
    private func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String :AnyObject]) {

        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
