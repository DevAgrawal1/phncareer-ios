//
//  TrainingsViewController.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 28/03/23.
//

import UIKit
import SDWebImage
import SkeletonView
import Lottie

class TrainingsViewController: UIViewController {
    //MARK IBOutlet
    @IBOutlet weak var trainingsCollectionView: UICollectionView!
    var trainings : [Training] = []
    var skeletonAnimated:Bool = true
    
    @IBOutlet weak var noDataAnimation: LottieAnimationView!
    @IBOutlet weak var animationView: LottieAnimationView!
 
    let refreshPull = UIRefreshControl()
    //MARK ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshPullControl()
        setLottieAnimationView()
        setUpCollectionView()
        setNavigationButton()
        checkInternet()
    }
    override func viewWillAppear(_ animated: Bool) {
        showTabBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        setNavigationBarTitle()
    }

    //MARK Other Function
    private func setRefreshPullControl(){
        refreshPull.attributedTitle = NSAttributedString(string: "Loading...")
        refreshPull.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.trainingsCollectionView.refreshControl = refreshPull
    }
    @objc func refresh(sender:UIRefreshControl){
            self.skeletonAnimated = true
            self.checkInternet()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
            sender.endRefreshing()
        })
    }
    private func setLottieAnimationView(){
         animationView!.contentMode = .scaleAspectFit
         animationView!.loopMode = .loop
         animationView!.animationSpeed = 0.5
         animationView!.play()
        
        noDataAnimation!.contentMode = .scaleAspectFit
        noDataAnimation!.loopMode = .loop
        noDataAnimation!.animationSpeed = 1
        noDataAnimation!.play()
    }
 
    @IBAction func tryButtonClick(_ sender: Any) {
        self.checkInternet()
    }
    
    private func checkInternet(){
        if(InternetConnectionManager.isConnectedToNetwork()){
            self.trainingsApiFetch()
            self.animationView.isHidden = true
            self.noDataAnimation.isHidden = true
            self.trainingsCollectionView.isHidden = false
            setSkeletonAnimation()
        }
        else{
            self.trainingsCollectionView.isHidden = true
            self.animationView.isHidden = false
            self.noDataAnimation.isHidden = true
            self.refreshPull.endRefreshing()
        }
    }
    private func setSkeletonAnimation(){
        if(skeletonAnimated){
            trainingsCollectionView.showAnimatedGradientSkeleton()
        }
    }
    private func setNavigationBarTitle(){
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Trainings".localizedCapitalized
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
    }
    private func setUpCollectionView(){
        trainingsCollectionView.delegate = self
        trainingsCollectionView.dataSource = self
        let nib = UINib(nibName: "TrainingsCVCell", bundle: nil)
        trainingsCollectionView.register(nib, forCellWithReuseIdentifier: "TrainingsCVCell")
        
    }
    private func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    private func setNavigationButton(){
        let addPersonDetail = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(profileNavigationBtnClick))
        addPersonDetail.imageInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        addPersonDetail.image = UIImage(named: "UserProfile")
        addPersonDetail.tintColor = UIColor(named: "projectColor")
        addPersonDetail.width = 30
        navigationItem.rightBarButtonItem = addPersonDetail
    }
    func trainingsApiFetch(){
        let mobileNo = UserDefaults.standard.string(forKey: "UserMobileNumber")
        let token = UserDefaults.standard.string(forKey: "apiToken")
        guard let url = ProjectApi.shared.trainingApi() else{return}
        let params: [String: Any] = ["mobile_no" : mobileNo ?? ""]
        let jsonDataParams = try? JSONSerialization.data(withJSONObject: params)
        
        // create post request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonDataParams
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{return}
            do{
                let jsondata = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let statusCode = jsondata["status_code"] as! String
                if(statusCode == "200"){
                    let trainingJson = try JSONDecoder().decode(TrainingModel.self, from: data)
                    self.trainings = trainingJson.training
                    DispatchQueue.main.async {
                        self.trainingsCollectionView.stopSkeletonAnimation()
                        self.trainingsCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                        self.skeletonAnimated = false
                    }
                }
                else if statusCode == "404"{
                    DispatchQueue.main.async {
                        self.animationView.isHidden = true
                        self.noDataAnimation.isHidden = false
                        self.trainingsCollectionView.isHidden = true
                    }
                }
                else if(statusCode == "408"){
                   logout(self: self)
                }
                else{
                    DispatchQueue.main.async {
                        self.trainingsCollectionView.stopSkeletonAnimation()
                        self.trainingsCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                        self.skeletonAnimated = false
                    }
                }
            }
            catch let error{
                print(error)
            }
        }
        dataTask.resume()
    }
    
    @objc func profileNavigationBtnClick(){
       let profileVc =  self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(profileVc, animated: true)
    }
}

extension TrainingsViewController:SkeletonCollectionViewDataSource{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "TrainingsCVCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trainings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = trainingsCollectionView.dequeueReusableCell(withReuseIdentifier: "TrainingsCVCell", for: indexPath) as! TrainingsCVCell
        cell.layer.cornerRadius = 10
        cell.trainingObj = trainings[indexPath.row]
        return cell
    }
}
extension TrainingsViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 20
        return CGSize(width: width, height: width * 0.55)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
extension TrainingsViewController:SkeletonCollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let traingsDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "TraingsDetailViewController") as! TraingsDetailViewController
        traingsDetailVC.trainingObj = self.trainings[indexPath.row]
        self.navigationController?.pushViewController(traingsDetailVC, animated: true)
    }
}
