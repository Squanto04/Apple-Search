//
//  SearchTableViewCell.swift
//  Apple Search
//
//  Created by Jordan Lamb on 10/3/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var musicItem: MusicSearchResult? {
        didSet {
            updateMusicViews()
        }
    }
    
    var appItem: AppSearchResult? {
        didSet {
            updateAppViews()
        }
    }
    
    func updateMusicViews() {
        guard let item = musicItem else { return }
        titleLabel.text = item.trackName
        subtitleLabel.text = item.artistName
        artworkImageView.image = nil
        
        SearchController.getMusicImage(item: item) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.artworkImageView.image = image
                }
            } else {
                print("Music Image was nil")
            }
        }
    }
    
    func updateAppViews() {
        guard let item = appItem else { return }
        titleLabel.text = item.trackName
        subtitleLabel.text = item.description
        artworkImageView.image = nil
        
        SearchController.getAppImage(item: item) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.artworkImageView.image = image
                }
            } else {
                print("App Image was nil")
            }
        }
    }
}
