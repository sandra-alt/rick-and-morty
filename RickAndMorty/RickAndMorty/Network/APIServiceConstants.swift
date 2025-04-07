//
//  APIServiceConstants.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//

import Foundation

enum APIServiceConstants {
    // MARK: - Base URL
    static let baseURL = "https://rickandmortyapi.com/api"
    
    // MARK: - Paths
    static func characterListPath(page: Int) -> String {
        "/character/?page=\(page)"
    }
}

