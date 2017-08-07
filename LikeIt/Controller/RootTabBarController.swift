

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initTabBar()
    }

    func initTabBar() {
        // 导航栏按钮颜色
        UINavigationBar.appearance().tintColor = UIColor.white
        // 导航栏颜色
        UINavigationBar.appearance().barTintColor = CustomColor.themeColor
        // 状态栏颜色
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        // tabBarItem选中后的颜色
        self.tabBar.tintColor = CustomColor.themeColor
        
        //修改导航栏字体颜色
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName:UIColor.white
        ]
    }

}
