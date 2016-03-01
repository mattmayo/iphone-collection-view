import UIKit

class CollectionViewCustomFlowLayout: UICollectionViewFlowLayout {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let cardSize = CGSizeMake(200, 80)

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
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionView.bounds.size.width / 2
        
        for attributes in layoutAttributes {
            if attributes.representedElementCategory != .Cell {
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
            }
            
            if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        
        if candidateAttributes == nil {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let newOffsetX = candidateAttributes!.center.x - collectionView.bounds.size.width / 2
        let offset = newOffsetX - collectionView.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = self.itemSize.width + self.minimumLineSpacing
            newOffsetX + velocity.x > 0 ? pageWidth : -pageWidth
        }
        
        return CGPointMake(newOffsetX, proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if self.collectionView == nil {
            return super.layoutAttributesForElementsInRect(rect)
        }
        
        let superAttributes = super.layoutAttributesForElementsInRect(rect)
        
        if superAttributes == nil {
            return nil
        }
        
        let contentOffset = self.collectionView!.contentOffset
        let size = self.collectionView!.bounds.size
        
        let visibleRect = CGRectMake(contentOffset.x, contentOffset.y, size.width, size.height)
        let visibleCenterX = CGRectGetMidX(visibleRect)
        
        var newAttributesArray = Array<UICollectionViewLayoutAttributes>()
        
        for attributes in superAttributes! {
            let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            newAttributesArray.append(newAttributes)
            let distanceFromCenter = visibleCenterX - newAttributes.center.x
            let absDistanceFromCenter = min(abs(distanceFromCenter), 150)
            let absDistanceFromCenterMax = min(abs(distanceFromCenter), 300)
            let scale = absDistanceFromCenter * (0.9 - 1) / 200 + 1
            let transformScale = CGAffineTransformScale(CGAffineTransformMakeScale(scale, scale), scale, scale)
            newAttributes.transform = transformScale
            var alpha = fabs(absDistanceFromCenter * (0.7 - 1))
            if absDistanceFromCenter == 0 {
                alpha = 1
            } else {
                alpha = (300 - absDistanceFromCenterMax) / 300 // 600 - 0 / 600
            }
            newAttributes.alpha = alpha
        }
        
        return newAttributesArray;
    }
}
