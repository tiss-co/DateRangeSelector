import UIKit

public protocol CalendarViewDelegate: class {
    func didSelectDate(startDate: Date , endDate : Date)
}

public final class CalendarViewFrameworkBundle {
    public static let main: Bundle = Bundle(for: CalendarViewFrameworkBundle.self)
}

public class CalendarView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var monthYearLabel: UILabel!
    @IBOutlet weak var headerBgView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var previousButton: UIButton!
    
    public weak var delegate: CalendarViewDelegate?
    private var calendarItemList = [CalendarLogic]()
    
    public var monthRange = 13 {
        didSet {
            calcuteDays()
            updateHeader()
            collectionView.reloadData()
        }
    }
    public var maxDate: Date = Date() {
        didSet {
            calcuteDays()
            updateHeader()
            collectionView.reloadData()
        }
    }
    
    public var selectedYear: Int = Date().year{
        didSet {
            let date = Date.from(year: selectedYear, month: 1, day: 1)
            setStartAndEnd(date: date)
            calcuteDays(year: selectedYear)
            updateHeader()
            collectionView.reloadData()
        }
    }
    
    public var startDate: Date? {
        didSet {
            DispatchQueue.main.async { [self] in
                self.moveToSelectedDate(selectedDate: startDate,animated: false)
            }
        }
    }
    
    public var endDate: Date? {
        didSet {
            DispatchQueue.main.async { [self] in
                self.moveToSelectedDate(selectedDate: endDate,animated: false)
                guard let start = startDate , let end = endDate else { return }
                self.delegate?.didSelectDate(startDate: start, endDate : end)
            }
        }
    }
    
    public var previousButtonIsEnable: Bool = true {
        didSet {
            self.previousButton.isEnabled = previousButtonIsEnable
        }
    }
    
    public var nextButtonIsEnable: Bool = true {
        didSet {
            self.nextButton.isEnabled = nextButtonIsEnable
        }
    }
    
    public var headerTitleColor: UIColor = .darkGray{
        didSet {
            monthYearLabel.textColor = headerTitleColor
        }
    }
    
    public var headerTitleFont: UIFont = UIFont.systemFont(ofSize: 18){
        didSet {
            monthYearLabel.font = headerTitleFont
        }
    }
    
    public var headerBackgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5){
        didSet {
            headerBgView.backgroundColor = headerBackgroundColor
        }
    }
    
    public var previousButtonTitleColor: UIColor = .darkGray{
        didSet {
            previousButton.setTitleColor(previousButtonTitleColor, for: .normal)
        }
    }
    
    public var previousButtonTitleFont: UIFont = UIFont.systemFont(ofSize: 20){
        didSet {
            previousButton.titleLabel?.font = previousButtonTitleFont
        }
    }
    
    public var previousButtonAligment: NSTextAlignment = .right{
        didSet {
            previousButton.titleLabel?.textAlignment = previousButtonAligment
        }
    }
    
    public var nextButtonTitleColor: UIColor = .darkGray{
        didSet {
            nextButton.setTitleColor(nextButtonTitleColor, for: .normal)
        }
    }
    public var nextButtonTitleFont: UIFont = UIFont.systemFont(ofSize: 20){
        didSet {
            nextButton.titleLabel?.font = nextButtonTitleFont
        }
    }
    
    public var nextButtonAligment: NSTextAlignment = .left{
        didSet {
            previousButton.titleLabel?.textAlignment = previousButtonAligment
        }
    }
    
    public var highlightColor: UIColor = UIColor(red: 11/255.0, green: 75/255.0, blue: 105/255.0, alpha: 1) {
        didSet {
            collectionView.layoutSubviews()
        }
    }
    
    public var highlightScale: CGFloat = 0.8 {
        didSet {
            collectionView.layoutSubviews()
        }
    }
    
    public var todayHighlightColor: UIColor = .red {
        didSet {
            collectionView.layoutSubviews()
        }
    }
    
    public var todayTextColor: UIColor = .white {
        didSet {
            collectionView.layoutSubviews()
        }
    }
    
    public var dayTextColor: UIColor = .gray {
        didSet {
            collectionView.layoutSubviews()
        }
    }
    
    public var dayFont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            collectionView.layoutSubviews()
        }
    }
    
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        registerCell()
        setupUI()
        setupCollectionView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        registerCell()
        setupUI()
        setupCollectionView()
    }
    
    func commonInit() {
        CalendarViewFrameworkBundle.main.loadNibNamed(CalendarView.nameOfClass, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    public override func awakeFromNib() {
        registerCell()
        setupUI()
        setupCollectionView()
    }
    
    func registerCell(){
        MonthCollectionCell.register(for: collectionView)
        selectedYear = Date().year
    }
    
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupUI(){
        nextButtonTitleColor = .darkGray
        nextButtonTitleFont = UIFont.systemFont(ofSize: 20)
        previousButtonTitleColor = .darkGray
        previousButtonTitleFont = UIFont.systemFont(ofSize: 20)
        headerTitleColor = .darkGray
        headerTitleFont = UIFont.systemFont(ofSize: 18)
        headerBackgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    func calcuteDays(year: Int? = nil){
        calendarItemList = [CalendarLogic]()
        var date : Date = maxDate
        if let year = year {
            date = Date.from(year: year, month: 1, day: 1)
        }
        self.startDate = date
        self.endDate = date
        var dateIter1 = date
        var dateIter2 = date
        
        var set = Set<CalendarLogic>()
        set.insert(CalendarLogic(date: date))
        
        (0..<monthRange).forEach { _ in
            dateIter2 = dateIter2.firstDayOfPreviousMonth
            set.insert(CalendarLogic(date: dateIter2))
            
            if dateIter1.firstDayOfFollowingMonth < maxDate{
                dateIter1 = dateIter1.firstDayOfFollowingMonth
                set.insert(CalendarLogic(date: dateIter1))
            }else{
                return
            }
        }
        calendarItemList = Array(set).sorted(by: <)
    }
    
    func setStartAndEnd(date: Date?){
        startDate = date
        endDate = date
    }
    
    func updateHeader() {
        let pageNumber = Int(collectionView.contentOffset.x / collectionView.frame.width)
        updateHeader(pageNumber: pageNumber)
    }
    
    func updateHeader(pageNumber: Int) {
        if calendarItemList.count > pageNumber && pageNumber>=0{
            let logic = calendarItemList[pageNumber]
            monthYearLabel.text = logic.currentMonthAndYear as String
        }
    }
    
    @IBAction func retreatToPreviousMonth(button: UIButton) {
        advance(byIndex: -1, animate: false)
    }
    
    @IBAction func advanceToFollowingMonth(button: UIButton) {
        advance(byIndex: 1, animate: false)
    }
    
    func advance(byIndex: Int, animate: Bool) {
        var visibleIndexPath = self.collectionView.indexPathsForVisibleItems.first!
        let pageNumber = visibleIndexPath.item + byIndex
        
        if calendarItemList.count <= pageNumber || pageNumber < 0{
            return
        }
        visibleIndexPath = IndexPath(item: pageNumber,
                                     section: visibleIndexPath.section)
        updateHeader(pageNumber: pageNumber)
        collectionView.scrollToItem(at: visibleIndexPath,
                                    at: .centeredHorizontally,
                                    animated: false)
    }
    
    func moveToSelectedDate(selectedDate: Date?, animated: Bool) {
        guard let selectedDate = selectedDate else { return }
        let index = (0..<calendarItemList.count).firstIndex { index -> Bool in
            let logic = calendarItemList[index]
            if logic.containsDate(date: selectedDate) {
                return true
            }
            return false
        }
        
        if let index = index {
            let indexPath = IndexPath(item: index, section: 0)
            updateHeader(pageNumber: indexPath.item)
            collectionView.scrollToItem(at: indexPath,
                                        at: .centeredHorizontally,
                                        animated: animated)
        }
    }
    
}

extension CalendarView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return calendarItemList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MonthCollectionCell.nameOfClass,
            for: indexPath) as! MonthCollectionCell
        cell.monthCellDelegate = self
        let calendarLogic = calendarItemList[indexPath.item]
        cell.logic = calendarLogic
        cell.maxDate = maxDate
        cell.setStartAndEndDate(start: startDate, end: endDate)
        cell.setUserInterfaceProperties(highlightColor: highlightColor,
                                        highlightScale: highlightScale,
                                        todayHighlightColor: todayHighlightColor,
                                        todayTextColor: todayTextColor,
                                        dayTextColor: dayTextColor,
                                        dayFont: dayFont)
        return cell
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

extension CalendarView: UIScrollViewDelegate {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            updateHeader()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateHeader()
    }
}

extension CalendarView : MonthCollectionCellDelegate {
    func startSelectedDate() -> Date? {
        return startDate
    }
    
    func endSelectedDate() -> Date? {
        return endDate
    }

    func didSelect(startDate: Date?, endDate: Date?) {
        self.startDate = startDate ?? nil
        self.endDate = endDate ?? nil
        print(startDate , " " , endDate)
        collectionView.reloadData()
    }
    
    func isStartOrEnd(date: Date) -> Bool {
        let result = date.areSameDay(date: startDate) || date.areSameDay(date: endDate)
        return result
    }
    
    func isBetweenStartAndEnd(date: Date) -> Bool{
        guard let start = startDate, let end = endDate else { return false }
        return date >= start && date <= end && start != end
    }
}
