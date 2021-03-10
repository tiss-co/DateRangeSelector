import UIKit

protocol MonthCollectionCellDelegate: class {
    func didSelect(startDate: Date? , endDate : Date?)
    func isStartOrEnd(date : Date) -> Bool
    func isBetweenStartAndEnd(date : Date) -> Bool
}

class MonthCollectionCell: UICollectionViewCell {
    
    @IBOutlet var collectionView: UICollectionView!
    
    weak var monthCellDelegate: MonthCollectionCellDelegate?
    var startDate : Date?
    var endDate : Date?
    let columns = 7
    var rows = 6
    lazy var total = columns * rows
    var dates = [Date]()
    var previousMonthVisibleDatesCount = 0
    var currentMonthVisibleDatesCount = 0
    var nextMonthVisibleDatesCount = 0
    var headerHeight : CGFloat = 40.0
    var maxDate: Date = Date()
    var logic: CalendarLogic? {
        didSet {
            populateDates()
            collectionView.reloadData()
        }
    }
    
    var highlightColor: UIColor = UIColor(red: 11/255.0, green: 75/255.0, blue: 105/255.0, alpha: 1)
    var highlightScale: CGFloat = 0.8
    var todayHighlightColor: UIColor = .red
    var todayTextColor: UIColor = .white
    var dayTextColor: UIColor = .gray
    var dayFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DayCollectionCell.register(for: collectionView)
        WeekHeaderView.register(for: collectionView)
    }
    
    func setUserInterfaceProperties(highlightColor: UIColor,
                                    highlightScale: CGFloat,
                                    todayHighlightColor: UIColor,
                                    todayTextColor: UIColor,
                                    dayTextColor: UIColor,
                                    dayFont: UIFont){
        self.highlightColor = highlightColor
        self.highlightScale = highlightScale
        self.todayHighlightColor = todayHighlightColor
        self.todayTextColor = todayTextColor
        self.dayFont = dayFont
    }
    
    func populateDates() {
        if let logic = logic {
            dates = []
            dates += logic.previousMonthVisibleDays!
            dates += logic.currentMonthDays!
            dates += logic.nextMonthVisibleDays!
            
            previousMonthVisibleDatesCount = logic.previousMonthVisibleDays!.count
            currentMonthVisibleDatesCount = logic.currentMonthDays!.count
            nextMonthVisibleDatesCount = logic.nextMonthVisibleDays!.count

        } else {
            dates.removeAll(keepingCapacity: false)
        }
    }
    
    func setStartAndEndDate(start: Date?, end: Date?){
        startDate = start
        endDate = end
        self.collectionView.layoutIfNeeded()
    }
}

extension MonthCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionCell.nameOfClass,for: indexPath) as! DayCollectionCell
        let date = dates[indexPath.item]
        let validateDate = fetchDate(indexPath: indexPath, date: date)
        let isDisable = isValidDate(indexPath: indexPath, date: date)
        cell.setCellProperties(highlightColor: highlightColor,
                               highlightScale: highlightScale,
                               todayHighlightColor: todayHighlightColor,
                               todayTextColor: todayTextColor,
                               dayTextColor: dayTextColor,
                               dayFont: dayFont)
        cell.config(date: date,
                    fetchDate: validateDate,
                    startDate: startDate,
                    endDate: endDate,
                    isDisable: isDisable)
        return cell
    }
    
    func fetchDate(indexPath: IndexPath, date: Date)-> Date?{
        return (indexPath.item < dates.count) ? date : nil
    }
    
    func isValidDate(indexPath: IndexPath, date: Date)-> Bool {
        let totalDay = previousMonthVisibleDatesCount
            + currentMonthVisibleDatesCount
        return (indexPath.item < previousMonthVisibleDatesCount) ||
            (indexPath.item >= totalDay) ||
            date > maxDate
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let date = dates[indexPath.item]
        let isVisible = self.logic!.isVisible(date: date)
        validateRange(date: date, isVisible: isVisible)
        collectionView.layoutIfNeeded()
    }
    
    func validateRange(date: Date, isVisible: Bool){
        if date <= maxDate && isVisible {
            if startDate != nil && endDate == nil && date >= startDate! {
                monthCellDelegate?.didSelect(startDate: startDate!, endDate: date)
            }
            else{
                monthCellDelegate?.didSelect(startDate: date, endDate: nil)
            }
        }
    }
}

extension MonthCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: WeekHeaderView.nameOfClass,
            for: indexPath
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/7.001, height: (collectionView.frame.height-headerHeight)/6.5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
}

extension MonthCollectionCell {
    class func register(for collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: MonthCollectionCell.nameOfClass, bundle: CalendarViewFrameworkBundle.main),
                                forCellWithReuseIdentifier:  MonthCollectionCell.nameOfClass)
    }
}
