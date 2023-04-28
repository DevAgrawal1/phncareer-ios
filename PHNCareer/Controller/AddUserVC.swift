//
//  AddUserVC.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 03/04/23.
//

import UIKit

class AddUserVC: UIViewController {
    //MARK IBOutlets
    // Alert label message
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblAppName: UILabel!
    
    // TextFields
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var TxtSelectAppName: UITextField!
    
    // CheckBoxButtons
    @IBOutlet weak var btnDownload: CheckBox!
    @IBOutlet weak var btnCyc: CheckBox!
    @IBOutlet weak var btnFund: CheckBox!
    @IBOutlet weak var btnTrade: CheckBox!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //PickerView
    var pickerElement:[String] = ["Paytm Money","Angel Broking"]
    let pickerView = UIPickerView()
    let tootBar = UIToolbar()
    
    //MARK viewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        setAlertLabel()
        setTextField()
        resetForm()
        setUpPickerView()
        setNavigationBarTitle()
        setActivityIndicator()
        hideKeyboardWhenTappedAround()
        checkForValidForm()
    }
    private func setBackButton(){
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        if #available(iOS 15.0, *) {
            self.navigationController?.navigationBar.tintColor = UIColor.tintColor
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor(named: "tintColorIos")
        }
    }
    private func setNavigationBarTitle(){
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 40))
        label.textColor = UIColor.black
        label.text = "Add User".localizedCapitalized
        label.font = UIFont.boldSystemFont(ofSize: 20)
        self.navigationItem.titleView = label
    }
    func setAlertLabel(){
        lblFirstName.isHidden = true
        lblLastName.isHidden = true
        lblEmail.isHidden = true
        lblMobileNo.isHidden = true
        lblAppName.isHidden = true
        lblAppName.isHidden = true
    }
    func setTextField(){
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtEmail.delegate = self
        self.txtMobileNo.delegate = self
        self.TxtSelectAppName.delegate = self
    }
    private func resetForm(){
        submitButton.isEnabled = false
        txtFirstName.isHidden = false
        txtEmail.isHidden = false
        txtLastName.isHidden = false
        txtMobileNo.isHidden = false
        
        lblFirstName.text = "Required"
        lblLastName.text = "Required"
        lblEmail.text = "Required"
        lblMobileNo.text = "Required"
        
        txtFirstName.text = ""
        txtLastName.text = ""
        txtMobileNo.text = ""
        TxtSelectAppName.text = ""
        txtEmail.text = ""
    }
    private func setUpPickerView(){
        pickerView.delegate = self
        pickerView.dataSource = self
        TxtSelectAppName.inputView = pickerView
        tootBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClick))
        tootBar.items = [doneBtn]
        TxtSelectAppName.inputAccessoryView = tootBar
    }
    @objc func doneBtnClick(){
        lblAppName.isHidden = true
        let selectedApp = pickerElement[pickerView.selectedRow(inComponent: 0)]
        self.TxtSelectAppName.text = selectedApp
        self.view.endEditing(true)
    }
    
    private func setActivityIndicator(){
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
    }
    
    
    //MARK OBActions
    @IBAction func firstNameTextField(_ sender: UITextField) {
        if let fname = sender.text
        {
            if let errorMessage = invalidName(sender: fname)
            {
                lblFirstName.text = errorMessage
                lblFirstName.isHidden = false
            }
            else
            {
                lblFirstName.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    @IBAction func lastNameTextField(_ sender: UITextField) {
        if let fname = sender.text
        {
            if let errorMessage = invalidName(sender: fname)
            {
                lblLastName.text = errorMessage
                lblLastName.isHidden = false
            }
            else
            {
                lblLastName.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    func invalidName(sender:String)->String?{
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        if(sender.rangeOfCharacter(from: set.inverted) != nil ){
            return "special character,number not valid"
        } else {
            return nil
        }
    }
    
    @IBAction func emailTextField(_ sender: UITextField) {
        if let email = sender.text
        {
            if let errorMessage = invalidEmail(email)
            {
                lblEmail.text = errorMessage
                lblEmail.isHidden = false
            }
            else
            {
                lblEmail.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    func invalidEmail(_ value: String) -> String?
    {
       // let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let reqularExpression = "[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value)
        {
            return "Email id should be valid"
        }
        
        return nil
    }
    
    @IBAction func mobileNumber(_ sender: UITextField) {
        guard let phoneNumber = sender.text, phoneNumber != "" else{return}
        self.lblMobileNo.text = "Please enter valid mobile number"
        if mobileNumberValidate(value: phoneNumber){
            self.lblMobileNo.isHidden = true
            self.view.endEditing(true)
        }
        else{
            self.lblMobileNo.isHidden = false
        }
        checkForValidForm()
    }
    func mobileNumberValidate(value: String) -> Bool {
        let phoneRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: value)
    }
    
    @IBAction func checkBoxBtnClick(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
            checkForValidForm()
        }
        
    }
    func checkForValidForm()
    {
        if lblFirstName.isHidden && lblLastName.isHidden && lblEmail.isHidden && lblMobileNo.isHidden && lblAppName.isHidden && btnDownload.isChecked && btnCyc.isChecked && btnFund.isChecked && btnTrade.isChecked && !txtFirstName.text!.isEmpty && !txtLastName.text!.isEmpty && !txtEmail.text!.isEmpty && !txtMobileNo.text!.isEmpty && !TxtSelectAppName.text!.isEmpty
        {
            submitButton.isEnabled = true
            submitButton.backgroundColor = UIColor(named: "projectColor")
        }
        else
        {
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.lightGray
        }
    }
    func addUserApi(){
        self.activityIndicator.startAnimating()
        let firstName = txtFirstName.text!
        let lastName = txtLastName.text!
        let email = txtEmail.text!
        let contact = txtMobileNo.text!
        let selectApp = TxtSelectAppName.text!
        
        let parameter:[String:Any] = [
            "firstname" : firstName,
            "lastname" : lastName,
            "email" : email,
            "contact" : contact,
            "app_name" : selectApp,
            "download" : 1,
            "kyc" : 1,
            "addfund" : 1,
            "execute" : 1,
        ]
        let jsonParameter = try? JSONSerialization.data(withJSONObject: parameter)
        guard let mobileNumbr = UserDefaults.standard.string(forKey: "UserMobileNumber")else{return}
        guard var url = ProjectApi.shared.addreferalApi() else{return}
        url.appendQueryItem(name: "mob_no", value: mobileNumbr)
        
        guard let token = UserDefaults.standard.string(forKey: "apiToken")else{return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonParameter
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            if data != nil{
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let status_code = jsonData["status_code"] as! String
                    let message = jsonData["data"] as! String
                    
                    print(status_code)
                    DispatchQueue.main.async {
                        if(status_code == "200"){
                            self.activityIndicator.stopAnimating()
                            self.navigationController?.popViewController(animated: true)
                        }
                        else if status_code == "408" {
                            logout(self: self)
                        }
                        else if status_code == "400"{
                            self.activityIndicator.stopAnimating()
                            alertMessage(self: self, message: message)
                        }
                        else{
                            self.activityIndicator.stopAnimating()
                            somethingWrong(self: self)
                            print("Status Code:-",status_code)
                        }
                    }
                }
                catch{}
            }
            else{
                
            }
        }
        dataTask.resume()
    }
    
    @IBAction func submitButtonClick(_ sender: UIButton) {
        
        let mobileNo = UserDefaults.standard.string(forKey: "UserMobileNumber") ?? ""
       
        if(InternetConnectionManager.isConnectedToNetwork()){
            if(mobileNo == txtMobileNo.text!){
                alertMessage(self: self, message: "You cannot add yourself in referral")
            }
            else{
                self.addUserApi()
            }
        }
        else{
            noInternetAlertView(self: self)
        }
    }
}


extension AddUserVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
       if(textField == txtMobileNo){
           let maxLength = 10
           let currentString = txtMobileNo.text! as NSString
           let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
           return newString.length <= maxLength
       }
        else if textField == TxtSelectAppName{
            return false
        }
      return true
   }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor(named: "projectColor")?.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}


extension AddUserVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerElement.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerElement[row]
    }
    
}
