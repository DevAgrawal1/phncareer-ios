//
//  logOutFunction.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 11/04/23.
//

import Foundation
import UIKit

func logout(self:UIViewController){
    //Clear Saved User Data
    UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    UserDefaults.standard.removeObject(forKey: "apiToken")
    UserDefaults.standard.removeObject(forKey: "userAllData")
    UserDefaults.standard.removeObject(forKey: "UserMobileNumber")
    UserDefaults.standard.synchronize()
    
    DispatchQueue.main.async {
    let logoutAlertMessage =  UIAlertController(title: "Logout", message: "Your session has been ended!", preferredStyle: .alert)
    logoutAlertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(registerViewController, animated: true, completion: nil)
        
    }))
    self.present(logoutAlertMessage, animated: true, completion: nil)
    }
}

func noInternetAlertView(self:UIViewController){
    let alertMessage = UIAlertController(title: "Network Error❗", message: "Please check your internet connection", preferredStyle: .alert)
    self.present(alertMessage, animated: true, completion: nil)
    let when = DispatchTime.now() + 1.6
    DispatchQueue.main.asyncAfter(deadline: when){
       alertMessage.dismiss(animated: true, completion: nil)
    }
}

func somethingWrong(self:UIViewController){
    let alertMessage = UIAlertController(title: "Oops, ", message: "something has gone wrong, Try After some time", preferredStyle: .alert)
    self.present(alertMessage, animated: true, completion: nil)
    let when = DispatchTime.now() + 1.5
    DispatchQueue.main.asyncAfter(deadline: when){
       alertMessage.dismiss(animated: true, completion: nil)
    }
}
func alertMessage(self:UIViewController,message:String){
    let alertMessage = UIAlertController(title: "", message: message, preferredStyle: .alert)
    self.present(alertMessage, animated: true, completion: nil)
    let when = DispatchTime.now() + 1.5
    DispatchQueue.main.asyncAfter(deadline: when){
       alertMessage.dismiss(animated: true, completion: nil)
    }
}
