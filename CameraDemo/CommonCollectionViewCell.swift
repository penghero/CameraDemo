//
//  CommonCollectionViewCell.swift
//  CameraDemo
//
//  Created by 陈鹏 on 2018/1/12.
//  Copyright © 2018年 penggege.CP. All rights reserved.
//

import UIKit

class CommonCollectionViewCell: UICollectionViewCell {
    static let cellID = "CommonCollectionViewCellID"

    @IBOutlet var playBtn: UIButton!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellLabel: UILabel!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
