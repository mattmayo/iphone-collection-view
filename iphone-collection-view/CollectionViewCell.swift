import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    var delegate: CollectionViewControllerDelegate?
    
    @IBAction func checkInButtonTouched(sender: UIButton) {
        if let delegate = self.delegate {
            delegate.checkIn()
        }
    }
}
