//
//  KingfisherManager+Extension.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 08.04.2025.
//

import Kingfisher
import UIKit

extension KingfisherManager {
    func retrieveImageWithLocalCheck(with resource: Resource,
                                     localPath: String?,
                                     options: KingfisherOptionsInfo? = nil,
                                     completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {

        if let localPath = localPath,
           let localURL = URL(string: "file://" + localPath),
           FileManager.default.fileExists(atPath: localPath) {
            
            let localResource = ImageResource(downloadURL: localURL)
            return retrieveImage(with: localResource, options: options, completionHandler: completionHandler)
        }

        return retrieveImage(with: resource, options: options, completionHandler: completionHandler)
    }
}
