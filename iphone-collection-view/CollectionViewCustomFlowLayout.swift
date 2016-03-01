import UIKit

class CollectionViewCustomFlowLayout: UICollectionViewFlowLayout {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let cardSize = CGSizeMake(200, 80)
    let cardScaleValue = CGFloat(0.7)
    let cardAlphaValue = CGFloat(0.9)

    override func prepareLayout() {
        let sideMargin = (screenWidth - cardSize.width) / 2
        self.scrollDirection = .Horizontal
        self.minimumInteritemSpacing = screenHeight
        self.minimumLineSpacing = 0
        self.itemSize = CGSizeMake(cardSize.width, cardSize.height)
        self.sectionInset = UIEdgeInsetsMake(0, sideMargin, 0, sideMargin)
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let proposedRect = CGRectMake(proposedContentOffset.x, 0, collectionView.bounds.size.width, collectionView.bounds.size.height)
        
        guard let layoutAttributes = self.layoutAttributesForElementsInRect(proposedRect) else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        var updatedAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionView.bounds.size.width / 2
        
        for attributes in layoutAttributes {
            if attributes.representedElementCategory != .Cell {
                continue
            }
            
            if updatedAttributes == nil {
                updatedAttributes = attributes
            } else if abs(attributes.center.x - proposedContentOffsetCenterX) < fabs(updatedAttributes!.center.x - proposedContentOffsetCenterX) {
                updatedAttributes = attributes
            }
        }
        
        guard let newAttributes = updatedAttributes else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        var newOffsetX = newAttributes.center.x - collectionView.bounds.size.width / 2
        let offset = newOffsetX - collectionView.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = self.itemSize.width + self.minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        
        return CGPointMake(newOffsetX, proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView,
              let superAttributes = super.layoutAttributesForElementsInRect(rect)else {
            return super.layoutAttributesForElementsInRect(rect)
        }
        
        let contentOffset = collectionView.contentOffset
        let size = collectionView.bounds.size
        let visibleRect = CGRectMake(contentOffset.x, contentOffset.y, size.width, size.height)
        let visibleCenterX = CGRectGetMidX(visibleRect)
        var newAttributesArray = [UICollectionViewLayoutAttributes]()
        
        let fromCenterMin = CGFloat(150)
        let fromCenterMax = CGFloat(300)
        
        
        for attributes in superAttributes {
            guard let newAttributes = attributes.copy() as? UICollectionViewLayoutAttributes else { continue }
            let distanceFromCenter = visibleCenterX - newAttributes.center.x
            let absDistanceFromCenterMin = min(abs(distanceFromCenter), fromCenterMin)
            let absDistanceFromCenterMax = min(abs(distanceFromCenter), fromCenterMax)
            let scale = absDistanceFromCenterMin * (cardScaleValue - 1) / self.cardSize.width + 1
            newAttributes.transform = CGAffineTransformMakeScale(scale, scale)
            var alpha = fabs(absDistanceFromCenterMin * (cardAlphaValue - 1))
            if absDistanceFromCenterMin == 0 {
                alpha = 1
            } else {
                alpha = (fromCenterMax - absDistanceFromCenterMax) / fromCenterMax
            }
            newAttributes.alpha = alpha
            
            newAttributesArray.append(newAttributes)
        }
        
        return newAttributesArray;
    }
}
