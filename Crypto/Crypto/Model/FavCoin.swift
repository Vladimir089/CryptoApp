//
//  FavCoin.swift
//  Crypto
//
//  Created by Владимир on 24.11.2023.
//

import Foundation

struct CoinFav: Codable {
    let id: String
    let name: String
    var isFavorite: Bool
}
