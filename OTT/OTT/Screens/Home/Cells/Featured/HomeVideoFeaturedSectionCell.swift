//
//  HomeVideoFeaturedSectionCell.swift
//  OTT
//
//  Created by Akash Sen on 30/06/24.
//

import UIKit

class HomeVideoFeaturedSectionCell: UICollectionViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            let width = self.pagerView.frame.size.width-30
            self.pagerView.automaticSlidingInterval = 3.0
            self.pagerView.itemSize = CGSize(
                width: width,
                height: width / 1.745
            )
            self.pagerView.isInfinite = true
            self.pagerView.interitemSpacing = 10
            self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
        }
    }
    @IBOutlet weak var pageControl: FSPageControl!
    
    // MARK: Initializers
    var videos = [Video]() {
        didSet {
            self.pagerView?.reloadData()
            self.pageControl.numberOfPages = videos.count
        }
    }
    
    
    // MARK: Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCells()
    }

}


extension HomeVideoFeaturedSectionCell {
    
    private func pushToDetailScreen(videos: [Video], selectedVideo: Video) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideoDetailPageVC") as! VideoDetailPageVC
        vc.videos = videos
        vc.selectedVideo = selectedVideo
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension HomeVideoFeaturedSectionCell {
    
    private func registerCells() {
        pagerView.register(UINib(nibName: "HomeFeaturedPagerViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeFeaturedPagerViewCell")
    }
    
}


extension HomeVideoFeaturedSectionCell: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return videos.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HomeFeaturedPagerViewCell", at: index) as! HomeFeaturedPagerViewCell
        
        let videoInfo = videos[index]
        cell.thumbImageView.loadImage(from: videoInfo.thumb)
        cell.titleLabel.text = videoInfo.title
        
        return cell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let video = videos[index]
        pushToDetailScreen(videos: videos, selectedVideo: video)
    }
    
}
