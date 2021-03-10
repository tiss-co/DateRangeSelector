import UIKit

class DayCollectionCell: UICollectionViewCell {
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var markedView: UIView!
    @IBOutlet var markedViewWidth: NSLayoutConstraint!
    @IBOutlet var markedViewHeight: NSLayoutConstraint!
    
    var highlightColor = UIColor(red: 11/255.0, green: 75/255.0, blue: 105/255.0, alpha: 1)
    var todayHighlightColor: UIColor = .red
    var todayTextColor: UIColor = .white
    var highlightScale: CGFloat = 0.8
    lazy var yHighlightPosition : CGFloat = height * ((1.0 - highlightScale)/2)
    
    var selectedView: UIView?
    var halfBackgroundView: UIView?
    var roundHighlightView: UIView?
    lazy var width = self.frame.size.width
    lazy var height = self.frame.size.height
    

    var date: Date? {
        didSet {
            if date != nil {
                label.text = "\(date!.day)"
            } else {
                label.text = ""
            }
        }
    }
    
    var disabled: Bool = false {
        didSet {
            if disabled {
                label.textColor = UIColor.lightGray.withAlphaComponent(0.30)
            } else {
                label.textColor = UIColor.darkGray
            }
        }
    }
    
    var mark: Bool = false {
        didSet {
            if mark {
                markedView!.isHidden = false
                markedView.backgroundColor = highlightColor.withAlphaComponent(1)
                label.textColor = .white
            } else {
                markedView!.isHidden = true
            }
        }
    }
    
    var idToday : Bool = false{
        didSet {
            if mark {
                markedView!.isHidden = false
                markedView.backgroundColor = todayTextColor
                label.textColor = todayTextColor
            } else {
                markedView!.isHidden = true
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        markedViewWidth!.constant = min(self.frame.width, self.frame.height)
        markedViewHeight!.constant = min(self.frame.width, self.frame.height)
        markedView!.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2.0
    }
    
    func config(date: Date,
                fetchDate: Date?,
                startDate: Date?,
                endDate: Date?,
                isDisable: Bool) {
        self.date = fetchDate
        self.disabled = isDisable
        self.reset()
        
        validateToday(date: date)
        validateMark(date: date, startDate: startDate, endDate: endDate)
        validateHighlight(date: date, startDate: startDate, endDate: endDate)
    }
    
    func setCellProperties(highlightColor: UIColor,
                                    highlightScale: CGFloat,
                                    todayHighlightColor: UIColor,
                                    todayTextColor: UIColor,
                                    dayTextColor:UIColor,
                                    dayFont: UIFont){
        self.highlightColor = highlightColor
        self.highlightScale = highlightScale
        self.todayHighlightColor = todayHighlightColor
        self.todayTextColor = todayTextColor
        self.label.textColor = dayTextColor
        self.label.font = dayFont
    }
    
    func validateToday(date: Date){
        if Date().areSameDay(date: date), !disabled {
            self.today()
        }
    }
    
    func validateMark(date: Date?, startDate: Date?, endDate: Date?){
        guard let date = date, let startDate = startDate else {
            self.mark = false
            return
        }
        if date.areSameDay(date: startDate) || date.areSameDay(date: endDate) {
            self.mark = !disabled
        }else{
            self.mark = false
        }
    }
    
    func validateHighlight(date: Date, startDate: Date?, endDate: Date?) {
        guard let startDate = startDate, let endDate = endDate, !disabled else {
            return
        }
        highlightRange(startDate: startDate, endDate: endDate, date: date)
    }
    
    func highlightRange(startDate: Date, endDate: Date, date: Date){
        if date >= startDate && date <= endDate && startDate != endDate {
            if date.areSameDay(date: startDate) {
                self.highlightRight()
            }else if date.areSameDay(date: endDate){
                self.highlightLeft()
            }else{
                self.highlight()
            }
        }
    }
    
    func reset() {
        resetView(view: &selectedView)
        resetView(view: &halfBackgroundView)
        resetView(view: &roundHighlightView)
    }
    
    func resetView(view: inout UIView?){
        if view != nil {
            view?.removeFromSuperview()
            view = nil
        }
    }
    
    func today() {
        selectedView = UIView(frame: CGRect(x: (width - height) / 2, y: 0, width: height, height: height))
        selectedView?.backgroundColor = todayHighlightColor
        selectedView?.layer.cornerRadius = height / 2
        self.addSubview(selectedView!)
        self.sendSubviewToBack(selectedView!)
        label.textColor = UIColor.white
    }
    
    func select() {
        let width = self.width * 0.9
        let height = self.height * 0.9
        selectedView = UIView(frame: CGRect(x: (width - height) / 2, y: 0, width: height, height: height))
        selectedView?.backgroundColor = highlightColor.withAlphaComponent(1)
        selectedView?.layer.cornerRadius = height / 2
        label.textColor = todayTextColor
        self.addSubview(selectedView!)
        self.sendSubviewToBack(selectedView!)
    }
    
    func highlightRight() {
        halfBackgroundView = UIView(frame: CGRect(x: width / 2, y: yHighlightPosition, width: width / 2, height: height*highlightScale))
        halfBackgroundView?.backgroundColor = highlightColor.withAlphaComponent(0.3)
        self.addSubview(halfBackgroundView!)
        self.sendSubviewToBack(halfBackgroundView!)
        addRoundHighlightView()
    }
    
    func highlightLeft() {
        halfBackgroundView = UIView(frame: CGRect(x: 0, y: yHighlightPosition, width: width / 2, height: height*highlightScale))
        halfBackgroundView?.backgroundColor = highlightColor.withAlphaComponent(0.3)
        self.addSubview(halfBackgroundView!)
        self.sendSubviewToBack(halfBackgroundView!)
        addRoundHighlightView()
    }
    
    func addRoundHighlightView() {
        roundHighlightView = UIView(frame: CGRect(x: (width - height) / 2, y: 0, width: height, height: height))
        roundHighlightView?.backgroundColor = highlightColor.withAlphaComponent(1)
        roundHighlightView?.layer.cornerRadius = height / 2
        self.addSubview(roundHighlightView!)
        self.sendSubviewToBack(roundHighlightView!)
    }
    
    func highlight() {
        roundHighlightView = UIView(frame: CGRect(x: 0, y: yHighlightPosition, width: width, height: height*highlightScale))
        roundHighlightView?.backgroundColor = highlightColor.withAlphaComponent(0.3)
        self.addSubview(roundHighlightView!)
        self.sendSubviewToBack(roundHighlightView!)
    }

}


extension DayCollectionCell {
    class func register(for collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: DayCollectionCell.nameOfClass, bundle: CalendarViewFrameworkBundle.main),
                                forCellWithReuseIdentifier:  DayCollectionCell.nameOfClass)
    }
}
