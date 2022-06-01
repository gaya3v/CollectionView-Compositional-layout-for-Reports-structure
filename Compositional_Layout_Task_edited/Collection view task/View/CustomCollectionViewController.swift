//
//  ViewController.swift
//  Collection view task
//
//  Created by Gayathri V on 10/05/22.
//

import UIKit

class CustomCollectionViewController: UIViewController {
    //scroll control props
    
    var startingXPoint: CGFloat = 0
    var startingYPoint: CGFloat = 0
    var isVerticalScroll : Bool = false
    var isHorizontalScroll : Bool = false
    var latestXPoint : CGFloat = 0
    var latestYPoint : CGFloat = 0
    
    //datasources for collection view
    
    private let dataOrganiser = DataArrangementController()
    private lazy var headers = dataOrganiser.getHeaders()
    private lazy var sections = dataOrganiser.getSections()
    
    //collection view
    var sectionDataCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        return collectionView
    }()
    
    var headerCollectionView: UICollectionView = {
        let headerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        headerCollectionView.isDirectionalLockEnabled = true
        headerCollectionView.showsVerticalScrollIndicator = false
        headerCollectionView.showsHorizontalScrollIndicator = false
        headerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        headerCollectionView.bounces = false
        return headerCollectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHeaderCollectionView()
        configureCollectionView()
        configureLayout()
    }
    
    func configureHeaderCollectionView() {
        //collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerCollectionView.backgroundColor = UIColor.systemBackground
        view.addSubview(headerCollectionView)
        headerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        headerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        headerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "header")
    }
    
    func configureCollectionView() {
        //collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sectionDataCollectionView.backgroundColor = UIColor.systemBackground
        view.addSubview(sectionDataCollectionView)
        sectionDataCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        sectionDataCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        sectionDataCollectionView.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor).isActive = true
        sectionDataCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        sectionDataCollectionView.delegate = self
        sectionDataCollectionView.dataSource = self
        sectionDataCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
    }
    
    //MARK: setup layout for the 2 collectionViews
    
    func configureLayout() {
        let layout = setupCompositionalLayout()
        let headerLayout = setupHeaderLayout()
        layout.targetContentOffset(forProposedContentOffset: CGPoint.zero)
        sectionDataCollectionView.setCollectionViewLayout(layout, animated: true, completion: { _ in
            self.sectionDataCollectionView.reloadData()
        })
        headerCollectionView.setCollectionViewLayout(headerLayout, animated: true, completion: { _ in
            self.headerCollectionView.reloadData()
        })
    }
    
    
    //MARK: Header layout
    
    func setupHeaderLayout() -> UICollectionViewCompositionalLayout {
        let standardHeightForLayoutItem: CGFloat = 50
        let standardWidthForLayoutItem: CGFloat = 180
        
        let layout = UICollectionViewCompositionalLayout { [unowned self] (sectionNumber, environment) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(standardWidthForLayoutItem), heightDimension: .absolute(standardHeightForLayoutItem)))
            
            let headerGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                                    NSCollectionLayoutSize(widthDimension:
                                                                            .absolute(item.layoutSize.widthDimension.dimension * CGFloat((headers.count))),
                                                                                           heightDimension:  .estimated(standardHeightForLayoutItem)), subitem: item, count: (headers.count))
            
            let headerSection = NSCollectionLayoutSection(group: headerGroup)
            headerSection.orthogonalScrollingBehavior = .none
            return headerSection
        }
        return layout
    }
    
    //MARK: non-header sections' layout
    
    func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { [unowned self] (sectionNumber, environment) -> NSCollectionLayoutSection? in
            
            let currentSection = sections[sectionNumber]

            let collectionGroup = createGroupLayout(section: currentSection)             //group
            let contentSection = NSCollectionLayoutSection(group: collectionGroup)       //section
            contentSection.orthogonalScrollingBehavior = .none
            return contentSection
        }
        return layout
    }
    
    func createGroupLayout(section: Section) -> NSCollectionLayoutGroup {
        let standardHeightForLayoutItem: CGFloat = 50
        let standardWidthForLayoutItem: CGFloat = 180

        //last subsection : subsection array is empty
        
        if section.sub_sections.isEmpty {
            let rowCount = section.rows.count
            let rowItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(standardWidthForLayoutItem), heightDimension: .absolute(standardHeightForLayoutItem)))
            
            //rowgroup looks like this: |1.1.1 | data 1 | data 2 | data 3 |
            
            let rowGroupSize = NSCollectionLayoutSize(widthDimension:
                    .absolute(standardWidthForLayoutItem * CGFloat(rowCount + 1)),
                                                      heightDimension:  .absolute(standardHeightForLayoutItem))
                                                      
            let rowGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                               rowGroupSize,
                                                              subitem: rowItem,
                                                              count: rowCount + 1)
            return rowGroup
        }
        
       // if not the last subsection : rows = 0 & subsections != 0
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(CGFloat(standardWidthForLayoutItem)), heightDimension:
                .absolute(standardHeightForLayoutItem * CGFloat(section.count))))
        
        var groups: [NSCollectionLayoutGroup] = []
        var maxWidth: CGFloat = 0
        
        for nextSection in section.sub_sections {
            let innerGroup = createGroupLayout(section: nextSection) //recursive call
            maxWidth = max(maxWidth, innerGroup.layoutSize.widthDimension.dimension)
            groups.append(innerGroup)
        }
        
        //vertical stacking of each subsection group
        
        let subGroup = NSCollectionLayoutGroup.vertical(layoutSize:
                                                            NSCollectionLayoutSize(widthDimension:
                                                                    .absolute(CGFloat(maxWidth)),
                                                                                   heightDimension:
                                                                    .absolute(standardHeightForLayoutItem * CGFloat(section.count))),
                                                        subitems: groups)
        
            //final grouping for the parent section
        
        let finalGroupSize = NSCollectionLayoutSize(widthDimension:
                .absolute(subGroup.layoutSize.widthDimension.dimension + item.layoutSize.widthDimension.dimension),
                                                    heightDimension:
                .absolute(item.layoutSize.heightDimension.dimension))
        
        let finalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: finalGroupSize,
                                                            subitems: [item, subGroup])
        return finalGroup
    }
    
}

//MARK: collection view - data methods

extension CustomCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var sectionCount = 0
        
        switch collectionView {
        case headerCollectionView:
            sectionCount = 1
            
        case sectionDataCollectionView:
            sectionCount = (sections.isEmpty && headers.isEmpty) ? 0 : sections.count

        default:
            sectionCount = 0
        }
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case headerCollectionView:
            return headers.count
            
        case sectionDataCollectionView:
            return sections[section].childCount //section items count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let idealCell = UICollectionViewCell(frame: .zero)
        
        switch collectionView {
        case headerCollectionView:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) as? CustomCollectionViewCell {
                cell.setLabelText(text: headers[indexPath.item].label)
                cell.backgroundColor = UIColor.tertiarySystemBackground
                return cell
            }
            return idealCell
            
        case sectionDataCollectionView:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell {
                var data: [String] = []
                dataOrganiser.getDataForSection(section: sections[indexPath.section], dataArray: &data)
                cell.setLabelText(text: data[indexPath.row])
                cell.backgroundColor = UIColor(named: "theme") ?? UIColor.systemBackground
                return cell
            }
        default:
            break
        }
        return idealCell
    }
    
    
    //MARK: Display title on long press & hold
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if collectionView == headerCollectionView {
            let headerText = headers[indexPath.row].label
            return configureContextMenu(text: headerText)
        }
        
        else if collectionView == collectionView {
            var data: [String] = []
            dataOrganiser.getDataForSection(section: sections[indexPath.section], dataArray: &data)
            return configureContextMenu(text: data[indexPath.item])
        }
        return configureContextMenu(text: "NA")
    }
    
    
    func configureContextMenu(text: String) -> UIContextMenuConfiguration {
        
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let edit = UIAction(title: text, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.destructive, children: [edit])
        }
        return context
    }
    
}


extension CustomCollectionViewController {
    
    //MARK: scroll direction control
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startingXPoint = scrollView.contentOffset.x
        startingYPoint = scrollView.contentOffset.y
        isVerticalScroll = false
        isHorizontalScroll = false
        latestXPoint = startingXPoint
        latestYPoint = startingYPoint
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //sync header scroll
        coordinateScrolling(activeScrollView: scrollView)
        
        if !(isVerticalScroll || isHorizontalScroll)
        {
            if !isVerticalScroll,scrollView.contentOffset.x > (startingXPoint + 3) || scrollView.contentOffset.x < (startingXPoint - 3)
            {
                isHorizontalScroll = true
                latestYPoint = scrollView.contentOffset.y
                
                
            }
            if !isHorizontalScroll,scrollView.contentOffset.y > (startingYPoint + 3) || scrollView.contentOffset.y < (startingYPoint - 3)
            {
                isVerticalScroll = true
                latestXPoint = scrollView.contentOffset.x
            }
        }
        
        if isVerticalScroll || isHorizontalScroll
        {
            if isVerticalScroll
            {
                scrollView.contentOffset.x = startingXPoint
            }
            if isHorizontalScroll
            {
                scrollView.contentOffset.y = startingYPoint
                
            }
        }
        else
        {
            return
        }
        
    }
    
    //MARK: scrolling both collectionViews in sync - either vertically / horizontally at a time
    
    func coordinateScrolling(activeScrollView: UIScrollView) {
        
        if activeScrollView == sectionDataCollectionView {
            self.syncScrollView(headerCollectionView, scrollViewCurrentlyInScroll: sectionDataCollectionView)
        }
        
        else if activeScrollView == headerCollectionView {
            self.syncScrollView(sectionDataCollectionView, scrollViewCurrentlyInScroll: headerCollectionView)
        }
        
    }
    
    func syncScrollView(_ scrollViewToBeSynced: UIScrollView, scrollViewCurrentlyInScroll scrolledView: UIScrollView) {
        var scrollBounds = scrollViewToBeSynced.bounds
        scrollBounds.origin.x = scrolledView.contentOffset.x
        scrollViewToBeSynced.bounds = scrollBounds
    }

}
