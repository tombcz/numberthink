
import UIKit

class WordListView: UIView, UITableViewDelegate, UITableViewDataSource, WordListCellDelegate {
    
    @IBOutlet weak var TableView: UITableView!
    
    var items: [WordListItem] = []
    
    @IBOutlet var contentView: UIView!
    override init(frame:CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("WordListView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        TableView.register(WordListCell.self, forCellReuseIdentifier: "cell")

        let dict = Csv.readWords()
        for (k,v) in (Array(dict).sorted {Int($0.1)! < Int($1.1)!}) {
            items.append(WordListItem(text:k, number:v))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WordListCell
        cell.listItems = items[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate = self
        return cell
    }

    // MARK: - TableViewCellDelegate methods
    
    func cellDidBeginEditing(_ editingCell: WordListCell) {
        let editingOffset = self.TableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
        let visibleCells = self.TableView.visibleCells as! [WordListCell]
        for cell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                cell.transform = CGAffineTransform(translationX: 0, y: editingOffset)
                if cell != editingCell {
                    cell.alpha = 0.3
                }
            })
        }
    }
    
    func cellDidEndEditing(_ editingCell: WordListCell) {
        
        if editingCell.listItems?.text == "" {
            editingCell.listItems?.text = editingCell.origWord
        }
        
        if editingCell.listItems?.text != editingCell.origWord {
            Csv.update(word:editingCell.origWord, newWord:(editingCell.listItems?.text)!)
        }
        
        let visibleCells = self.TableView.visibleCells as! [WordListCell]
        let lastView = visibleCells[visibleCells.count - 1] as WordListCell
        for cell: WordListCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                cell.transform = CGAffineTransform.identity
                if cell != editingCell {
                    cell.alpha = 1.0
                }
            }, completion: { (Finished: Bool) -> Void in
                if cell == lastView {
                    self.TableView.reloadData()
                }
            })
        }
    }
}
