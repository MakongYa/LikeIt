

import UIKit

class SpendDetailController: BaseViewController, TypeViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var spendTypePicBtn: UIButton!
    @IBOutlet weak var spendTypeBtn: UIButton!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    fileprivate lazy var typeView: UIView = {
        let view  = UIView(frame: CGRect(x: 0, y: self.view.height, width: screenWidth, height: 137 * autoSizeScaleY + 1))
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 1))
        
        topLine.backgroundColor = UIColor.groupTableViewBackground
        
        let typeView = ((Bundle.main.loadNibNamed("TypeView", owner: self, options: nil)! as NSArray).object(at: 0)) as! TypeView
        typeView.frame = CGRect(x: 0, y: 1, width: view.width, height: 137 * autoSizeScaleY)
        typeView.delegate = self
        typeView.tag = 99
        
        view.addSubview(topLine)
        view.addSubview(typeView)
        
        return view
    }()
    
    fileprivate lazy var datePick: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: screenHeight-185, width: screenWidth, height: 185))
        
        let leftBtn = UIButton(frame: CGRect(x: 5, y: 0, width: 45, height: 30))
        leftBtn.setTitle("取消", for: UIControlState())
        leftBtn.addTarget(self, action: #selector(SpendDetailController.dismissDatePick(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.setTitleColor(CustomColor.themeColor, for: UIControlState())
        
        let rightBtn = UIButton(frame: CGRect(x: view.width-45-5, y: 0, width: 45, height: 30))
        rightBtn.setTitle("确认", for: UIControlState())
        rightBtn.addTarget(self, action: #selector(SpendDetailController.dismissDatePick(_:)), for: UIControlEvents.touchUpInside)
        rightBtn.setTitleColor(CustomColor.themeColor, for: UIControlState())
        rightBtn.tag = 1
        
        var pick = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: view.height))
        pick.minimumDate = Date(timeIntervalSince1970: 1352563200)//2013.11.11
        pick.maximumDate = Date(timeIntervalSince1970: 1762790400)//2025.11.11
        pick.datePickerMode = UIDatePickerMode.date
        pick.backgroundColor = CustomColor.viewBackgroundColor
        pick.addTarget(self, action: #selector(SpendDetailController.selectTime(_:)), for: UIControlEvents.valueChanged)
        pick.tag = 10
        
        view.addSubview(pick)
        view.addSubview(leftBtn)
        view.addSubview(rightBtn)
        
        return view
    }()
    
    fileprivate var model: AddModel!
    fileprivate var typeData: NSArray!
    
    fileprivate var isChange = false
    fileprivate var selectTime: Date!
    fileprivate var selectTypeModel: TypeModel!
    fileprivate var typeModel: TypeModel!
    
    fileprivate var fromVC: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        moneyTextField.delegate = self

        spendTypePicBtn.addTarget(self, action: #selector(SpendDetailController.onClickTypeBtn), for: .touchUpInside)
        spendTypeBtn.addTarget(self, action: #selector(SpendDetailController.onClickTypeBtn), for: .touchUpInside)
        
        timeTextField.inputView = datePick
        
        noteTextView.delegate = self
        
        view.addSubview(typeView)
        
        UIView.animate(withDuration: 0.25, delay: 0.35, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.spendTypePicBtn.alpha = 1
        }, completion: nil)
        
        guard fromVC != nil else {
            return
        }
        fromVC.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setData()
        // 状态栏颜色
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 状态栏颜色
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    fileprivate func setData() {
        selectTime = model.time.doubleValue.date
        
        typeModel = TypeModel.findFirst(byCriteria: "WHERE pk = '\(model.typePK)'")
        
        moneyTextField.text = model.addMoney.stringValue
        spendTypeBtn.setTitle(typeModel.typeTitle, for: UIControlState())
        spendTypePicBtn.setBackgroundImage(UIImage(named: typeModel.typePicName), for: UIControlState())
        timeTextField.text = model.time.doubleValue.date.string("yyyy-MM-dd")
        noteTextView.text = model.addContent.isEmpty ? "无" : model.addContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUI(_ model: AddModel, typeData: NSArray, fromVC: UIViewController?) {
        self.typeData = []
        self.typeData = typeData
        self.model    = model
        self.fromVC   = fromVC
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        model.addMoney = NSNumber(value: moneyTextField.text!.double!)
        model.typePK = selectTypeModel == nil ? model.typePK : selectTypeModel.pk.description
        model.time = selectTime.timeStamp as NSNumber
        model.addContent = noteTextView.text
        
        if model.saveOrUpdate() {
            view.makeToast(message: "修改成功", duration: 0.5, position: "center" as AnyObject)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NSCRefresh"), object: nil, userInfo: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveBtn.isEnabled = model.addMoney.stringValue != textField.text
    }
    
    func didSelectItemAtIndexPath(_ model: TypeModel) {
        spendTypePicBtn.setBackgroundImage(UIImage(named: model.typePicName), for: UIControlState())
        spendTypeBtn.setTitle(model.typeTitle, for: UIControlState())
        
        saveBtn.isEnabled = self.model.typePK != model.pk.description
        selectTypeModel = model
    }
    
    @objc fileprivate func onClickTypeBtn() {
        moneyTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
        
        
        (typeView.viewWithTag(99) as! TypeView).reloadData(typeData)
        (typeView.viewWithTag(99) as! TypeView).selectRow(typeModel)
        
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.typeView.frame.origin = CGPoint(x: 0, y: self.view.height-self.typeView.height)
        }) 
    }
    
    @objc fileprivate func dismissDatePick(_ sender: UIButton) {
        timeTextField.resignFirstResponder()
        
        if sender.tag == 1 {
            timeTextField.text! = selectTime.string("yyyy-MM-dd")
            saveBtn.isEnabled = model.time.doubleValue.date != selectTime
        }
    }
    
    @objc fileprivate func selectTime(_ sender: UIDatePicker) {
        selectTime = sender.date
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        dismissTypeView()
        view.viewScrollUP(0, IS_IPHONE_4_4s ? -(screenHeight-226-49) : -(screenHeight-226-noteTextView.height))
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            saveBtn.isEnabled = model.addContent != textView.text
            return false
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        view.viewScrollDonw()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        moneyTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
        
        dismissTypeView()
    }
    
    func dismissTypeView() {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.typeView.frame.origin = CGPoint(x: 0, y: self.view.height)
            }, completion: { (_) -> Void in
                (self.typeView.viewWithTag(99) as! TypeView).cleanData()
        }) 
    }

}
