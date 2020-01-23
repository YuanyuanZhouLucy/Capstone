//
//  ExerciseB.swift
//  
//
//  Created by Yuanyuan Zhou on 2019-12-02.
//

import UIKit

class ExerciseB: UIViewController{
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var allQuestions = QuestionBank()
    var questionNumber = 0
    var totalScore = 0
    var wrongOption = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hide()
        button1.layer.cornerRadius = 30
        button2.layer.cornerRadius = 30
        button3.layer.cornerRadius = 30
        button4.layer.cornerRadius = 30
        button1.setTitle("Click Here to Start ", for: UIControl.State.normal)
        button2.setTitle("Select the Option", for: UIControl.State.normal)
        button3.setTitle("That Does Not", for: UIControl.State.normal)
        button4.setTitle("Describe the Picture", for: UIControl.State.normal)
    }
    
    
    func updateQuestion (){
    if let url = URL (string:allQuestions.list[questionNumber].questionImage) {
        DispatchQueue.main.async {
            do {
                let data = try Data(contentsOf: url)
                self.imageView.image = UIImage(data: data)
                self.imageView.setNeedsDisplay()
            }catch let err {
                print("error")
            }
        }
    }
        wrongOption = allQuestions.list[questionNumber].wrongOpt
        
        print("wrongOption is")
             print(wrongOption)
        
        button1.setTitle(allQuestions.list[questionNumber].relatedWord1, for: UIControl.State.normal)
        button2.setTitle(allQuestions.list[questionNumber].relatedWord2, for: UIControl.State.normal)
        button3.setTitle(allQuestions.list[questionNumber].relatedWord3, for: UIControl.State.normal)
        button4.setTitle(allQuestions.list[questionNumber].relatedWord4, for: UIControl.State.normal)
        
        questionNumber += 1
    }
    
    
    
    func hide() {
        label.isHidden = true
    }
    func unHide() {
        label.isHidden = false
    }
    
    @IBAction func button1Action(_ sender: Any) {
        
        unHide()
        print("clicked1")
     
        if(wrongOption == 1 && questionNumber != 0){
            label.text = ("You got the previous one right")
             totalScore += 1
          
        } else if (questionNumber != 0){
            label.text =  ("You got the previous one wrong")
            
        } else {
            hide()
        }
        if(questionNumber < 5){
        updateQuestion()
        }
         else{
            label.text =  ("Your total score is \(totalScore). End of the Exercise")
               }
    }
    
    @IBAction func button2Action(_ sender: Any) {
        
        unHide()
        print("clicked2")
        if(wrongOption == 2 && questionNumber != 0){
            label.text = ("You got the previous one right")
            totalScore += 1
        } else if (questionNumber != 0){
            label.text =  ("You got the previous one wrong")
           
        } else {
            hide()
        }
        if(questionNumber < 5){
            updateQuestion()
        }
        else{
            label.text =  ("Your total score is \(totalScore). End of the Exercise")
        }
    }
    
    @IBAction func button3Action(_ sender: Any) {
        
        unHide()
        print("clicked3")
        if(wrongOption == 3 && questionNumber != 0){
            label.text = ("You got the previous one right")
             totalScore += 1
   
        } else if (questionNumber != 0){
            label.text =  ("You got the previous one wrong")
             
        } else {
            hide()
        }
        if(questionNumber < 5){
            updateQuestion()
        }
        else{
            label.text =  ("Your total score is \(totalScore). End of the Exercise")
        }
    }
    
    @IBAction func button4Action(_ sender: Any) {
        
        unHide()
        print("clicked4")
        if(wrongOption == 4 && questionNumber != 0){
            label.text = ("You got the previous one right")
          totalScore += 1
        } else if (questionNumber != 0){
            label.text =  ("You got the previous one wrong")
          
        } else {
            hide()
        }
        if(questionNumber < 5){
            updateQuestion()
        }
        else{
            label.text =  ("Your total score is \(totalScore). End of the Exercise")
        }
    }
    
    @IBAction func homeButton(_ sender: Any) {
        let id = SQLiteDataStore.instance.addExerciseBSession(date: Date(), exercisesAttempted: questionNumber, exercisesCorrect: totalScore)
        if id! == nil {
            print("Add to session information to exercise B database failed" )
        }
    }
    

}
