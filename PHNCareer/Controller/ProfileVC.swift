//
//  ProfileVC.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 05/04/23.
//

import UIKit
import Lottie

class ProfileVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var editProfileLbl: UILabel!
    
    var pickerElement:[String] = []
    let pickerView = UIPickerView()
    let tootBar = UIToolbar()
    var selectedTextField = UITextField()
    
    @IBOutlet weak var avaiableSoonMessageLbl: UILabel!
    
    @IBOutlet weak var loadingAnimationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        hideKeyboardWhenTappedAround()
        avaiableSoonMessageLbl.text = "The quiz scoreboard\nwill be available\nsoon."
        setAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTabBarAndNavigationBar()
        setNameLabel()
    }
    private func setTabBarAndNavigationBar(){
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    private func setNameLabel(){
        guard let user = UserDefaults.standard.dictionary(forKey: "userAllData")else{return}
        let firstName = user["firstname"] as! String
        userNameLbl.text = firstName
    }
    private func setLabels(){
        //Make a Clickable editProfileLbl
        let click = UITapGestureRecognizer(target: self, action: #selector(self.editProfileClick))
        editProfileLbl.isUserInteractionEnabled = true
        editProfileLbl.addGestureRecognizer(click)
        
        // Add UnderLine to editProfileLbl
        let text = editProfileLbl.text
         let textRange = NSRange(location: 0, length: (text?.count)!)
         let attributedText = NSMutableAttributedString(string: text!)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
        editProfileLbl.attributedText = attributedText
    }
    @objc func editProfileClick(){
        let editProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    private func setAnimation(){
        loadingAnimationView.contentMode = .scaleAspectFill
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.animationSpeed = 0.5
        loadingAnimationView.play()
    }
}

