

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 子页面返回按钮的名称
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
    func setNavItemTitle(_ title: String) {
        self.navigationItem.title = title
    }
    
    
}
