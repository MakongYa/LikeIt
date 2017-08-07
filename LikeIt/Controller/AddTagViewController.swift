

import UIKit

class AddTagViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var typeNameTextField: UITextField!
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var _collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var dataSource: NSArray!
    var typePicName: String!
    var type: Int!
    var typeModel: TypeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddTagViewController.saveAction(_:)))
        
        self.navigationItem.rightBarButtonItem = rightItem

        dataSource = [
            "爱好","背包","标签","冰淇淋","餐饮","吃饭","宠物","存钱","地铁","电视",
            "电影","房子","房租","飞机","工资","公文包","购物","购物车","还钱","红包",
            "化妆品","记事本","健身","奖金","教育","借钱","酒水","篮球","礼物","沙发",
            "生活用品","生鲜","食用油","收入","手机通讯","书","水电","水果","投资",
            "维修","香烟","鞋子","星星","摇椅","衣架","医院","银行卡","饮料",
            "婴儿","照相","支出","纸巾","KTV","Tag",
            "更多"
        ]
        typeNameTextField.delegate = self
        _collectionView.dataSource = self
        _collectionView.delegate = self
        
        let width = (screenWidth - 20 - 32) / 5
        _collectionViewFlowLayout.itemSize = CGSize(width: width, height: width)
        
        if typeModel == nil {
            typePicName = dataSource.object(at: 0) as! String
            _collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.top)
        } else {
            for i in 0..<dataSource.count {
                let title = dataSource[i] as! String
                if typeModel.typePicName == title {
                    _collectionView.selectItem(at: IndexPath(item: i, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.top)
                    typeNameTextField.text = typeModel.typeTitle
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setData(_ type: Int, model: TypeModel?) {
        self.type = type
        
        guard model != nil else {
            return
        }
        typeModel = model
    }
    
    @objc fileprivate func saveAction(_ sender: UIBarButtonItem) {
        guard !typeNameTextField.text!.isEmpty else {
            view.makeToast(message: "填写类型名称", duration: 0.5, position: "center" as AnyObject)
            return
        }
        
        guard !typePicName.isEmpty else {
            view.makeToast(message: "选一个图标", duration: 0.5, position: "center" as AnyObject)
            return
        }
        
        if typeModel == nil {
            typeModel = TypeModel(typeId: NSNumber(value: type), typeTitle: typeNameTextField.text!, typePicName: typePicName, typeIsSys: 1)
            
            typeModel.save()
        } else {
            typeModel.typeTitle = typeNameTextField.text!
            typeModel.typePicName = typePicName
            
            typeModel.saveOrUpdate()
        }
        
        SummaryReport.getTypeData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddTagCell
        
        cell.setCell(dataSource.object(at: indexPath.row) as! String, type: type)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        typeNameTextField.resignFirstResponder()
        typePicName = dataSource.object(at: indexPath.row) as! String
    }

}
