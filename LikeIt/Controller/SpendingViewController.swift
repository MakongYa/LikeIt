

import UIKit

/// 支出
class SpendingViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, TypeViewDelegate, UITextViewDelegate, UITextFieldDelegate, AddCellDelegate, UIAlertViewDelegate {

    @IBOutlet weak var _navigationBar: UINavigationBar!
    @IBOutlet weak var _segmentedControl: UISegmentedControl!
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var tvTopConstraint: NSLayoutConstraint!
    
    fileprivate var tvTopConstantOffset: CGFloat!
    
    fileprivate lazy var moneyView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: 50))
        
        let lineView = UIView(frame: CGRect(x: 0, y: view.height-0.5, width: view.width, height: 0.5))
        lineView.backgroundColor = CustomColor.garyFont3Color
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: (view.height-20)/2, width: 100, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = "金额"
        
        let textField = UITextField(frame: CGRect(x: view.width-8-200, y: (view.height-40)/2, width: 200, height: 40))
        textField.textAlignment = .right
        textField.borderStyle = UITextBorderStyle.none
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.keyboardType = UIKeyboardType.numberPad
        textField.placeholder = "0.0"
        textField.delegate = self
        textField.tag = 11
        
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(lineView)
        
        return view
    }()
    
    fileprivate lazy var typeView: TypeView = {
        let typeView = ((Bundle.main.loadNibNamed("TypeView", owner: self, options: nil))?.first) as! TypeView
        typeView.frame = CGRect(x: 0, y: 114, width: screenWidth, height: 137 * autoSizeScaleY)
        typeView.delegate = self
        typeView.isHidden = true

        return typeView
    }()
    
    fileprivate lazy var datePick: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: screenHeight-185, width: screenWidth, height: 185))
        
        let leftBtn = UIButton(frame: CGRect(x: 5, y: 0, width: 45, height: 30))
        leftBtn.setTitle("取消", for: UIControlState())
        leftBtn.addTarget(self, action: #selector(SpendingViewController.dismissDatePick(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.setTitleColor(CustomColor.themeColor, for: UIControlState())
        
        let rightBtn = UIButton(frame: CGRect(x: view.width-45-5, y: 0, width: 45, height: 30))
        rightBtn.setTitle("确认", for: UIControlState())
        rightBtn.addTarget(self, action: #selector(SpendingViewController.dismissDatePick(_:)), for: UIControlEvents.touchUpInside)
        rightBtn.setTitleColor(CustomColor.themeColor, for: UIControlState())
        rightBtn.tag = 1
        
        var pick = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: view.height))
        pick.minimumDate = Date(timeIntervalSince1970: 1352563200)//2013.11.11
        pick.maximumDate = Date(timeIntervalSince1970: 1762790400)//2025.11.11
        pick.datePickerMode = UIDatePickerMode.date
        pick.backgroundColor = CustomColor.viewBackgroundColor
        pick.addTarget(self, action: #selector(SpendingViewController.selectTime(_:)), for: UIControlEvents.valueChanged)
        pick.tag = 10
        
        view.addSubview(pick)
        view.addSubview(leftBtn)
        view.addSubview(rightBtn)
        
        return view
    }()
    
    fileprivate lazy var timeView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.typeView.bottomSpacing, width: screenWidth, height: 44))
        
        let topLineView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 0.5))
        topLineView.backgroundColor = CustomColor.garyFont3Color

        let botLineView = UIView(frame: CGRect(x: 0, y: view.height-0.5, width: view.width, height: 0.5))
        botLineView.backgroundColor = CustomColor.garyFont3Color
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: (view.height-20)/2, width: 100, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = "时间"
        
        let textField = UITextField(frame: CGRect(x: view.width-25-200, y: (view.height-40)/2, width: 200, height: 40))
        textField.textAlignment = .right
        textField.borderStyle = UITextBorderStyle.none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.text = Date().string("yyyy-MM-dd")
        textField.inputView = self.datePick
        textField.tag = 11
        
        let imageView = UIImageView(frame: CGRect(x: view.width - 10 - 8, y: (view.height-16)/2, width: 10, height: 16))
        imageView.image = UIImage(named: "nextPic")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        
        view.addSubview(topLineView)
        view.addSubview(botLineView)
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(imageView)
        
        return view
    }()
    
    fileprivate lazy var noteView: UIView = {
        let height: CGFloat = IS_IPHONE_4_4s ? 50 : IS_IPHONE_6 ? 200 : IS_IPHONE_6P ? 250 : 100
        
        let view = UIView(frame: CGRect(x: 0, y: self.timeView.bottomSpacing, width: screenWidth, height: height))
        
        let lineView = UIView(frame: CGRect(x: 0, y: view.height-0.5, width: view.width, height: 0.5))
        lineView.backgroundColor = CustomColor.garyFont3Color
        
        let titleLabel = UILabel(frame: CGRect(x: 5, y: 6, width: 100, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = CustomColor.garyFont2Color
        titleLabel.text = "写点什么吧"
        titleLabel.tag = 10
        
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height))
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.returnKeyType = UIReturnKeyType.done
        textView.delegate = self
        textView.tag = 11
        
        view.addSubview(textView)
        view.addSubview(titleLabel)
       
        return view
    }()
    
    fileprivate lazy var tableHeadView: UIView = {
        let view = UIView(frame:
            CGRect(x: 0, y: 0, width: screenWidth, height: IS_IPHONE_6 ? 250 : IS_IPHONE_6P ? 300 : 200))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(SpendingViewController.longPressHeaderView(_:))))
        
        var navItemTitleLabel = UILabel(frame: CGRect(x: (screenWidth-100)/2, y: 25, width: 100, height: 20))
        navItemTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        navItemTitleLabel.textColor = UIColor.white
        navItemTitleLabel.textAlignment = .center
        navItemTitleLabel.text = "记一笔"
        navItemTitleLabel.tag = 1
        
        var headViewTopImageView = UIImageView(frame: view.frame)
        headViewTopImageView.image = UIImage(named: "indexImage")
        headViewTopImageView.tag = 7
        
        let bottomView = UIView(frame:
            CGRect(x: 0, y: view.height-44, width: view.width, height: 44))
        bottomView.backgroundColor = UIColor.white
        
        var headViewBotImageView = UIImageView(frame: bottomView.bounds)
        headViewBotImageView.image = UIImage(named: "indexImage")
        headViewBotImageView.alpha = 0
        headViewBotImageView.tag = 8
        
        let spendLabel = UILabel(frame: CGRect(x: 8, y: 5, width: "支出".stringRectWithFontSize(12, width: screenWidth).width, height: 18))
        self.setLabelStyle(spendLabel, 12, .left)
        spendLabel.text = "支出"
        
        let spendMoneyLabel = UILabel(frame:
            CGRect(x: 8, y: bottomView.height-20, width: 100, height: 20))
        self.setLabelStyle(spendMoneyLabel, 16, .left)
        spendMoneyLabel.text = "0.00"
        spendMoneyLabel.tag = 9
        
        let menthBudLabel = UILabel(frame: CGRect(x: spendLabel.rightSpacing+3, y: spendLabel.y, width: 150, height: spendLabel.height))
        menthBudLabel.textColor = CustomColor.spendColor
        menthBudLabel.textAlignment = .left
        menthBudLabel.font = UIFont.systemFont(ofSize: 11)
        menthBudLabel.tag = 48
        
        let incomeLabel = UILabel(frame:
            CGRect(x: bottomView.width-100-8, y: 5, width: 100, height: 18))
        self.setLabelStyle(incomeLabel, 12, .right)
        incomeLabel.text = "收入"
        
        let incomeMoneyLabel = UILabel(frame:
            CGRect(x: bottomView.width-100-8, y: bottomView.height-20, width: 100, height: 20))
        self.setLabelStyle(incomeMoneyLabel, 16, .right)
        incomeMoneyLabel.text = "0.00"
        incomeMoneyLabel.tag = 10
        
        bottomView.addSubview(headViewBotImageView)
        bottomView.addSubview(spendMoneyLabel)
        bottomView.addSubview(menthBudLabel)
        bottomView.addSubview(spendLabel)
        bottomView.addSubview(incomeLabel)
        bottomView.addSubview(incomeMoneyLabel)
        
        var addButton = PushButtonView(frame:
            CGRect(x: (view.width-66)/2, y: bottomView.y - 33, width: 66, height: 66))
        addButton.addTarget(self, action: #selector(SpendingViewController.onClickAddBtn(_:)), for: .touchUpInside)
        addButton.fillColor = CustomColor.spendColor
        addButton.isAddButton = true
        addButton.tag = 6
        
        let addBtnBgView = UIView(frame: CGRect(x: (view.width-70)/2, y: addButton.y - 2, width: 70, height: 70))
        addBtnBgView.backgroundColor = UIColor.white
        addBtnBgView.cornerRadius(addBtnBgView.width/2)
        
        view.addSubview(headViewTopImageView)
        view.addSubview(bottomView)
        view.addSubview(navItemTitleLabel)
        view.addSubview(addBtnBgView)
        view.addSubview(addButton)
        
        return view
    }()

    fileprivate var spendTypeData: NSArray!
    fileprivate var incomeTypeData: NSArray!
    fileprivate var addDataSource: NSArray!
    fileprivate var addType: NSNumber = spend
    fileprivate var selectTypeModel: TypeModel!
    fileprivate var selectTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvTopConstantOffset = screenHeight - 49 - (IS_IPHONE_6 ? 250 : IS_IPHONE_6P ? 300 : 200)
        
        refreshData()
        selectTypeData()
        
        _tableView.delegate = self
        _tableView.separatorStyle = .none
        
        _segmentedControl.addTarget(self, action: #selector(SpendingViewController.segmentedValueChange(_:)), for: UIControlEvents.valueChanged)
        
        view.addSubview(typeView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SpendingViewController.refreshAction), name: NSNotification.Name(rawValue: "NSCRefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SpendingViewController.refreshBudget), name: NSNotification.Name(rawValue: "NSCRefreshBudget"), object: nil)
    }
    
    @objc fileprivate func refreshAction(){
        refreshData()
    }
    @objc fileprivate func refreshBudget(){
        let spendTotalMoney = SummaryReport.spendTotalMoney == nil ? 0 : SummaryReport.spendTotalMoney
        let budget = UserDefaults.standard.double(forKey: "monthBudget")
        
        
        (tableHeadView.viewWithTag(48) as! UILabel).text = compareBudget(spendTotalMoney!, budget)
        
        _tableView.dataSource = self
        _tableView.reloadData()
    }
    
    fileprivate func compareBudget(_ money:Double,_ budget:Double) -> String {
        var message = ""
        
        if money > 0 && budget > 0{
            if money > budget {
                message = "超出预算\(money-budget)"
            } else if budget - money < 50 {
                message = "即将超出预算"
            } else if budget - money < 100 {
                message = "省着点花"
            }
        }
        return message
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isSelect {
            (tableHeadView.viewWithTag(6) as! PushButtonView).onRotation(CGFloat(45.0 * Double.pi / 180.0), 0)
            dismissBackgroundView()
        }
    }
    
    @objc fileprivate func segmentedValueChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            addType = spend
            
            guard incomeTypeData.count > 0 else {
                return
            }
            typeView.reloadData(spendTypeData)
        } else {
            addType = income
            
            guard incomeTypeData.count > 0 else {
                return
            }
            typeView.reloadData(incomeTypeData)
        }
    }
    
    @objc fileprivate func dismissDatePick(_ sender: UIButton) {
        (timeView.viewWithTag(11) as! UITextField).resignFirstResponder()
        
        if sender.tag == 1 {
            (timeView.viewWithTag(11) as! UITextField).text! = selectTime.string("yyyy-MM-dd")
        }
    }
    
    @objc fileprivate func selectTime(_ sender: UIDatePicker) {
        selectTime = sender.date
    }
    
    
    // MARK: - 保存
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let moneyStr = (moneyView.viewWithTag(11) as! UITextField).text!
        
        guard !moneyStr.isEmpty else {
            view.makeToast(message: "金额不能为空", duration: 0.5, position: "center" as AnyObject)
            return
        }
        guard moneyStr.double != nil && moneyStr.double! > 0.0 else {
            view.makeToast(message: "金额不能小于0", duration: 0.5, position: "center" as AnyObject)
            return
        }
        guard selectTypeModel != nil else {
            view.makeToast(message: "类型未选", duration: 0.5, position: "center" as AnyObject)
            return
        }
        
        let money = moneyStr.double!
        let content = (noteView.viewWithTag(11) as! UITextView).text!
        
        let model = AddModel(type: addType, money: NSNumber(value: money), time: NSNumber(value: selectTime.timeStamp), typePK: selectTypeModel.pk.description, addTime: NSNumber(value: Date().timeStamp), content: content, accountId: 1)
        
        if model.save() {
            cleanText()
            view.makeToast(message: self.addType == spend ? "新加一笔支出" : "新加一笔收入", duration: 0.65, position: "center" as AnyObject)
            
            (tableHeadView.viewWithTag(6) as! PushButtonView).onRotation(CGFloat(45.0 * Double.pi / 180.0), 0)
            dismissBackgroundView()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NSCRefresh"), object: nil)
        }
    }
    
    // MARK: - TypeViewDelegate
    func didSelectItemAtIndexPath(_ model: TypeModel) {
        (noteView.viewWithTag(11) as! UITextView).resignFirstResponder()
        dismissKeyborad()
        
        selectTypeModel = model
    }
    
    // MARK: - AddCellDelegate
    func didSelectCell(_ model: AddModel?) {
        guard model != nil && model!.addType != timeSpace else {
            return
        }
        self.performSegue(withIdentifier: "detailSegue", sender: model)
    }
    func deleteCell(_ model: AddModel?) {
        guard model != nil else {
            return
        }
        
        let alert = MyAlertView(title: "删除这条记录？", message: "不可恢复!", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "删除")
        alert.addModel = model
        
        alert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            (alertView as! MyAlertView).addModel.deleteObject()
            refreshData()
        }
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        dismissKeyborad()
        view.viewScrollUP(0, IS_IPHONE_4_4s ? -(screenHeight-226-noteView.height) : -50)
    }
    func textViewDidChange(_ textView: UITextView) {
        let label = (noteView.viewWithTag(10) as! UILabel)
        
        label.isHidden = textView.text.length > 0
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        view.viewScrollDonw()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeadView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addDataSource.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! TimeSpaceCell
            
            cell.dayLabel.text = "今天"
            cell.timeLabel.text = Date().weekday
        
            return cell
        }
        
        let model = addDataSource.object(at: (addDataSource.count-1)-(indexPath.row-1)) as! AddModel
        
        if model.addType == spend {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! SpendCell
            cell.delegate = self
            
            if model.addMoney == 0 {
                cell.setCell(model, true)
            } else {
                cell.setCell(model, false)
            }
            
            return cell
        } else if model.addType == income {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! IncomeCell
            cell.delegate = self
            cell.setCell(model)
            
            return cell
        } else if model.addType == timeSpace {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! TimeSpaceCell
            cell.setCell(model)
            
            return cell
        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }
        
        let model = addDataSource.object(at: (addDataSource.count-1)-(indexPath.row-1)) as! AddModel
        
        if model.addType == timeSpace {
            return 20
        }
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return IS_IPHONE_6 ? 250 : IS_IPHONE_6P ? 300 : 200
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let delay = 0.08 * indexPath.row.double
        
        cell.transform = CGAffineTransform(translationX: 0, y: tableView.bounds.height)
        
        UIView.animate(withDuration: 0.45, delay: delay, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    // MARK: - 支出、收入Label样式
    fileprivate func setLabelStyle(_ label: UILabel, _ fontSize: CGFloat, _ alignment:NSTextAlignment) {
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = alignment
    }
    
    // MARK: - 长按HeadView
    func longPressHeaderView(_ sender: UILongPressGestureRecognizer) {
        if sender.numberOfTouchesRequired == 1 {
            if sender.state == UIGestureRecognizerState.began {
                
                print("长按")
            }
        }
    }

    
    // MARK: - 点击增加按钮
    var isSelect = false
    @objc fileprivate func onClickAddBtn(_ sender: PushButtonView) {
        if !isSelect {
            showBackgroundView()
            sender.onRotation(0, CGFloat(45.0 * Double.pi / 180.0))
        } else {
            dismissBackgroundView()
            sender.onRotation(CGFloat(45.0 * Double.pi / 180.0), 0)
        }
    }
    
    fileprivate func showBackgroundView() {
        isSelect = !isSelect
        
        typeView.reloadData(spendTypeData)
        _segmentedControl.selectedSegmentIndex = 0
        (datePick.viewWithTag(10) as! UIDatePicker).setDate(self.selectTime, animated: true)
        
        _tableView.isScrollEnabled = false
        _tableView.scrollRectToVisible(
            CGRect(x: 0, y: 0, width: _tableView.width, height: _tableView.height), animated: false)
        
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            
            self.updateConstraint(self.tvTopConstantOffset)
            self.showView(true)
            
            }, completion: { (finish) -> Void in
                
                self.typeView.isHidden = false
                self.view.addSubview(self.moneyView)
                self.view.addSubview(self.timeView)
                self.view.addSubview(self.noteView)
        }) 
    }
    
    fileprivate func dismissBackgroundView() {
        isSelect = !isSelect
        
        (noteView.viewWithTag(11) as! UITextView).resignFirstResponder()
        dismissKeyborad()
        
        typeView.cleanData()
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.typeView.isHidden = true
            self.moneyView.removeFromSuperview()
            self.timeView.removeFromSuperview()
            self.noteView.removeFromSuperview()
            
            self.updateConstraint(0)
            self.showView(false)
            }, completion: { (finish) -> Void in
                self._tableView.isScrollEnabled = true
        }) 
    }
    
    fileprivate func showView(_ show: Bool) {
        let titleLabrl = tableHeadView.viewWithTag(1)
        let topView = tableHeadView.viewWithTag(7)
        let botView = tableHeadView.viewWithTag(8)
        
        if show {
            setAlpha(titleLabrl!, alpha: 1)
            setAlpha(topView!, alpha: 0)
            setAlpha(botView!, alpha: 1)
            setAlpha(_navigationBar, alpha: 1)
        } else {
            setAlpha(titleLabrl!, alpha: 1)
            setAlpha(topView!, alpha: 1)
            setAlpha(botView!, alpha: 0)
            setAlpha(_navigationBar, alpha: 0)
        }
    }
    
    /// 更新约束
    fileprivate func updateConstraint(_ y: CGFloat) {
        tvTopConstraint.constant = y
        
        self.updateViewConstraints()
        _tableView.setNeedsLayout()
        _tableView.layoutIfNeeded()
    }
    
    fileprivate func setAlpha(_ view: UIView, alpha: CGFloat) {
        if alpha == 0 {
            view.isOpaque = false
        } else {
            view.isOpaque = true
        }
        view.alpha = alpha
    }
    
    fileprivate func dismissKeyborad() {
        (moneyView.viewWithTag(11) as! UITextField).resignFirstResponder()
        (timeView.viewWithTag(11) as! UITextField).resignFirstResponder()
    }
    
    fileprivate func cleanText() {
        (moneyView.viewWithTag(11) as! UITextField).text = ""
        (datePick.viewWithTag(10) as! UIDatePicker).setDate(Date(),animated: true)
        (noteView.viewWithTag(11) as! UITextView).text = ""
        selectTime = Date()
    }
    
    func refreshData() {
        addDataSource = SummaryReport.getAllData() as NSArray
//        SummaryReport.getChartData()
        
        if addDataSource.count > 0 {
            addTimeSpace(addDataSource.lastObject as! AddModel)
        }
        
        let spendTotalMoney = SummaryReport.spendTotalMoney == nil  ? 0 :  SummaryReport.spendTotalMoney
        let incomeTotalMoney = SummaryReport.incomeTotalMoney == nil  ? 0 :  SummaryReport.incomeTotalMoney

        let formatted = NumberFormatter()
        formatted.numberStyle = NumberFormatter.Style.decimal
        
        (tableHeadView.viewWithTag(9) as! UILabel).text = formatted.string(from: NSNumber(value: spendTotalMoney!))
        (tableHeadView.viewWithTag(10) as! UILabel).text = formatted.string(from: NSNumber(value: incomeTotalMoney!))
        
        let budget = UserDefaults.standard.double(forKey: "monthBudget")
        var message = ""
       
        if spendTotalMoney! > 0 && budget > 0{
            if spendTotalMoney! > budget {
                message = "超出预算\(spendTotalMoney! - budget)"
            } else if budget - spendTotalMoney! < 50 {
                message = "即将超出预算"
            } else if budget - spendTotalMoney! < 100 {
                message = "省着点花"
            }
        }
        (tableHeadView.viewWithTag(48) as! UILabel).text = message
        
        _tableView.dataSource = self
        _tableView.reloadData()
    }

    fileprivate func selectTypeData() {
        SummaryReport.getTypeData()
        spendTypeData = SummaryReport.spendTypeData! as NSArray
        incomeTypeData = SummaryReport.incomeTypeData as NSArray
    }
    
    func addTimeSpace(_ lastAddModel: AddModel) {
        print("lastAddModel---\(lastAddModel)")
        
        //最后一条记录添加的时间
        let addTime = lastAddModel.addTime.doubleValue.date
        
        /// 最后一条数据不是本月
        if !addTime.isThisMonth {
            print("最后一条数据不是本月")
            let addModel = AddModel(
                type: spend,
                money: 0.0,
                time: lastAddModel.addTime,
                typePK: addTime.monthday,
                addTime: NSNumber(value: Date().timeStamp),
                content: "",
                accountId: 1
            )
            // 保存一条纪录做月份分割cell
            if addModel.save() {
                cleanText()
                refreshData()
            }
        } else {
            /// 最后一条数据不是今天
            if !addTime.isToday {
                print("最后一条数据不是今天")
                
                guard lastAddModel.addMoney != 0.0 else {
                    return
                }
                
                guard lastAddModel.addType != timeSpace else {
                    return
                }
                
                let addModel = AddModel(
                    type: timeSpace,
                    money: 0.0,
                    time: lastAddModel.addTime,
                    typePK: addTime.weekday,
                    addTime: NSNumber(value: Date().timeStamp),
                    content: "",
                    accountId: 1
                )
                // 保存一条纪录做天分割cell
                if addModel.save() {
                    cleanText()
                    refreshData()
                }
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let vc = segue.destination as! SpendDetailController
            let model = sender as! AddModel
            
            vc.setUI(model, typeData: (model.addType == spend ? spendTypeData : incomeTypeData), fromVC:nil)
        }
    }

    deinit {
        print("移除通知")
        NotificationCenter.default.removeObserver(self)
    }
}
