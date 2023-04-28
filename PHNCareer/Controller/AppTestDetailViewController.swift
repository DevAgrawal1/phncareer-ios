//
//  AppTestDetailViewController.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 30/03/23.
//

import UIKit
import AVKit
import AVFoundation

class AppTestDetailViewController: UIViewController {

    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var scrollUIView: UIView!
    @IBOutlet weak var appVideoView: UIView!
    @IBOutlet weak var appDetailTableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollUIViewHeight: NSLayoutConstraint!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var installBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    var player : AVPlayer!
    var avpController = AVPlayerViewController()
    var appDetails:[String] = ["Download & Install","KYC","ADD Fund - ₹100","Execute Any Trade","Add Referral"]
    let note:String = "Note: Don't worry you can withdraw your amount"
    
    var appData : Datum?
    //MARK ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppImageView()
        setTableView()
        setVideoView()
        setHeightScrollView()
    }
    override func viewWillAppear(_ animated: Bool) {
        hideTabBar()
    }
    private func hideTabBar() {
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = true
        self.extendedLayoutIncludesOpaqueBars = true
    }
    private func setAppImageView(){
        appImage.layer.cornerRadius = 15
        appImage.layer.borderColor = UIColor.gray.cgColor
        appImage.layer.borderWidth = 0.7
        guard let str  = appData!.app_icon else{return}
        guard let urlString = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else{return}
        let imageURl = URL(string: urlString)
        appImage.sd_setImage(with: imageURl , placeholderImage: UIImage(named: "dummyImg"))
        appName.text = appData?.title
    }
    private func setTableView(){
        let nib = UINib(nibName: "AppTestDetailViewTableViewCell", bundle: nil)
        appDetailTableView.register(nib, forCellReuseIdentifier: "AppTestDetailViewTableViewCell")
       appDetailTableView.delegate = self
       appDetailTableView.dataSource = self
       appDetailTableView.separatorStyle = .none
       appDetailTableView.layer.cornerRadius = 10
        self.appDetailTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
   
    private func setVideoView(){
        guard let urlString = appData!.video_img!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else{return}
        guard let url = URL(string: urlString)else{return}
                  
        videoThumbnail.sd_setImage(with: url, placeholderImage: UIImage(named: "dummyImg"))
        self.appVideoView.layer.masksToBounds = true
        self.appVideoView.layer.cornerRadius = 10
    }

    private func setHeightScrollView(){
        scrollUIViewHeight.constant = self.appDetailTableView.frame.size.height + appVideoView.frame.size.height + 170
         scrollUIView.layoutIfNeeded()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        appDetailTableView.layer.removeAllAnimations()
        tableHeightConstraint.constant = appDetailTableView.contentSize.height + 20
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    
    //MARK IBActions
    @IBAction func installAppBtnClick(_ sender: UIButton) {
        guard let aapUrl = stringToUrl(str: appData?.app_link ?? "") else{return}
        if UIApplication.shared.canOpenURL(aapUrl)
        {
            UIApplication.shared.open(aapUrl)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(aapUrl)
        }
    }
    
    @IBAction func shareAppBtnClick(_ sender: Any) {
     
        UIGraphicsBeginImageContext(view.frame.size)
               view.layer.render(in: UIGraphicsGetCurrentContext()!)
               UIGraphicsEndImageContext()
        let url = stringToUrl(str: appData?.app_link ?? "")
               let textToShare = "Let me recommend you this application"
        let objectsToShare = [textToShare, url as Any] as [Any]
                   let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                   activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                   activityVC.popoverPresentationController?.sourceView = self.view
                   self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func viewUserButtonClick(_ sender: UIButton) {
        let appViewUserViewController = self.storyboard?.instantiateViewController(withIdentifier: "AppViewUserViewController") as! AppViewUserViewController
        self.navigationController?.pushViewController(appViewUserViewController, animated: true)
    }
    
    @IBAction func startVideoButtonClick(_ sender: UIButton) {
        guard let str  = appData!.video_link else{return}
        guard let urlString = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else{return}
        guard let videoUrl = URL(string: urlString)
        else{return}
        
        player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avpController.player = player
        avpController.view.frame.size.width = appVideoView.frame.size.width
        avpController.view.frame.size.height = appVideoView.frame.size.height
        self.appVideoView.addSubview(avpController.view)
        player.allowsExternalPlayback = false
        player.play()
    }
    
}

extension AppTestDetailViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = appDetailTableView.dequeueReusableCell(withIdentifier: "TestAppDetailTableViewCell", for: indexPath)
//        cell.textLabel?.text = "\(indexPath.row + 1)  " + appDetails[indexPath.row]
//        return cell
        let cell = appDetailTableView.dequeueReusableCell(withIdentifier: "AppTestDetailViewTableViewCell", for: indexPath) as! AppTestDetailViewTableViewCell
        cell.cellTitle.text = appDetails[indexPath.row]
        cell.indexNumber.text = "\(indexPath.row + 1)"
        cell.noteLbl.text = note
        if(indexPath.row == 2){
            cell.noteLbl.isHidden = false
        }
        else{
            cell.noteLbl.isHidden = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.width), height: 20))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.bounds.width-10, height: 20))
            label.text = "Steps to Earn:"
        headerView.addSubview(label)
        return headerView
    }
}

extension AppTestDetailViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 2){
            return UITableView.automaticDimension
        }
        else{
            return 25
        }
    }
}


