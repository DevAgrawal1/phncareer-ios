//
//  ShopViewController.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 28/03/23.
//

import UIKit
import Lottie

class ShopViewController: UIViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnimation()
        setNavigationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationBarTitle()
    }
    
    private func setNavigationBarTitle(){
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Shop".localizedCapitalized
        label.font = UIFont.boldSystemFont(ofSize: 20)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
    }

    private func setAnimation(){
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }
    
    private func setNavigationButton(){
        let addPersonDetail = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(profileNavigationBtnClick))
        addPersonDetail.imageInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        addPersonDetail.image = UIImage(named: "UserProfile")
        addPersonDetail.tintColor = UIColor(named: "projectColor")
        addPersonDetail.width = 30
        navigationItem.rightBarButtonItem = addPersonDetail
    }
    @objc func profileNavigationBtnClick(){
        let profileVc =  self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(profileVc, animated: true)
    }
}
