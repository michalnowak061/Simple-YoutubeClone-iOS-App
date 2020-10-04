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
            self.player.load(withVideoId: self.videoId, playerVars: playvarsDic)
        }
        setupPlayerView()
    }
    
    private func updateView() {
        
    }
    
    @IBOutlet weak var player: YTPlayerView!
    @IBOutlet weak var actualTimeLabel: UILabel!
    @IBOutlet weak var timeToEndLabel: UILabel!
    @IBOutlet weak var playerSlider: UISlider!
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        self.player.playVideo()
    }
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        self.player.pauseVideo()
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
    }
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
        
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(playTime))
        let seconds = s < 10 ? "0" + String(s) : String(s)
        let minutes = String(m)
        let hours = String(h)
        if h != 0 {
            actualTimeLabel.text = hours + ":" + minutes + ":" + seconds
        } else {
            actualTimeLabel.text = minutes + ":" + seconds
        }
    }
}
