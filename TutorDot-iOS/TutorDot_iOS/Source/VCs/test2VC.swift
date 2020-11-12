//
//  test2VC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/12.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import FSCalendar

class test2VC: UIViewController,FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var calendar: FSCalendar!
   
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
//    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
//        [unowned self] in
//        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
//        panGesture.delegate = self
//        panGesture.minimumNumberOfTouches = 1
//        panGesture.maximumNumberOfTouches = 2
//        return panGesture
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
        
//        if UIDevice.current.model.hasPrefix("iPad") {
//            self.calendarHeightConstraint.constant = 400
//        }
        
        self.calendar.select(Date())
        
        //self.view.addGestureRecognizer(self.scopeGesture)
        //self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .month
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
     
    }
    
    deinit {
        print("\(#function)")
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
//        if shouldBegin {
//            let velocity = self.scopeGesture.velocity(in: self.view)
//            switch self.calendar.scope {
//            case .month:
//                return velocity.y < 0
//            case .week:
//                return velocity.y > 0
//            }
//        }
//        return shouldBegin
//    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    var dates = ["2020-11-05", "2020-11-07", "2020-11-07"]
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter3.string(from: date)

        if self.dates.contains(dateString){
            cell.eventIndicator.numberOfEvents = 2
            //display events as dots
            cell.eventIndicator.isHidden = false
            cell.eventIndicator.color = UIColor.red
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd"
          let strDate = dateFormatter3.string(from: date)

            if dates.contains(strDate) && dates.contains(strDate)
            {
                return [UIColor.red ,UIColor.blue]
            }
            else if dates.contains(strDate)
            {
                 return [UIColor.red]
            }
            else if dates.contains(strDate)
            {
                 return [UIColor.blue]
            }

                return [UIColor.clear]
        }
    
    
    
    
    
    // MARK:- UITableViewDataSource
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return [2,20][section]
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let identifier = ["cell_month", "cell_week"][indexPath.row]
//            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EventTableViewCell
//            return cell
//        }
//    }
//    
//    
//    // MARK:- UITableViewDelegate
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.section == 0 {
//            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
//            self.calendar.setScope(scope, animated: self.animationSwitch.isOn)
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
//    
//    // MARK:- Target actions
//    
//    @IBAction func toogleClicked(_ sender: Any) {
//        if self.calendar.scope == .month {
//            self.calendar.setScope(.week, animated: self.animationSwitch.isOn)
//        } else {
//            self.calendar.setScope(.month, animated: self.animationSwitch.isOn)
//        }
//    }
//   
//    
//    @IBAction func BackTapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    

   

}
