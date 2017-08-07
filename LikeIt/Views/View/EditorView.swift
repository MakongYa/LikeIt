

import UIKit

protocol EditorViewDelegate {
    func executeUpdate(_ index: Int)
    func executeDelete(_ index: Int)
}

class EditorView: UIView {
    
    var delegate: EditorViewDelegate?
    var index: Int!

    @IBAction func updateAction(_ sender: UIButton) {
        delegate?.executeUpdate(index)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        delegate?.executeDelete(index)
    }

}
