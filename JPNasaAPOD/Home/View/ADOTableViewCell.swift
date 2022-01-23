//
//  ADOTableViewCell.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 19/01/2022.
//

import UIKit
import AVKit
import AVFoundation
import YouTubeiOSPlayerHelper

enum MediaType: String{
    case image = "image"
    case video = "video"
}

class ADOTableViewCell: UITableViewCell {
    
    static var cellIdentifier = "ADOTableViewCell"

    @IBOutlet weak var ytPlayerView: YTPlayerView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var aodImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /**
           Same Cell is been used for both video type and image type, just hiding and showing the type which  we need as per mediaType
           Having seperate cell views just for two media type might be overhead on the memory , so considered having just one cell view.
     */
    func configureCell(with APODData: AODViewModelProtocol) -> Void {
        titleLabel.text = APODData.title
        explanationLabel.text = APODData.explanation
        dateLabel.text = APODData.date?.convertToMonthDayYear()
        if APODData.mediaType == MediaType.image.rawValue {
            loadImage(url: APODData.mediaSourceURL)
        } else {
            loadYouTubeVideo(videoSourceUrl: APODData.mediaSourceURL)
        }
    }
    /**
         Third party Pod is been used to load and play Youtube video
     */
    private func loadYouTubeVideo(videoSourceUrl:String?) -> Void {
        self.ytPlayerView.isHidden = false
        guard let videoId = getVideoIdFrom(VideoSource: videoSourceUrl) else {return}
        ytPlayerView.load(withVideoId:videoId)
    }
    /**
         get Video Id from the Media URL
     */
    func getVideoIdFrom(VideoSource:String?) -> String? {
        guard let videoID = VideoSource?.components(separatedBy: "/").last else { return nil }
        return videoID
    }
    /**
     Image is downloaded using DispatchQueue.Global in background and image is set on the main Queue.
     */
    private func loadImage(url:String?) -> Void {
        self.ytPlayerView.isHidden = true
        self.aodImageView.image = UIImage(named: "placeholder")!
        guard let url = URL(string: url!) else {return}
        self.aodImageView.load(url: url)
    }
    
    // MARK: - AVPlayer
    /**
        This method is not used but just for reference  in case we have to implement AVPlayer for other videos type other than Youtube videos
     */
    private func loadVideo() -> Void {
        
        guard let url = URL(string: "https://www.youtube.com/embed/25FfQ9MEQE8") else { return}
        let avPlayer = AVPlayer(url: url)
        playerView.playerLayer.player = avPlayer
        playerView.player?.play()
    }

}
