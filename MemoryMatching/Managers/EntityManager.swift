//
//  EntityManager.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import Foundation


final class EntityManager {
    static let instance = EntityManager()

    private(set) var entities = [Card]()


    // Use singleton
    private init() { }


    // MARK: API

    /// Makes a network request to grab all products from Shopify store
    func initialize(completion: @escaping () -> Void) {
        APIService.instance.get { [weak self] (result: Result<Card.Container, APIService.APIError>) in
            switch result {
            case let .success(cardContainer):
                self?.entities = cardContainer.products
                completion()
            case .failure(_):
                completion()
            }
        }
    }


    // MARK: Helpers








}
