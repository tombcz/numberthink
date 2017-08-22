
import Foundation
import UIKit

class Logic {
    
    //
    // Returns the peg word from the data file that exactly matches the given
    // number, so only expect an output if the number is between 0 and 99.
    //
    static func lookupWordForNumber(number: String) -> String {
        let words = Csv.readWords()
        for word in words.keys {
            if (words[word] == number) {
                return word;
            }
        }
        return "";
    };
    
    //
    // Returns the peg word phrase for the given number. For example, an input
    // of "123" would output "tin mow". This is done by stepping through pairs
    // of numbers from the beginning to the end and converting each pair into
    // a word until there is 1 (or none) left, which is then converted. This
    // minimizes the phrase length.
    //
    static func convertNumberToPhrase(number: String) -> Array<String> {
        var words = [String]();
        var index = 0
        while(true) {
            
            // stop when we reach the end
            if index == number.characters.count {
                break
            }
            
            // convert the next two digits if we have them
            if index + 1 < number.characters.count {
                let pair = Logic.substring(string: number, fromIndex: index, toIndex: index+2)!
                let match = Logic.lookupWordForNumber(number:pair)
                words.append(match)
                index += 2
            }
            else {
                // just one digit left so convert it
                let single = Logic.substring(string: number, fromIndex: index, toIndex: index+1)!
                let match = Logic.lookupWordForNumber(number:single)
                words.append(match)
                index += 1
            }
        }
        return words
        
    };
    
    //
    // Returns a list of strings that represent the sounds that make up
    // the given word.
    //
    static func convertWordToSounds(word: String) -> Array<String> {
        var sounds = [String]()
        var start = 0
        while(true)
        {
            // stop when we reach the end of the word
            if(start >= word.characters.count) {
                break;
            }
            
            var digit = "";
            var sound = Logic.substring(string:word, fromIndex: start, toIndex: start+1)
            if(Logic.isIgnored(s:sound!) == true)
            {
                start += 1
            }
            else
            {
                // check for a 3-character sound
                if(start+2 < word.characters.count) {
                    sound = Logic.substring(string:word, fromIndex: start, toIndex: start + 3);
                    digit = Logic.digitForSound(s:sound!);
                    if(digit != "") {
                        start += 3;
                    }
                }
                
                // check for 2-character if we didn't find a 3-character sound
                if(digit == "" && start+1 < word.characters.count) {
                    sound = Logic.substring(string:word, fromIndex: start, toIndex: start + 2);
                    digit = Logic.digitForSound(s:sound!);
                    if(digit != "") {
                        start += 2;
                    }
                }
                
                // use the 1-character sound if we didn't find any 2- or 3-character sounds
                if(digit == "") {
                    sound = Logic.substring(string: word, fromIndex: start, toIndex: start + 1)
                    digit = Logic.digitForSound(s:sound!);
                    start += 1;
                }
            }
            
            sounds.append(sound!)
        }
        
        return sounds
    }
    
    //
    // Returns true if the given srting (which should contain a single letter
    // is ignored in the Major System.
    //
    static func isIgnored(s: String) -> Bool {
        
        let c = s[s.index(s.startIndex, offsetBy: 0)]
        
        switch (c) {
        case "a":
            return true;
        case "e":
            return true;
        case "i":
            return true;
        case "o":
            return true;
        case "u":
            return true;
        case "w":
            return true;
        case "h":
            return true;
        case "y":
            return true;
        case " ":
            return true;
        case "_":
            return true;
        case "-":
            return true;
        default:
            return false;
        }
    }
    
    //
    // Returns the digit for the given sound. This isn't perfect since
    // we're just basing this off of letter combinations, but it works
    // for the peg words that are included in the app.
    //
    static func digitForSound(s:String) -> String {
        switch (s) {
        case "z":
            return "0";
        case "s":
            return "0";
        case "zz":
            return "0";
        case "ss":
            return "0";
        case "sy":
            return "0";
        case "ce":
            return "0";
        case "ci":
            return "0";
        case "cy":
            return "0";
        case "d":
            return "1";
        case "t":
            return "1";
        case "dd":
            return "1";
        case "dy":
            return "1";
        case "tt":
            return "1";
        case "ty":
            return "1";
        case "n":
            return "2";
        case "nn":
            return "2";
        case "kn":
            return "2";
        case "m":
            return "3";
        case "mb":
            return "3"
        case "mm":
            return "3"
        case "r":
            return "4";
        case "rr":
            return "4";
        case "l":
            return "5";
        case "ll":
            return "5";
        case "ly":
            return "5";
        case "j":
            return "6";
        case "jj":
            return "6";
        case "sh":
            return "6";
        case "ch":
            return "6";
        case "ge":
            return "6";
        case "gi":
            return "6";
        case "gy":
            return "6";
        case "tch":
            return "6";
        case "k":
            return "7";
        case "c":
            return "7";
        case "g":
            return "7";
        case "q":
            return "7";
        case "kk":
            return "7";
        case "ky":
            return "7";
        case "ck":
            return "7";
        case "cc":
            return "7";
        case "gg":
            return "7";
        case "qq":
            return "7";
        case "qu":
            return "7";
        case "f":
            return "8";
        case "v":
            return "8";
        case "ff":
            return "8";
        case "fy":
            return "8";
        case "vv":
            return "8";
        case "vy":
            return "8";
        case "ph":
            return "8";
        case "p":
            return "9";
        case "b":
            return "9";
        case "pp":
            return "9";
        case "py":
            return "9";
        case "bb":
            return "9";
        case "by":
            return "9";
        default:
            return "";
        }
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func digitColor(digit:String) -> UIColor {
        switch digit {
        case "0":
            return Logic.hexStringToUIColor(hex:"#90CAF9");
        case "1":
            return Logic.hexStringToUIColor(hex:"#81D4FA");
        case "2":
            return Logic.hexStringToUIColor(hex:"#CE93D8");
        case "3":
            return Logic.hexStringToUIColor(hex:"#9FA8DA");
        case "4":
            return Logic.hexStringToUIColor(hex:"#F48FB1");
        case "5":
            return Logic.hexStringToUIColor(hex:"#A5D6A7");
        case "6":
            return Logic.hexStringToUIColor(hex:"#E6EE9C");
        case "7":
            return Logic.hexStringToUIColor(hex:"#FFE082");
        case "8":
            return Logic.hexStringToUIColor(hex:"#FFAB91");
        case "9":
            return Logic.hexStringToUIColor(hex:"#EF9A9A");
        default:
            return Logic.hexStringToUIColor(hex:"#EEEEEE");
        }
    }
    
    static func substring(string: String, fromIndex: Int, toIndex: Int) -> String? {
        let startIndex = string.index(string.startIndex, offsetBy: fromIndex)
        let endIndex = string.index(string.startIndex, offsetBy: toIndex)
        return String(string[startIndex..<endIndex])
    }
    
    static func primaryColor() -> UIColor {
        return hexStringToUIColor(hex: "#2C2C2C");
    }
    
    static func activeBarColor() -> UIColor {
        return hexStringToUIColor(hex: "#333333");
    }
    
    static func textColor() -> UIColor {
        return hexStringToUIColor(hex: "#EEEEEE");
    }
}
