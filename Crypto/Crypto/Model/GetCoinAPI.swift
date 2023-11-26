import Foundation



struct Coins: Codable {
    let id: String
    let symbol: String
    let name: String
    let image: Image
    let marketData: MarketData

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case marketData = "market_data"
    }
}

struct Image: Codable {
    let small, large, thumb: String
}

struct MarketData: Codable {
    let currentPrice: [String: Double]
    let marketCap: [String: Double]
    let totalVolume: [String: Double]
    // Add other properties as needed

    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case totalVolume = "total_volume"

    }
}






