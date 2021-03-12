# DateRangeSelector

<img width="200" alt="Screen Shot 2021-03-10 at 4 02 20 PM" src="https://user-images.githubusercontent.com/35375629/110629989-115ade00-81ba-11eb-85af-f6d5f026066c.png"> 

# Requirements
- Xcode 11+
- Swift 5
- iOS 10.0+


# Installation


## Cocoapods
```ruby
pod 'DateRangeSelector', :git => 'git@github.com:boof-tech/DateRangeSelector.git', :tag => '0.0.2'
```

# Usage

### Import DateRangeSelector
```swift
import DateRangeSelector
```

### Create an instance of Calendar
```swift
let frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 300)
var calendarView: CalendarView = CalendarView(frame: frame)

```
### Setup Calendar
```swift
calendarView.monthRange = 12 // Show the 12 month ago of Max Date
calendarView.selectedYear = 2019 // The defult value is now year but when you set selected year, the range month of year is changed

```

### Delegate
```swift
class ViewController: UIViewController {
override func viewDidLoad() {
    super.viewDidLoad()
    ...
    calendarView.delegate = self
}
...
}

extension ViewController: CalendarViewDelegate {
    func didSelectDate(startDate: Date, endDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        fromValueLabel.text = dateFormatter.string(from: startDate)
        toValueLabel.text = dateFormatter.string(from: endDate)
    }
}
```

### Customize gauge

- Max Date
```swift
calendarView.maxDate = Date() // Limited to show future days
```

- Header Calendar
```swift 
calendarView.headerTitleColor = .darkGray
calendarView.headerTitleFont = UIFont.systemFont(ofSize: 18)
calendarView.headerBackgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
```
- Previous and Next Month
```swift 
calendarView.previousButtonIsEnable = true
calendarView.nextButtonIsEnable  = true
calendarView.previousButtonTitleColor = .darkGray
calendarView.previousButtonTitleFont = UIFont.systemFont(ofSize: 20)
calendarView.previousButtonAligment = .right
calendarView.nextButtonTitleColor = .darkGray
calendarView.nextButtonTitleFont = UIFont.systemFont(ofSize: 20)
calendarView.nextButtonAligment = .left
```
- Highlight
```swift 
calendarView.highlightColor = UIColor(red: 11/255.0, green: 75/255.0, blue: 105/255.0, alpha: 1)
calendarView.highlightScale = 0.8
```
- Today
```swift 
calendarView.todayHighlightColor = .red
calendarView.todayTextColor = .white
```
- Day
```swift 
calendarView.dayTextColor = .gray
calendarView.dayFont = UIFont.systemFont(ofSize: 16)
```

## Licence
Date Range Selector is available under the MIT license. See the [LICENSE.txt](https://github.com/boof-tech/DateRangeSelector/blob/main/LICENSE) file for more info.


