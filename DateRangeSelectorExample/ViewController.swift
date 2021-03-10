//
//  ViewController.swift
//  DateRangeSelectorExample
//
//  Created by Amir on 3/4/21.
//

import UIKit
import DateRangeSelector

class ViewController: UIViewController {

    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var saveMonthButton: UIButton!
    @IBOutlet weak var resetMonthButton: UIButton!
    @IBOutlet weak var fromValueLabel: UILabel!
    @IBOutlet weak var toValueLabel: UILabel!
    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCalendarUI()
        calendarView.delegate = self
    }
    
    func setupUI(){
        saveMonthButton.layer.borderWidth = 1
        saveMonthButton.layer.borderColor = UIColor.gray.cgColor
        saveMonthButton.layer.cornerRadius = 8
        resetMonthButton.layer.borderWidth = 1
        resetMonthButton.layer.borderColor = UIColor.gray.cgColor
        resetMonthButton.layer.cornerRadius = 8
    }
    
    func setupCalendarUI(){
        calendarView.selectedYear = 2019
        calendarView.maxDate = Date()
        calendarView.previousButtonIsEnable = true
        calendarView.nextButtonIsEnable  = true
        calendarView.headerTitleColor = .darkGray
        calendarView.headerTitleFont = UIFont.systemFont(ofSize: 18)
        calendarView.headerBackgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        calendarView.previousButtonTitleColor = .darkGray
        calendarView.previousButtonTitleFont = UIFont.systemFont(ofSize: 20)
        calendarView.previousButtonAligment = .right
        calendarView.nextButtonTitleColor = .darkGray
        calendarView.nextButtonTitleFont = UIFont.systemFont(ofSize: 20)
        calendarView.nextButtonAligment = .left
        calendarView.highlightColor = UIColor(red: 11/255.0, green: 75/255.0, blue: 105/255.0, alpha: 1)
        calendarView.highlightScale = 0.8
        calendarView.todayHighlightColor = .red
        calendarView.todayTextColor = .white
        calendarView.dayTextColor = .gray
        calendarView.dayFont = UIFont.systemFont(ofSize: 16)
    }
    
    
    @IBAction func saveMonthButtonPressed(_ sender: Any) {
        guard let monthCount = monthTextField.text else {
            return
        }
        calendarView.monthRange = Int(monthCount) ?? 12
        monthTextField.endEditing(true)
    }
    
    @IBAction func resetMonthButtonPressed(_ sender: Any) {
        calendarView.monthRange = 12
        monthTextField.text = ""
        monthTextField.endEditing(true)
    }
    
}

extension ViewController: CalendarViewDelegate {
    func didSelectDate(startDate: Date, endDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        fromValueLabel.text = dateFormatter.string(from: startDate)
        toValueLabel.text = dateFormatter.string(from: endDate)
    }
}


