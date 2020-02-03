import UIKit
import NaturalLanguage

// Find similar words based on embedding
func embedCheck(word: String){
// Extract the language type
    //let lang = NLLanguageRecognizer.dominantLanguage(for: word)
// Get the OS embeddings for the given language
    let embedding = NLEmbedding.wordEmbedding(for: NLLanguage.english)
// Find the 5 words that are nearest to the input word based on the embedding
    let res = embedding?.neighbors(for: word, maximumCount: 5)
// Print the words
    print(res ?? [])
    print(embedding?.vocabularySize)
}
// Find words similar to cheese
embedCheck(word: "fan")
