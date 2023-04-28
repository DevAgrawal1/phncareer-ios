//
//  AppTestTableViewCell.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 29/03/23.
//

import UIKit
import SkeletonView

class AppTestTableViewCell: UITableViewCell {

    @IBOutlet weak var appTestCollectionView: UICollectionView!
    @IBOutlet weak var seeAllLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    var homeVCDelegate:UIViewController?
    
    var appData:Apps?{
        didSet{
            headerLabel.text = appData?.title
        }
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpCollectionView()
        self.makeLabelClickable()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUpCollectionView(){
        let nib = UINib(nibName: "AppTestCollectionViewCell", bundle: nil)
        self.appTestCollectionView.register(nib, forCellWithReuseIdentifier: "AppTestCollectionViewCell")
        self.appTestCollectionView.delegate = self
        self.appTestCollectionView.dataSource = self
    }
    private func makeLabelClickable(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(AppTestTableViewCell.seeAllLabelClick))
        seeAllLabel.isUserInteractionEnabled = true
        seeAllLabel.addGestureRecognizer(tap)
    }
    
    @objc
        func seeAllLabelClick(sender:UITapGestureRecognizer) {
            let sellAllVC = homeVCDelegate?.storyboard?.instantiateViewController(withIdentifier: "SellAllTestAppsViewController") as! SellAllTestAppsViewController
            sellAllVC.appData = appData!.data
            homeVCDelegate?.navigationController?.pushViewController(sellAllVC, animated: true)
        }
    
}
extension AppTestTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (appData?.data.count ?? 0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  appTestCollectionView.dequeueReusableCell(withReuseIdentifier: "AppTestCollectionViewCell", for: indexPath) as! AppTestCollectionViewCell
        guard let stringUrl = appData!.data[indexPath.row].image else{return UICollectionViewCell()}
        let url = stringToUrl(str: stringUrl)
        guard let placeholderImage = UIImage(named: "dummyImg") else{return UICollectionViewCell()}
        cell.appTestImageView.sd_setImage(with: url,placeholderImage: placeholderImage)
        return cell
    }
}


extension AppTestTableViewCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/2 - 5
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
}

extension AppTestTableViewCell : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appTestDetailViewController = homeVCDelegate?.storyboard?.instantiateViewController(withIdentifier: "AppTestDetailViewController") as! AppTestDetailViewController
        appTestDetailViewController.appData = appData!.data[indexPath.row]
        homeVCDelegate?.navigationController?.pushViewController(appTestDetailViewController, animated: true)
    }
}

extension AppTestTableViewCell: SkeletonCollectionViewDataSource{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "AppTestCollectionViewCell"
    }
}
