//
//  VideoPlayerVC.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerVC: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    // MARK: Initializers
    var video: Video?
    var delegate: VideoPlayerDelegate?
    
    // MARK: Properties
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    // MARK: Configuration Properties
    private var isPlaying = false {
        didSet {
            if isPlaying {
                playPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                player.play()
            } else {
                playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
                player.pause()
            }
        }
    }
    
    
    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnVideoView))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utility.lockOrientation(.all)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Utility.lockOrientation(.all)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer.frame = videoPlayerView.bounds
        
        prevBtn.roundCorners(corners: .allCorners, radius: prevBtn.frame.size.height/2)
        playPauseBtn.roundCorners(corners: .allCorners, radius: playPauseBtn.frame.size.height/2)
        nextBtn.roundCorners(corners: .allCorners, radius: nextBtn.frame.size.height/2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.isPlaying = true
    }
    
    // MARK: IBActions
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func prevBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.playPreviousVideoTapped()
    }
    
    @IBAction func playPauseBtnTapped(_ sender: Any) {
        if player.timeControlStatus == .playing {
            self.isPlaying = false
        } else if player.timeControlStatus == .paused {
            self.isPlaying = true
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.playNextVideoTapped()
    }
    
}


extension VideoPlayerVC {
    
    private func setupUI() {
        titleLabel.text = video?.title
        guard let videoURLString = video?.url else {
            Utility.showAlert(on: self, title: Constants.AlertMessages.unableToFetchServerData, message: Constants.AlertMessages.unableToFetchServerData, options: [Constants.AlertMessages.ok]) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        // Ensure the URL is valid
        guard let videoURL = URL(string: videoURLString) else {
            Utility.showAlert(on: self, title: Constants.AlertMessages.unableToFetchServerData, message: Constants.AlertMessages.unableToFetchServerData, options: [Constants.AlertMessages.ok]) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        
        videoPlayerView.layer.addSublayer(playerLayer)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
            self.overlayView.isHidden = true
        }
    }
    
    @objc private func tappedOnVideoView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.isHidden = !self.overlayView.isHidden
        })
    }
    
}


extension VideoPlayerVC {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
}
