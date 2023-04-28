//
//  AppTestDetailViewTableViewCell.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 18/04/23.
//

import UIKit

class AppTestDetailViewTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var indexNumber: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
