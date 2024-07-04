//
//  VideoDetailPageVC.swift
//  OTT
//
//  Created by Akash Sen on 30/06/24.
//

import UIKit
import AVFoundation

class VideoDetailPageVC: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var thumbnailView: UIView!
    @IBOutlet weak var playVideoBtn: UIButton!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDurationLabel: UILabel!
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    @IBOutlet weak var movieTagCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryListCollectionView: UICollectionView!
    
    // MARK: Initializers
    var videos = [Video]()
    var selectedVideo: Video!
    
    // MARK: Properties
    private var relatedVideos = [Video]()
    private var lastSelectedCategoryIndex = 0
    
    
    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        relatedVideos = videos.filter { $0.id != selectedVideo.id }
        
        registerCells()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playVideoBtn.applyBorder(width: 5, color: .white)
        playVideoBtn.roundCorners(corners: .allCorners, radius: playVideoBtn.frame.size.height/2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Utility.lockOrientation(.all)
    }
    
    // MARK: IBActions
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playVideoTapped(_ sender: Any) {
        self.playVideo(video: selectedVideo)
    }
    
}


extension VideoDetailPageVC {
    
    private func registerCells() {
        movieTagCollectionView.register(UINib(nibName: "MovieTagCell", bundle: nil), forCellWithReuseIdentifier: "MovieTagCell")
        categoryCollectionView.register(UINib(nibName: "DetailViewCategoryCell", bundle: nil), forCellWithReuseIdentifier: "DetailViewCategoryCell")
        categoryListCollectionView.register(UINib(nibName: "HomeVideoThumbCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeVideoThumbCollectionViewCell")
    }
    
    private func setupUI() {
        self.thumbImageView.loadImage(from: selectedVideo.thumb)
        self.videoTitleLabel.text = selectedVideo.title
        if let videoURL = URL(string: selectedVideo.url) {
            getVideoDuration(from: videoURL)
        }
        self.videoDescriptionLabel.text = selectedVideo.description
        
        movieTagCollectionView.reloadData()
        categoryCollectionView.reloadData()
        categoryListCollectionView.reloadData()
    }
    
    private func getVideoDuration(from url: URL) {
        let asset = AVURLAsset(url: url)
        asset.loadDuration { [weak self] duration in
            guard let self = self else { return }
            self.videoDurationLabel.text = duration ?? "N/A"
        }
    }
    
}


extension VideoDetailPageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == movieTagCollectionView {
            return selectedVideo.movieTags.count
        } else if collectionView == categoryCollectionView {
            return 1
        }
        else {
            return videos.count-1   // Related videos are videos in the category except the video on display
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == movieTagCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieTagCell", for: indexPath) as! MovieTagCell
            cell.tagLabel.text = selectedVideo.movieTags[indexPath.row].uppercased()
            return cell
        }
        else if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailViewCategoryCell", for: indexPath) as! DetailViewCategoryCell
            
            if lastSelectedCategoryIndex == indexPath.row {
                cell.bottomHRLine.isHidden = false
            } else {
                cell.bottomHRLine.isHidden = true
            }
            cell.titleLabel.text = "Related"
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVideoThumbCollectionViewCell", for: indexPath) as! HomeVideoThumbCollectionViewCell
            
            let relatedVideo = relatedVideos[indexPath.row]
            cell.thumbImageView.loadImage(from: relatedVideo.thumb)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            lastSelectedCategoryIndex = indexPath.row
        }
        else if collectionView == categoryListCollectionView {
            selectedVideo = relatedVideos[indexPath.row]
            reloadScreenContent(videos: videos, selectedVideo: selectedVideo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoryCollectionView {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        else if collectionView == categoryListCollectionView {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == movieTagCollectionView {
            return CGSize(width: 1, height: 30)
        }
        else if collectionView == categoryListCollectionView {
            let width = (collectionView.frame.size.width-10)/2
            let thumbAspectRatio = 1.745
            return CGSize(width: width, height: width / thumbAspectRatio)
        } else {
            return CGSize(width: 1, height: 50)
        }
    }
    
}


extension VideoDetailPageVC {
    
    private func playVideo(video: Video) {
        let storyboard = UIStoryboard(name: "VideoPlayer", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.video = video
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func reloadScreenContent(videos: [Video], selectedVideo: Video) {
        relatedVideos = videos.filter { $0.id != selectedVideo.id }
        setupUI()
    }
    
}


extension VideoDetailPageVC: VideoPlayerDelegate {
    
    func playPreviousVideoTapped() {
        guard let selectedIndex = videos.firstIndex(of: selectedVideo) else {
            debugPrint("Video is not part of videos: This case should never occur")
            return
        }
        var previousIndex = selectedIndex - 1
        if previousIndex >= 0 {
            selectedVideo = videos[previousIndex]
        } else {
            previousIndex = videos.count-1
            selectedVideo = videos[previousIndex]
        }
        
        reloadScreenContent(videos: videos, selectedVideo: selectedVideo)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            self.playVideo(video: self.selectedVideo)
        }
    }
    
    func playNextVideoTapped() {
        guard let selectedIndex = videos.firstIndex(of: selectedVideo) else {
            debugPrint("Video is not part of videos: This case should never occur")
            return
        }
        var nextIndex = selectedIndex + 1
        if nextIndex < videos.count {
            selectedVideo = videos[nextIndex]
        } else {
            nextIndex = 0
            selectedVideo = videos[nextIndex]
        }
        
        reloadScreenContent(videos: videos, selectedVideo: selectedVideo)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            self.playVideo(video: self.selectedVideo)
        }
    }
    
}
