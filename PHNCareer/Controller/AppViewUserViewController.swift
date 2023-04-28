//
//  AppViewUserViewController.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 01/04/23.
//

import UIKit
import SkeletonView
import Lottie

class AppViewUserViewController: UIViewController {

    @IBOutlet weak var appViewUserCollectionView: UICollectionView!
    @IBOutlet weak var noInternetAnimationView: LottieAnimationView!
    @IBOutlet weak var noDataAnimation: LottieAnimationView!
    
    @IBOutlet weak var addUserButton: UIButton!
    
    var users:[AppUser] = []
    let refreshPull = UIRefreshControl()
    
    override func viewDidLoad() {
        setBackButton()
        super.viewDidLoad()
        setRefreshPullControl()
        setUpCollectionView()
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        setNavigationBarTitle()
        setAnimation()
        addUserButton.layer.cornerRadius = addUserButton.layer.frame.height / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkInternet()
    }
    private func setBackButton(){
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        if #available(iOS 15.0, *) {
            self.navigationController?.navigationBar.tintColor = UIColor.tintColor
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor(named: "tintColorIos")
        }
    }
    private func setRefreshPullControl(){
        refreshPull.attributedTitle = NSAttributedString(string: "Loading...")
        refreshPull.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.appViewUserCollectionView.refreshControl = refreshPull
    }
    @objc func refresh(sender:UIRefreshControl){
        self.checkInternet()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }
    private func setNavigationBarTitle(){
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 40))
        label.textColor = UIColor.black
        label.text = "View User".localizedCapitalized
        label.font = UIFont.boldSystemFont(ofSize: 20)
        self.navigationItem.titleView = label
    }
   
    private func setUpCollectionView(){
        appViewUserCollectionView.delegate = self
        appViewUserCollectionView.dataSource = self
    }
    private func setAnimation(){
        //No Internet Animation
        noInternetAnimationView.contentMode = .scaleAspectFit
        noInternetAnimationView.loopMode = .loop
        noInternetAnimationView.animationSpeed = 0.5
        noInternetAnimationView.play()
        
        //No Data Found Animation
        noDataAnimation.contentMode = .scaleAspectFit
        noDataAnimation.loopMode = .loop
        noDataAnimation.animationSpeed = 1
        noDataAnimation.play()
    }
    private func checkInternet(){
        if InternetConnectionManager.isConnectedToNetwork(){
            appViewUserCollectionView.showAnimatedGradientSkeleton()
            fetchUserApi()
            noInternetAnimationView.isHidden = true
            appViewUserCollectionView.isHidden = false
            noDataAnimation.isHidden = true
            addUserButton.isHidden = false
        }
        else{
            appViewUserCollectionView.isHidden = true
            noInternetAnimationView.isHidden = false
            addUserButton.isHidden = true
            noDataAnimation.isHidden = true
        }
    }
    private func fetchUserApi(){
        self.users = []
        guard let mobileNo = UserDefaults.standard.string(forKey: "UserMobileNumber")else{return}
        guard var  url = ProjectApi.shared.viewreferalApi() else{return}
       
        url.appendQueryItem(name: "mob_no", value: mobileNo)

       let token = UserDefaults.standard.string(forKey: "apiToken")
        let params: [String: Any] = ["mobile_no" : mobileNo]
        let jsonDataParams = try? JSONSerialization.data(withJSONObject: params)
        
        // create post request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonDataParams
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( token, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else{return}
            do{
                let jsondata = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let statusCode = jsondata["status_code"] as! String
                if(statusCode == "200"){
                    let data = jsondata["data"] as! [[String:Any?]]
                    for i in data{
                        let id = i["id"] as? String?
                        let firstname = i["firstname"] as? String?
                        let lastname = i["lastname"] as? String?
                        let email = i["email"] as? String?
                        let contact = i["contact"] as? String?
                        let status = i["status"] as? String?
                        let user_id = i["user_id"] as? String?
                        let updated = i["updated"] as? String?
                        let app_name = i["app_name"] as? String?
                        let download = i["download"] as? String?
                        let addfund = i["addfund"] as? String?
                        let kyc = i["kyc"] as? String?
                        let execute = i["execute"] as? String?
                        let remark = i["remark"] as? String?
                        let userDataObject = AppUser(id: id ?? "",
                                                     firstname: firstname ?? "",
                                                     lastname: lastname ?? "",
                                                     email: email ?? "",
                                                     contact: contact ?? "",
                                                     status: status ?? "",
                                                     user_id: user_id ?? "",
                                                     updated: updated ?? "",
                                                     app_name: app_name ?? "",
                                                     download: download ?? "",
                                                     addfund: addfund ?? "",
                                                     kyc: kyc ?? "",
                                                     execute: execute ?? "",
                                                     remark: remark ?? "")
                         users.append(userDataObject)
                    }
                    DispatchQueue.main.async {
                        self.appViewUserCollectionView.stopSkeletonAnimation()
                        self.appViewUserCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    }
                }
                else if statusCode == "404"{
                    DispatchQueue.main.async {
                        self.appViewUserCollectionView.isHidden = true
                        self.noInternetAnimationView.isHidden = true
                        self.addUserButton.isHidden = false
                        self.noDataAnimation.isHidden = false
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
    //MARK IBActions
    
    
    @IBAction func tryAgainBtnClick(_ sender: UIButton) {
        self.checkInternet()
    }
    
    @IBAction func addUserButtonClick(_ sender: UIButton) {
        let addUserVC = self.storyboard?.instantiateViewController(withIdentifier: "AddUserVC") as! AddUserVC
        self.navigationController?.pushViewController(addUserVC, animated: true)
    }
}


extension AppViewUserViewController : SkeletonCollectionViewDataSource{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "AppViewUserCollectionViewCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = appViewUserCollectionView.dequeueReusableCell(withReuseIdentifier: "AppViewUserCollectionViewCell", for: indexPath) as! AppViewUserCollectionViewCell
        cell.appUserModelObject = users[indexPath.row]
        return cell
    }
}
extension AppViewUserViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 30
        return CGSize(width: width, height: 80)
    }
}


