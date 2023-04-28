//
//  ViewController.swift
//  PHN_Vivek_Task
//
//  Created by PHN MAC 1 on 27/03/23.
//

import UIKit
import Lottie

class RegisterViewController : UIViewController {
    //MARK IBOutlets
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var termsAndConditonTextView: UITextView!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var warningMessageLbl: UILabel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        mobileNumberTextField.delegate = self
        warningMessageLbl.isHidden = true
        setTextView()
        setAnimationView()
        setMobileNumberTextField()
        hideKeyboardWhenTappedAround()
    }
     
    //MARK SetFunctions
    private func setMobileNumberTextField(){
       // mobileNumberTextField.text = UserDefaults.standard.string(forKey: "UserMobileNumber")
        mobileNumberTextField.borderStyle = .roundedRect
        mobileNumberTextField.layer.borderColor = UIColor(named: "projectColor")?.cgColor
        mobileNumberTextField.layer.borderWidth = 1
        mobileNumberTextField.layer.cornerRadius = 5
    }
    private func setTextView(){
        let termsString = "By continuing you are agreeing to our\nTerms and Conditions and\nPrivacy and Policy"
        let attributedString = NSMutableAttributedString(string: termsString)
        
        // hyperlink add
        attributedString.addAttribute(.link, value: ProjectApi.shared.termsAndConditions(), range: NSRange(location: 38, length: 20))
        attributedString.addAttribute(.link, value: ProjectApi.shared.privacyAndPolicy(), range: NSRange(location: 63, length: 18))
        //under line
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                                        NSRange.init(location: 38, length: 20));
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                                        NSRange.init(location: 63, length: 18));
        attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 81))
        
        //bind attributed text to textView
        termsAndConditonTextView.attributedText = attributedString
        termsAndConditonTextView.textAlignment = .center
        termsAndConditonTextView.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        //Link color change
        termsAndConditonTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "projectColor") ?? .black]
        let countyImageView = UIImageView(frame: CGRect(x: 46.5, y: 15.5, width: 25, height: 18))
        countyImageView.image = #imageLiteral(resourceName: "india")
        countyImageView.layer.masksToBounds = true
        countyImageView.layer.cornerRadius = 5
        countryTextField.addSubview(countyImageView)
    }
    
    private func setAnimationView(){
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        animationView!.play()
    }
    
    //MARK IBActions
    
    @IBAction func mobileNumberTextFieldClick(_ sender: UITextField) {
        if(sender.text?.count == 10){
            self.view.endEditing(true)
        }
    }
    
    
    @IBAction func continueButtonClick(_ sender: UIButton){
        guard let number = mobileNumberTextField.text, number != ""
        else{
            warningMessageLbl.text = "Mobile number cannot be empty"
            warningMessageLbl.isHidden = false
            return
        }
        if number.count == 10 {
            if mobileNumberValidate(value: number){
                warningMessageLbl.isHidden = true
                UserDefaults.standard.set(number, forKey: "UserMobileNumber")
                if(InternetConnectionManager.isConnectedToNetwork()){
                    self.activityIndicator.startAnimating()
                    self.sendOtpOnMobileNumberApi(number:number)
                }
                else{
                    noInternetAlertView(self: self)
                }
            }
            else{
                warningMessageLbl.text = "Please enter valid mobile number"
                warningMessageLbl.isHidden = false
            }
        }
        else{
            warningMessageLbl.text = "Mobile number should be of 10 digit"
            warningMessageLbl.isHidden = false
        }
    }
    
    
    func mobileNumberValidate(value: String) -> Bool {
        let phoneRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: value)
    }
   
    private func sendOtpOnMobileNumberApi(number:String) {
        let dictionary:[String:Any] = ["mobile_no": number,"otp": 0]
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
                let status_code = jsonData["status_code"] as! String
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if(status_code == "200"){
                        let otpVeryfyVC = self.storyboard?.instantiateViewController(withIdentifier: "OtpVeryfyViewController") as! OtpVeryfyViewController
                        self.navigationController?.pushViewController(otpVeryfyVC, animated: true)
                        
                    }
                    else{
                        let webPage = self.storyboard?.instantiateViewController(withIdentifier: "UserRegisterOnWebViewViewController") as! UserRegisterOnWebViewViewController
                        self.navigationController?.pushViewController(webPage, animated: true)
                    }
                }
            }
            catch{}
        }
        dataTask.resume()
        
    }
    
}

extension RegisterViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool
    {
        let maxLength = 10
        let currentString = mobileNumberTextField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor(named: "projectColor")?.cgColor
    }
    
}
