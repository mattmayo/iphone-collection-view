import UIKit

private let collectionViewCellReuseIdentifier = "collection-view-cell-reuse-identifier"

protocol CollectionViewControllerDelegate {
    func checkIn()
}

class CollectionViewController: UICollectionViewController, CollectionViewControllerDelegate {
    let businesses = ["Blue Bottle", "Sightglass", "Stumptown", "Four Barrel", "Ritual",
                      "Chromatic Coffee Co.", "Linea", "Front", "Verve", "Supersonic"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource, UIViewControllerDelegate

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.businesses.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewCellReuseIdentifier, forIndexPath: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.label.text = businesses[indexPath.row]
        cell.delegate = self
    
        return cell
    }
    
    // MARK: - CollectionViewControllerDelegate
    
    func checkIn() {
        let alert = UIAlertController(title: "You've been checked in", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { alertAction in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
            
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
