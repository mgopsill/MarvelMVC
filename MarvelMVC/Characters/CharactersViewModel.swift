//
//  CharactersViewModel.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 01/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import Foundation

protocol CharactersViewModelProtocol {
    var characters: [MarvelCharacter]? { get }
    func fetchCharacters(then completion: @escaping (CharactersTableViewState) -> Void)
}

class CharactersViewModel: CharactersViewModelProtocol {
    
    var characters: [MarvelCharacter]?
    
    private let characterService: CharacterService
    
    init(characterService: CharacterService) {
        self.characterService = characterService
    }
    
    func fetchCharacters(then completion: @escaping (CharactersTableViewState) -> Void) {
        characterService.fetchCharacters { result in
            switch result {
            case .success(let characters):
                self.characters = characters.data.characters
                completion(.loaded)
            case .failure(let error):
                completion(.failed)
                print(error)
            }
        }
    }
}
