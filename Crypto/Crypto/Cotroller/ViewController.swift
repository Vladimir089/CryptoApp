//
//  ViewController.swift
//  Crypto
//
//  Created by Владимир on 16.11.2023.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Outlets
    var originalNameIdArray = [[String]]()
    var nameIdArray = [[String]]()
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCoins()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchTextField.delegate = self
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderWidth = 2
        searchTextField.layer.borderColor = CGColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        
        
    }


    //MARK: -Func
    func getCoins() {
            guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/list") else { return }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { [self] data , response , error in
                if let data = data, let coin = try? JSONDecoder().decode(AllCoins.self, from: data) {
                    for i in coin {
                        originalNameIdArray.append([i.name, i.id])
                    }
                    nameIdArray = originalNameIdArray
                    DispatchQueue.main.sync { [self] in
                        collectionView.reloadData()
                    }
                }
            }
            task.resume()
        }
}

    //MARK: -Extensions

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameIdArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "IDUnic", for: indexPath)

        cell.layer.cornerRadius = 12
        if let label = cell.viewWithTag(100) as? UILabel {
            label.text = nameIdArray[indexPath.row][0]
        } else {
            let label = UILabel()
            label.tag = 100
            label.text = nameIdArray[indexPath.row][0]
            label.frame = CGRect(x: 30, y: 10, width: 300, height: 50)
            label.contentMode = .center
            label.textColor = .white
            label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
            cell.addSubview(label)

            let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrowImageView.tintColor = .white
            arrowImageView.frame = CGRect(x: cell.bounds.width - 30, y: 25, width: 20, height: 20)

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(arrowTapped(_:)))
            arrowImageView.isUserInteractionEnabled = true
            tapGestureRecognizer.view?.isUserInteractionEnabled = true
            arrowImageView.addGestureRecognizer(tapGestureRecognizer)
            cell.isUserInteractionEnabled = true
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapGestureRecognizer)
            cell.addGestureRecognizer(tapGestureRecognizer)

            cell.addSubview(arrowImageView)
        }
        cell.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        return cell
    }

    @objc func arrowTapped(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view as? UICollectionViewCell,
           let indexPath = collectionView.indexPath(for: cell) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VC") as! SecondViewController
            vc.ID.append(nameIdArray[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 70)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            textField.resignFirstResponder()
            return true
        }

        nameIdArray = originalNameIdArray.filter { $0[0].lowercased().contains(searchText.lowercased()) }
        updateCollectionView(with: nameIdArray)

        textField.resignFirstResponder()
        textField.text = ""
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            nameIdArray = originalNameIdArray
            updateCollectionView(with: nameIdArray)
            return
        }

        nameIdArray = originalNameIdArray.filter { $0[0].lowercased().contains(searchText.lowercased()) }
        updateCollectionView(with: nameIdArray)
    }

    func updateCollectionView(with filteredCoins: [[String]]) {
        collectionView.reloadData()
    }
}
