//
//  PhotosVC.swift
//  Homework 6.1
//
//  Created by Stas on 07.12.2020.
//

import UIKit
import Foundation
import SDWebImage

struct Photo: Codable {
    var url: String
}

class PhotosVC: UIViewController {

    var imageURLs: [Photo] = []
    var counter: Int = 0
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counter = UserDefaults.standard.integer(forKey: "OpenCount") ?? 0
        UserDefaults.standard.setValue(counter + 1, forKey: "OpenCount")
        print("It's the \(UserDefaults.standard.integer(forKey: "OpenCount")) openning")
        getURLAPI()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "customCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
    }
    
    func getURLAPI() {
        guard let imgUrl = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        URLSession.shared.dataTask(with: imgUrl) { data, _, _ in
            if
                let data = data,
                let urls = try? JSONDecoder().decode([Photo].self, from: data)
            {
                self.imageURLs = urls.prefix(30).map { Photo(url: $0.url) }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }.resume()
    }
}

extension PhotosVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CollectionViewCell
            var imageUrl = URL(string: imageURLs[indexPath.item].url)
            cell.loadImage.sd_setImage(with: imageUrl)
        return cell
    }
}

extension PhotosVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "fullScrean") as! ViewController
        present(controller, animated: true)
        let imageUrl = URL(string: imageURLs[indexPath.item].url)
        controller.fullImage.sd_setImage(with: imageUrl)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 40) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

