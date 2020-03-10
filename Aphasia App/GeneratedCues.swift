//
//  GeneratedCues.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-03-10.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import Foundation
import NaturalLanguage


class CueGenerator {
    let word: String
    var cue_dic: [String: String] = [:]

    init(word:String) {
        self.word = word
        self.runAPICalls(text: word)
    }
    
    func getCues() -> [String:Any]{
        return self.generateCues()
    }
    
    func getCuesDelayed() -> [String:Any]{
        //the whole thing needs to be async
        var cues: [String:Any] = [:]
        let seconds = 2
        sleep(UInt32(UInt32(seconds)))
        return self.generateCues()
    }
    
    func runAPICalls(text:String){
        self.generate_cue_ex1(word: text)
        self.get_elementry_defi(text)
        self.getRhyme(word: text)
    }
    
    func prepareExample(text: String, example:String) -> String{
        let str1 = example.replacingOccurrences(of: text.lowercased(), with: "__")
        return str1.replacingOccurrences(of: text, with: "__")
    }
    
    func generateCues() -> ([String:Any]) {
        let isWord = self.checkName(word: self.word)
        let existsInModel = self.inEmbeddingModel(word: self.word.lowercased())
        var exerciseBSimilar = [String]()
        var exerciseBDissimilar = [String]()
        var dict = [String:Any]()
        
        if isWord && existsInModel {
            
            exerciseBSimilar = self.findSemanticNeighbours(word: self.word.lowercased())
            exerciseBDissimilar = self.findDissimilar(word: self.word.lowercased())
        
            print("there will be CUES")
            print(self.cue_dic)
        }
        
        if existsInModel && !self.cue_dic.isEmpty {
            
            dict = [
                "Name": self.word,
                "Answer": self.word,
                "hasCues": existsInModel,
                "Cue1": String(self.cue_dic["count"] ?? "no syllables available"),
                "Cue2": String(self.cue_dic["definition"] ?? "no def available"),
                "Cue4": String(self.cue_dic["rhymes"] ?? "no rhyme available"),
                "Opt1": exerciseBDissimilar[0],
                "Opt2": exerciseBSimilar[1],
                "Opt3": exerciseBSimilar[2],
                "Opt4": exerciseBSimilar[3],
                "Wrong1": exerciseBDissimilar[0],
                "Wrong2": exerciseBDissimilar[1],
                "Wrong3": exerciseBDissimilar[2],
                "WrongOpt": 1
            ]
            
            if (self.cue_dic["example"] != nil){
                dict["Cue3"] = self.prepareExample(text: self.word, example: self.cue_dic["example"] as! String)
            } else{
                dict["Cue3"] = "no example"
            }
        }
        else {
            dict = [
                "Name": self.word,
                "hasCues": existsInModel,
            ]
        }
        
        return dict
    }
    
    func checkName(word: String) -> Bool{
        var isWord = true
        let text = word
        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
        tagger.string = text
        let range = NSRange(location:0, length: text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
            if let tag = tag, tags.contains(tag) {
                isWord = false
                let name = (text as NSString).substring(with: tokenRange)
                print("\(name): \(tag)")
            }
        }
        return isWord
    }
    
    func findSemanticNeighbours(word: String) -> [String] {
        let embedding = NLEmbedding.wordEmbedding(for: NLLanguage.english)
        let neighbours = embedding?.neighbors(for: word, maximumCount: 4)
        print("Neighbours:", neighbours ?? [])
        
        var similarWords = [String]()
        
        neighbours!.enumerated().forEach { (arg) in
            let (_, value) = arg
            similarWords.append(value.0)
        }
        return similarWords
    }
    
    func findDissimilar(word:String) -> [String] {
        let embedding = NLEmbedding.wordEmbedding(for: NLLanguage.english)
        let neighbours = embedding?.neighbors(for: word, maximumCount: 100)
        let furthestNeighbour = neighbours!.last!.0
        let furtherNeighbours = embedding?.neighbors(for: furthestNeighbour, maximumCount: 100)
        let furthestNeighbour2 = furtherNeighbours!.last!.0
        let furtherNeighbours2 = embedding?.neighbors(for: furthestNeighbour2, maximumCount: 100)
        var dissimilarWords = [String]()
        
        furtherNeighbours2!.enumerated().forEach { (arg) in
            let (_, value) = arg
            dissimilarWords.append(value.0)
        }
        print("Most dissimilar", dissimilarWords.suffix(3))
        return dissimilarWords.suffix(3)
    }
    
    func inEmbeddingModel(word:String) -> Bool {
        let embedding = NLEmbedding.wordEmbedding(for: NLLanguage.english)
        return embedding!.contains(word)
    }
    
    func get_elementry_defi(_ word: String){
        ///test dic
        //https://www.dictionaryapi.com/api/v3/references/sd2/json/school?key=your-api-key
        
        
        let headers = [
            //            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "key": "277f4daf-2de0-4c65-ad30-14490832baa9"
        ]
        let request2 = NSMutableURLRequest(url: NSURL(string: "https://dictionaryapi.com/api/v3/references/sd2/json/\(word)?key=277f4daf-2de0-4c65-ad30-14490832baa9")! as URL,
                                           cachePolicy: .useProtocolCachePolicy,
                                           timeoutInterval: 10.0)
        request2.httpMethod = "GET"
        //       request2.allHTTPHeaderFields = headers
        
        let session2 = URLSession.shared
        let dataTask2 = session2.dataTask(with: request2 as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("---fail2----")
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("-----success2 new ----")
                print(data)
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) {
                    //                    print(json)
                    print("got it")
                    
                    if let dictionary = json as? [Any] {
                        if let ssefs = dictionary[0] as? [String: Any]{
                            if let def = ssefs["def"] as? [Any] {
                                if let array = def[0] as? [String: Any]{
                                    if let sseq = array["sseq"] as? Array<Array<Any>>{
                                        if let sense_top = sseq[0][0] as? [Any]{
                                            if let sense = sense_top[1] as? [String: Any]{
                                                if let sense_ele_top = sense["dt"] as? Array<Array<String>>{
                                                    //                                        if let sense_ele = sense_ele_top[1]["dt"] as? Array<Array<String>>{
                                                    let definition = sense_ele_top[0][1]
                                                    let startIndex = definition.index(definition.startIndex, offsetBy: 4)
                                                    self.cue_dic["definition"] = String(definition[startIndex...])    // "String"
                                                    
                                                    print(self.cue_dic["definition"])
                                             
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
    
                        }
                    }
                    
                }
            }
            
        })
        
        
        dataTask2.resume()
        
    }
    
    func getRhyme(word: String){
        let headers = [
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "x-rapidapi-key": "fcceaaaa83msh794a5625b58ed61p10b214jsne604f93cb0db"
        ]
        let request2 = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/\(word)/rhymes")! as URL,
                                           cachePolicy: .useProtocolCachePolicy,
                                           timeoutInterval: 10.0)
        request2.httpMethod = "GET"
        request2.allHTTPHeaderFields = headers
        
        let session2 = URLSession.shared
        let dataTask2 = session2.dataTask(with: request2 as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("---fail2----")
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("-----success2----")
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    print("------start----")
                    //print(json)
                    print("------end----")
                    if let dictionary = json as? [String: Any] {
                        if let nestedDictionary = dictionary["rhymes"] as? Dictionary<String, Any>{
                            
                            if let r_words = nestedDictionary["all"] as? [String] {
                                self.cue_dic["rhymes"] = "Rhymes with " + r_words[0]
                            }
                        }
                    }
                }
            }
        })
        
        dataTask2.resume()
    }
    
    func generate_cue_ex1(word: String) -> [String: String]{
        let headers = [
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "x-rapidapi-key": "fcceaaaa83msh794a5625b58ed61p10b214jsne604f93cb0db"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/\(word)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                //                print(httpResponse)
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    print("------success----")
                    //                             print(json)
                    //                     print("------end----")
                    if let dictionary = json as? [String: Any] {
                        
                        if let nestedDictionary = dictionary["results"] as? Array<Dictionary<String, Any>> {
                            for resul in nestedDictionary {
                                if let POS = resul["partOfSpeech"] as? String {
                                    if POS == "noun" {
                                        //print(resul["definition"] ?? "") // this works resul[]- but need to selection the one correspond to noun
                                        //                                                if let def = resul["definition"] as? String {
                                        ////                                                    if let def0 = def[0] as? String {
                                        //                                                        selfxs.cue_dic["definition"] = def
                                        ////                                                    }
                                        //
                                        //                                                }
                                        if let eg = resul["examples"] as? [Any] {
                                            if let eg0 = eg[0] as? String {
                                                let newString = eg0.replacingOccurrences(of: word, with: "___")
                                                print("Example", newString)
                                                self.cue_dic["example"] = newString
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let syl = dictionary["syllables"] as? [String: Any] {
                            if let count = syl["count"] as? Int {
                                //print(count)
                                self.cue_dic["count"] = String(count) + " Syllables"
                                
                            }
                        }
                        
                    }
                    
                }
            }
        })
        dataTask.resume()
        print("--------------------------------print json------------------------------------------------")
        return self.cue_dic
    }
}
