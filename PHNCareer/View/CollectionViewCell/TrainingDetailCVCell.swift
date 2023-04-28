//
//  TrainingDetailCVCell.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 04/04/23.
//

import UIKit

class TrainingDetailCVCell: UICollectionViewCell {

    @IBOutlet weak var indexNumberLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sectionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
   
    var sectionObj : Section?{
        didSet{
            titleLbl.text = sectionObj!.title
        }
    }
}
