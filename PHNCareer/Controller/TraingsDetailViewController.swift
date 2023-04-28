//
//  TraingsDetailViewController.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 04/04/23.
//

import UIKit

class TraingsDetailViewController: UIViewController{
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
  
    @IBOutlet weak var discriptionLbl: UILabel!
    @IBOutlet weak var lastUpdatedDate: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollUIView: UIView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    
    var heightTableView:CGFloat = 0
    var trainingObj:Training?
    var alertMessage = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setData()
         setUpTabBar()
         setCollectionView()
         setHeightAllView()
         setHeightAllView()
    }
    override func viewWillAppear(_ animated: Bool) {
        setBackButton()
    }
   
    private func setData(){
        titleLabel.text = trainingObj?.title ?? ""
        discriptionLbl.text = trainingObj?.description ?? ""
        lastUpdatedDate.text = "Last updated " + (trainingObj?.lastUpdated ?? "")
        //image bind
        let urlString = (trainingObj?.image ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: urlString)else{return}
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "dummyImg"))
    }
    private func setUpTabBar(){
        self.extendedLayoutIncludesOpaqueBars = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    private func setBackButton(){
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        if #available(iOS 15.0, *) {
            self.navigationController?.navigationBar.tintColor = UIColor.tintColor
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor(named: "tintColorIos")
        }
    }
    private func setHeightAllView(){
        imageViewHeight.constant = imageView.frame.width * 0.525
        
        scrollViewHeight.constant =  self.collectionView.frame.size.height + imageView.frame.width
        scrollUIView.layoutIfNeeded()
    }

    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "TrainingDetailCVCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "TrainingDetailCVCell")
        let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height
        self.view.setNeedsLayout()
        self.collectionView.reloadData()
    }
    
    
    private func presentAlertView(){
        self.alertMessage = UIAlertController(title: "Coming soon❗", message: "Trainings section coming soon", preferredStyle: .alert)
        self.present(self.alertMessage, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){ [self] in
            self.alertMessage.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension TraingsDetailViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trainingObj!.section.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TrainingDetailCVCell", for: indexPath) as! TrainingDetailCVCell
        cell.indexNumberLbl.text = String(indexPath.row + 1)
        cell.sectionLbl.text = "Section \(indexPath.row + 1) "
        cell.sectionObj = trainingObj!.section[indexPath.row]
        return cell
    }
}
extension TraingsDetailViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: 70)
    }
}
extension TraingsDetailViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presentAlertView()
    }
}

