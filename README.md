# Table-view-using-compositional-layout

Table with multiple rows and columns and internal sectioning - achieved using collection view compositional layout.


**STATEMENT:**

The problem statement is to create a table with many sections which further branches into 'N' level of subsections and the last Nth subsection level has 'M' number of rows as given in the image. The headers (first row in the table guven) should remain static at top while scrolling vertically.

_Expected output table format:_

<img width="655" alt="Screenshot 2022-06-01 at 3 39 47 PM" src="https://user-images.githubusercontent.com/48595252/171381615-80eb13ee-36af-4a75-8f9e-b7c480b21b7e.png">


**APPROACH:**

The proposed solution involves creating two collectionViews, headerCollectionView and sectionCollectionView for the header and section layouts. 

The data is filled in the collectionView using the layout code provided by the closure,

  _UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in ... }_ 

The table is made of non-uniform cells (width of cell is fixed: 180 and height of the last row cell has a standard height of 50).

 **(Refer: - func setupCompositionalLayout() and func setupHeaderLayout() methods in the file CustomCollectionViewController.swift)**


Output:


https://user-images.githubusercontent.com/48595252/171376902-75c15f0c-f31a-438d-b7ad-ba511316444a.mp4

