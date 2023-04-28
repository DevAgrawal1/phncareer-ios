//
//  OtpVeryfyViewController.swift
//  PHN_Vivek_Task
//
//  Created by PHN MAC 1 on 27/03/23.
//

import UIKit
import Lottie
import DPOTPView

class OtpVeryfyViewController: UIViewController {
    //MARK IBOutlet
    @IBOutlet weak var otpWarningMessage: UILabel!
    @IBOutlet weak var otpVeryfyTextView: UITextView!
    @IBOutlet weak var otpUIView: UIView!
    @IBOutlet weak var resendCodeLable: UILabel!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var didntReciveAnyCodeLbl: UILabel!
    var mobileNumber = "9876543210"
    var txtOTPView = DPOTPView()
    
    var secondsRemaining = 30
    //MARK ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mobileNumber = UserDefaults.standard.string(forKey: "UserMobileNumber") ?? "9876543210"
        otpWarningMessage.isHidden = true
        setAnimationView()
        setTextView()
        setOtpView()
        setResendCodeLable()
        activityIndicator.hidesWhenStopped = true
        hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    //MARK SetFunctions
    private func setAnimationView(){
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.75
        animationView!.play()
    }
    private func setTextView(){
        let termsString = "Verify your Phone Number\nWe have sent you a verification code\n on \(mobileNumber.prefix(2))********"
        let attributedString = NSMutableAttributedString(string: termsString)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .medium), range: NSRange(location: 0, length: 24))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .light), range: NSRange(location: 25, length: 51))
        otpVeryfyTextView.attributedText = attributedString
        otpVeryfyTextView.textAlignment = .center
    }
    private func setOtpView(){
        txtOTPView = DPOTPView(frame: CGRectMake(0, 0,self.view.bounds.width-50, otpUIView.bounds.height))
        txtOTPView.count = 6
        txtOTPView.spacing = 10
        txtOTPView.fontTextField = UIFont(name: "Helvetica", size: CGFloat(24.0))!
        txtOTPView.dismissOnLastEntry = true
        txtOTPView.backGroundColorTextField = UIColor(named: "otpColor") ?? .white
        txtOTPView.textColorTextField = UIColor(named: "projectColor") ?? .black
        txtOTPView.cornerRadiusTextField = 8
        txtOTPView.isCursorHidden = true
        otpUIView.addSubview(txtOTPView)
    }
    private func setResendCodeLable(){
        //add undrline
        let attributedString = NSMutableAttributedString.init(string: "Resend OTP")
        // Add Underline Style Attribute.
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length));
        resendCodeLable.attributedText = attributedString
        
        //make label clickable
        let tap = UITapGestureRecognizer(target: self, action: #selector(OtpVeryfyViewController.resendOtp))
        resendCodeLable.isUserInteractionEnabled = true
        resendCodeLable.addGestureRecognizer(tap)
    }
    
    @objc
    func resendOtp(sender:UITapGestureRecognizer) {
        if(InternetConnectionManager.isConnectedToNetwork()){
              self.startTimer()
                alertMessage(self: self, message: "OTP Sent Successfully")
                let dictionary:[String:Any] = ["mobile_no": mobileNumber,"otp": 0]
                let parameter = try? JSONSerialization.data(withJSONObject: dictionary)
                guard let url = ProjectApi.shared.otpApi() else{return}
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = parameter
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let dataTask =  URLSession.shared.dataTask(with: request){
                    data,response,error in
                    do{
                        guard let data = data else{return}
                        let jsonData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                        print("OTP:-",jsonData["otp"] as Any)
                    }
                    catch{}
                }
                dataTask.resume()
        }
    else{
        noInternetAlertView(self: self)
    }
}
private func startTimer(){
            self.resendCodeLable.isHidden = true
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {(Timer) in
                if self.secondsRemaining > -1 {
                    if(self.secondsRemaining >= 10){
                        self.didntReciveAnyCodeLbl.text = " Didn't Receive any code?Retry in 00:\(self.secondsRemaining)"
                    }
                    else{
                        self.didntReciveAnyCodeLbl.text = " Didn't Receive any code?Retry in 00:0\(self.secondsRemaining)"
                    }
                    self.secondsRemaining -= 1
                } else {
                    self.resendCodeLable.isHidden = false
                    self.didntReciveAnyCodeLbl.text = " Didn't Receive any code?"
                    self.secondsRemaining = 30
                    Timer.invalidate()
                }
        }
}
    
func verifyOtp(userOtp:String){
        let dictionary: [String:Any] = ["mobile_no": mobileNumber,"otp":userOtp]
        guard let url = ProjectApi.shared.otpverifyApi() else{return}
        guard let parameter = try? JSONSerialization.data(withJSONObject: dictionary) else{return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameter
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request){ data , response, error in
            guard let data = data else{return}
            do{
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else{return}
                guard let status_code = jsonObject["status_code"] as? String else{return}
                DispatchQueue.main.async {
                    if(status_code == "200"){
                        self.activityIndicator.stopAnimating()
                        guard let apiToken = jsonObject["token"] as? String else{return}
                        UserDefaults.standard.set(apiToken, forKey: "apiToken")
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        // User Data Save in DataBase
                        let user = jsonObject["user"] as! [String:Any]
                        UserDefaults.standard.set(user, forKey: "userAllData")
                        let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "RootTabBarViewController") as! RootTabBarViewController
                        self.present(rootVC, animated: true)
                    }
                    else{
                        self.activityIndicator.stopAnimating()
                        self.otpWarningMessage.isHidden = true
                        self.otpIncorrectAlert()
                    }
                }
            }
            catch{}
        }
        dataTask.resume()
    }
 
  
    // MARK IBActions
    @IBAction func otpVerifyButtonClick(_ sender: Any) {
        guard let userOtp = txtOTPView.text,userOtp != ""
        else {
            otpWarningMessage.text = "OTP cannot be empty"
            otpWarningMessage.isHidden = false
            return
        }
        if(userOtp.count == 6){
            if InternetConnectionManager.isConnectedToNetwork(){
                activityIndicator.startAnimating()
                self.verifyOtp(userOtp: userOtp)
            }
            else{
                noInternetAlertView(self: self)
            }
        }
        else{
            otpWarningMessage.text = "Please enter a 6 digit OTP"
            otpWarningMessage.isHidden = false
        }
    }
    private func otpIncorrectAlert(){
       let alertMessage = UIAlertController(title: "OTP is not correct❗", message: "Please check your otp", preferredStyle: .alert)
        self.present(alertMessage, animated: true, completion: nil)
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when){
           alertMessage.dismiss(animated: true, completion: nil)
        }
    }
}
