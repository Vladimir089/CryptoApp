//
//  GetCoins.swift
//  Crypto
//
//  Created by Владимир on 16.11.2023.
//

import Foundation

// MARK: - Predstavleny
struct Coin: Codable {
    let id, symbol, name: String
}

typealias AllCoins = [Coin]
