//
//  MusicRecommendFactory.swift
//  ExProtocolOrientedCollectionView
//
//  Created by Kant on 12/15/23.
//

import UIKit

protocol CellViewModelType {
    var action: Any? { get }
    var size: CGSize { get }
    var reuseIdentifier: String { get }
    var inset: UIEdgeInsets { get }
}

protocol SectionViewModelType: CellViewModelType {
    var action: Any? { get }
    var size: CGSize { get }
    var reuseIdentifier: String { get }
    var inset: UIEdgeInsets { get }
    var itemSpacing: CGFloat { get set }
    var sectionSpacing: CGFloat { get }
    var viewWeight: Int { get set }
}

struct CollectionViewModel {
    var header: SectionViewModelType?
    var footer: SectionViewModelType?
    var list: [CellViewModelType]?

    init(header: SectionViewModelType? = nil,
         footer: SectionViewModelType? = nil,
         list: [CellViewModelType]? = nil,
         itemSpaacing: CGFloat = 8,
         sectionSpacing: CGFloat = 1) {
        self.header = header
        self.footer = footer
        self.list = list
    }
}

struct FavoriteCellType: Equatable {
    var contentType: CellContentType
    var alignType: CellAlignType
    
    static func == (lhs: FavoriteCellType, rhs: FavoriteCellType) -> Bool {
        return lhs.contentType == rhs.contentType &&
        lhs.alignType == rhs.alignType
    }
}

enum CellContentType: String {
    case vod =  "vod"
    case live  = "live"
    case animation = "animation"
    case seasonal = "seasonal"
    case banner = "banner"
    case subscriptionBanner = "subscription_banner"
    case tailor = "tailor"
}

enum CellAlignType: String {
    
    case slide = "slide"
    case grid = "grid"
    case poster = "poster"
    case list = "list"
    case grouped = "grouped"
    case seasonal = "seasonal"
    case banner = "banner"
    case subscriptionBanner = "subscription_banner"
    case none
    
}

struct MusicRecommendSectionViewModel: SectionViewModelType {
    var action: Any?
    var size: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 45)
    }
    
    // TODO: 해결 필요
    var reuseIdentifier: String {
        return MusicRecommendHeaderView.reuse
    }
    
    var inset: UIEdgeInsets {
        return .zero
    }
    
    var itemSpacing: CGFloat = 0
    var sectionSpacing: CGFloat = 0
    var viewWeight: Int = 0
    
    var title: String
    
}

protocol MusicFactoryType {
    var cellType: FavoriteCellType { get set }
    func getType() -> CollectionViewModel
}

struct MusicRecommendFactory: MusicFactoryType {
    var cellType: FavoriteCellType
    
    
    // TODO: 해결 필요
    func getType() -> CollectionViewModel {
        let header =
        let section = CollectionViewModel(header: <#T##SectionViewModelType?#>)
        return section
    }
    
    
}
