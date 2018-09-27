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
    private var questionOrders = [QuestionOrder]()
    
    // Questions
    private var questions = [AnyObject]()
    
    private var isKolodaSwipeEnable = false
    
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
        
        setupLearnWords()
        
        getLearnWordsOrderFromPlistFile()
        
        setupQuestions()
        
        // Koloda view delegate and datasource
        kolodaView.delegate = self
        kolodaView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getLearnWordsOrderFromPlistFile() {
        // Get learn words order from plist file and set a variable.
        SwiftyPlistManager.shared.getValue(for: "LearnWords", fromPlistWithName: "LearnWordsOrder-Info") { (data, error) in
            if let err = error {
                print("Error: \(err.localizedDescription)")
            } else {
                if let orders = data as? [[String : String]] {
                    for questionOrder in orders {
                        let tempQuestionOrder = QuestionOrder()
                        
                        tempQuestionOrder.setupQuestionOrder(withDictionary: questionOrder)
                        
                        questionOrders.append(tempQuestionOrder)
                    }
                }
                
            }
        }
    }
    
    private func setup(_ view: UIView, withAlpha alpha: CGFloat, andHiddenState state: Bool) {
        view.alpha = alpha
        view.isHidden = state
    }
    
    private func setupLearnWords() {
        // Setup learn words
        for (index, word) in words!.enumerated() {
            var learnWord = LearnWord()
            
            let questions = learnWord.setupQuestions(withWords: word)
            
            let multipleSelections = learnWord.setupMultipleSelections(withQuestions: questions, andWords: words!)
            
            let writings = learnWord.setupWritings(withQuestions: questions)
            
            learnWord = LearnWord(multipleSelections: multipleSelections, writings: writings)
            
            learnWords.insert(learnWord, at: index)
        }
    }
    
    private func setupQuestions() {
        for (index, order) in questionOrders.enumerated() {
            questions.append(learnWords[index % 5].getQuestion(withAnswerType: order.getAnswerType(), withLanguageType: order.getLanguageType(), andQuestionType: order.getQuestionType()))
        }
    }
    
    private func updateView() {
        
        if currentQuestionIndex < Int(questionNumber) {
        
            let currentQuestionOrder = questionOrders[currentQuestionIndex]
        
            switch currentQuestionOrder.getAnswerType() {
            case .multipleSelection:
                
                self.view.endEditing(true)
                
                turnDefaultButtonsAppearence()
                
                for (index, answerButton) in answerButtons.enumerated() {
                    if let currentQuestion = questions[currentQuestionIndex] as? MultipleSelection {
                        answerButton.setTitle("\(currentQuestion.getAnswers()[index].getText(withType: currentQuestionOrder.getQuestionType()))", for: .normal)
                    }
                }
                
                changeButtonsUserInteractionStatus()
                
            case .writing:
                
                turnDefaultTextFieldAppearence()
                
                checkAnswerButton.isUserInteractionEnabled = true
            }
        
        }
        
        changeAnswerType()
        
    }
    
    private func turnDefaultButtonsAppearence() {
        for answerButton in answerButtons {
            turnDefaultButtonAppearence(button: answerButton)
        }
    }
    
    private func change(button: UIButtonWithRoundedCornersAndBottomShadow, withBackgroundColor backgroundColor: UIColor, andBorderColor borderColor: CGColor) {
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.backgroundColor = backgroundColor
        button.layer.borderColor = borderColor
    }
    
    private func changeButtonsUserInteractionStatus() {
        for answerButton in answerButtons {
            answerButton.isUserInteractionEnabled = !answerButton.isUserInteractionEnabled
        }
    }
    
    private func turnDefaultTextFieldAppearence() {
        writingAnswerTextField.text = ""
        writingAnswerTextField.textColor = UIColor.black
    }
    
    private func turnDefaultButtonAppearence(button: UIButtonWithRoundedCornersAndBottomShadow) {
        button.setTitleColor(UIColor.customColors.swordBlue, for: UIControl.State.normal)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.white.cgColor
    }

    private func changeAnswerType() {
        if currentQuestionIndex < Int(questionNumber) {
            switch questionOrders[currentQuestionIndex].getAnswerType() {
            case .multipleSelection:
                multipleSelectionView.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.multipleSelectionView.alpha = 1.0
                    self.writingView.alpha = 0.0
                }
                writingView.isHidden = true
            case .writing:
                writingView.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.writingView.alpha = 1.0
                    self.multipleSelectionView.alpha = 0.0
                }
                multipleSelectionView.isHidden = true
            }
        }
    }
    
    private func updateProgressbar() {
        progress = quizProgressBar.progress + 1 / questionNumber
        quizProgressBar.animateTo(progress: progress)
    }
    
    @IBAction func answerButtonTouchUpInside(_ sender: UIButtonWithRoundedCornersAndBottomShadow) {
        
        print("Quiz question answered.")
        
        changeButtonsUserInteractionStatus()
        
        if let multipleSelectionQuestion = questions[currentQuestionIndex] as? MultipleSelection {
            let isAnswerRight = multipleSelectionQuestion.answerTheQuestion(answerIndex: sender.tag - 1)
            
            if isAnswerRight {
                
                // Change button appearance.
                change(button: sender, withBackgroundColor: UIColor.customColors.green, andBorderColor: UIColor.customColors.borderGreen.cgColor)
                
                // Play sound "right".
                playSound(withName: "right")
                
                // Update progress bar.
                progress = quizProgressBar.progress + 1 / questionNumber
                quizProgressBar.animateTo(progress: progress)
            } else {
                change(button: sender, withBackgroundColor: UIColor.customColors.red, andBorderColor: UIColor.customColors.borderRed.cgColor)
                playSound(withName: "wrong")
            }
        }
        
    }

    
    @IBAction func answerWritingButtonTouchUpInside(_ sender: UIButtonWithRoundedCorners) {
        
        print("Writing question answered.")
        
        sender.isUserInteractionEnabled = false
        
        if let currentQuestion = questions[currentQuestionIndex] as? Writing {
            
            let isAnswerRight = currentQuestion.answerTheQuestion(withText: writingAnswerTextField.text ?? "")
            
            if isAnswerRight {
                writingAnswerTextField.textColor = UIColor.customColors.green
                playSound(withName: "right")
                progress = quizProgressBar.progress + 1 / questionNumber
                quizProgressBar.animateTo(progress: progress)
            } else {
                writingAnswerTextField.textColor = UIColor.customColors.red
                playSound(withName: "wrong")
            }
        }
    }
    
    @IBAction func thenContinueButtonTouchUpInside(sender: UIButton) {
        
        
        
        performSegue(withIdentifier: "unwindSegueToHead", sender: self)
    }

    private func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("AUDIO PLAYER DID FINISH PLAYING.")
        isKolodaSwipeEnable = true
        kolodaView.swipe(.left)
        updateView()
    }
    
    private func textToSpeech(withQuestion question: Question) {
        var language = ""
        
        switch question.getLanguage() {
        case .foreign: language = "en-UK"
        case .mother: language = "tr-TR"
        }
        
        let utterance = AVSpeechUtterance(string: question.getText())
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    private func getCurrentQuestionText() -> String {
        if let multipleSelectionQuestion = questions[currentQuestionIndex] as? MultipleSelection {
            return multipleSelectionQuestion.getQuestion().getText()
        } else if let writingQuestion = questions[currentQuestionIndex] as? Writing {
            return writingQuestion.getQuestion().getText()
        } else {
            return ""
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
        print("KARTLAR BİTTİ")
        
        performSegue(withIdentifier: "learnResultSegue", sender: self)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("\(index) INDEXED CARD SELECTED")
        
        if let multipleSelectionQuestion = questions[index] as? MultipleSelection {
            textToSpeech(withQuestion: multipleSelectionQuestion.getQuestion())
        }

        if let writingQuestion = questions[index] as? Writing {
            textToSpeech(withQuestion: writingQuestion.getQuestion())
        }
        
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print("\(index) INDEX CARD SWIPED")
        isKolodaSwipeEnable = false
    }
    
}

// MARK: - KolodaViewDataSource -

extension LearnViewController: KolodaViewDataSource {

//    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
//        return false
//    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        return isKolodaSwipeEnable
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return questionOrders.count
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
        
        
        
        switch questionOrders[index].getQuestionType() {
        case .reading:
            if let currentQuestion = questions[index] as? MultipleSelection {
                label.text = currentQuestion.getQuestion().getText()
            }

            if let currentQuestion = questions[index] as? Writing {
                label.text = currentQuestion.getQuestion().getText()
            }
            //label.text = getCurrentQuestionText()
        case .listening:
            label.addImage(imageName: "Sound", afterLabel: true)
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
