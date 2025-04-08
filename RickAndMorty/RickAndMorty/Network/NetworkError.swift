//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
}
