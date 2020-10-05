//
//  PlayerVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 03/10/2020.
//

import UIKit
import youtube_ios_player_helper

class PlayerVC: UIViewController {
    var videoId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        func setupPlayerView() {
            let playvarsDic = ["controls": 0, "playsinline": 1, "modestbranding": 1]
            
            self.player.delegate = self
            self.player.isUserInteractionEnabled = false
            //self.player.load(withVideoId: self.videoId, playerVars: playvarsDic)
            self.player.load(withVideoId: "QnJXreIcSJI", playerVars: playvarsDic)
        }
        setupPlayerView()
    }
    
    private func updateView() {
        
    }
    
    @IBOutlet weak var player: YTPlayerView!
    @IBOutlet weak var actualTimeLabel: UILabel!
    @IBOutlet weak var timeToEndLabel: UILabel!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        self.player.playerState { (YTPlayerState, error) in
            print(YTPlayerState.rawValue)
            
            if YTPlayerState == .playing {
                self.player.pauseVideo()
                sender.setImage(UIImage(named: "SF_play"), for: .normal)
            }
            else if YTPlayerState == .paused {
                self.player.playVideo()
                sender.setImage(UIImage(named: "SF_pause"), for: .normal)
            }
        }
        sender.setImage(UIImage(contentsOfFile: "SF_pause"), for: .normal)
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        self.player.previousVideo()
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.player.nextVideo()
    }
}

extension PlayerVC: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.player.playVideo()
        self.playPauseButton.setImage(UIImage(named: "SF_pause"), for: .normal)
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
        
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(playTime))
        let seconds = s < 10 ? "0" + String(s) : String(s)
        let minutes = String(m)
        let hours = String(h)
        if h != 0 {
            self.actualTimeLabel.text = hours + ":" + minutes + ":" + seconds
        } else {
            self.actualTimeLabel.text = minutes + ":" + seconds
        }
        
        self.player.duration { (duration, error) in
            let timeToEnd: Int = Int(duration) - Int(playTime)
            let (h, m, s) = secondsToHoursMinutesSeconds(seconds: timeToEnd)
            let seconds = s < 10 ? "0" + String(s) : String(s)
            let minutes = String(m)
            let hours = String(h)
            
            if h != 0 {
                self.timeToEndLabel.text = "-" + hours + ":" + minutes + ":" + seconds
            } else {
                self.timeToEndLabel.text = "-" + minutes + ":" + seconds
            }
            self.playerSlider.value = Float(playTime) / Float(duration)
        }
    }
}
