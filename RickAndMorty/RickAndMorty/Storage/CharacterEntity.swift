//
//  CharacterEntity.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//

import CoreData

@objc(CharacterEntity)
public class CharacterEntity: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
            return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var species: String?
    @NSManaged public var type: String?
    @NSManaged public var gender: String?
    @NSManaged public var origin: String?
    @NSManaged public var location: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var imageFilePath: String?
}

extension CharacterEntity {
    func toCharacter() -> Character? {
        guard let name = name,
              let status = status,
              let species = species,
              let type = type,
              let gender = gender,
              let image = imageUrl,
              let origin = origin,
              let location = location
        else { return nil }
        
        return Character(
            id: Int(id),
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            origin: Location(name: origin, url: nil),
            location: Location(name: location, url: nil),
            image: image,
            localImage: imageFilePath)
        }
}
