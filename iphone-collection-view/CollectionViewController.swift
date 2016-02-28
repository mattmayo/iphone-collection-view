import UIKit

private let collectionViewCellReuseIdentifier = "collection-view-cell-reuse-identifier"

class CollectionViewController: UICollectionViewController {
    let businesses = ["V-Cafe", "Sextant", "Super Que", "Vaper in Reverse", "Little Griddle"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.businesses.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewCellReuseIdentifier, forIndexPath: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.label.text = businesses[indexPath.row]
    
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return UIScreen.mainScreen().bounds.width / 8
    }
}
