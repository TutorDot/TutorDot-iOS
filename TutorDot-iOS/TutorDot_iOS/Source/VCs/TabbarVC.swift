//
//  TabbarVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 29/06/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {

    static let identifier:String = "TabbarVC"
            
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.white
        tabBarSetUp()
        viewDidLayoutSubviews()
        self.tabBar.backgroundColor = UIColor.white
       
    }
    
    override func viewDidLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
        if self.view.frame.size.height > 800 {
            tabFrame.size.height = 80
            tabFrame.origin.y = self.view.frame.size.height - 80
            self.tabBar.frame = tabFrame
        } else {
            tabFrame.size.height = 68
            tabFrame.origin.y = self.view.frame.size.height - 68
            self.tabBar.frame = tabFrame
        }
    
    }
    
    func tabBarSetUp(){
        // Calendar Tab
        let calendarStoryboard = UIStoryboard.init(name: "Calendar", bundle: nil)

        guard let firstTab = calendarStoryboard.instantiateViewController(identifier: "CalendarVC")
            as? CalendarVC  else {
            return
        }
        
        if self.view.frame.size.height > 800 {
            firstTab.tabBarItem.image = UIImage(named: "tabbarIcCalenderUnpick")?.withRenderingMode(.alwaysOriginal)
            firstTab.tabBarItem.selectedImage = UIImage(named: "calenderBalnkIcnCalender")?.withRenderingMode(.alwaysOriginal)

            print(#function)
        } else {
            firstTab.tabBarItem.image = UIImage(named: "classLogMathIcCalenderPick")?.withRenderingMode(.alwaysOriginal)
            firstTab.tabBarItem.selectedImage = UIImage(named: "calenderBalnkIcnCalender")?.withRenderingMode(.alwaysOriginal)

        }
        
        
        // Notes Tab
        let notesStoryboard = UIStoryboard.init(name: "Notes", bundle: nil)
        guard let secondTab = notesStoryboard.instantiateViewController(identifier: "NotesMainVC")
            as? NotesMainVC  else {
            return
        }
        if self.view.frame.size.height > 800 {
        secondTab.tabBarItem.image = UIImage(named: "calenderBalnkIcnClasslog")?.withRenderingMode(.alwaysOriginal)
        secondTab.tabBarItem.selectedImage = UIImage(named: "tabbarIcClassLogPick")?.withRenderingMode(.alwaysOriginal)
        } else {
            secondTab.tabBarItem.image = UIImage(named: "calenderBalnkIcnClasslog")?.withRenderingMode(.alwaysOriginal)
            secondTab.tabBarItem.selectedImage = UIImage(named: "classLogMathIcClassLogPick")?.withRenderingMode(.alwaysOriginal)
        }
        // Alert Tab
        let alertStoryboard = UIStoryboard.init(name: "Alert", bundle: nil)
        guard let thirdTab = alertStoryboard.instantiateViewController(identifier: "AlertVC")
            as? AlertVC  else {
            return
        }
        if self.view.frame.size.height > 800 {
        thirdTab.tabBarItem.image = UIImage(named: "calenderIcnMemo")?.withRenderingMode(.alwaysOriginal)
        thirdTab.tabBarItem.selectedImage = UIImage(named: "tabbarIcNoticePick")?.withRenderingMode(.alwaysOriginal)
        } else {
            thirdTab.tabBarItem.image = UIImage(named: "calenderIcnMemo")?.withRenderingMode(.alwaysOriginal)
            thirdTab.tabBarItem.selectedImage = UIImage(named: "noticeBlankIcNoticePick")?.withRenderingMode(.alwaysOriginal)
        }
        
        // MyPage Tab
        let personalInfoStoryboard = UIStoryboard.init(name: "MyPage", bundle: nil)
        guard let fourthTab = personalInfoStoryboard.instantiateViewController(identifier: "MyPageVC")
            as? MyPageVC  else {
            return
        }

        if self.view.frame.size.height > 800 {

        fourthTab.tabBarItem.image = UIImage(named: "calenderBalnkIcnMy")
        fourthTab.tabBarItem.selectedImage = UIImage(named: "tabbarIcMyPick")?.withRenderingMode(.alwaysOriginal)
        } else {
            fourthTab.tabBarItem.image = UIImage(named: "calenderBalnkIcnMy")
            fourthTab.tabBarItem.selectedImage = UIImage(named: "myIcMyPick")?.withRenderingMode(.alwaysOriginal)
        }
        let tabs =  [firstTab, secondTab, thirdTab, fourthTab]

        self.setViewControllers(tabs, animated: false)
        self.selectedViewController = firstTab


    }
}

class CustomTabbar: UITabBar {
    func setup() {
        backgroundColor = .green
    }
}





