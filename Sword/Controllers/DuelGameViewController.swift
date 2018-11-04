//
//  ArenaViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 12.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import UICircularProgressRing
import Koloda
import AVFoundation

class DuelGameViewController: CustomViewController {
    
    // MARK: - Properties
    
    // Countdown timer display view.
    @IBOutlet var countdownTimerDisplayView: CustomView!
    @IBOutlet var coundownTimerLabel: UILabel!
    
    // Timer circular progress bar.
    @IBOutlet var timeCircularProgressRing: UICircularProgressRing!
    
    // Swipable card view
    @IBOutlet var kolodaView: KolodaView!
    
    // Current User
    private var currentUser: User?
    
    // Opponent User
    private var opponentUser: User?
    
    // User Data
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userScoreLabel: UILabel!
    
    // Opponent Data
    @IBOutlet var opponentImageView: UIImageView!
    @IBOutlet var opponentNameLabel: UILabel!
    @IBOutlet var opponentScoreLabel: UILabel!
    
    // Multiple Selection Objects
    @IBOutlet var multipleSelectionFirstButton: MultipleSelectionButton!
    @IBOutlet var multipleSelectionSecondButton: MultipleSelectionButton!
    @IBOutlet var multipleSelectionThirdButton: MultipleSelectionButton!
    @IBOutlet var multipleSelectionFourthButton: MultipleSelectionButton!
    
    // Multiple Selection Buttons Array
    private var multipleSelectionButtons = [MultipleSelectionButton]()
    
    // Duel start time.
    private let duelStartTime: Double = 60.0
    
    // Duel finish time.
    private let duelFinishTime: CGFloat = 0.0
    
    // Joker Buttons
    @IBOutlet var fiftyPercentButton: UIButton!
    @IBOutlet var doubleAnswerButton: UIButton!
    @IBOutlet var skipQuestionButton: UIButton!
    
    // Game Object
    public var game: Game?
    
    // Question's words.
    private var words = [Word]()
    
    // To Be Learned Words
    private var learnWords = [LearnWord]()
    
    // Questions array.
    private var questions = [Any]()
    
    // When this properties is false koloda view swipe disable.
    private var isKolodaSwipeEnable = false
    
    // Current question array index.
    private var currentQuestionIndex: Int {
        get {
            return kolodaView.currentCardIndex
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get current user data from realm.
        currentUser = RealmUtilities.getCurrentUserFromRealm()

        // Setup multiple selection button array.
        multipleSelectionButtons = [self.multipleSelectionFirstButton, self.multipleSelectionSecondButton, self.multipleSelectionThirdButton, self.multipleSelectionFourthButton]
        
        // Print all game data.
        game?.printData()
        
        // Setup circular progress bar.
        setupCircularProgressBar()
        
        // Koloda kard view delegate and datasource
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
        // Setup words.
        setupWords()
        
        // Setup learned words.
        setupLearnWords()
        
        // Setup questions.
        setupQuestions()
        
        // Update answer buttons title.
        updateAnswerButtons()
        
        // Reload koloda view.
        kolodaView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show countdown.
        countdown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupLearnWords() {
        // Setup learn words
        for (index, word) in words.enumerated() {
            var learnWord = LearnWord()
            
            let questions = learnWord.setupQuestions(withWords: word)
            
            let multipleSelections = learnWord.setupMultipleSelections(withQuestions: questions, andWords: words)
            
            let writings = learnWord.setupWritings(withQuestions: questions)
            
            learnWord = LearnWord(multipleSelections: multipleSelections, writings: writings)
            
            learnWords.insert(learnWord, at: index)
        }
    }
    
    private func setupQuestions() {
        for learnWord in learnWords {
            questions.append(learnWord.getQuestion(withAnswerType: AnswerType.multipleSelection, withLanguageType: LanguageType.foreign, andQuestionType: QuestionType.reading))
        }
    }
    
    // MARK: - Setup Circular Progress Bar
    
    private func setupCircularProgressBar() {
        // Remove default '%' value indicator.
        timeCircularProgressRing.valueIndicator = ""
        
        // Set circular progress bar max value.
        timeCircularProgressRing.maxValue = 60
        
        // Set circular progress bar min value.
        timeCircularProgressRing.minValue = 0
        
        // Set circular progress bar start value.
        timeCircularProgressRing.value = 60
        
        // Set circular progress bar style.
        timeCircularProgressRing.ringStyle = .ontop
        
        // Set circular progress bar font attributes.
        guard let font = UIFont(name: "Mikado", size: 15.0) else { return }
        timeCircularProgressRing.font = font
        
        // Set circular progress bar font color.
        timeCircularProgressRing.fontColor = UIColor.white
        
        // Set circular progress bar inner circle color.
        timeCircularProgressRing.innerRingColor = UIColor.customColors.swordBlue
        
        // Set circular progress bar outter circle color.
        timeCircularProgressRing.outerRingColor = UIColor.white
        
        // Set circular progress bar outter circle width to inner circle width.
        timeCircularProgressRing.outerRingWidth = timeCircularProgressRing.innerRingWidth
    }
    
    private func updateCircularProgressBar(withCurrentProgress progress: CGFloat) {
        timeCircularProgressRing.startProgress(to: progress, duration: 1.0)
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        
        var timeInterval: CGFloat = 60
            
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (_) in
            
            // Increase time interval every seconds
            timeInterval -= 1.0
            
            self.updateCircularProgressBar(withCurrentProgress: timeInterval)
            
            if timeInterval == 0 {
                // When duel time(60 second) is over, this works.
                self.performSegue(withIdentifier: "gameResultSegue", sender: self)
            }
        }
    }
    
    // MARK: - Coundown
    
    private func countdown() {
        
        showBlurView(withBlurEffectStyle: .dark) { (_) in
            
            self.countdownTimerDisplayView.center = self.view.center
            self.view.addSubview(self.countdownTimerDisplayView)
        
            var countdownTimeInterval = 3
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                countdownTimeInterval -= 1
                
                self.coundownTimerLabel.text = "\(countdownTimeInterval)"
                
                UIView.animate(withDuration: 1.0, animations: {
                    
                })
                
                if countdownTimeInterval + 1 == 0 {
                    
                    // Stop countdown timer.
                    timer.invalidate()
                    
                    // Remove coundown view from superview.
                    self.countdownTimerDisplayView.removeFromSuperview()
                    
                    // Dissappear blur view.
                    self.hideBlurView()
                    
                    // Start timer.
                    self.startTimer()
                    
                }
            }
        }
    }
    
    // MARK: - Setup Duel Game
    
    private func setupWords() {
        // Get words from realm
        words = RealmUtilities.getWordsFromRealm(withRandom: game?.getRandom())
    }
    
    private func updateAnswerButtons() {
        if currentQuestionIndex < Int(questions.count) {
            for (index, multipleSelectionButton) in multipleSelectionButtons.enumerated() {
                if let currentQuestion = questions[currentQuestionIndex] as? MultipleSelection {
                    multipleSelectionButton.setTitle("\(currentQuestion.getAnswers()[index].getText(withType: QuestionType.reading))", for: .normal)
                }
            }
        }
    }
    
    private func updateView() {
        
        turnDefaultButtonsAppearence()
        
        for (index, multipleSelectionButton) in multipleSelectionButtons.enumerated() {
            if let currentQuestion = questions[currentQuestionIndex] as? MultipleSelection {
                multipleSelectionButton.setTitle("\(currentQuestion.getAnswers()[index].getText(withType: QuestionType.reading))", for: .normal)
            }
        }
        
        changeButtonsUserInteractionStatus()
    }
    
    private func turnDefaultButtonsAppearence() {
        for multipleSelectionButton in multipleSelectionButtons {
            turnDefaultButtonAppearence(button: multipleSelectionButton)
        }
    }
    
    private func turnDefaultButtonAppearence(button: MultipleSelectionButton) {
        button.setTitleColor(UIColor.customColors.swordBlue, for: UIControl.State.normal)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    /**
      Play sound for question answer state.
     */
    private func playSound(withAnswerState state: Bool) {
        if state {
            playSound(withName: "right")
        } else {
            playSound(withName: "wrong")
        }
    }
    
    private func showRightAnswer(withQuestion question: MultipleSelection) {
        multipleSelectionButtons[question.getRightAnswerIndex()].changeAppearance(withAnswerState: true)
    }
    
    @IBAction func multipleSelectionAnswerButtonTouchUpInside(_ sender: MultipleSelectionButton) {
        
        changeButtonsUserInteractionStatus()
        
        if let currentQuestion = questions[currentQuestionIndex] as? MultipleSelection {
            let isAnswerRight = currentQuestion.answerTheQuestion(answerIndex: sender.tag - 1)
            
            // Change button appearance with "right" or "wrong" style.
            sender.changeAppearance(withAnswerState: isAnswerRight)
            
            // Play "right" or "wrong" sound.
            playSound(withAnswerState: isAnswerRight)
            
            if isAnswerRight {
                
            } else {
                // Show right answer.
                showRightAnswer(withQuestion: currentQuestion)
            }
        }
    }
    
    
    private func changeButtonsUserInteractionStatus() {
        for multipleSelectionButton in multipleSelectionButtons {
            multipleSelectionButton.isUserInteractionEnabled = !multipleSelectionButton.isUserInteractionEnabled
        }
    }
    
    private func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("AUDIO PLAYER DID FINISH PLAYING.")
        isKolodaSwipeEnable = true
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

extension DuelGameViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("KARTLAR BİTTİ")
        
        performSegue(withIdentifier: "gameResultSegue", sender: self)
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

extension DuelGameViewController: KolodaViewDataSource {
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        return isKolodaSwipeEnable
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return questions.count
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
        

        if let currentQuestion = questions[index] as? MultipleSelection {
            label.text = currentQuestion.getQuestion().getText()
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
