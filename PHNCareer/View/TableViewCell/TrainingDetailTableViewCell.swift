//
//  TrainingDetailTableViewCell.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 20/04/23.
//

import UIKit

class TrainingDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionTitleLbl: UILabel!
    @IBOutlet weak var sectionNumberLbl: UILabel!
    
    @IBOutlet weak var indexNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    var sectionObj : Section?{
        didSet{
            sectionTitleLbl.text = sectionObj!.title
        }
    }
}
