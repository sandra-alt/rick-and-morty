//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void)
    func fetchCharacter(characterID: Int, completion: @escaping (Result<Character, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {

    private let session = URLSession.shared

    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        let endpoint = APIServiceConstants.baseURL + APIServiceConstants.characterListPath(page: page)
        performRequest(urlString: endpoint, completion: completion)
    }

    func fetchCharacter(characterID: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        let endpoint = APIServiceConstants.baseURL + APIServiceConstants.character(id: characterID)
        performRequest(urlString: endpoint, completion: completion)
    }

    // MARK: - Generic Request Handler

    private func performRequest<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }

        task.resume()
    }
}
