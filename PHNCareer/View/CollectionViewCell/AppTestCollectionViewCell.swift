//
//  AppTestCollectionViewCell.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 29/03/23.
//

import UIKit

class AppTestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var appTestImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        appTestImageView.layer.cornerRadius = 10
    }

}
