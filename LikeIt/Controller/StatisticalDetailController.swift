

import UIKit

class StatisticalDetailController: BaseTableViewController {

    @IBOutlet weak var _tableView: UITableView!
    
    fileprivate var dataSource: NSArray!
    fileprivate var type: Int!
    fileprivate var isShowMonthInfo: Bool!
    
    override func viewDidLoad() {
        self.tableView = _tableView
        
        super.viewDidLoad()
        
        setUI()
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func setData(_ type: Int, isShowMonthInfo: Bool) {
        self.type = type
        self.isShowMonthInfo = isShowMonthInfo
       
        if isShowMonthInfo {
            var arr:[AddModel] = []
            for i in SummaryReport.getMonthReport {
                if i.addType.intValue == type {
                    arr.append(i)
                }
            }
            dataSource = arr as NSArray
        } else {
            dataSource = data(NSNumber(value: type))
        }
    }
    
    fileprivate func data(_ type:NSNumber) -> NSArray {
        return (type == spend ? SummaryReport.getSpendData : SummaryReport.getIncomeData)! as NSArray
    }

    // MARK: - UITableViewDataSource
    fileprivate func setUI() {
        self.numberOfRowsInSection = {(section: Int) -> Int in
            return self.dataSource.count + 1
        }
        self.cellForRowAtIndexPath = {(indexPath: IndexPath) -> UITableViewCell in
            if indexPath.row == 0 {
                let cell = self._tableView.dequeueReusableCell(withIdentifier: "cell1") as! StatisticalDetailHeadCell
                
                guard self.dataSource.count > 0 else {
                    cell.setCell(AddModel(type: self.type! as NSNumber, money: 0, time: 0, typePK: "", addTime: 0, content: "", accountId: 0), isShowMonthInfo: self.isShowMonthInfo)
                    
                    return cell
                }
                let model = self.dataSource.object(at: 0) as! AddModel
                cell.setCell(model, isShowMonthInfo: self.isShowMonthInfo)
                
                return cell
            } else {
                let cell = self._tableView.dequeueReusableCell(withIdentifier: "cell2") as! StatisticalDetailCell
                
                let model = self.dataSource.object(at: (self.dataSource.count-1) - (indexPath.row-1)) as! AddModel
                cell.setCell(model, isShowMonthInfo: self.isShowMonthInfo)
                
                return cell
            }
        }
        self.heightForRowAtIndexPath = {(indexPath: IndexPath) -> CGFloat in
            if indexPath.row == 0 {
                return 135
            } else {
                return 50
            }
        }
        self.didSelectRowAtIndexPath = {(indexPath: IndexPath) -> Void in
            if indexPath.row != 0 {
                let model = self.dataSource.object(at: (self.dataSource.count-1) - (indexPath.row-1)) as! AddModel
                
                self.performSegue(withIdentifier: "detailSegue", sender: model)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let vc = segue.destination as! SpendDetailController
            let model = sender as! AddModel
            let typeData = (model.addType == spend ? SummaryReport.spendTypeData : SummaryReport.incomeTypeData) as NSArray
            
            vc.setUI(model, typeData: typeData, fromVC: self)
        }
    }
    

}
