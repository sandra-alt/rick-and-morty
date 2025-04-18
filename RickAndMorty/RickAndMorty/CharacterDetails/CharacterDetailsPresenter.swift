//
//  CharacterDetailsPresenter.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CharacterDetailsPresentationLogic: AnyObject {
    func presentCharacterDetails(response: CharacterDetails.FetchCharacterDetails.Response)
}

class CharacterDetailsPresenter: CharacterDetailsPresentationLogic {
    
    weak var viewController: CharacterDetailsDisplayLogic?
    
    func presentCharacterDetails(response: CharacterDetails.FetchCharacterDetails.Response) {
        let viewModel = CharacterDetails.FetchCharacterDetails.ViewModel(
            name: response.character?.name ?? "",
            status: response.character?.status ?? "",
            species: response.character?.species ?? "",
            gender: response.character?.gender ?? "",
            origin: response.character?.origin.name ?? "",
            location: response.character?.location.name ?? "",
            imageURL: response.character?.image ?? "",
            imageFilePath: response.character?.localImage
        )
        
        DispatchQueue.main.async {
            self.viewController?.displayCharacterDetails(viewModel: viewModel)
        }
    }
}
