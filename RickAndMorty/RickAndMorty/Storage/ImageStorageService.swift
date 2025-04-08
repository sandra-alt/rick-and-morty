//
//  ImageStorageService.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 08.04.2025.
//

import UIKit
import Kingfisher

class ImageStorageService {

    private let directoryName = "CharactersImages"

    private var imagesDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let imagesDirectory = documentsDirectory.appendingPathComponent(directoryName)

        if !FileManager.default.fileExists(atPath: imagesDirectory.path) {
            try? FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
        }
        
        return imagesDirectory
    }

    func saveImage(imageURL: String, characterID: Int, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: imageURL) else {
            completion(nil)
            return
        }

        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                let fileName = "\(characterID).jpg"
                let fileURL = self.imagesDirectory.appendingPathComponent(fileName)
                
                if let data = value.image.jpegData(compressionQuality: 0.8) {
                    do {
                        try data.write(to: fileURL)
                        completion(fileURL.path)
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
                
            case .failure:
                completion(nil)
            }
        }
    }

    func loadImage(from path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }

    func imageExists(for path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    func localImageURL(from path: String) -> URL? {
        return URL(fileURLWithPath: path)
    }
}
