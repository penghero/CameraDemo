//
//  ViewController.swift
//  CameraDemo
//
//  Created by 陈鹏 on 2018/1/10.
//  Copyright © 2018年 penggege.CP. All rights reserved.
//

import UIKit

enum UnityFileType: Int {
    /* "文件夹-1","文件夹-2","文件夹-3","文件夹-4","文件夹-5" */
    case UnityFileTypeGL = 0
    case UnityFileTypeCW
    case UnityFileTypeZX
    case UnityFileTypeXM
    case UnityFileTypeLX
}


class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var cellTitle = ["文件夹-1","文件夹-2","文件夹-3","文件夹-4","文件夹-5"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib.init(nibName: "CommonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CommonCollectionViewCell.cellID)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
/* cellectionView 代理方法和数据源  */
extension ViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCollectionViewCell.cellID, for: indexPath) as! CommonCollectionViewCell
        cell.cellImage?.image = UIImage.init(named: "Slice")
        cell.tag = indexPath.row
        cell.cellLabel?.text = self.cellTitle[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        switch indexPath.row {
        case 0:
            let detailVC: DetailedModelController = story.instantiateViewController(withIdentifier: "DetailedModelController") as! DetailedModelController
            detailVC.fileType = UnityFileType.UnityFileTypeGL
            let user = UserDefault()
            let type:Int = 0
            user.setNormalDefault("type", type as AnyObject)
            print(detailVC.fileType as Any)
            present(detailVC, animated:true, completion: nil)
            break
        case 1:
            let detailVC: DetailedModelController = story.instantiateViewController(withIdentifier: "DetailedModelController") as! DetailedModelController
            let type:UnityFileType = UnityFileType.UnityFileTypeCW
            detailVC.fileType = type
            let user = UserDefault()
            let typeT:Int = 1
            user.setNormalDefault("type", typeT as AnyObject)
            print(detailVC.fileType as Any)
            present(detailVC, animated:true, completion: nil)
            break
        case 2:
            let detailVC: DetailedModelController = story.instantiateViewController(withIdentifier: "DetailedModelController") as! DetailedModelController
            let type:UnityFileType = UnityFileType.UnityFileTypeZX
            detailVC.fileType = type
            let user = UserDefault()
            let typeT:Int = 2
            user.setNormalDefault("type", typeT as AnyObject)
            print(detailVC.fileType as Any)
            present(detailVC, animated:true, completion: nil)
            break
        case 3:
            let detailVC: DetailedModelController = story.instantiateViewController(withIdentifier: "DetailedModelController") as! DetailedModelController
            let type:UnityFileType = UnityFileType.UnityFileTypeXM
            detailVC.fileType = type
            let user = UserDefault()
            let typeT:Int = 3
            user.setNormalDefault("type", typeT as AnyObject)
            print(detailVC.fileType as Any)
            present(detailVC, animated:true, completion: nil)
            break
        case 4:
            let detailVC: DetailedModelController = story.instantiateViewController(withIdentifier: "DetailedModelController") as! DetailedModelController
            let type:UnityFileType = UnityFileType.UnityFileTypeLX
            detailVC.fileType = type
            let user = UserDefault()
            let typeT:Int = 4
            user.setNormalDefault("type", typeT as AnyObject)
            print(detailVC.fileType as Any)
            present(detailVC, animated:true, completion: nil)
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.size.width / 4, height: UIScreen.main.bounds.size.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    }
}

