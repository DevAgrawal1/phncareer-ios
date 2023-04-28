//
//  HomeViewController.swift
//  PHN_Vivek_Task
//
//  Created by PHN MAC 1 on 28/03/23.
//

import UIKit
import SkeletonView
import Lottie

class HomeViewController: UIViewController {
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var animationUIView: UIView!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var noDataAnimation: LottieAnimationView!
    
    let refreshPull = UIRefreshControl()
    var apps:[Apps] = []
    
    var shouldAnimate:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshPullControl()
        setOfflineAnimationView()
        setCollectionView()
        setNavigationButton()
        checkInternet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showTabBar()
        setNameLabel()
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    private func setRefreshPullControl(){
        refreshPull.attributedTitle = NSAttributedString(string: "Loading...")
        refreshPull.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.contentTableView.refreshControl = refreshPull
    }
    @objc func refresh(sender:UIRefreshControl){
        self.checkInternet()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
            sender.endRefreshing()
        })
    }
    private func setOfflineAnimationView(){
        //No internet animation
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        animationView!.play()
 
        //No DataFound animation
        noDataAnimation!.contentMode = .scaleAspectFit
        noDataAnimation!.loopMode = .loop
        noDataAnimation!.animationSpeed = 1
        noDataAnimation!.play()
    }
    func checkInternet(){
        if(InternetConnectionManager.isConnectedToNetwork()){
            startSkeletonAnimation()
            self.animationView.isHidden = true
            self.noDataAnimation.isHidden = true
            self.contentTableView.isHidden = false
            self.fetchTaskApi()
        }
        else{
            self.noDataAnimation.isHidden = true
            self.contentTableView.isHidden = true
            self.animationView.isHidden = false
        }
    }
    
    func startSkeletonAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
            self.shouldAnimate = false
            self.contentTableView.reloadData()
        }
        self.shouldAnimate = true
    }
    
    @IBAction func tryAgainBtnClick(_ sender: Any) {
        self.checkInternet()
    }
    
    private func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    private func setNameLabel(){
        guard let userData = UserDefaults.standard.dictionary(forKey: "userAllData") else{return}
        nameLabel.text = (userData["firstname"] as! String)
    }
    private func setNavigationButton(){
        let addPersonDetail = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(profileNavigationBtnClick))
        addPersonDetail.imageInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        addPersonDetail.image = UIImage(named: "UserProfile")
        addPersonDetail.tintColor = UIColor(named: "projectColor")
        addPersonDetail.width = 30
        addPersonDetail.tintColor = UIColor(named: "projectColor")
        navigationItem.rightBarButtonItem = addPersonDetail
    }
    @objc func profileNavigationBtnClick(){
        let profileVc =  self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(profileVc, animated: true)
    }
    
    private func setCollectionView(){
        self.contentTableView.dataSource = self
        self.contentTableView.delegate = self
        self.contentTableView.separatorStyle = .none
    }
    private func fetchTaskApi(){
        let mobileNo = UserDefaults.standard.string(forKey: "UserMobileNumber")
        let token = UserDefaults.standard.string(forKey: "apiToken")
        guard let url = ProjectApi.shared.taskApi() else{return}
        let params: [String: Any] = ["mobile_no" : mobileNo ?? ""]
        let jsonDataParams = try? JSONSerialization.data(withJSONObject: params)
        
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
                    let taskData = try JSONDecoder().decode(TaskModel.self, from: data)
                    self.apps = taskData.apps
                    DispatchQueue.main.async {
                        self.contentTableView.reloadData()
                    }
                }
                else if statusCode == "404"{
                    DispatchQueue.main.async {
                        self.animationView.isHidden = true
                        self.contentTableView.isHidden = true
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
}

extension HomeViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return apps.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
          let  cell = contentTableView.dequeueReusableCell(withIdentifier: "AppTestTableViewCell", for: indexPath) as! AppTestTableViewCell
            cell.homeVCDelegate = self
            cell.appData = self.apps[indexPath.section]
        
            if shouldAnimate {
                cell.showAnimatedGradientSkeleton()
            }
            else{
               cell.hideSkeleton()
            }
          return cell
        }
        else if indexPath.section == 1{
           
            let cell = contentTableView.dequeueReusableCell(withIdentifier: "SocialMediaTableViewCell", for: indexPath) as! SocialMediaTableViewCell
            cell.socialMediaData = apps[indexPath.section]
           
            if shouldAnimate {
                cell.showAnimatedGradientSkeleton()
            }
            else{
                cell.hideSkeleton()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //for line space
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return " "
    }
}

extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension HomeViewController : SkeletonTableViewDataSource{
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        var reusableCellIdentifier = ""
        
        if indexPath.section == 0{
            reusableCellIdentifier = "AppTestTableViewCell"
        }
        else if indexPath.section == 1{
            reusableCellIdentifier = "SocialMediaTableViewCell"
        }
        return reusableCellIdentifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int{
        UITableView.automaticNumberOfSkeletonRows
    }
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return apps.count
    }
}
