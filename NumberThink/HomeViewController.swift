
import UIKit

class HomeViewController: UIViewController {
    
    enum Mode {
        case None
        case Quiz
        case Teach
    }
    
    var mode = Mode.None
    var quizNumber = ""
    var quizOver = false
    
    @IBOutlet weak var wordsTextView: UITextView!
    @IBOutlet weak var numbersTextView: UITextView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var sideButtonView: UIView!
    @IBOutlet weak var aboutView: AboutView!
    @IBOutlet weak var wordListView: WordListView!
    @IBOutlet weak var helpView: HelpView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // MARK: VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.clipsToBounds = true // hide bottom line
        mode = Mode.Teach
        clearDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        aboutView.contentTextView.isScrollEnabled = true
    }
    
    // MARK: UI Actions
    
    @IBAction func addDigit(_ sender: Any) {
        
        // limit the teach mode to 7 digits
        if(numbersTextView.attributedText.length == 7) {
            showToast(message: "Whoa there, 7 digits is the limit")
            return;
        }
        
        // ignore input if a quiz has ended
        if mode == Mode.Quiz && quizOver == true {
            return;
        }
        
        let button: UIButton = sender as! UIButton
        let digit = button.titleLabel?.text
        
        let color = Logic.digitColor(digit: digit!)
        
        let multipleAttributes: [String : Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 60),
            NSForegroundColorAttributeName: color]
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(numbersTextView.attributedText)
        attributedString.append(NSAttributedString(string:digit!, attributes:multipleAttributes))
        numbersTextView.attributedText = attributedString
        
        switch(mode) {
        case Mode.Teach:
            updateWords(number:numbersTextView.text)
            break;
        case Mode.Quiz:
            checkForQuizEnded()
            break;
        case Mode.None:
            break;
        }
    }
    
    @IBAction func beginQuiz(_ sender: Any) {
        mode = Mode.Quiz
        clearDisplay()
        quizOver = false
        quizNumber = String(format: "%d", arc4random() % 100)
        updateWords(number: quizNumber)
        showToast(message: "What is the number?")
    }
    
    @IBAction func beginTeach(_ sender: Any) {
        mode = Mode.Teach
        clearDisplay()
        showToast(message: "Enter a number")
    }
    
    @IBAction func showInfo(_ sender: Any) {
        showSideView(view: aboutView, title: "About")
    }
    
    @IBAction func showInfoModal(_ sender: Any) {
        showModalView(view: AboutView(), title:"About")
    }
    
    @IBAction func showSettings(_ sender: Any) {
        showSideView(view: wordListView, title: "Peg Words")
    }
    
    @IBAction func showSettingsModal(_ sender: Any) {
        showModalView(view: WordListView(), title:"Peg Words")
    }
    
    @IBAction func showHelp(_ sender: Any) {
        showSideView(view: helpView, title: "Cheat Sheet")
    }
    
    @IBAction func showHelpModal(_ sender: Any) {
        showModalView(view: HelpView(), title:"Cheat Sheet")
    }
    
    // MARK: Helpers
    
    func clearDisplay() {
        numbersTextView.text = ""
        wordsTextView.text = ""
        quizImageView.isHidden = true
    }
    
    func updateWords(number:String) {
        let attributedString = NSMutableAttributedString()
        
        var associatedSoundList = [String]()
        let words = Logic.convertNumberToPhrase(number:number)
        for word in words {
            
            let sounds = Logic.convertWordToSounds(word: word)
            
            for sound in sounds {
                
                let digit = Logic.digitForSound(s: sound)
                var color = Logic.digitColor(digit: digit)
                
                if digit != "" {
                    associatedSoundList.append(sound)
                }
                
                if mode == Mode.Quiz && quizOver == false {
                    
                    // it overlaps by x digits, so we know that the first
                    // x sounds (that are actual major system sounds) are
                    // matched
                    let overlapCount = min(number.characters.count, numbersTextView.attributedText.string.characters.count)
                    if(associatedSoundList.count > overlapCount) {
                        color = Logic.textColor()
                    }
                }
                
                let multipleAttributes: [String : Any] = [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 60),
                    NSForegroundColorAttributeName: color]
                
                attributedString.append(NSAttributedString(string:sound, attributes:multipleAttributes))
            }
            
            let multipleAttributes: [String : Any] = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 60)]
            
            attributedString.append(NSAttributedString(string:" ", attributes:multipleAttributes))
        }
        
        wordsTextView.attributedText = attributedString
        
        // need to delay the line count calculation for some reason
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            let lineCount = (self.wordsTextView.contentSize.height - self.wordsTextView.textContainerInset.top - self.wordsTextView.textContainerInset.bottom) / (self.wordsTextView.font?.lineHeight)!;
            if(lineCount >= 2) {
                self.wordsTextView.flashScrollIndicators()
            }
        }
    }
    
    func checkForQuizEnded() {
        if quizOver == false {
            if numbersTextView.attributedText.string == quizNumber {
                // correct
                quizOver = true
                quizImageView.image = UIImage(named:"ic_mood_96p")
                quizImageView.tintColor = Logic.hexStringToUIColor(hex:"#66BB6A") // green 400
                quizImageView.isHidden = false
            }
            
            if quizNumber.hasPrefix(numbersTextView.attributedText.string) == false {
                // incorrect
                quizOver = true
                quizImageView.image = UIImage(named:"ic_mood_bad_96p")
                quizImageView.tintColor = Logic.hexStringToUIColor(hex:"#EF5350") // red 400
                quizImageView.isHidden = false
            }
            updateWords(number:quizNumber)
        }
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-60, width: 300, height: 40))
        toastLabel.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        toastLabel.textColor = Logic.textColor()
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 22)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 2;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showSideView(view: UIView, title:String) {
        view.isHidden = false
        sideButtonView.isHidden = true
        navigationBar.topItem?.title = title
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_close_24p"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(hideSideView(sender:)))
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = Logic.activeBarColor()
    }
    
    func hideSideView(sender: UIBarButtonItem) {
        wordListView.isHidden = true
        aboutView.isHidden = true
        helpView.isHidden = true
        navigationBar.topItem?.leftBarButtonItem = nil
        navigationBar.topItem?.title = nil
        sideButtonView.isHidden = false
        navigationBar.barTintColor = Logic.primaryColor()
    }
    
    func showModalView(view: UIView, title:String) {
        let viewController = UIViewController()
        viewController.view.addSubview(view)
        view.frame = viewController.view.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = Logic.activeBarColor()
        navigationController.navigationBar.topItem?.title = title
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Logic.textColor()]
        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_close_24p"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissModal(sender:)))
        navigationController.navigationBar.topItem?.leftBarButtonItem?.tintColor = Logic.textColor()
        
        present(navigationController, animated: true, completion:{
            
            // this is a hack around UITextView's insistence on always initially scrolling
            // to the bottom of the content set in IB
            if view is AboutView {
                let aboutView = view as! AboutView
                aboutView.contentTextView.isScrollEnabled = true
            }
        })
    }
    
    func dismissModal(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
