import UIKit

class CollectionViewCustomFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        let cardWidth: CGFloat = 200
        let cardHeight: CGFloat = 80
        let sideMargin = (screenWidth - cardWidth) / 2
        self.scrollDirection = .Horizontal
        self.minimumInteritemSpacing = screenHeight
        self.minimumLineSpacing = screenWidth / 8
        self.itemSize = CGSizeMake(cardWidth, cardHeight)
        
        self.sectionInset = UIEdgeInsetsMake(0, sideMargin, 0, sideMargin)
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        print("proposedContentOffset x: " + proposedContentOffset.x.description + " y: " + proposedContentOffset.y.description)
        print("velocity x: " + velocity.x.description + " y: " + velocity.y.description)
        
        guard let collectionView = self.collectionView else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        var calculatedContentOffset = proposedContentOffset
        
        if (proposedContentOffset.x > collectionView.contentOffset.x) {
            calculatedContentOffset.x = collectionView.contentOffset.x + collectionView.bounds.size.width / 2
        } else if (proposedContentOffset.x < collectionView.contentOffset.x) {
            calculatedContentOffset.x = collectionView.contentOffset.x - collectionView.bounds.size.width / 2
        }
        
        var offsetAdjustment = CGFloat.max
        let horizontalCenter = calculatedContentOffset.x + collectionView.bounds.size.width / 2
        let targetRect = CGRectMake(calculatedContentOffset.x, 0, collectionView.bounds.size.width, collectionView.bounds.size.height)
        
        guard let layoutAttributes = self.layoutAttributesForElementsInRect(targetRect) else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
        for attributes in layoutAttributes {
            let itemHorizontalCenter = attributes.center.x
            if (abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment)) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return super.targetContentOffsetForProposedContentOffset(CGPointMake(calculatedContentOffset.x + offsetAdjustment, calculatedContentOffset.y) , withScrollingVelocity: velocity)
    }
}
