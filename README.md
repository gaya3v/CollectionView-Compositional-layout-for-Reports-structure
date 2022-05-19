# Spreadsheet-view-using-compositional-layout
Spreadsheet with multiple rows and columns and internal sectioning - achieved using collection view compositional layout

Visualising the project - Note that the idea is not to create a spreadsheet made of uniform rows and columns like a grid (which can be achieved using a flow layout), but also to make multiple subsectioning possible as given in the image. 

As there is bidirectional scrolling involved, flow layouts might just not work fine so we are preferring UICollectionViewCompositionalLayouts for achieving the required layout as output.

<img width="655" alt="Screenshot 2022-05-11 at 7 44 01 PM" src="https://user-images.githubusercontent.com/48595252/169320400-674158ba-52ee-4423-bc07-0a9d49753d5f.png">


If you're wondering where would this project be of use, I've sketched the problem statement as a use case (here,annual sales and performance reports is given as an example).

<img width="683" alt="Screenshot 2022-05-17 at 5 42 47 PM" src="https://user-images.githubusercontent.com/48595252/169320276-2095a4ba-e63e-4f7f-a2dc-55878d738e0f.png">

