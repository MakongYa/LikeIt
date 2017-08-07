

import UIKit

class TagManageController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var _tableView: UITableView!
    
    fileprivate var selectType = 0
    fileprivate var dataSource: [TypeModel]!
    fileprivate var _editing = false
    fileprivate var rightItem: UIBarButtonItem!
    
    fileprivate var addButton: PushButtonView = {
        var btn = PushButtonView()
        btn.frame = CGRect(x: screenWidth-35-40, y: screenHeight-50-40, width: 40, height: 40)
        btn.isAddButton = true
        btn.fillColor = CustomColor.spendColor
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "标签管理"
        
        rightItem = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TagManageController.editAction(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        addButton.addTarget(self, action: #selector(TagManageController.addType), for: .touchUpInside)
        view.addSubview(addButton)
        
        _tableView.delegate = self
        _tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource = SummaryReport.spendTypeData
        _tableView.reloadData()
    }
    
    @IBAction func changeValue(_ sender: UISegmentedControl) {
        if selectType == sender.selectedSegmentIndex {
            return
        }
        selectType = sender.selectedSegmentIndex
        
        if sender.selectedSegmentIndex == 0 {
            dataSource = SummaryReport.spendTypeData
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.addButton.fillColor = CustomColor.spendColor
            })
        } else {
            dataSource = SummaryReport.incomeTypeData
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.addButton.fillColor = CustomColor.inComeColor
            })
        }
        
        _tableView.reloadData()
    }
    
    @objc fileprivate func editAction(_ sender: UIBarButtonItem) {
        if sender.title == "编辑" {
            sender.title = "完成"
        } else {
            sender.title = "编辑"
        }
        _editing = !_editing
        _tableView.setEditing(_editing, animated: true)
    }
    
    @objc fileprivate func addType() {
        self.performSegue(withIdentifier: "addTypeSegue", sender: nil)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TagManageCell
        
        let model = dataSource[indexPath.row]
        if model.typeIsSys == 0 {
            cell.isEditing = false
            cell.showPon(false)
        } else {
            cell.isEditing = true
            cell.showPon(true)
        }
        
        cell.setCell(model)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        
        self.performSegue(withIdentifier: "addTypeSegue", sender: model)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let model = dataSource[indexPath.row]
        if model.typeIsSys == 0 {
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = MyAlertView(title: "删除此类型？", message: "删除后不可恢复!\n与之相关的数据也被清除", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "删除")
            alert.indexPath = indexPath
            
            alert.show()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            deleteCell((alertView as! MyAlertView).indexPath)
            
            rightItem.title = "编辑"
        
            _editing = !_editing
            _tableView.setEditing(_editing, animated: true)
        }
    }
    
    fileprivate func deleteCell(_ indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        
        AddModel.deleteObjects(byCriteria: "WHERE typePK = '\(model.pk)'")
        if model.deleteObject() {
            dataSource.remove(at: indexPath.row)
            _tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    // MARK: - Navigation addTypeSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTypeSegue" {
            let vc = segue.destination as! AddTagViewController
            
            vc.setNavItemTitle("添加标签")
            vc.setData(selectType, model: nil)
            
            guard sender != nil else {
                return
            }
            vc.setNavItemTitle("修改标签")
            let model = sender as! TypeModel
            vc.setData(selectType, model: model)
        }
    }

}
