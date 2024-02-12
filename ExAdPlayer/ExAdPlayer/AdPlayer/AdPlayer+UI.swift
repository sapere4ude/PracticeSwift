//
//  AdPlayer+UI.swift
//  ExAdPlayer
//
//  Created by Kant on 2/10/24.
//

import UIKit
import AVFoundation

// MARK: - UI
extension AdPlayer {
    internal func setupUI() {
        self.layer.cornerRadius = 8
        self.addSubview(thumbnailImageView)
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
