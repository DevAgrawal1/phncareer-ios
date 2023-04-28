//
//  LaunchScreenVC.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 19/04/23.
//

import UIKit
import Lottie

class LaunchScreenVC: UIViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setAnimation()
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
            var rootViewController = UIViewController()
            
            if(isUserLoggedIn){
                rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarViewController") as! RootTabBarViewController
            }
            else{
                rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginUINavigationController") as! LoginUINavigationController
            }
            self.present(rootViewController, animated: true, completion: nil)
        }
    }
    
    private func setAnimation(){
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 0.8
        animationView!.play()
    }

}

