
import UIKit

class AboutView: UIView {

    @IBOutlet var contentView: UIView!
    override init(frame:CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        commonInit()
    }
    
    @IBOutlet weak var contentTextView: UITextView!
    private func commonInit() {
        Bundle.main.loadNibNamed("AboutView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
