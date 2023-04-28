//
//  SocialMediaTableViewCell.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 29/03/23.
//

import UIKit
import SkeletonView

class SocialMediaTableViewCell: UITableViewCell {

    @IBOutlet weak var socialMediaCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var socialMediaData:Apps?{
        didSet{
            titleLabel.text = self.socialMediaData?.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUpCollectionView(){
        let nib = UINib(nibName: "SocialMediaCollectionViewCell", bundle: nil)
        self.socialMediaCollectionView.register(nib, forCellWithReuseIdentifier: "SocialMediaCollectionViewCell")
        self.socialMediaCollectionView.delegate = self
        self.socialMediaCollectionView.dataSource = self
    }
 
    func goToSocialMediaSide(url:String){
        guard let appURL = stringToUrl(str: url) else{return}
        UIApplication.shared.open(appURL)
    }

}
extension SocialMediaTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (socialMediaData?.data.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  socialMediaCollectionView.dequeueReusableCell(withReuseIdentifier: "SocialMediaCollectionViewCell", for: indexPath) as! SocialMediaCollectionViewCell
        let url = stringToUrl(str: socialMediaData?.data[indexPath.row].app_icon ?? "")
        guard let placeholderImage = UIImage(named: "dummyImg") else{return UICollectionViewCell()}
        cell.socialMediaImageView.sd_setImage(with: url,placeholderImage: placeholderImage)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor(named: "projectColor")?.cgColor
        return cell
    }
}

extension SocialMediaTableViewCell : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let stringURL = socialMediaData?.data[indexPath.row].app_link else{return}
        goToSocialMediaSide(url: stringURL)
    }
}

extension SocialMediaTableViewCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/4 - 8
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = collectionView.bounds.width/4 - 8
        let height = collectionView.bounds.height
        let bottom = height - width
        return UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
    }
}

extension SocialMediaTableViewCell: SkeletonCollectionViewDataSource{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "SocialMediaCollectionViewCell"
    }
}
