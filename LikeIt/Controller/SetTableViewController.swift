

import UIKit
import MessageUI

class SetTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 * autoSizeScaleY
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 && indexPath.row == 0 {
            feedBack()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

    fileprivate func feedBack() {
        if MFMailComposeViewController.canSendMail() {
            
            let controller = MFMailComposeViewController()
            
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("意见反馈")
            //设置收件人
            controller.setToRecipients(["1076000966@qq.com"])
            //设置抄送人
//            controller.setCcRecipients(["1076000966@qq.com"])
            //设置密送人
//            controller.setBccRecipients(["1076000966@qq.com"])
            
            //添加图片附件
            //            var path = NSBundle.mainBundle().pathForResource("hangge.png", ofType: "")
            //            var myData = NSData(contentsOfFile: path!)
            //            controller.addAttachmentData(myData, mimeType: "image/png", fileName: "swift.png")
            
            //设置邮件正文内容（支持html）
            controller.setMessageBody("反馈内容", isHTML: false)
            
            //打开界面
            self.present(controller, animated: true, completion: nil)
        }else{
            print("本设备不能发送邮件", terminator: "")
            view.showAlertView("本设备不能发送邮件", message: "如果您想反馈,请用网页发送邮件至1319653319@qq.com")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
            
            switch result.rawValue{
            case MFMailComposeResult.sent.rawValue:
                print("邮件已发送", terminator: "")
                view.showAlertView("发送成功!", message: "感谢您的反馈!")
            case MFMailComposeResult.cancelled.rawValue:
                print("邮件已取消", terminator: "")
                view.showAlertView("邮件已取消", message: "")
            case MFMailComposeResult.saved.rawValue:
                print("邮件已保存", terminator: "")
                view.showAlertView("邮件已保存", message: "")
            case MFMailComposeResult.failed.rawValue:
                print("邮件发送失败", terminator: "")
                view.showAlertView("邮件发送失败", message: "")
            default:
                print("邮件没有发送", terminator: "")
                break
            }
    }
    
    // MARK: - Navigation manageSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MonthBudgetSegue" {
            let vc = segue.destination as! MonthBudgetViewController
            vc.setNavItemTitle("每月预算")
            vc.fromeVC = self
        }
    }

}
