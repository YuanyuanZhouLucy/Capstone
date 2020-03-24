//
//  ExerciseB.swift
//
//
//  Created by Yuanyuan Zhou on 2019-12-02.
//

import UIKit
import AVFoundation

class ExerciseB: UIViewController{
    
    @IBOutlet weak var instr6: UILabel!
    
    @IBOutlet weak var instr8: UILabel!
    @IBOutlet weak var instr7: UILabel!
    @IBOutlet weak var instr1: UILabel!
    @IBOutlet weak var instr5: UILabel!
    
    @IBOutlet weak var instr4: UILabel!
    @IBOutlet weak var instr3: UILabel!
    @IBOutlet weak var instr2: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var finishButton: UIButton!
    var allQuestions = QuestionBank()
    var questionNumber = 0
    var totalScore = 0
    var wrongOption = Int()
    
    let correct_colour = UIColor.systemGreen
    
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
        nextButton.setTitle("Next Question", for: UIControl.State.normal)
        
        button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
            button4.isHidden = true
            nextButton.isHidden = true
            finishButton.isHidden = true
            
    }
    
    @IBAction func beginButtonAction(_ sender: UIButton) {
        unHide()
        updateQuestion()
    }
    
    func updateQuestion (){
        hide()
        instr1.isHidden = true
           instr2.isHidden = true
           instr3.isHidden = true
           instr4.isHidden = true
           instr5.isHidden = true
           instr6.isHidden = true
           instr7.isHidden = true
           instr8.isHidden = true
        beginButton.isHidden = true
         finishButton.isHidden = false
         button1.isHidden = false
         button2.isHidden = false
                button3.isHidden = false
                button4.isHidden = false
                nextButton.isHidden = false
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
        button1.setTitleColor(.blue, for: .normal)
          button2.setTitleColor(.blue, for: .normal)
          button3.setTitleColor(.blue, for: .normal)
          button4.setTitleColor(.blue, for: .normal)
        if(questionNumber != 0 ){
            if( allQuestions.list[questionNumber].correctAnswer  == 1){
                  previousAnswer = allQuestions.list[questionNumber].optionA
              }
              else if(allQuestions.list[questionNumber].correctAnswer  == 2){
                  previousAnswer = allQuestions.list[questionNumber].optionB
              }
              else if(allQuestions.list[questionNumber].correctAnswer  == 3){
                  previousAnswer = allQuestions.list[questionNumber].optionC
              }
              else if (allQuestions.list[questionNumber].correctAnswer  == 4){
                  previousAnswer = allQuestions.list[questionNumber].optionD
              }
        }
        else{
            if( allQuestions.list[0].correctAnswer  == 1){
                previousAnswer = allQuestions.list[0].optionA
            }
            else if(allQuestions.list[0].correctAnswer  == 2){
                previousAnswer = allQuestions.list[0].optionB
            }
            else if(allQuestions.list[0].correctAnswer  == 3){
                previousAnswer = allQuestions.list[0].optionC
            }
            else if (allQuestions.list[0].correctAnswer  == 4){
                previousAnswer = allQuestions.list[0].optionD
            }
        }
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
        
        if(questionNumber == 0){
            updateQuestion()
        }
        else{
            if(wrongOption == 1 && questionNumber != 0){
                button1.setTitleColor(correct_colour, for: .normal)
                label.text = ("You got this correct.")
                if(questionNumber < self.allQuestions.size){
                    totalScore += 1
                }
               
            } else if (questionNumber != 0){
                label.text =  ("Good try, but this is incorrect.")
                if (wrongOption == 1){
                    button1.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 2){
                    button2.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 3){
                    button3.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 4){
                    button4.setTitleColor(correct_colour, for: .normal)
                }
            } else {
                hide()
            }
        }
        
    }
    
    @IBAction func button2Action(_ sender: Any) {
        
        unHide()
        
        if(questionNumber == 0){
            updateQuestion()
        }
        else{
            if(wrongOption == 2 && questionNumber != 0){
                button2.setTitleColor(correct_colour, for: .normal)
                label.text = ("You got this correct.")
                 if(questionNumber < self.allQuestions.size){
                                 totalScore += 1
                             }
            } else if (questionNumber != 0){
                label.text =  ("Good try, but this is incorrect.")
                if (wrongOption == 1){
                    button1.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 2){
                    button2.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 3){
                    button3.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 4){
                    button4.setTitleColor(correct_colour, for: .normal)
                }
            } else {
                hide()
            }
        }
        
    }
    
    @IBAction func button3Action(_ sender: Any) {
        unHide()
        
        if(questionNumber == 0){
            updateQuestion()
        }
        else{
            if(wrongOption == 3 && questionNumber != 0){
                button3.setTitleColor(correct_colour, for: .normal)
                label.text = ("You got this correct.")
                  if(questionNumber < self.allQuestions.size){
                                 totalScore += 1
                             }
            } else if (questionNumber != 0){
                label.text =  ("Good try, but this is incorrect.")
                if (wrongOption == 1){
                    button1.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 2){
                    button2.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 3){
                    button3.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 4){
                    button4.setTitleColor(correct_colour, for: .normal)
                }
            } else {
                hide()
            }
        }
        
    }
    
    @IBAction func button4Action(_ sender: Any) {
        
        unHide()
        
        if(questionNumber == 0){
            updateQuestion()
        }
        else{
            if(wrongOption == 4 && questionNumber != 0){
                button4.setTitleColor(correct_colour, for: .normal)
                label.text = ("You got this correct.")
                  if(questionNumber < self.allQuestions.size){
                                 totalScore += 1
                             }
            } else if (questionNumber != 0){
                label.text =  ("Good try, but this is incorrect.")
                if (wrongOption == 1){
                    button1.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 2){
                    button2.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 3){
                    button3.setTitleColor(correct_colour, for: .normal)
                }
                else if (wrongOption == 4){
                    button4.setTitleColor(correct_colour, for: .normal)
                }
            } else {
                hide()
            }
        }
        
    }
    
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if(questionNumber < self.allQuestions.size){
            updateQuestion()
        }
        else{
               label.text =  ("Your total score is \(totalScore). End of the Exercise")
           }
        
    }
    
    @IBAction func updateScore(_ sender: Any) {
        let id = SQLiteDataStore.instance.addExerciseBSession(date: Date(), exercisesAttempted: questionNumber, exercisesCorrect: totalScore)
        if id! == nil {
            print("Add to session information to exercise B database failed" )
        }
    }
    
    // Locking orientation.
     override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
    }

}
