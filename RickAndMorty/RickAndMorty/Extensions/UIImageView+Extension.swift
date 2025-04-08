//
//  UIImageView+Extension.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 08.04.2025.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImageWithLocalFallback(urlString: String, localPath: String?) {
        if let localPath = localPath, FileManager.default.fileExists(atPath: localPath) {
            if let localURL = URL(string: "file://" + localPath) {
                self.kf.setImage(with: localURL)
            } else if let image = UIImage(contentsOfFile: localPath) {
                self.image = image
            }
        } else if let url = URL(string: urlString) {
            self.kf.setImage(with: url)
        }
    }
}
