
import UIKit

class WeekHeaderView: UICollectionReusableView {

    @IBOutlet var labels: [UILabel]!
    let formatter = DateFormatter()
    var bgColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5)
    var textColor: UIColor = UIColor.darkGray
    
    override func awakeFromNib() {
        self.backgroundColor = bgColor
        labels.forEach { $0.textColor = textColor }
        if labels.count == formatter.weekdaySymbols.count {
            let weekdaySymbols = formatter.weekdaySymbols!
            (0..<weekdaySymbols.count).forEach { index in
                labels[index].text = String(weekdaySymbols[index].prefix(1)).uppercased()
            }
        }
    }
    
}

extension WeekHeaderView {
    class func register(for collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: WeekHeaderView.nameOfClass,
                                      bundle: CalendarViewFrameworkBundle.main),
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeekHeaderView.nameOfClass)
    }
}
