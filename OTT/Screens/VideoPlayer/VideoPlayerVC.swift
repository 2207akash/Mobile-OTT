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
    @IBOutlet weak var fullScreenBtn: UIButton!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var seekSlider: UISlider!
    
    // MARK: Initializers
    var video: Video?
    weak var delegate: VideoPlayerDelegate?
    
    deinit {
        // Remove observers
        player.currentItem?.removeObserver(self, forKeyPath: "duration")
        NotificationCenter.default.removeObserver(self)
        
        // Release player and layer (if necessary)
        player = nil
        playerLayer = nil
    }
    
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
    
    private var isFullScreen = false {
        didSet {
            if isFullScreen {
                fullScreenBtn.setImage(UIImage(systemName: "arrow.up.right.and.arrow.down.left"), for: .normal)
                Utility.lockOrientation(.all, andRotateTo: .landscapeLeft)
            } else {
                fullScreenBtn.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right"), for: .normal)
                Utility.lockOrientation(.all, andRotateTo: .portrait)
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
        delegate?.playNextVideoTapped()
    }
    
    @IBAction func seekSliderValueChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
    }
    
    @IBAction func fullScreenBtnTapped(_ sender: Any) {
        isFullScreen = !isFullScreen
    }
}


// MARK: UI updates
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
        
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        updateElapsedTimeObserver()
        
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


// MARK: Manage Seeker
extension VideoPlayerVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration, duration.seconds > 0.0 {
            self.totalTimeLabel.text = duration.formattedTimeForPlayerSeeker()
        }
    }
    
    @objc private func videoDidEnded() {
        delegate?.playNextVideoTapped()
    }
    
    private func updateElapsedTimeObserver() {
        let updateInterval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        _ = player.addPeriodicTimeObserver(forInterval: updateInterval, queue: DispatchQueue.main, using: { [weak self] time in
            guard let currentTime = self?.player.currentItem else { return }
            self?.seekSlider.maximumValue = Float(currentTime.duration.seconds)
            self?.seekSlider.isUserInteractionEnabled = self?.seekSlider.maximumValue ?? 0.0 > 0.0
            self?.seekSlider.minimumValue = 0
            self?.seekSlider.value = Float(currentTime.currentTime().seconds)
            self?.timeElapsedLabel.text = currentTime.currentTime().formattedTimeForPlayerSeeker()
        })
    }
    
}
