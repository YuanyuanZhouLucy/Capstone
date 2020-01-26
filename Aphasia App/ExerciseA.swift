//
//  ExerciseA.swift
//  Aphasia App
//
//  Created by Yuanyuan Zhou on 2019-11-20.
//  Copyright © 2019 Yuanyuan Zhou. All rights reserved.
//

import UIKit
import FirebaseDatabase
import AVFoundation

class ExerciseA: UIViewController, UITableViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    let ref = Database.database().reference()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var cueButton: UIButton!
    @IBOutlet weak var cueButton2: UIButton!
    @IBOutlet weak var cueButton3: UIButton!
    @IBOutlet weak var cueButton4: UIButton!
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    var fileName:String = "audioFile.m4a"
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var labelEnd: UILabel!
    var allQuestions = QuestionBank()
    var questionNumber = 0
    var selectedAnswer = 0
    var totalScore = 0
    var correctAnswer = String()
    var cue1 = String()
    var cue2 = String()
    var cue3 = String()
    var cue4 = String()
    var pictureURL: String?
    var picture: UIImage?
    var dog = "dog.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hide()
        setupRecorder()
       
        playButton.isEnabled = false
        button1.layer.cornerRadius = 30
        button2.layer.cornerRadius = 30
        button3.layer.cornerRadius = 30
        button4.layer.cornerRadius = 30
        cueButton.layer.cornerRadius = 30
        cueButton2.layer.cornerRadius = 30
        cueButton3.layer.cornerRadius = 30
        cueButton4.layer.cornerRadius = 30
        button1.setTitle("Begin Now", for: UIControl.State.normal)
        button2.setTitle("Begin Now", for: UIControl.State.normal)
        button3.setTitle("Begin Now", for: UIControl.State.normal)
        button4.setTitle("Begin Now", for: UIControl.State.normal)
        cueButton.setTitle("Click 'Begin Now' to Start", for:UIControl.State.normal)
        cueButton2.setTitle("Select the Option", for:UIControl.State.normal)
        cueButton3.setTitle("that Best Describes ", for:UIControl.State.normal)
        cueButton4.setTitle("the Picture", for:UIControl.State.normal)
        nextButton.setTitle("Next Question", for: UIControl.State.normal)

    }
  
    func updateQuestion (){
        hide()
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
        print("question number")
        print(questionNumber)
        print("question list")
        print(allQuestions.list[questionNumber].optionA)
        button1.setTitle(allQuestions.list[questionNumber].optionA, for: UIControl.State.normal)
        button2.setTitle(allQuestions.list[questionNumber].optionB, for: UIControl.State.normal)
        button3.setTitle(allQuestions.list[questionNumber].optionC, for: UIControl.State.normal)
        button4.setTitle(allQuestions.list[questionNumber].optionD, for: UIControl.State.normal)
        
         button1.setTitleColor(.blue, for: .normal)
         button2.setTitleColor(.blue, for: .normal)
         button3.setTitleColor(.blue, for: .normal)
         button4.setTitleColor(.blue, for: .normal)
        
        cueButton.setTitle("Cues", for: UIControl.State.normal)
        cueButton2.setTitle("Cues", for: UIControl.State.normal)
        cueButton3.setTitle("Cues", for: UIControl.State.normal)
        cueButton4.setTitle("Cues", for: UIControl.State.normal)
        
        selectedAnswer = allQuestions.list[questionNumber].correctAnswer
        cue1 = allQuestions.list[questionNumber].cue1
        cue2 = allQuestions.list[questionNumber].cue2
        cue3 = allQuestions.list[questionNumber].cue3
        cue4 = allQuestions.list[questionNumber].cue4
        print("for this question \(questionNumber), the cue is \(cue1)")
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
    
    @IBAction func button1Action(_ sender: AnyObject) {
        unHide()
        print("clicked1")
        
        if(questionNumber == 0){
            updateQuestion()
        }
        else{
        
        if(selectedAnswer == 1 && questionNumber != 0){
             button1.setTitleColor(.green, for: .normal)
            labelEnd.text = ("You got this one correct")
              if(questionNumber < 5){
                             totalScore += 1
                         }
        } else if (questionNumber != 0){
            labelEnd.text =  ("You got this one wrong \(previousAnswer) is the answer")
            if (selectedAnswer == 1){
                button1.setTitleColor(.green, for: .normal)
            }
            else if (selectedAnswer == 2){
                button2.setTitleColor(.green, for: .normal)
            }
            else if (selectedAnswer == 3){
                button3.setTitleColor(.green, for: .normal)
            }
            else if (selectedAnswer == 4){
                button4.setTitleColor(.green, for: .normal)
            }
        } else {
            hide()
        }
        }
       
    }
    
    
    @IBAction func button2Action(_ sender: AnyObject) {
        unHide()
        print("clicked2")
        
        if(questionNumber == 0){
                   updateQuestion()
               }
               else{
        if(selectedAnswer == 2){
             button2.setTitleColor(.green, for: .normal)
              labelEnd.text =  ("You got this one correct")
                  if(questionNumber < 5){
                                totalScore += 1
                            }
              } else if (questionNumber != 0) {
                  labelEnd.text =  ("You got this one wrong \(previousAnswer) is the answer")
                if (selectedAnswer == 1){
                         button1.setTitleColor(.green, for: .normal)
                     }
                     else if (selectedAnswer == 2){
                         button2.setTitleColor(.green, for: .normal)
                     }
                     else if (selectedAnswer == 3){
                         button3.setTitleColor(.green, for: .normal)
                     }
                     else if (selectedAnswer == 4){
                         button4.setTitleColor(.green, for: .normal)
                     }
              }else {
                  hide()
              }
        }
       
    }
    
    @IBAction func button3Action(_ sender: AnyObject) {
        unHide()
        print("clicked3")
        if(questionNumber == 0){
                   updateQuestion()
               }
               else{
        if(selectedAnswer == 3 && questionNumber != 0){
            button3.setTitleColor(.green, for: .normal)
            labelEnd.text = ("You got this one correct")
               if(questionNumber < 5){
                             totalScore += 1
                         }
        } else if (questionNumber != 0){
            labelEnd.text =  ("You got this one wrong \(previousAnswer) is the answer")
            if (selectedAnswer == 1){
                         button1.setTitleColor(.green, for: .normal)
                     }
                     else if (selectedAnswer == 2){
                         button2.setTitleColor(.green, for: .normal)
                     }
                     else if (selectedAnswer == 3){
                         button3.setTitleColor(.green, for: .normal)
                     }
                     else if (selectedAnswer == 4){
                         button4.setTitleColor(.green, for: .normal)
                     }
        } else {
            hide()
        }
        }
      
    }
    
    
    @IBAction func button4Action(_ sender: AnyObject) {
        unHide()
        
        if(questionNumber == 0){
                   updateQuestion()
               }
               else{
        if(selectedAnswer == 4 && questionNumber != 0){
            button4.setTitleColor(.green, for: .normal)
            labelEnd.text = ("You got this one correct")
            if(questionNumber < 5){
                             totalScore += 1
                         }
        } else if (questionNumber != 0){
           labelEnd.text =  ("You got this one wrong \(previousAnswer) is the answer")
            if (selectedAnswer == 1){
                         button1.setTitleColor(.green, for: .normal)
                     }
                     else if (selectedAnswer == 2){
                         button2.setTitleColor(.green, for: .normal)
                     }
                     else if (selectedAnswer == 3){
                         button3.setTitleColor(.green, for: .normal)
                     }
                     else if (selectedAnswer == 4){
                         button4.setTitleColor(.green, for: .normal)
                     }
        } else {
            hide()
        }
        }
       
    }
    
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if(questionNumber < 5){
            updateQuestion()
        }
        else{
            labelEnd.text =  ("Your total score is \(totalScore). End of the Exercise")
        }
    }
    
    @IBAction func cueButtonAction(_ sender: AnyObject) {
          print("clicked on cues")
        cueButton.setTitle(cue1, for: UIControl.State.normal)
    }
    
    @IBAction func cueButtonAction2(_ sender: Any) {
         cueButton2.setTitle(cue2, for: UIControl.State.normal)
    }
    
    @IBAction func cueButtonAction3(_ sender: Any) {
           cueButton3.setTitle(cue3, for: UIControl.State.normal)
    }
    
    @IBAction func cueButtonAction4(_ sender: Any) {
           cueButton4.setTitle(cue4, for: UIControl.State.normal)
    }
    
    func hide() {
        labelEnd.isHidden = true
    }
    func unHide() {
        labelEnd.isHidden = false
    }
    func getDocumentsDirector() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths [0]
    }
    func setupRecorder(){
        let audioFileName = getDocumentsDirector().appendingPathComponent(fileName)
        let recordSetting = [AVFormatIDKey: kAudioFormatAppleLossless,
                             AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                             AVEncoderBitRateKey:320000,
                             AVNumberOfChannelsKey:2,
                             AVSampleRateKey : 44100.2] as [String: Any]
        do {
            soundRecorder = try AVAudioRecorder(url:audioFileName,settings:recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
            
        } catch {
            print(error)
        }
    }
    
    func setupPlayer() {
        let audioFilename = getDocumentsDirector().appendingPathComponent(fileName)
        do{
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
        catch {
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder:AVAudioRecorder, successfully flag: Bool){
        playButton.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying (_ player: AVAudioPlayer, successfully flag: Bool){
        recordButton.isEnabled = true
        playButton.setTitle("Play", for: .normal)
    }
    @IBAction func recordAct(_ sender: Any) {
        if recordButton.titleLabel?.text == "Record" {
            soundRecorder.record()
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
        }
        else{
            soundRecorder.stop()
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = false
        }
    }
    
    @IBAction func playAct(_ sender: Any) {
        if playButton.titleLabel?.text == "Play" {
            playButton.setTitle("Stop", for: .normal)
            recordButton.isEnabled = false
            setupPlayer()
            soundPlayer.play()
        }
        else{
            soundPlayer.stop()
            playButton.setTitle("Play", for: .normal)
            recordButton.isEnabled = false
        }
    }

    @IBAction func homeButton(_ sender: Any) {
        self.addSessionProgress()
    }
    
    @IBAction func nextExerciseButton(_ sender: Any) {
        self.addSessionProgress()
    }
    
    func addSessionProgress() {
        let id = SQLiteDataStore.instance.addExerciseASession(date: Date(), exercisesAttempted: questionNumber, exercisesCorrect: totalScore)
        if id! == nil {
            print("Add to session information to exercise A database failed" )
        }
    }
}
