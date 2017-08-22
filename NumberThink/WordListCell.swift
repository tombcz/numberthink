
import UIKit

protocol WordListCellDelegate {
    func cellDidBeginEditing(_ editingCell: WordListCell)
    func cellDidEndEditing(_ editingCell: WordListCell)
}

class WordListCell: UITableViewCell, UITextFieldDelegate {
    
    let label:UITextField
    let numberLabel:UILabel

    var origWord:String = ""
    var delegate: WordListCellDelegate?

    var listItems:WordListItem? {
        didSet {
            label.text = listItems!.text
            numberLabel.text = listItems!.number
            origWord = listItems!.text
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        label = UITextField(frame: CGRect.null)
        numberLabel = UILabel(frame:CGRect.null)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Logic.primaryColor()
        
        label.textColor = Logic.textColor()
        label.font = UIFont.systemFont(ofSize: 20)
        label.delegate = self
        label.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        addSubview(label)
        
        numberLabel.font = UIFont.systemFont(ofSize: 26)
        numberLabel.textColor = Logic.textColor()
        addSubview(numberLabel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    let leftMarginForLabel: CGFloat = 22.0
    let numberWidth: CGFloat = 18.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: leftMarginForLabel + numberWidth + leftMarginForLabel, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
        numberLabel.frame = CGRect(x: leftMarginForLabel, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if listItems != nil {
            self.listItems?.text = textField.text!
        }
        
        if delegate != nil {
            delegate?.cellDidEndEditing(self)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if delegate != nil {
            delegate!.cellDidBeginEditing(self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
