//
//  AppViewUserCollectionViewCell.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 01/04/23.
//

import UIKit
import SkeletonView

class AppViewUserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var processImage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var appUserModelObject:AppUser?{
        didSet{
            appName.text = appUserModelObject?.app_name ?? ""
            nameLbl.text = (appUserModelObject!.firstname ?? "") + " " + (appUserModelObject!.lastname ?? "")
            
            var date:String = appUserModelObject!.updated ?? ""
            date.removeLast(8)
            dateLbl.text = date
            
            let process:String = appUserModelObject!.status ?? ""
            if process == "Pending"{
                processImage.image = UIImage(named: "pending")
            }
            else if process == "Approved"{
                processImage.image = UIImage(named: "approved")
            }
            else{
                processImage.image = UIImage(named: "notApproved")
            }
            
            self.layer.borderColor = UIColor(named: "projectColor")?.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 10
        }
        
    }
}
