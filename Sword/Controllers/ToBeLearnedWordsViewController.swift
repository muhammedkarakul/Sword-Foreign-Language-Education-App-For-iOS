//
//  ToBeLearnedWordsViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 2.08.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class ToBeLearnedWordsViewController: CustomViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var toBeLearnedWords: [Word]?
    public var voiceQuestionState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toBeLearnedWords!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToBeLearnedWordsTableViewCell
        
        let currentWord = toBeLearnedWords![indexPath.row]
        
        cell.foreignLangWordLabel.text = currentWord.getForeignLang()
        cell.motherLangWordLabel.text = currentWord.getMotherLang()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    @IBAction func goToLearnButtonTouchUpInside(_ sender: CustomButton) {
        
        alertWithOkAndCancelAction(
            title: "Uyarı!",
            message: "Sesli soruları cevaplayabilir misin?",
            okButtonTitle: "Evet",
            cancelButtonTitle: "Hayır",
            okButtonHandler: { (_) in
                self.voiceQuestionState = true
                self.performSegue(withIdentifier: "learnScreenSegue", sender: self)
        },
            cancelButtonHandler: { (_) in
                self.voiceQuestionState = false
                self.performSegue(withIdentifier: "learnScreenSegue", sender: self)
        })
        
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! LearnViewController
        
        vc.words = toBeLearnedWords
        vc.voiceQuestionState = self.voiceQuestionState
     }
    
    
}

class ToBeLearnedWordsTableViewCell: UITableViewCell {
    @IBOutlet var containerView: UIView?
    @IBOutlet var foreignLangWordLabel: UILabel!
    @IBOutlet var motherLangWordLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        containerView?.layer.cornerRadius = 5
        containerView?.layer.masksToBounds = true
    }
}
