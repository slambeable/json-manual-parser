//
//  ViewController.swift
//  JSONManualParser
//
//  Created by Андрей Евдокимов on 27.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var leftCardImageView: UIImageView!
    @IBOutlet var rightCardImageView: UIImageView!
    
    @IBOutlet var loadingActivityIndicator: UIActivityIndicatorView!
    
    private var deckId = ""
    private var cards: [Card] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingActivityIndicator.hidesWhenStopped = true
        loadingActivityIndicator.startAnimating()
        
        DispatchQueue.global().async {
            self.fetchDeck()
        }
    }

    private func fetchDeck() {
        NetworkManager.shared.fetchData(
            from: getUrls(from: .createDeck)) { result in
                switch result {
                case .success(let data):
                    let deck = Deck(
                        success: data["success"] as? Bool ?? false,
                        deckId: data["deck_id"] as? String ?? "",
                        shuffled: data["shuffled"] as? Bool ?? false,
                        cards: data["cards"] as? [[String: Any]],
                        remaining: data["remaining"] as? Int ?? 0
                    )
                    
                    self.deckId = deck.deckId

                    self.fetchCards()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func fetchCards() {
        NetworkManager.shared.fetchData(
            from: getUrls(from: .getCards)) { result in
                switch result {
                case .success(let data):
                    let deck = Deck(
                        success: data["success"] as? Bool ?? false,
                        deckId: data["deck_id"] as? String ?? "",
                        shuffled: data["shuffled"] as? Bool ?? false,
                        cards: data["cards"] as? [[String: Any]],
                        remaining: data["remaining"] as? Int ?? 0
                    )
                    
                    guard let cards = deck.cards else { return }
                    
                    for card in cards {
                        self.cards.append(Card(
                            image: card["image"] as? String ?? "",
                            value: card["value"] as? String ?? "",
                            suit: card["suit"] as? String ?? "",
                            code: card["code"] as? String ?? "")
                        )
                    }
                    
                    self.drawImage()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func drawImage() {
        guard let leftImage = self.cards.first?.image else { return }
        guard let rightImage = self.cards.last?.image else { return }
        
        guard let leftImageURL = URL(string: leftImage) else { return }
        guard let rightImageURL = URL(string: rightImage) else { return }
        
        guard let leftImageData = try? Data(contentsOf: leftImageURL) else { return }
        guard let rightImageData = try? Data(contentsOf: rightImageURL) else { return }
        
        DispatchQueue.main.async { [self] in
            leftCardImageView.image = UIImage(data: leftImageData)
            rightCardImageView.image = UIImage(data: rightImageData)
            
            loadingActivityIndicator.stopAnimating()
        }
    }
    
    private func getUrls(from key: URLKeys) -> String {
        switch key {
        case .createDeck:
            return "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1"
        case .getCards:
            return "https://deckofcardsapi.com/api/deck/\(deckId)/draw/?count=2"
        }
    }
}

extension ViewController {
    enum URLKeys {
        case createDeck
        case getCards
    }
}
