

import UIKit


class StatisticalViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, StatisticalCellDelegate, ChartCellDelegate {

    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var tvTopConstraint: NSLayoutConstraint!
    
    var isShowMonthInfo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _tableView.dataSource = self
        _tableView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(StatisticalViewController.refreshAction), name: NSNotification.Name(rawValue: "NSCRefresh"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc fileprivate func refreshAction() {
        (cellForRowAtIndexPath(0,0) as! StatisticalCell).setCell()
        (cellForRowAtIndexPath(1,0) as! ChartCell).setCell()
    }
    
    fileprivate func cellForRowAtIndexPath(_ forRow:Int,_ inSection:Int) -> UITableViewCell {
        return _tableView.cellForRow(at: IndexPath(row: forRow, section: inSection))!
    }
    
    // MARK: - StatisticalCellDelegate
    func didSelectView(_ type: Int) {
        isShowMonthInfo = false
        self.performSegue(withIdentifier: "totalDetailSegue", sender: type)
    }
    
    // MARK: - ChartCellDelegate
    func didSelectChart(_ model: AddModel) {
        self.performSegue(withIdentifier: "detailSegue", sender: model)
    }
    func showTypeInfo(_ type: Int) {
        isShowMonthInfo = true
        print(type)
        self.performSegue(withIdentifier: "totalDetailSegue", sender: type)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! StatisticalCell
            cell.delegate = self
             
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ChartCell
            cell.delegate = self
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 206
        }
        return screenHeight - 206 - 65 - 49
    }
    
    fileprivate func updateConstraint(_ y: CGFloat) {
        tvTopConstraint.constant = y
        
        self.updateViewConstraints()
        _tableView.setNeedsLayout()
        _tableView.layoutIfNeeded()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "totalDetailSegue" {
            let vc = segue.destination as! StatisticalDetailController
            
            if let i = sender as? Int {
                vc.setData(i, isShowMonthInfo: isShowMonthInfo)
                
                if isShowMonthInfo {
                    vc.setNavItemTitle(i == spend.intValue ? "\(Date().monthday)月支出" : "\(Date().monthday)月收入")
                } else {
                    vc.setNavItemTitle(i == spend.intValue ? "总支出" : "总收入")
                }
            }
        }
        
        if segue.identifier == "detailSegue" {
            let vc = segue.destination as! SpendDetailController
            
            if let model = sender as? AddModel {
                
                vc.setUI(model, typeData: ((model.addType == spend ? SummaryReport.spendTypeData : SummaryReport.incomeTypeData!) as NSArray), fromVC: self)
            }
        }
    }
    
    deinit {
        print("移除通知")
        NotificationCenter.default.removeObserver(self)
    }

}
