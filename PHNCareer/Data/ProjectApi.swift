//
//  ProjectApis.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 10/04/23.
//

import Foundation

struct ProjectApi{
    let testMainUrl = "https://www.phntechnology.info/phn_career_test/"
    let mainUrl = "https://phntechnology.info/phn_career/"
    static let shared = ProjectApi()
    
    private init(){}
    
    func termsAndConditions()->String{
        return testMainUrl + "terms&condition.html"
    }
    func privacyAndPolicy()->String{
        return testMainUrl + "privacy&policy.html"
    }
    
    func otpApi()->URL?{
        let str:String = "otp.php"
        let urlString = mainUrl + str
        let url = URL(string: urlString)
        return url
    }
    
    func otpverifyApi()->URL?{
        let str:String = "otpverify.php"
        let urlString = mainUrl + str
        let url = URL(string: urlString)
        return url
    }
    
    func taskApi()->URL?{
        let str:String = "task.php"
        let urlString = mainUrl + str
        let url = URL(string: urlString)
        return url
    }
    
    func trainingApi()->URL?{
        let str:String = "training.php"
        let urlString = mainUrl + str
        let url = URL(string: urlString)
        return url
    }
    
    func editProfileApi()->URL?{
        let str:String = "edit_profile.php"
        let urlString = mainUrl + str
        let url = URL(string: urlString)
        return url
    }
    
    func viewreferalApi()->URL?{
        let str:String = "viewreferal.php"
        let urlString = mainUrl + str
        let url = URL(string: urlString)
        return url
    }
    
    func addreferalApi()->URL?{
        let str:String = "addreferal.php"
        let urlString = mainUrl + str
        let url = URL(string: urlString)
        return url
    }
    
    func scoreCardApi()->URL?{
        let testMainUrl = "https://www.phntechnology.info/phn_career_test/"
        let str:String = "score_card.php"
        let urlString = testMainUrl + str
        let url = URL(string: urlString)
        return url
    }
}
