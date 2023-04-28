//
//  CheckBoxButton.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 03/04/23.
//

import UIKit
class CheckBox: UIButton {
    // Images
    //let checkedImage:UIImage = #imageLiteral(resourceName: "icons8-unchecked-checkbox-24()")
   // let uncheckedImage:UIImage = #imageLiteral(resourceName: "icons8-tick-box-60()")
    let checkedImage:UIImage = UIImage(named: "checkedImage")!
    let uncheckedImage:UIImage = UIImage(named: "uncheckedImage")!
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
