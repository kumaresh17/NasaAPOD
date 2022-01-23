//
//  PlayerView.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 19/01/2022.
//
import UIKit
import AVFoundation
import AVKit

// MARK: - AVPlayer
/**
 Not used as of now, but in future if we have video other than Youtube we can leavarge this class
 */
final class PlayerView: UIView {
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
