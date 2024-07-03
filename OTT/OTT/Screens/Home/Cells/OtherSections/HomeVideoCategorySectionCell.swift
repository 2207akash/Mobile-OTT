//
//  HomeVideoCategorySectionCell.swift
//  OTT
//
//  Created by Akash Sen on 30/06/24.
//

import UIKit

class HomeVideoCategorySectionCell: UICollectionViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Initializers
    var videos = [Video]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCells()
    }

}


extension HomeVideoCategorySectionCell {
    
    private func pushToDetailScreen(videos: [Video], selectedVideo: Video) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideoDetailPageVC") as! VideoDetailPageVC
        vc.videos = videos
        vc.selectedVideo = selectedVideo
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension HomeVideoCategorySectionCell {
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "HomeVideoThumbCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeVideoThumbCollectionViewCell")
    }
    
}


extension HomeVideoCategorySectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVideoThumbCollectionViewCell", for: indexPath) as! HomeVideoThumbCollectionViewCell
        
        let videoInfo = videos[indexPath.row]
        cell.thumbImageView.loadImage(from: videoInfo.thumb)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        pushToDetailScreen(videos: videos, selectedVideo: video)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width-10)/2
        return CGSize(width: width, height: collectionView.frame.size.height)
    }
    
}
