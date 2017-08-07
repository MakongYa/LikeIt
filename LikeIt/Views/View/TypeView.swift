

import UIKit

protocol TypeViewDelegate {
    func didSelectItemAtIndexPath(_ model: TypeModel)
}

class TypeView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var _collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var dataSource: NSArray = []
    var numberOfSections = 1
    var delegate: TypeViewDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        initCollectionView()
    }
    
    fileprivate func initCollectionView() {
        _collectionView.register(UINib(nibName: "TypeCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        _collectionViewFlowLayout.itemSize = CGSize(width: (self.width-30)/5, height: (self.height-25)/2)
        _collectionView.delegate = self
    }
    
    func reloadData(_ data: NSArray) {
        dataSource = data
        _collectionView.dataSource = self
        _collectionView.reloadData()
        
        _collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.top)
        delegate?.didSelectItemAtIndexPath(dataSource[0] as! TypeModel)
    }
    
    func selectRow(_ model: TypeModel) {
        for i in 0..<dataSource.count {
            let m = dataSource[i] as! TypeModel
            if model.typeTitle == m.typeTitle {
                _collectionView.selectItem(at: IndexPath(item: i, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.right)
                delegate?.didSelectItemAtIndexPath(m)
            }
        }
    }
    
    func cleanData() {
        dataSource = []
        _collectionView.dataSource = nil
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TypeCell

        let model = dataSource.object(at: indexPath.row) as! TypeModel
        cell.setCell(model.typePicName, model.typeTitle)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource.object(at: indexPath.row) as! TypeModel
        
        delegate?.didSelectItemAtIndexPath(model)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //设置cell的显示动画为3D，xy方向的缩放动画，初始值0.1，结束值1
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }

}
