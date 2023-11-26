//
//  FavoriteViewController.swift
//  Crypto
//
//  Created by Владимир on 25.11.2023.
//

import UIKit

class FavoriteViewController: UIViewController {
    var favoriteCoins: [CoinFav] = []
    var favCoinArray = [[String]]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStateChanged), name: NSNotification.Name(rawValue: "FavoriteStateChanged"), object: nil)
        loadCoin()
        
        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    @objc func handleFavoriteStateChanged() {
        favCoinArray.removeAll()
        loadCoin()
        collectionView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadCoin() {
        if let savedCoinsData = UserDefaults.standard.data(forKey: "favoriteCoins"),
           let savedCoins = try? JSONDecoder().decode([CoinFav].self, from: savedCoinsData) {
            favoriteCoins = savedCoins
        }

        // Вывод сохраненных монет на консоль
        for coin in favoriteCoins {
            print("Coin ID: \(coin.name), Is Favorite: \(coin.isFavorite)")
            favCoinArray.append([coin.name, coin.id])
            DispatchQueue.main.async { [self] in
                collectionView.reloadData()
            }
        }
    }
    
    

    

}


extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favCoinArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ID", for: indexPath)
        cell.backgroundColor = UIColor(red: 52/255.0, green: 168/255.0, blue: 83/255.0, alpha: 1.0)
        cell.layer.cornerRadius = 12
        let gesture = UITapGestureRecognizer(target: self, action: #selector(nextScreen(_:)))
        
        
        if let label = cell.viewWithTag(100) as? UILabel {
            label.text = favCoinArray[indexPath.row][0]
        } else {
            let label = UILabel()
            label.tag = 100
            label.text = favCoinArray[indexPath.row][0]
            label.frame = CGRect(x: 30, y: 10, width: 300, height: 50)
            label.contentMode = .center
            label.textColor = .white
            label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
            cell.addSubview(label)
            label.isUserInteractionEnabled = true
            cell.isUserInteractionEnabled = true
            

            let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrowImageView.tintColor = .white
            arrowImageView.frame = CGRect(x: cell.bounds.width - 30, y: 25, width: 20, height: 20)
            
            
            
            
            arrowImageView.isUserInteractionEnabled = true
            label.isUserInteractionEnabled = true
            cell.isUserInteractionEnabled = true
            
            arrowImageView.addGestureRecognizer(gesture)
            label.addGestureRecognizer(gesture)
            
            
            cell.addSubview(arrowImageView)
        }
        cell.addGestureRecognizer(gesture)
        
        return cell
    }
    
    
    @objc func nextScreen(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view as? UICollectionViewCell,
           let indexPath = collectionView.indexPath(for: cell) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VC") as! SecondViewController
            vc.ID.append(favCoinArray[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 70)
    }
    
    
}
