# Report-table-using-Collection-view-compositional-layout

Table with multiple rows and columns and internal sectioning - achieved using collection view compositional layout.


**STATEMENT:**

The problem statement is to create a table with many sections which further branches into 'N' level of subsections and the last Nth subsection level has 'M' number of rows as given in the image. The headers (first row in the table given) should remain static at top while scrolling vertically.

_Expected output:_

<img width="655" alt="Screenshot 2022-06-01 at 3 39 47 PM" src="https://user-images.githubusercontent.com/48595252/171381615-80eb13ee-36af-4a75-8f9e-b7c480b21b7e.png">

**OUTPUT:**

https://user-images.githubusercontent.com/48595252/171376902-75c15f0c-f31a-438d-b7ad-ba511316444a.mp4

**REFERENCES:**

_I. Apple Documentations:_

For Compositional Layout implementation:

1. https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout
2. https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views
3. https://developer.apple.com/documentation/appkit/nscollectionviewcompositionallayoutsectionprovider

Scroll-related implementations:

4. https://developer.apple.com/documentation/uikit/uiscrollviewdelegate

Context menu display on long tap:

5. https://developer.apple.com/documentation/uikit/uicollectionviewdelegate/3295917-collectionview

_II. Other Blogs / articles:_

1. https://lickability.com/blog/getting-started-with-uicollectionviewcompositionallayout/
2. https://www.zealousweb.com/how-to-use-compositional-layout-in-collection-view/

_III. Videos:_

1. https://developer.apple.com/videos/play/wwdc2019/215/
2. https://www.youtube.com/watch?v=y1uXXVUu43o
3. https://www.youtube.com/watch?v=vAhas_my5mo

**APPROACH (in brief):**

The proposed solution involves creating two collectionViews, headerCollectionView and sectionCollectionView for the header and section layouts. 

The data is filled in the collectionView using the layout code provided by the closure,

  _UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in ... }_ by using a DFS-tree-traversal of the nested objects in the JSON datasource.

The table is made of non-uniform cells (width of cell is fixed: 180 and height of the last row cell has a standard height of 50).

 **(Refer: - func setupCompositionalLayout() and func setupHeaderLayout() methods in the file CustomCollectionViewController.swift)**
