//
//  SecondViewController.swift
//  Crypto
//
//  Created by Владимир on 17.11.2023.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameNavigation: UINavigationItem!
    var ID = [[String]]()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var selectIndex = 0
    var currentPriceArray: [String: Double] = [:]
    var marketCapArray: [String: Double] = [:]
    var totalVolumeArray: [String: Double] = [:]
    var favoriteCoins: Set<String> = []
    var coins: [CoinFav] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameNavigation.title = ID[0][0]
        imageView.layer.borderColor = UIColor.clear.cgColor
        segmentedControl.selectedSegmentIndex = 0
        imageView.layer.cornerRadius = 100
        collectionView.dataSource = self
        collectionView.delegate = self
        imageView.layer.borderWidth = 5.0
        getCoin()
        loadFav()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func loadFav() {
        if let savedCoinsData = UserDefaults.standard.data(forKey: "favoriteCoins"),
        let savedCoins = try? JSONDecoder().decode([CoinFav].self, from: savedCoinsData) {
            coins = savedCoins
        }
        let coinID = ID[0][1]
        if coins.firstIndex(where: { $0.id == coinID }) != nil {
            animateBorder(color: UIColor.systemGreen)
        } 
    }
    
    func saveFavoriteCoins() {
            if let coinsData = try? JSONEncoder().encode(coins) {
                UserDefaults.standard.set(coinsData, forKey: "favoriteCoins")
                UserDefaults.standard.synchronize()
            }
        }
    func addToFavorites(coinID: String) {
        if !coins.contains(where: { $0.id == coinID }) {
            let name = ID[0][0]
            let newCoin = CoinFav(id: coinID, name: name, isFavorite: true)
            coins.append(newCoin)
            saveFavoriteCoins()
        }
    }
    
    
    func removeFromFavorites(coinID: String) {
            if let index = coins.firstIndex(where: { $0.id == coinID }) {
                coins.remove(at: index)
                saveFavoriteCoins()
            }
        }
    
    @objc func imageTapped() {
            let coinID = ID[0][1]

            if let coinIndex = coins.firstIndex(where: { $0.id == coinID }) {
                removeFromFavorites(coinID: coinID)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FavoriteStateChanged"), object: nil)
                animateBorder(color: UIColor.clear)
            } else {
                addToFavorites(coinID: coinID)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FavoriteStateChanged"), object: nil)
                animateBorder(color: UIColor.systemGreen)
            }
        }

    func animateBorder(color: UIColor) {
            // Анимация изменения цвета обводки
            let animation = CABasicAnimation(keyPath: "borderColor")
            animation.fromValue = imageView.layer.borderColor
            animation.toValue = color.cgColor
            animation.duration = 0.5
            imageView.layer.borderColor = color.cgColor
            imageView.layer.add(animation, forKey: "borderColor")
        }
    
    
    @IBAction func selectFunc(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print(0)
            selectIndex = 0
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case 1:
            print(1)
            selectIndex = 1
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case 2:
            print(2)
            selectIndex = 2
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        default:
            print(000)
        }
    }
    
    
    
    
    
    func getCoin() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(ID[0][1])") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if let data = data, let coin = try? JSONDecoder().decode(Coins.self, from: data) {
                currentPriceArray = coin.marketData.currentPrice
                marketCapArray = coin.marketData.marketCap
                totalVolumeArray = coin.marketData.totalVolume
                getImage(image: coin.image.large)
                print(coin.marketData.marketCap)
                print(marketCapArray.count)
                print(currentPriceArray.count)
                print(totalVolumeArray.count)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func getImage(image: String) {
        guard let url = URL(string: image) else { return }
        let request = URLRequest(url: url)
        if let data = try? Data(contentsOf: url) {
            DispatchQueue.main.async { [self] in
                imageView.image = UIImage(data: data)
                self.imageView.reloadInputViews()
            }
        }
    }
  

}


extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return currentPriceArray.count
            
        case 1:
            return marketCapArray.count
        case 2:
            return totalVolumeArray.count
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ID", for: indexPath)
        cell.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        cell.layer.cornerRadius = 12
        
        if let label = cell.viewWithTag(100) as? UILabel {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                let key = [String](currentPriceArray.keys)
                let values = [Double](currentPriceArray.values)
                label.text = "\(key[indexPath.row]) \(values[indexPath.row])"
            case 1:
                let key = [String](marketCapArray.keys)
                let values = [Double](marketCapArray.values)
                label.text = "\(key[indexPath.row]) \(values[indexPath.row])"
            case 2:
                let key = [String](totalVolumeArray.keys)
                let values = [Double](totalVolumeArray.values)
                label.text = "\(key[indexPath.row]) \(values[indexPath.row])"
            default:
                label.text = "-"
            }
        } else {
            let label = UILabel()
            label.tag = 100
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                let key = [String](currentPriceArray.keys)
                let values = [Double](currentPriceArray.values)
                label.text = "\(key[indexPath.row]) \(values[indexPath.row])"
            case 1:
                let key = [String](marketCapArray.keys)
                let values = [Double](marketCapArray.values)
                label.text = "\(key[indexPath.row]) \(values[indexPath.row])"
            case 2:
                let key = [String](totalVolumeArray.keys)
                let values = [Double](totalVolumeArray.values)
                label.text = "\(key[indexPath.row]) \(values[indexPath.row])"
            default:
                label.text = "-"
            }
            label.frame = CGRect(x: 30, y: 10, width: 300, height: 50)
            label.contentMode = .center
            label.textColor = .white
            label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
            cell.addSubview(label)

           
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 370, height: 70)
    }
    
    
}
