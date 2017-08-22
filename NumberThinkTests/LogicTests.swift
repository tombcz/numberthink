
import XCTest
@testable import NumberThink

class LogicTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testLookupWordForNumber() {
        let x = Logic.lookupWordForNumber(number:"1")
        assert(x == "tie")
    }

    func testConvertNumberToPhrase() {
        let x = Logic.convertNumberToPhrase(number: "123")
        assert(x[0] == "tin")
        assert(x[1] == "mow")
    }
    
    func testConvertWordToSounds() {

        var x = Logic.convertWordToSounds(word:"t");
        assert(x.count == 1)
        assert(x[0] == "t")

        x = Logic.convertWordToSounds(word:"tim");
        assert(x.count == 3)
        assert(x[0] == "t")
        assert(x[1] == "i")
        assert(x[2] == "m")

        x = Logic.convertWordToSounds(word:"hello");
        assert(x.count == 4)
        assert(x[0] == "h")
        assert(x[1] == "e")
        assert(x[2] == "ll")
        assert(x[3] == "o")
    }
    
    func testIsIgnored() {
        var x = Logic.isIgnored(s: "a")
        assert(x == true)
        x = Logic.isIgnored(s: "t")
        assert(x == false)
    }
    
    func testDigitForSound() {
        let x = Logic.digitForSound(s:"ll")
        assert(x == "5")
    }
    
    func testsubstring()
    {
        let s = "hello there"
        let x = Logic.substring(string: s, fromIndex: 0, toIndex: 1)
        assert(x == "h")
    }
}
