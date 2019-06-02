//
//  AllImagesViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/2.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class AllImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var images: [Image] = [Image]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singalImage", for: indexPath) as! ImageCollectionViewCell
        let urlStr = "http://140.121.197.197:6700/image?path=\(images[indexPath.row].imageName)"
        if let url = URL(string: urlStr) {
            let data = try? Data(contentsOf: url)
            if let imageData = data{
                cell.singalImage.image = UIImage(data: imageData)
            }
        }
        return cell
    }
    
    
    @IBOutlet weak var imagesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollection.delegate = self
        imagesCollection.dataSource = self
        if let data = Image.readImagesFromFile(receiver: "test") {
            images = data
            imagesCollection.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
