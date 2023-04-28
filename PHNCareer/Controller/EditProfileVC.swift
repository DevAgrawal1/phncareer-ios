//
//  EditProfileVC.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 05/04/23.
//

import UIKit

class EditProfileVC: UIViewController { 
    //TextField Outlet
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var mobileNumberTxt: UITextField!
    @IBOutlet weak var qualificationTxt: UITextField!
    @IBOutlet weak var educationalStatusTxt: UITextField!
    @IBOutlet weak var passoutYearTxt: UITextField!
    @IBOutlet weak var jobStatusTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var districtTxt: UITextField!
    @IBOutlet weak var referenceTxt: UITextField!
    
    //Error Message Lbl Outlet
    @IBOutlet weak var firstNameErrorLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var districtErrorLbl: UILabel!
    @IBOutlet weak var passoutYearEmptyLbl: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var pickerElement:[String] = []
    let pickerView = UIPickerView()
    let tootBar = UIToolbar()
    let pickarViewData = EditProfileData()
    var selectedTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        setDataOnTextfield()
        setTextField()
        resetForm()
        setUpPickerView()
        submitButton.tintColor = UIColor(named: "projectColor")
        setNavigationBarTitle()
        setActivityIndicator()
        hideKeyboardWhenTappedAround()
    }
    //Bind API Data
    private func setBackButton(){
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        if #available(iOS 15.0, *) {
            self.navigationController?.navigationBar.tintColor = UIColor.tintColor
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor(named: "tintColorIos")
        }
    }
    func setDataOnTextfield(){
        firstNameTxt.text = "Vivek"
        lastNameTxt.text = "Lokhande"
        emailTxt.text = "vivek@gmail.com"
        mobileNumberTxt.text = "9325874120"
        qualificationTxt.text = "12th"
        educationalStatusTxt.text = "Passout"
        passoutYearTxt.text = "2020"
        jobStatusTxt.text = "Experienced"
        stateTxt.text = "Bihar"
        districtTxt.text = "Latur"
        referenceTxt.text = "PHN Employee"
        
        guard let userData = UserDefaults.standard.dictionary(forKey: "userAllData") else{return}
        firstNameTxt.text = userData["firstname"] as? String
        lastNameTxt.text = userData["lastame"] as? String
        emailTxt.text = userData["email"] as? String
        mobileNumberTxt.text = userData["mobile_no"] as? String
        qualificationTxt.text = userData["qualification"] as? String
        educationalStatusTxt.text = userData["education_status"] as? String
        passoutYearTxt.text = userData["passout_year"] as? String
        jobStatusTxt.text = userData["job_status"] as? String
        stateTxt.text = userData["state"] as? String
        districtTxt.text = userData["district"] as? String
        referenceTxt.text = userData["reference"] as? String
    }
    private func setActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    private func setNavigationBarTitle(){
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 40))
        label.textColor = UIColor.black
        label.text = "Edit Profile".localizedCapitalized
        label.font = UIFont.boldSystemFont(ofSize: 20)
        self.navigationItem.titleView = label
    }
    private func resetForm()
        {
            districtErrorLbl.text = "Please first select state"
            districtErrorLbl.isHidden = true
            firstNameErrorLbl.text = "Required"
            lastNameLbl.text = "Required"
            firstNameErrorLbl.isHidden = true
            lastNameLbl.isHidden = true
            passoutYearEmptyLbl.isHidden = true
            checkForValidForm()
        }
    private func setTextField(){
        self.emailTxt.isUserInteractionEnabled = false
        self.mobileNumberTxt.isUserInteractionEnabled = false
        
        firstNameTxt.delegate = self
        lastNameTxt.delegate = self
        qualificationTxt.delegate = self
        educationalStatusTxt.delegate = self
        passoutYearTxt.delegate = self
        jobStatusTxt.delegate = self
        stateTxt.delegate = self
        districtTxt.delegate = self
        referenceTxt.delegate = self
    }
    
    private func setUpPickerView(){
        pickerView.delegate = self
        pickerView.dataSource = self
        tootBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClick))
        tootBar.items = [doneBtn]
    }
    
    @objc func doneBtnClick(){
        if pickerElement.count == 0{
            self.view.endEditing(true)
            return
        }
        let selectedData = pickerElement[pickerView.selectedRow(inComponent: 0)]
        selectedTextField.text = selectedData
        self.view.endEditing(true)
        
        if(selectedTextField == stateTxt){
            self.districtTxt.text = ""
            districtErrorLbl.text = "Required"
            districtErrorLbl.isHidden = false
        }
        else if(selectedTextField == districtTxt){
            districtErrorLbl.isHidden = true
        }
        else if selectedTextField == educationalStatusTxt{
            passoutYearTxt.text = ""
            passoutYearEmptyLbl.text = "Current Year cannot be empty"
            passoutYearEmptyLbl.isHidden = false
        }
        else if selectedTextField == passoutYearTxt{
            passoutYearEmptyLbl.isHidden = true
        }
        checkForValidForm()
    }
    
    @IBAction func firstNameTxtAction(_ sender: UITextField) {
        if let fname = sender.text
                {
            if let errorMessage = invalidName(sender: fname)
                    {
                       firstNameErrorLbl.text = errorMessage
                       firstNameErrorLbl.isHidden = false
                    }
                    else
                    {
                        firstNameErrorLbl.isHidden = true
                    }
                }
                checkForValidForm()
    }
    
    @IBAction func lastNamaeTxtAction(_ sender: UITextField) {
        if let lastName = sender.text
                {
            if let errorMessage = invalidName(sender: lastName)
                    {
                        lastNameLbl.text = errorMessage
                        lastNameLbl.isHidden = false
                    }
                    else
                    {
                        lastNameLbl.isHidden = true
                    }
                }
                checkForValidForm()
    }
    
    func invalidName(sender:String)->String?{
        if(sender == ""){
            return "Empty textfield not valid"
        }
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        if(sender.rangeOfCharacter(from: set.inverted) != nil ){
            return "special character,number not valid"
           } else {
             return nil
        }
    }

  // TextField Did editing Begain Actions
    @IBAction func qualificationTextfieldClick(_ sender: UITextField) {
        pickerElement = pickarViewData.qualification()
        selectedTextField = sender
        sender.inputView = pickerView
        sender.inputAccessoryView = tootBar
        pickerView.reloadAllComponents()
    }
   
    @IBAction func educationalStatusTextFieldClick(_ sender: UITextField) {
        pickerElement = pickarViewData.educationalStatus()
        selectedTextField = sender
        sender.inputView = pickerView
        sender.inputAccessoryView = tootBar
        pickerView.reloadAllComponents()
    }
    
    @IBAction func passOutTextFieldClick(_ sender: UITextField) {
        pickerElement = pickarViewData.passoutYear(educationStatus: educationalStatusTxt.text!)
        selectedTextField = sender
        sender.inputView = pickerView
        sender.inputAccessoryView = tootBar
        pickerView.reloadAllComponents()
    }
    
    
    @IBAction func jobStatusTextFieldClick(_ sender: UITextField) {
        pickerElement = pickarViewData.jobStatus()
        selectedTextField = sender
        sender.inputView = pickerView
        sender.inputAccessoryView = tootBar
        pickerView.reloadAllComponents()
    }
    
    
    @IBAction func referenceTextFieldClick(_ sender: UITextField) {
        pickerElement = pickarViewData.reference()
        selectedTextField = sender
        sender.inputView = pickerView
        sender.inputAccessoryView = tootBar
        pickerView.reloadAllComponents()
    }
    
    @IBAction func stateTextFieldClick(_ sender: UITextField) {
        var states:[String] = []
        guard let data = pickarViewData.stateDistricts() else{return}
        for i in data{
            states.append(i.state)
        }
        pickerElement = states
        selectedTextField = sender
        sender.inputView = pickerView
        sender.inputAccessoryView = tootBar
        pickerView.reloadAllComponents()
    }
    
    @IBAction func districtTextFieldClick(_ sender: UITextField) {
        if let state = stateTxt.text{
            var districts:[String] = []
            guard let data = pickarViewData.stateDistricts() else{return}
            for i in data{
                if(i.state == state){
                    districts = i.districts
                    break
                }
            }
            pickerElement = districts
            selectedTextField = sender
            sender.inputView = pickerView
            sender.inputAccessoryView = tootBar
            pickerView.reloadAllComponents()
            districtErrorLbl.isHidden = true
        }
        else{
            districtErrorLbl.isHidden = false
        }
    }
    
    func checkForValidForm()
        {
            if firstNameErrorLbl.isHidden && lastNameLbl.isHidden && !districtTxt.text!.isEmpty && passoutYearEmptyLbl.isHidden && !passoutYearTxt.text!.isEmpty
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
    
    @IBAction func submitBtnClick(_ sender: UIButton) {
        guard let userData = UserDefaults.standard.dictionary(forKey: "userAllData") else{return}
        let registration_id = userData["registration_id"] as! String
        let firstname = firstNameTxt.text!
        let lastame = lastNameTxt.text!
        let email = emailTxt.text!
        let mobile_no = mobileNumberTxt.text!
        let qualification = qualificationTxt.text!
        let education_status = educationalStatusTxt.text!
        let passout_year = passoutYearTxt.text!
        let state = stateTxt.text!
        let district = districtTxt.text!
        let reference = referenceTxt.text!
        let job_status = jobStatusTxt.text!
        
        let parameter:[String:Any] = [
            "registration_id" : registration_id,
            "firstname" : firstname,
            "lastame" : lastame,
            "email" : email,
            "mobile_no" : mobile_no,
            "qualification" : qualification,
            "education_status" : education_status,
            "passout_year" : passout_year,
            "state" : state,
            "district" : district,
            "reference" : reference,
            "job_status" : job_status
        ]
        if InternetConnectionManager.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            editProfileApi(parameter : parameter)
        }
        else{
            noInternetAlertView(self: self)
        }
    }
    private func editProfileApi(parameter:[String:Any]){
        let token = UserDefaults.standard.string(forKey: "apiToken")
        guard let url = ProjectApi.shared.editProfileApi() else{return}
        let jsonDataParams = try? JSONSerialization.data(withJSONObject: parameter)
        
        // create post request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonDataParams
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( token, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{return}
            do{
                let jsondata = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let statusCode = jsondata["status_code"] as! String
                if(statusCode == "200"){
                   print("EditProfileApiFetched")
                    let user = jsondata["user"] as! [String:Any]
                    UserDefaults.standard.set(user, forKey: "userAllData")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else if statusCode == "408"{
                    logout(self: self)
                }
                else{}
            }
            catch let error{
                print(error)
            }
        }
        dataTask.resume()
    }
    
}

extension EditProfileVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
        let logic:Bool = textField == qualificationTxt || textField == educationalStatusTxt || textField == passoutYearTxt || textField == jobStatusTxt || textField == stateTxt || textField == districtTxt || textField == referenceTxt
        
        if(logic){
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

extension EditProfileVC:UIPickerViewDelegate,UIPickerViewDataSource{
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
