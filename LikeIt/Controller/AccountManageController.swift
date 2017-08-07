

import UIKit

class AccountManageController: BaseViewController, EditorViewDelegate {
    
    @IBOutlet weak var _tableView: UITableView!
    var editorView: EditorView!
    
    var selectIndex: IndexPath!
    var dataSource: NSMutableArray = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "账户管理"
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(AccountManageController.addAccount))
        self.navigationItem.rightBarButtonItem = rightItem
        
        _tableView.tableFooterView = UIView()
        initCellBotton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initCellBotton()
        getAccountData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAccountData() {
        
//        dataSource = AccountModel().selectAll()
        _tableView.reloadData()
    }
    
    func addAccount() {
//        self.performSegueWithIdentifier("addAccountSegue", sender: AccountModel())
    }
    
    fileprivate func initCellBotton() {
        selectIndex = nil
        
        if editorView != nil {
            editorView.removeFromSuperview()
            editorView = nil
        }
        
        editorView = ((Bundle.main.loadNibNamed("EditorView", owner: self, options: nil)! as NSArray).object(at: 0)) as! EditorView
        editorView.frame = CGRect(x: 0, y: 56, width: screenWidth, height: 65)
        editorView.delegate = self
    }
    
    // MARK: - EditorViewDelegate
    func executeUpdate(_ index: Int) {
        let model = dataSource.object(at: index) as! AccountModel
        self.performSegue(withIdentifier: "addAccountSegue", sender: model)
    }
    func executeDelete(_ index: Int) {
//      _el = dataSource.objectAtIndex(index) as! AccountModel
//        if model.delete() {
//            dataSource.removeObjectAtIndex(index)
//            
//            initCellBotton()
//            
//            _tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
//        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        cell.selectionStyle = .none
        let model = dataSource.object(at: indexPath.row) as! AccountModel
        (cell.viewWithTag(66) as! UILabel).text = model.title
        
        if selectIndex != nil && (indexPath.row == selectIndex.row) {
            editorView.index = indexPath.row
            cell.contentView.addSubview(editorView)
        } else {
            if editorView != nil && editorView.superview == cell.contentView {
                editorView.removeFromSuperview()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (selectIndex == nil) {
            selectIndex = indexPath
            tableView.reloadRows(at: [selectIndex], with: UITableViewRowAnimation.automatic)
        } else {
            let selectTheSameRow = (indexPath.row == self.selectIndex.row)
            
            //两次点击不同的cell
            if !selectTheSameRow {
                //收起上次点击展开的cell;
                let tempIndexPath = selectIndex
                selectIndex = nil
                
                tableView.reloadRows(at: [tempIndexPath!], with: UITableViewRowAnimation.automatic)
                
                selectIndex = indexPath
                tableView.reloadRows(at: [selectIndex], with: UITableViewRowAnimation.automatic)
            } else {
                //若点击相同的cell，收起cell
                selectIndex = nil
                
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if selectIndex != nil && (indexPath.row == selectIndex.row) {
            return 120
        }
        
        return 55
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return "我的帐户"
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAccountSegue" {
            let vc = segue.destination as! MonthBudgetViewController
            //              _el = sender as? AccountModel
            vc.setNavItemTitle("添加帐户")
            
            //                if model?.title != nil {
            //                    vc.accountModel = sender as! AccountModel
            //                    vc.setNavItemTitle("修改信息")
            //                }
        }
    }
    

}
