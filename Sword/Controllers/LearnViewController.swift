//
//  LearnViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 2.08.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import Koloda
import GTProgressBar
import AVFoundation
import SwiftyPlistManager

class LearnViewController: CustomViewController {
    
    @IBOutlet var quizProgressBar: GTProgressBar!
    
    @IBOutlet var kolodaView: KolodaView! // Card stack view
    
    // Writing items.
    @IBOutlet var writingView: UIView!
    @IBOutlet var writingViewHeaderLabel: UILabel!
    @IBOutlet var writingAnswerTextField: UITextField!
    @IBOutlet var checkAnswerButton: UIButtonWithRoundedCorners!
    
    // Multiple selection items.
    @IBOutlet var multipleSelectionView: UIView!
    @IBOutlet var multipleSelectionViewHeaderLabel: UILabel!
    @IBOutlet var multipleSelectionFirstButton: UIButtonWithRoundedCornersAndBottomShadow!
    @IBOutlet var multipleSelectionSecondButton: UIButtonWithRoundedCornersAndBottomShadow!
    @IBOutlet var multipleSelectionThirdButton: UIButtonWithRoundedCornersAndBottomShadow!
    @IBOutlet var multipleSelectionFourthButton: UIButtonWithRoundedCornersAndBottomShadow!
    
    // Answer buttons array.
    private var answerButtons = [UIButtonWithRoundedCornersAndBottomShadow]()
    
    // Words to be learning.
    public var words: [Word]?
    
    // Question container word models.
    private var learnWords = [LearnWord]()
    
    // Total question number
    private var questionNumber: CGFloat = 25
    
    // Current progress
    private var progress: CGFloat = 0
    
    // Learn words order.
    private var learnWordOrder = [[String : String]]()
    
    // Current question index
    private var currentQuestionIndex: Int {
        get {
            return kolodaView.currentCardIndex
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup(multipleSelectionView, withAlpha: 1.0, andHiddenState: false)
        setup(writingView, withAlpha: 0.0, andHiddenState: true)
        
        answerButtons = [self.multipleSelectionFirstButton, self.multipleSelectionSecondButton, self.multipleSelectionThirdButton, self.multipleSelectionFourthButton]
        
        // Update question and view
        updateView()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupQuestions()
        
        // Get learn words order from plist file and set a variable.
        SwiftyPlistManager.shared.getValue(for: "LearnWords", fromPlistWithName: "LearnWordsOrder-Info") { (data, error) in
            if let err = error {
                print("Error: \(err.localizedDescription)")
            } else {
                if let d = data as? [[String : String]] {
                    learnWordOrder = d
                }
                
            }
        }
        
        // Koloda view delegate and datasource
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setup(_ view: UIView, withAlpha alpha: CGFloat, andHiddenState state: Bool) {
        view.alpha = alpha
        view.isHidden = state
    }
    
    private func setupQuestions() {
        // Setup Questions
        if let words = self.words {
            while learnWords.count < words.count {
                
                var learnWord = LearnWord()
                
                let questions = learnWord.setupQuestions(withWords: words)
                
                let multipleSelections = learnWord.setupMultipleSelections(withQuestions: questions, andWords: words)
                
                let writings = learnWord.setupWritings(withQuestions: questions)
                
                learnWord = LearnWord(multipleSelections: multipleSelections, writings: writings)
                
                learnWords.insert(learnWord, at: learnWords.count)
            }
        }
    }
    
    private func updateView() {
        
        switch learnWordOrder[currentQuestionIndex]["AnswerType"] {
        case "MultipleSelection":
            
            self.view.endEditing(true)
            
            turnDefaultButtonsAppearence()
            
            for (index, answerButton) in answerButtons.enumerated() {
                var answer = ""
                
                if learnWordOrder[currentQuestionIndex]["QuestionType"] == "Reading" {
                    if learnWordOrder[currentQuestionIndex]["LanguageType"] == "Foreign" {
                        answer = "Mother"
                    } else {
                        answer = "Foreign"
                    }
                } else {
                    if learnWordOrder[currentQuestionIndex]["LanguageType"] == "Foreign" {
                        answer = "Foreign"
                    } else {
                        answer = "Mother"
                    }
                }
                
                answerButton.setTitle("\(answer) - \(index + 1)", for: .normal)
            }
        case "Writing":
            turnDefaultTextFieldAppearence()
            changeAnswerType()
        default: print("Böyle bir seçenek yok!")
        }
        
    }
    
    private func turnDefaultButtonsAppearence() {
        for answerButton in answerButtons {
            turnDefaultButtonAppearence(button: answerButton)
        }
    }
    
    private func turnDefaultTextFieldAppearence() {
        writingAnswerTextField.text = ""
        writingAnswerTextField.textColor = UIColor.black
    }
    
    private func turnDefaultButtonAppearence(button: UIButtonWithRoundedCornersAndBottomShadow) {
        button.setTitleColor(UIColor.customColors.swordBlue, for: UIControlState.normal)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.white.cgColor
    }

    private func changeAnswerType() {
        
        if multipleSelectionView.isHidden {
            multipleSelectionView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.multipleSelectionView.alpha = 1.0
                self.writingView.alpha = 0.0
            }
            writingView.isHidden = true
        } else {
            writingView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.writingView.alpha = 1.0
                self.multipleSelectionView.alpha = 0.0
            }
            multipleSelectionView.isHidden = true
        }
    }
    
    @IBAction func answerButtonTouchUpInside(_ sender: UIButtonWithRoundedCornersAndBottomShadow) {
        
        print("Quiz question answered.")
        
        var answer = ""
        
        if learnWordOrder[currentQuestionIndex]["QuestionType"] == "Reading" {
            if learnWordOrder[currentQuestionIndex]["LanguageType"] == "Foreign" {
                answer = "Mother"
            } else {
                answer = "Foreign"
            }
        } else {
            if learnWordOrder[currentQuestionIndex]["LanguageType"] == "Foreign" {
                answer = "Foreign"
            } else {
                answer = "Mother"
            }
        }
        
        let isAnswerRight = "\(answer) - \(currentQuestionIndex)" == "\(sender.titleLabel?.text ?? "Empty")"
        
        if isAnswerRight {
            sender.setTitleColor(UIColor.white, for: UIControlState.normal)
            sender.backgroundColor = UIColor.customColors.green
            sender.layer.borderColor = UIColor.customColors.borderGreen.cgColor
            playSound(withName: "right")
            progress = quizProgressBar.progress + 1 / questionNumber
            quizProgressBar.animateTo(progress: progress)
        } else {
            sender.setTitleColor(UIColor.white, for: UIControlState.normal)
            sender.backgroundColor = UIColor.customColors.red
            sender.layer.borderColor = UIColor.customColors.borderRed.cgColor
            playSound(withName: "wrong")
        }
        
    }

    
    @IBAction func answerWritingButtonTouchUpInside(_ sender: UIButtonWithRoundedCorners) {
        
        print("Writing question answered.")
        
        var answer = ""
        
        if learnWordOrder[currentQuestionIndex]["QuestionType"] == "Reading" {
            if learnWordOrder[currentQuestionIndex]["LanguageType"] == "Foreign" {
                answer = "Mother"
            } else {
                answer = "Foreign"
            }
        } else {
            if learnWordOrder[currentQuestionIndex]["LanguageType"] == "Foreign" {
                answer = "Foreign"
            } else {
                answer = "Mother"
            }
        }
        
        let isAnswerRight =  "\(answer) - \(currentQuestionIndex % 5)" == writingAnswerTextField.text
        
        if isAnswerRight {
            writingAnswerTextField.textColor = UIColor.customColors.green
            playSound(withName: "right")
        } else {
            writingAnswerTextField.textColor = UIColor.customColors.red
            playSound(withName: "worng")
        }
        
    }
    
    @IBAction func thenContinueButtonTouchUpInside(sender: UIButton) {
        performSegue(withIdentifier: "pickUpWordsViewSegue", sender: self)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("AUDIO PLAYER DID FINISH PLAYING.")
        kolodaView.swipe(.left)
        updateView()
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
        print("KARTLAR BİTTİ")
        
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("\(index) INDEXED CARD SELECTED")
        
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print("\(index) INDEX CARD SWIPED")
    
    }
    
}

// MARK: - KolodaViewDataSource -

extension LearnViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return learnWordOrder.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return setCard(index)
    }
    
    func setCard(_ index: Int) -> UILabel {
        let labelBGColor = UIColor(displayP3Red: (213.0 + CGFloat(index))/255.0, green: (234.0 + CGFloat(index))/255.0, blue: (245.0 + CGFloat(index))/255.0, alpha: 1.0)
        let label = UILabel()
        label.numberOfLines = 0
        
        switch learnWordOrder[index]["QuestionType"] {
        case "Listening": label.addImage(imageName: "Sound", afterLabel: true)
        case "Reading":
            switch learnWordOrder[index]["LanguageType"] {
            case "Foreign": label.text = "Foreing - \(index % 5)"
            case "Mother": label.text = "Mother - \(index % 5)"
            default: break
            }
        default: break
        }
        
        label.backgroundColor = labelBGColor
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 24.0)
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

extension UIColor {
    struct customColors {
        static let green = UIColor(red: 57/255, green: 202/255, blue: 116/255, alpha: 1.0)
        static let red = UIColor(red: 229/255, green: 77/255, blue: 66/255, alpha: 1.0)
        static let borderGreen = UIColor(red: 54/255, green: 184/255, blue: 132/255, alpha: 1.0)
        static let borderRed = UIColor(red: 205/255, green: 83/255, blue: 79/255, alpha: 1.0)
        static let swordBlue = UIColor(red: 58/255, green: 153/255, blue: 216/255, alpha: 1.0)
    }
}
