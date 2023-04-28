//
//  SellAllTestAppsViewController.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 29/03/23.
//

import UIKit


class SellAllTestAppsViewController: UIViewController {

    var appData = [Datum]()
    
    @IBOutlet weak var viewUserButton: UIButton!
    @IBOutlet weak var testAppsCollectionView: UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setCollectionViewCell()
        hideTabBar()
        setNavigationBarTitle()
    }
    override func viewWillAppear(_ animated: Bool) {
        setBackButton()
    }
    private func setBackButton(){
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        if #available(iOS 15.0, *) {
            self.navigationController?.navigationBar.tintColor = UIColor.tintColor
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor(named: "tintColorIos")
        }
    }
    private func hideTabBar(){
       
        self.extendedLayoutIncludesOpaqueBars = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setCollectionViewCell(){
        testAppsCollectionView.delegate = self
        testAppsCollectionView.dataSource = self
        let nib = UINib(nibName: "AppTestCollectionViewCell", bundle: nil)
        testAppsCollectionView.register(nib, forCellWithReuseIdentifier: "AppTestCollectionViewCell")
    }
    private func setNavigationBarTitle(){
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 40))
        label.textColor = UIColor.black
        label.text = "Apps".localizedCapitalized
        label.font = UIFont.boldSystemFont(ofSize: 20)
        self.navigationItem.titleView = label
    }

    
    @IBAction func viewUserBtnClick(_ sender: UIButton) {
        let appViewUserViewController = self.storyboard?.instantiateViewController(withIdentifier: "AppViewUserViewController") as! AppViewUserViewController
        self.navigationController?.pushViewController(appViewUserViewController, animated: true)
    }
}

extension SellAllTestAppsViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = testAppsCollectionView.dequeueReusableCell(withReuseIdentifier: "AppTestCollectionViewCell", for: indexPath) as! AppTestCollectionViewCell
        let url = stringToUrl(str: appData[indexPath.row].image!)
        cell.appTestImageView.sd_setImage(with: url!)
        return cell
    }
}

extension SellAllTestAppsViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width-40
        return CGSize(width: width, height: width * 0.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

extension SellAllTestAppsViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appTestDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "AppTestDetailViewController") as! AppTestDetailViewController
        appTestDetailViewController.appData = appData[indexPath.row]
        self.navigationController?.pushViewController(appTestDetailViewController, animated: true)
    }
}
