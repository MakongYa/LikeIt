

import UIKit

class MonthBudgetViewController: BaseViewController {

    @IBOutlet weak var budgetMoneyLabel: UILabel!
    @IBOutlet weak var spendMoneyLabel: UILabel!
    @IBOutlet weak var setButton: DoneButton!
    @IBOutlet weak var chartView: UIView!
    
    fileprivate var textField: UITextField!
    fileprivate var sendButton: UIButton!
    fileprivate var bgView: UIButton!
    fileprivate var money = SummaryReport.spendTotalMoney
    
    fileprivate var monthBudgetChart: PNPieChart!
    var fromeVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let budget = UserDefaults.standard.double(forKey: "monthBudget")
        budgetMoneyLabel.text = "\(budget)"
        
        spendMoneyLabel.text = money?.string

        setButton.addTarget(self, action: #selector(MonthBudgetViewController.onClick), for: .touchUpInside)
        
        textField = UITextField(frame: CGRect(x: (screenWidth-200)/2, y: -33, width: 200, height: 33))
        textField.keyboardType = UIKeyboardType.numberPad
        textField.textColor = UIColor.white
        textField.textAlignment = .center
        textField.placeholder = "添加预算"
        
        sendButton = UIButton(frame: CGRect(x: (screenWidth-200)/2, y: self.view.height, width: 200, height: 35))
        sendButton.setTitle("完成", for: UIControlState())
        sendButton.setTitleColor(UIColor.white, for: UIControlState())
        sendButton.addTarget(self, action: #selector(MonthBudgetViewController.doneAction), for: .touchUpInside)
        sendButton.cornerRadius(sendButton.height/2)
        sendButton.backgroundColor = CustomColor.inComeColor
        
        bgView = UIButton(frame: view.bounds)
        bgView.setBackgroundImage(UIImage(named: "indexImage"), for: UIControlState())
        bgView.setBackgroundImage(UIImage(named: "indexImage"), for: .highlighted)
        //UIImageView(frame: view.frame)
        //bgView.image = UIImage(named: "indexImage")
        bgView.addTarget(self, action: #selector(MonthBudgetViewController.dismissTextField), for: .touchUpInside)
        bgView.alpha = 0
        
        view.addSubview(bgView)
        view.addSubview(textField)
        view.addSubview(sendButton)
        
        refreshData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MonthBudgetViewController.keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MonthBudgetViewController.keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        monthBudgetChart.isHidden = false
        monthBudgetChart.frame = chartView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fromeVC.navigationController?.isNavigationBarHidden = true
        // 状态栏颜色
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 状态栏颜色
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func onClick() {
        showTextField()
    }
    @objc fileprivate func doneAction() {
        if !textField.text!.isEmpty {
            UserDefaults.standard.set(textField.text!.double!, forKey: "monthBudget")
            budgetMoneyLabel.text = textField.text
            refreshData()
            monthBudgetChart.isHidden = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NSCRefreshBudget"), object: nil)
        }
        dismissTextField()
    }
    
    fileprivate func showTextField() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.navigationController?.navigationBar.alpha = 0
            self.bgView.alpha = 1
            
            self.textField.becomeFirstResponder()
            self.textField.frame.origin.y = 150
        })
    }
    @objc fileprivate func dismissTextField() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.navigationController?.navigationBar.alpha = 1
            self.bgView.alpha = 0
            
            self.textField.frame.origin.y = -33
            self.textField.resignFirstResponder()
        })
    }
    
    @objc fileprivate func keyboardShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyBoardRect = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).floatValue
       
        UIView.animate(withDuration: Double(duration!), animations: { () -> Void in
            
            self.sendButton.frame = CGRect(x: (screenWidth-200)/2, y: keyBoardRect!.origin.y-35-20, width: 200, height: 35)
        })
    }
    @objc fileprivate func keyboardHide(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).floatValue

        UIView.animate(withDuration: Double(duration!), animations: { () -> Void in
            self.sendButton.frame = CGRect(x: (screenWidth-200)/2, y: self.view.height, width: 200, height: 35)

            }, completion: { (finished) -> Void in

        }) 
    }
    
    fileprivate func refreshData() {
        let budget = UserDefaults.standard.double(forKey: "monthBudget")
        budgetMoneyLabel.text = "\(budget)"
        
        spendMoneyLabel.text = money?.string
        
        if monthBudgetChart != nil {
            monthBudgetChart.removeFromSuperview()
        }
        
        let spendPen = budget == 0.0 ? 100 : ((money! / budget) * 100).cgFloat > 100 ? 100 : ((money! / budget) * 100).cgFloat
        let subPen = 100 - spendPen
        
        
        let items = [
            PNPieChartDataItem(value: spendPen, color: CustomColor.spendColor, description: "已支出"),
            PNPieChartDataItem(value: subPen, color: CustomColor.inComeColor, description: "预算余额")
        ]
        
        monthBudgetChart = PNPieChart(frame: chartView.bounds, items: items.map({ $0! }))
        monthBudgetChart.isHidden = true
        monthBudgetChart.descriptionTextColor = UIColor.white
        monthBudgetChart.descriptionTextFont  = UIFont(name: "Avenir-Medium", size: IS_IPHONE_4_4s ? 11 : 14)
        monthBudgetChart.descriptionTextShadowColor = UIColor.clear
        monthBudgetChart.showAbsoluteValues = false
        monthBudgetChart.showOnlyValues = false
        monthBudgetChart.stroke()
        
        monthBudgetChart.legendStyle = PNLegendItemStyle.serial
        monthBudgetChart.legendFont = UIFont.boldSystemFont(ofSize: 12)
        monthBudgetChart.legendFontColor = CustomColor.lightGreen
        
        chartView.addSubview(monthBudgetChart)
    }
    
    deinit {
        print("移除通知")
        NotificationCenter.default.removeObserver(self)
    }

}
