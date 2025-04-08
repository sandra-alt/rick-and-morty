//
//  Models.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let localImage: String?
}

struct Location: Codable {
    let name: String
    let url: String?
}

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
