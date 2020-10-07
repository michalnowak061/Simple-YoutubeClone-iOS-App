//
//  PlaylistsPlayerVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 07/10/2020.
//

import UIKit
import youtube_ios_player_helper

class PlaylistsPlayerVC: UIViewController {
    enum PlaylistsPlayerVCState {
        case videoIsLoading
        case videoIsPlaying
        case videoIsPaused
    }
    var state: PlaylistsPlayerVCState = .videoIsLoading
    var playlistId: String = ""
    var actualTimeSeconds: Int = 0
    var actualTimeHMS: String {
        get {
            let (h, m, s) = secondsToHoursMinutesSeconds(seconds: actualTimeSeconds)
            let seconds = s < 10 ? "0" + String(s) : String(s)
            let minutes = String(m)
            let hours = String(h)
            if h != 0 {
                return hours + ":" + minutes + ":" + seconds
            } else {
               return minutes + ":" + seconds
            }
        }
    }
    var timeToEndSeconds: Int = 0
    var timeToEndHMS: String {
        get {
            let (h, m, s) = self.secondsToHoursMinutesSeconds(seconds: timeToEndSeconds)
            let seconds = s < 10 ? "0" + String(s) : String(s)
            let minutes = String(m)
            let hours = String(h)
            
            if h != 0 {
                return "-" + hours + ":" + minutes + ":" + seconds
            } else {
                return "-" + minutes + ":" + seconds
            }
        }
    }
    var playerSliderTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        func setupPlayerView() {
            let playvarsDic = ["controls": 0, "playsinline": 1, "modestbranding": 1]
            
            self.player.delegate = self
            self.player.isUserInteractionEnabled = false
            print(self.playlistId)
            self.player.load(withPlaylistId: self.playlistId, playerVars: playvarsDic)
        }
        func setupPlayerSlider() {
            self.playerSlider.value = 0
            self.playerSlider.thumbTintColor = .black
            self.playerSlider.minimumTrackTintColor = .black
        }
        setupPlayerView()
        setupPlayerSlider()
    }
    
    private func updateView() {
        
    }
    
    private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @IBOutlet weak var player: YTPlayerView!
    @IBOutlet weak var actualTimeLabel: UILabel!
    @IBOutlet weak var timeToEndLabel: UILabel!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBAction func playerSliderValueChanged(_ sender: UISlider) {
        self.player.duration { (duration, error) in
            guard duration != 0 else {
                self.playerSliderTimer?.invalidate()
                return
            }
            self.state = .videoIsLoading
            self.playerSliderTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                let setTime: Float = Float(duration) * sender.value
                self.player.seek(toSeconds: setTime, allowSeekAhead: true)
                self.state = .videoIsPlaying
            }
            self.actualTimeSeconds = Int(Float(duration) * sender.value)
            self.actualTimeLabel.text = self.actualTimeHMS
            
            self.timeToEndSeconds = Int(duration) - self.actualTimeSeconds
            self.timeToEndLabel.text = self.timeToEndHMS
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        self.player.playerState { (YTPlayerState, error) in
            if YTPlayerState == .playing {
                self.player.pauseVideo()
                self.state = .videoIsPaused
                sender.setImage(UIImage(named: "SF_play"), for: .normal)
            }
            else if YTPlayerState == .paused {
                self.player.playVideo()
                self.state = .videoIsPlaying
                sender.setImage(UIImage(named: "SF_pause"), for: .normal)
            }
        }
    }
    
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        self.player.previousVideo()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.player.nextVideo()
    }
}

extension PlaylistsPlayerVC: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.player.playVideo()
        self.state = .videoIsPlaying
        self.playPauseButton.setImage(UIImage(named: "SF_pause"), for: .normal)
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        if self.state != .videoIsLoading {
            self.actualTimeSeconds = Int(playTime)
            self.actualTimeLabel.text = self.actualTimeHMS
            
            self.player.duration { (duration, error) in
                self.timeToEndSeconds = Int(duration) - Int(playTime)
                self.timeToEndLabel.text = self.timeToEndHMS
                self.playerSlider.value = Float(playTime) / Float(duration)
            }
        }
    }
}
