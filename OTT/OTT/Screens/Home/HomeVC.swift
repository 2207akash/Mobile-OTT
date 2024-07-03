//
//  HomeVC.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import UIKit
import GoogleSignIn

class HomeVC: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var videosListCollectionView: UICollectionView!
    
    // MARK: Properties
    private var datasource = [HomeVideoListSection]() {
        didSet {
            DispatchQueue.main.async {
                self.videosListCollectionView?.reloadData()
            }
        }
    }
    
    
    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        registerCells()
        getDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Utility.lockOrientation(.all)
    }
    
}


extension HomeVC {
    
    private func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.showLoginVC()
    }
    
    private func showLoginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
}


extension HomeVC {
    
    private func setupUI() {
        let menuLogoutBtn = UIAction(title: "Sign Out", image: nil) { _ in
            self.signOut()
        }
        menuLogoutBtn.attributes = .destructive
        
        profileBtn.showsMenuAsPrimaryAction = true
        profileBtn.menu = UIMenu(title: "Profile", children: [menuLogoutBtn])
    }
    
    private func registerCells() {
        videosListCollectionView.register(UINib(nibName: "HomeVideoSectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeVideoSectionHeader")
        videosListCollectionView.register(UINib(nibName: "HomeVideoFeaturedSectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeVideoFeaturedSectionCell")
        videosListCollectionView.register(UINib(nibName: "HomeVideoCategorySectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeVideoCategorySectionCell")
    }
    
    private func getDatasource() {
        do {
            self.datasource = try JSONParser.shared.parse(jsonFileName: "HomeVideos")
        } catch (let error) {
            debugPrint("Error: \(error.localizedDescription)")
            Utility.showAlert(
                on: self,
                title: Constants.AlertMessages.sorry,
                message: Constants.AlertMessages.unableToFetchServerData,
                options: [Constants.AlertMessages.ok]
            )
        }
    }
    
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeVideoSectionHeader", for: indexPath) as! HomeVideoSectionHeader
        
        let data = datasource[indexPath.section]
        headerView.sectionTitleLabel.text = data.sectionTitle
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        } else {
            return CGSize(width: collectionView.frame.size.width, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let videoSectionInfo = datasource[indexPath.section]
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVideoFeaturedSectionCell", for: indexPath) as! HomeVideoFeaturedSectionCell
            cell.videos = videoSectionInfo.videos
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVideoCategorySectionCell", for: indexPath) as! HomeVideoCategorySectionCell
            cell.videos = videoSectionInfo.videos
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let thumbAspectRatio = 1.745
        
        if indexPath.section == 0 {
            let width = collectionView.frame.size.width
            return CGSize(width: collectionView.frame.size.width, height: width / thumbAspectRatio + 40)
        }
        else {
            let width = (collectionView.frame.size.width-10) / 2
            return CGSize(width: collectionView.frame.size.width, height: width / thumbAspectRatio)
        }
    }
    
}
