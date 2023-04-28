//
//  TrainingsCVCell.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 04/04/23.
//

import UIKit
import SDWebImage

class TrainingsCVCell: UICollectionViewCell {

    @IBOutlet weak var lblTitleOfTraining: UILabel!
    @IBOutlet weak var lblNumberOfLessons: UILabel!
    @IBOutlet weak var trainingImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var trainingObj : Training?{
        didSet{
            if trainingObj != nil{
                lblTitleOfTraining.text = trainingObj?.title
                lblNumberOfLessons.text = "\(trainingObj!.lesson ?? "0") Lessons"
                let urlString = (trainingObj!.thumbnil ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlString!)
                trainingImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "dummyImg"))
            }
        }
    }
}
