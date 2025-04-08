//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 08.04.2025.
//

import CoreData
import Foundation

protocol CharacterRepositoryProtocol {
    func getCharactersList(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void)
    func getCharacter(id: Int, completion: @escaping (Result<Character, Error>) -> Void)
}

class CharacterRepository: CharacterRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let imageService: ImageStorageService
    private let persistenceService: CharacterPersistenceService
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         persistenceService: CharacterPersistenceService,
         imageService: ImageStorageService = ImageStorageService()) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        self.imageService = imageService
    }
    
    // MARK: - Public methods
    func getCharactersList(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        if !NetworkMonitor.shared.isConnected {
            if let cachedResponse = loadCharactersFromCoreData(page: page) {
                completion(.success(cachedResponse))
                return
            }
        }

        networkService.fetchCharacters(page: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.saveCharactersResponseToCoreData(response)
                completion(.success(response))
            case .failure(let error):
                if let cachedResponse = self?.loadCharactersFromCoreData(page: page) {
                    completion(.success(cachedResponse))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getCharacter(id: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        if let character = loadCharacterFromCoreData(id: id) {
            completion(.success(character))
            return
        }
        
        networkService.fetchCharacter(characterID: id) { [weak self] result in
            switch result {
            case .success(let character):
                self?.saveCharacterToCoreData(character)
                completion(.success(character))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Core Data
    private func saveCharactersResponseToCoreData(_ response: CharacterResponse) {
        persistenceService.viewContext.perform { [weak self] in
            for character in response.results {
                self?.saveCharacterToCoreData(character)
            }

            try? self?.persistenceService.viewContext.save()
        }
    }
    
    private func saveCharacterToCoreData(_ character: Character) {
        let fetchRequest: NSFetchRequest<CharacterEntity>  = CharacterEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", character.id)
        
        let context = persistenceService.viewContext
        
        context.perform { [weak self] in
            
            let characterEntity: CharacterEntity
            
            // Try to find existing entity or create new one
            if let existingCharacter = try? context.fetch(fetchRequest).first {
                characterEntity = existingCharacter
            } else {
                characterEntity = CharacterEntity(context: context)
                characterEntity.id = Int64(character.id)
            }

            characterEntity.name = character.name
            characterEntity.status = character.status
            characterEntity.species = character.species
            characterEntity.gender = character.gender
            characterEntity.type = character.type
            characterEntity.imageUrl = character.image
            characterEntity.location = character.location.name
            characterEntity.origin = character.origin.name

            self?.imageService.saveImage(imageURL: character.image, characterID: character.id) { path in
                if let path = path {
                    context.perform {
                        characterEntity.imageFilePath = path
                        try? context.save()
                    }
                }
            }
            
            try? context.save()
        }
    }
    
    private func loadCharactersFromCoreData(page: Int) -> CharacterResponse? {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        guard let characters = try? persistenceService.viewContext.fetch(fetchRequest) else {
            return nil
        }

        guard !characters.isEmpty else { return nil }
        
        let modelCharacters = characters.compactMap { $0.toCharacter() }
        
        let countRequest = NSFetchRequest<NSNumber>(entityName: "CharacterEntity")
        countRequest.resultType = .countResultType
        let count = (try? persistenceService.viewContext.fetch(countRequest).first?.intValue) ?? modelCharacters.count

        let info = Info(
            count: count,
            pages: 1,
            next: nil,
            prev: nil
        )
        
        return CharacterResponse(info: info, results: modelCharacters)
    }
    
    private func loadCharacterFromCoreData(id: Int) -> Character? {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        guard let characterEntity = try? persistenceService.viewContext.fetch(fetchRequest).first,
              let name = characterEntity.name,
              let status = characterEntity.status,
              let species = characterEntity.species,
              let gender = characterEntity.gender,
              let type = characterEntity.type,
              let image = characterEntity.imageUrl,
              let localImage = characterEntity.imageFilePath else {
            return nil
        }
        
        let origin = characterEntity.origin != nil
            ? Location(name: characterEntity.origin ?? "", url: nil)
            : Location(name: "", url: nil)
        
        let location = characterEntity.location != nil
            ? Location(name: characterEntity.location ?? "", url: nil)
            : Location(name: "", url: nil)
        
        return Character(
            id: Int(characterEntity.id),
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            origin: origin,
            location: location,
            image: image,
            localImage: localImage
        )
    }
}
