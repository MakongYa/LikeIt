

import UIKit

class BaseTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var section = 1
    var numberOfRowsInSection: ((_ section: Int) -> Int)!
    var cellForRowAtIndexPath: ((_ indexPath: IndexPath) -> UITableViewCell)!
    var heightForRowAtIndexPath: ((_ indexPath: IndexPath) -> CGFloat)!
    var didSelectRowAtIndexPath: ((_ indexPath: IndexPath) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellForRowAtIndexPath(indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard numberOfRowsInSection != nil else {
            return 0
        }
        
        return numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        guard heightForRowAtIndexPath != nil else {
            return 44
        }
        
        return heightForRowAtIndexPath(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard didSelectRowAtIndexPath != nil else {
            return
        }
        
        didSelectRowAtIndexPath(indexPath)
    }

}
