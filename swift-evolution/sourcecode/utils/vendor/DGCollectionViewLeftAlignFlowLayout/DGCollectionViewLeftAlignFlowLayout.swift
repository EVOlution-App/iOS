// Created by Digipolitan
// GitHub: https://github.com/Digipolitan/collection-view-left-align-flow-layout-swift

import UIKit

public class DGCollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    var delegate: UICollectionViewDelegateFlowLayout? {
        collectionView?.delegate as? UICollectionViewDelegateFlowLayout
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesCollection = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var updatedAttributes = [UICollectionViewLayoutAttributes]()
        for originalAttributes in attributesCollection {
            guard originalAttributes.representedElementKind == nil else {
                updatedAttributes.append(originalAttributes)
                continue
            }

            if let updatedAttribute = layoutAttributesForItem(at: originalAttributes.indexPath) {
                updatedAttributes.append(updatedAttribute)
            }
        }

        return updatedAttributes
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath)?
            .copy() as? UICollectionViewLayoutAttributes
        else {
            return nil
        }

        guard let collectionView else {
            return attributes
        }

        let firstInSection: Bool = indexPath.item == 0
        guard !firstInSection else {
            let section = attributes.indexPath.section
            let x = delegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section)
                .left ?? sectionInset.left
            attributes.frame.origin.x = x
            return attributes
        }

        let previousAttributes = layoutAttributesForItem(at: IndexPath(
            item: indexPath.item - 1,
            section: indexPath.section
        ))
        let previousFrame: CGRect = previousAttributes?.frame ?? CGRect()
        let firstInRow = previousFrame.origin.y != attributes.frame.origin.y

        guard !firstInRow else {
            let section = attributes.indexPath.section
            let x = delegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section)
                .left ?? sectionInset.left
            attributes.frame.origin.x = x
            return attributes
        }

        let interItemSpacing: CGFloat = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
            .collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section) ??
            minimumInteritemSpacing

        let x = previousFrame.origin.x + previousFrame.width + interItemSpacing
        attributes.frame = CGRect(x: x,
                                  y: attributes.frame.origin.y,
                                  width: attributes.frame.width,
                                  height: attributes.frame.height)

        return attributes
    }
}
