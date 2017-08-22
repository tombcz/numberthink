
import UIKit

class Csv {
    
    static func readWords() -> Dictionary<String,String> {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirectory.appendingPathComponent("words.csv")
        let contents = try? String(contentsOf: fileURL)
        let rows = contents?.components(separatedBy: "\n")
        var dictionary = [String:String]()
        for row in rows! {
            if row.characters.count > 0 {
                var tokens = row.components(separatedBy: ",")
                dictionary[tokens[1]] = tokens[0]
            }
        }
        return dictionary
    }
    
    static func update(word:(String), newWord:(String)) {
        var words = readWords()
        let number = words[word]
        words.removeValue(forKey: word)
        words[newWord] = number
        var f = String()
        for next in words {
            if next.key == word {
                f.append("\(newWord),\(next.key)\n")
            }
            else {
                f.append("\(next.value),\(next.key)\n")
            }
        }
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirectory.appendingPathComponent("words.csv")
        try? f.write(to: fileURL, atomically: false, encoding: .utf8)
    }
}
