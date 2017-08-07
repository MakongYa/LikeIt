

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true

        let infoDict = Bundle.main.infoDictionary!
        let currentVersion = infoDict["CFBundleShortVersionString"] as! String
        let currentName = infoDict["CFBundleDisplayName"] as! String
        appName = currentName
        appVersion = currentVersion
        
        _ = UIMaker.shareInstance()
        
        sleep(UInt32(1))
        
        if !UserDefaults.standard.bool(forKey: "firstStart") {
            UserDefaults.standard.set(true, forKey: "firstStart")
            
            
            insertDefaultType()
            
            NSLog("%@", "这是第一次进入")
        } else {
            NSLog("%@", "这不是第一次进入")
        }
        
        return true
    }
    
    func insertDefaultType() {
        let title1 = [
            "一般","餐饮","购物","借出","水果零食",
            "酒水饮料","行车交通","旅行","体育运动","手机通讯",
            "休闲娱乐","医疗保健","房租","学习进修","买烟",
            "人情往来"
        ]
        let pic1 = [
            "Tag","吃饭","购物车","借钱","水果",
            "酒水","地铁","飞机","健身","手机通讯",
            "KTV","医院","房租","教育","香烟",
            "购物"
        ]
        
        let title2 = [
            "工资","奖金","兼职外快","生活费","零花钱",
            "借入","投资","其他","红包"
        ]
        let pic2 = [
            "工资","奖金","公文包","银行卡","存钱",
            "还钱","投资","爱好","红包"
        ]
        
        for i in 0..<title1.count {
            creatModel(spend, title1[i], pic1[i]).save()
            
            guard i < title2.count else {
                continue
            }
            
            creatModel(income, title2[i], pic2[i]).save()
        }
    }
    
    fileprivate func creatModel(_ typeId: NSNumber,_ typeTitle: String,_ typePicName: String) -> TypeModel {
        return TypeModel(typeId: typeId, typeTitle: typeTitle, typePicName: typePicName, typeIsSys: 0)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

