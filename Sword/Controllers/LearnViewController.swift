//
//  LearnViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import Koloda
import Firebase



class LearnViewController: UIViewController {
    

    
    // MARK: - Preferences -
    @IBOutlet var messageLabel: UILabel! // Info message about word choice
    @IBOutlet var kolodaView: KolodaView! // Card stack view
    @IBOutlet weak var learnContainerView: UIView! // When user chose words this view appears
    @IBOutlet weak var titleMessageLabel: UILabel! // Info message about learn screen
    @IBOutlet weak var wordProgressView: UIProgressView! // Progress bar about word learning
    @IBOutlet weak var wordCounterLabel: UILabel! // Which word you are in
    @IBOutlet weak var selectWordContainerView: UIView! // If user wasn't select words this view appears
    
    var db: Firestore!
    
    // Learn cards data source
    fileprivate var dataSource: [String] = {
        var array: [String] = ["Home", "Window", "Door", "Shoe", "Glasses", "Desk", "Chair", "Bed", "Computer", "Call"]
        //        for index in 0..<numberOfCards {
        //            array.append(UIImage(named: "Card_like_\(index + 1)")!)
        //        }
        
        return array
    }()
    
    // Current card index
    var currentCardIndex = 0
    
    
    private var numberOfCards: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        updateView()
        
        getCardData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions -
    
    @IBAction func selectWordsTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "LanguageLevelSegue", sender: self)
    }
    
    @IBAction func learnButtonTapped(_ sender: UIButtonWithRoundedCorners) {
        print("LEARNBUTTONTAPPED")
        kolodaView.swipe(.left)
    }
    
    @IBAction func knowButtonTapped(_ sender: UIButtonWithRoundedCorners) {
        print("KNOWBUTTONTAPPED")
        kolodaView.swipe(.right)
    }

    @IBAction func goToPreviousWordButtonTapped(_ sender: UIButton) {
        kolodaView.revertAction()
        if currentCardIndex > 0 {
            currentCardIndex = currentCardIndex - 1
        }
        updateView()
    }
    
    // MARK: - Fire Base -
    
    private func getCardData() {
        db.collection("User").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - KolodaViewDelegate -

extension LearnViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        let position = kolodaView.currentCardIndex
//        for i in 1...4 {
//            dataSource.append(UIImage(named: "Card_like_\(i)")!)
//
//        }
//        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
        print("KARTLAR BİTTİ")
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("\(index) INDEXED CARD SELECTED")
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print("\(index) INDEX CARD SWIPED")
        if currentCardIndex < dataSource.count {
            currentCardIndex = currentCardIndex + 1
        }
        updateView()
    }
    
    func updateView() {
        wordCounterLabel.text = "\(currentCardIndex)/\(dataSource.count)"
        wordProgressView.progress = (Float(currentCardIndex))/10.0
    }
    
}

// MARK: - KolodaViewDataSource -

extension LearnViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        //return UIImageView(image: dataSource[Int(index)])
        
        
        return setCard(index)
    }
    
    func setCard(_ index: Int) -> UILabel {
        let labelBGColor = UIColor(displayP3Red: (213.0 + CGFloat(index))/255.0, green: (234.0 + CGFloat(index))/255.0, blue: (245.0 + CGFloat(index))/255.0, alpha: 1.0)
        let label = UILabel()
        label.numberOfLines = 0
        label.text = dataSource[index]
        label.backgroundColor = labelBGColor
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.layer.borderWidth = 2
        label.layer.borderColor = labelBGColor.cgColor
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
}
