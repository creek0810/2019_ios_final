//
//  AllImagesViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/2.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class AllImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var images: [Image] = [Image]()
    var receiver: Friend = Friend(propic: "test", name: "", id: "")
    let fullScreenSize = UIScreen.main.bounds.size
    let spacing:CGFloat = 1

    
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var imagesCollectionLayout: UICollectionViewFlowLayout!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singalImage", for: indexPath) as! ImageCollectionViewCell
        
        if let image = Image.getImage(imageName: images[indexPath.row].imageName) {
             cell.singalImage.image = image
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 1
        
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.imagesCollection{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        self.performSegue(withIdentifier: "showSingalImageFromAll", sender: cell.singalImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollection.delegate = self
        imagesCollection.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.imagesCollection?.collectionViewLayout = layout
        
        if let data = Image.readImagesNameFromFile(receiver: receiver.id) {
            images = data
            imagesCollection.reloadData()
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSingalImageFromAll" {
            let image = sender as! UIImageView
            let controller = segue.destination as! SingalImage2ViewController
            controller.tmpImage = image.image!
        }
    }
 

}
