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

class LearnViewController: CustomViewController, UITextFieldDelegate {
    
    @IBOutlet var quizProgressBar: GTProgressBar!
    
    @IBOutlet var kolodaView: KolodaView! // Card stack view
    
    // Writing items.
    @IBOutlet var writingView: UIView!
    @IBOutlet var writingViewHeaderLabel: UILabel!
    @IBOutlet var writingAnswerTextField: WritingTextField!
    @IBOutlet var checkAnswerButton: CustomButton!
    @IBOutlet var correctAnswerLabel: UILabel!
    
    // Multiple selection items.
    @IBOutlet var multipleSelectionView: UIView!
    @IBOutlet var multipleSelectionViewHeaderLabel: UILabel!
    @IBOutlet var multipleSelectionFirstButton: MultipleSelectionButton!
    @IBOutlet var multipleSelectionSecondButton: MultipleSelectionButton!
    @IBOutlet var multipleSelectionThirdButton: MultipleSelectionButton!
    @IBOutlet var multipleSelectionFourthButton: MultipleSelectionButton!
    
    // Continue later button
    @IBOutlet var continueLaterButton: UIButton!
    
    // Answer buttons array.
    private var answerButtons = [MultipleSelectionButton]()
    
    // Words to be learning.
    public var words: [Word]?
    
    // Question container word models.
    private var learnWords = [LearnWord]()
    
    // Total question number
    private var questionNumber: CGFloat {
        get {
            return CGFloat(questionOrders.count)
        }
    }
    
    // Current progress
    private var progress: CGFloat {
        set{
            quizProgressBar.progress = quizProgressBar.progress + newValue / 25
            quizProgressBar.update()
        }
        get {
            return quizProgressBar.progress
        }
    }
    
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
    
    public var voiceQuestionState: Bool?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        answerButtons = [
            self.multipleSelectionFirstButton,
            self.multipleSelectionSecondButton,
            self.multipleSelectionThirdButton,
            self.multipleSelectionFourthButton
        ]
        
        // Update question and view
        updateView()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupLearnWords()
        
        getLearnWordsOrderFromPlistFile()
        
        checkVoiceQuestionState()
        
        setupQuestions()
        
        // If user can't answer voice question turn listening questions to reading type question
        checkVoiceQuestionState()
        
        // Koloda view delegate and datasource
        kolodaView.delegate = self
        kolodaView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        
//        let answersRect = CGRect(
//            x: 16,
//            y: kolodaView.frame.origin.y + kolodaView.frame.size.height + 8,
//            width: width - 32,
//            height: continueLaterButton.frame.origin.y - kolodaView.frame.origin.y - kolodaView.frame.size.height - 16
//        )
        
//        multipleSelectionView = setupView(
//            withAlpha: 1.0,
//            andHiddenState: false,
//            andRect: answersRect
//        )
        multipleSelectionView.frame = CGRect(
            x: 16,
            y: kolodaView.frame.origin.y + kolodaView.frame.size.height - 8,
            width: width - 32,
            height: continueLaterButton.frame.origin.y - kolodaView.frame.origin.y - kolodaView.frame.size.height - 16
        )
        
//        writingView = setupView(
//            withAlpha: 0.0,
//            andHiddenState: true,
//            andRect: answersRect
//        )
        writingView.frame = CGRect(
            x: 16,
            y: kolodaView.frame.origin.y + kolodaView.frame.size.height + 8,
            width: width - 32,
            height: continueLaterButton.frame.origin.y - kolodaView.frame.origin.y - kolodaView.frame.size.height - 16
        )
        
        self.view.addSubview(multipleSelectionView)
        self.view.addSubview(writingView)
        
        writingAnswerTextField.delegate = self
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
    
//    private func setupView(
//        withAlpha alpha: CGFloat,
//        andHiddenState state: Bool,
//        andRect rect: CGRect
//        ) -> UIView {
//
//        let view = UIView()
//        view.alpha = alpha
//        view.isHidden = state
//        view.frame = rect
//
//        return view
//    }
    
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
    
    private func checkVoiceQuestionState() {
        if voiceQuestionState == false {
            for questionOrder in questionOrders {
                if questionOrder.getQuestionType() == .listening {
                    questionOrder.setQuestionType(questionType: .reading)
                }
            }
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
                
                resetWritingAppearance()
                
                checkAnswerButton.isUserInteractionEnabled = true
            }
        
        }
        
        changeAnswerType()
        
    }
    
    private func resetWritingAppearance() {
        writingAnswerTextField.text = ""
        writingAnswerTextField.textColor = UIColor.black
        
        correctAnswerLabel.text = ""
    }
    
    private func turnDefaultButtonsAppearence() {
        for answerButton in answerButtons {
            turnDefaultButtonAppearence(button: answerButton)
        }
    }
    
    private func change(button: MultipleSelectionButton, withBackgroundColor backgroundColor: UIColor, andBorderColor borderColor: CGColor) {
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.backgroundColor = backgroundColor
        button.layer.borderColor = borderColor
    }
    
    private func changeButtonsUserInteractionStatus() {
        for answerButton in answerButtons {
            answerButton.isUserInteractionEnabled = !answerButton.isUserInteractionEnabled
        }
    }
    
    private func turnDefaultButtonAppearence(button: MultipleSelectionButton) {
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
    
    private func playSound(withAnswerState state: Bool) {
        if state {
            playSound(withName: "right")
        } else {
            playSound(withName: "wrong")
        }
    }
    
    @IBAction func answerButtonTouchUpInside(_ sender: MultipleSelectionButton) {
        
        print("Quiz question answered.")
        
        changeButtonsUserInteractionStatus()
        
        if let currentQuestion = questions[currentQuestionIndex] as? MultipleSelection {
            let isAnswerRight = currentQuestion.answerTheQuestion(answerIndex: sender.tag - 1)
            
            // Change button appearance with "right" or "wrong" style.
            sender.changeAppearance(withAnswerState: isAnswerRight)
            
            // Play "right" or "wrong" sound.
            playSound(withAnswerState: isAnswerRight)
            
            if isAnswerRight {
                // Update progress bar with new value.
                increaseProgress(withIncreaseValue: 1)
            } else {
                // Show right answer.
                showRightAnswer(withQuestion: currentQuestion)
                
                // Check wrong answered times of the question
                if !currentQuestion.isAnswered() {
                    
                    questionOrders.append(questionOrders[currentQuestionIndex])
                    
                    questions.append(currentQuestion)
                    
                } else {
                    increaseProgress(withIncreaseValue: 1)
                }
            }
        }
    }
    
    private func showRightAnswer(withQuestion question: MultipleSelection) {
        answerButtons[question.getRightAnswerIndex()].changeAppearance(withAnswerState: true)
    }
    
    private func increaseProgress(withIncreaseValue value: CGFloat) {
        progress = value
    }
    
    @IBAction func answerWritingButtonTouchUpInside(_ sender: CustomButton) {
        
        print("Writing question answered.")
        
        sender.isUserInteractionEnabled = false
        
        checkWritingAnswer()
    }
    
    private func checkWritingAnswer() {
        if let currentQuestion = questions[currentQuestionIndex] as? Writing {
            
            let isAnswerRight = currentQuestion.answerTheQuestion(withText: writingAnswerTextField.text ?? "")
            
            // Change text field appearance with "right" or "wrong" style.
            writingAnswerTextField.changeAppearance(withAnswerState: isAnswerRight)
            
            // Play "right" or "wrong" sound.
            playSound(withAnswerState: isAnswerRight)
            
            if isAnswerRight {
                increaseProgress(withIncreaseValue: 1)
            } else {
                
                // Check wrong answered times of the question
                if !currentQuestion.isAnswered() {
                    
                    correctAnswerLabel.text = currentQuestion.getQuestion().getRightAnswer()
                    
                    questionOrders.append(questionOrders[currentQuestionIndex])
                    
                    questions.append(currentQuestion)
                    
                } else {
                    increaseProgress(withIncreaseValue: 1)
                }
            }
        }
    }
    
    @IBAction func continueLaterButtonTouchUpInside(sender: UIButton) {
        
        alertWithOkAndCancelAction(
            title: "Çıkmak istediğine emin misin?",
            message: "Eğitim bitmeden çıkarsan puan kazanamazsın.",
            okButtonTitle: "Tamam",
            cancelButtonTitle: "Vazgeç",
            okButtonHandler: { (_) in
                
            self.performSegue(withIdentifier: "unwindSegueToHead", sender: self)
                
        })
        
    }

    private func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("AUDIO PLAYER DID FINISH PLAYING.")
        isKolodaSwipeEnable = true
        kolodaView.swipe(.left)
        updateView()
    }
    
    // MARK: - UITextfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        checkWritingAnswer()
        
        return true
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
            
        case .listening:
            label.addImage(imageName: "Sound", afterLabel: true)
        }
        
        label.backgroundColor = labelBGColor
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.font = UIFont(name: "Mikado", size: 24.0)
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
