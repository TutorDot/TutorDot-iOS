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
        print(self.view.frame.size.height)
        
    }
    
    override func viewDidLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        //        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
        if self.view.frame.size.height > 800 {
            tabFrame.size.height = 80
            tabFrame.origin.y = self.view.frame.size.height - 80
            self.tabBar.frame = tabFrame
        } else {
            tabFrame.size.height = 68
            tabFrame.origin.y = self.view.frame.size.height - 50
            self.tabBar.frame = tabFrame
        }
        
    }
    
    func tabBarSetUp(){
        // Calendar Tab
        let calendarStoryboard = UIStoryboard.init(name: "Calendar", bundle: nil)
        
        guard let firstTab = calendarStoryboard.instantiateViewController(identifier: "CalendarNavigationController")
                as? CalendarNavigationController  else {
            return
        }
        
        firstTab.tabBarItem.image = UIImage(named: "calenderIcnUnpick")?.withRenderingMode(.alwaysOriginal)
        firstTab.tabBarItem.selectedImage = UIImage(named: "calenderIcnPick")?.withRenderingMode(.alwaysOriginal)
        firstTab.tabBarItem.title = nil
        
        
        // Notes Tab
        let notesStoryboard = UIStoryboard.init(name: "Notes", bundle: nil)
        guard let secondTab = notesStoryboard.instantiateViewController(identifier: "NotesMainVC")
                as? NotesMainVC  else {
            return
        }
        
        secondTab.tabBarItem.image = UIImage(named: "classlogIcnUnpick")?.withRenderingMode(.alwaysOriginal)
        secondTab.tabBarItem.selectedImage = UIImage(named: "classlogIcnPick")?.withRenderingMode(.alwaysOriginal)
        
        
        let questionStoryboard = UIStoryboard.init(name: "Question", bundle: nil)
        guard let thirdTab = questionStoryboard.instantiateViewController(identifier: "QuestionVC")
                as? QuestionVC  else {
            return
        }
        
        thirdTab.tabBarItem.image = UIImage(named: "questionIcnUnpick")?.withRenderingMode(.alwaysOriginal)
        thirdTab.tabBarItem.selectedImage = UIImage(named: "questionIcnPick")?.withRenderingMode(.alwaysOriginal)
        
        
        // MyPage Tab
        let personalInfoStoryboard = UIStoryboard.init(name: "MyPage", bundle: nil)
        guard let fourthTab = personalInfoStoryboard.instantiateViewController(identifier: "MyPageVC")
                as? MyPageVC  else {
            return
        }
        
        
        fourthTab.tabBarItem.image = UIImage(named: "myPageUnPick")
        fourthTab.tabBarItem.selectedImage = UIImage(named: "myIcnPick")?.withRenderingMode(.alwaysOriginal)
        
        
        if self.view.frame.size.height > 800 {
            firstTab.tabBarItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0);
            secondTab.tabBarItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0);
            thirdTab.tabBarItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0);
            fourthTab.tabBarItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0);
        }
        
        let tabs = [firstTab, secondTab, thirdTab, fourthTab]
        
        self.setViewControllers(tabs, animated: false)
        self.selectedViewController = firstTab
        
        
    }
}

class CustomTabbar: UITabBar {
    func setup() {
        backgroundColor = .green
    }
}





