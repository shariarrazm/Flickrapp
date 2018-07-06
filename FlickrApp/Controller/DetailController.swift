//
//  DetailController.swift
//  FlickrApp
//
//  Created by Shariar Razm1 on 2018-06-22.
//  Copyright © 2018 Shariar Razm. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage


class DetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var ownerId = String("")
    var publicPhotos = [PublicPhotos]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(DetailCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow-2"), style: .plain, target: self, action: #selector(handleBack))
        
        //Calling  api in order get more photos of selected user
        self.callGetPhotos()
    }
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DetailCell
        
        var photo = publicPhotos[indexPath.row] as! PublicPhotos
        cell.infoLabel.text = photo.title
        cell.imageView.sd_setImage(with: URL(string: self.getURl(photo: photo)), placeholderImage: UIImage(named: Constants.kNoImage))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publicPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func getURl(photo: PublicPhotos) -> String {
        var strURL = String("")
        
        strURL = "https://farm\(photo.farm!).staticflickr.com/\(photo.server!)/\(photo.id!)_\(photo.secret!).jpg"
        
        return strURL
    }
}
extension DetailController {
    //This method will call api in order to get all photos
    func callGetPhotos() {
        
        CommonMethods.sharedInstance.showLoader(self, strMsg: Constants.kLoading)
        let strUrl = "\(Constants.kGetPublicPhotoURL)\(ownerId)"
        
        
        WebServiceManager.sharedInstance.sendAPIRequestForGet(andURLString: strUrl, withOwner: self, withSelector: #selector(self.getresonse(obj:)))
    }
    
    @objc func getresonse(obj: AnyObject){
        var response = ((obj as! NSDictionary).value(forKey: "photos") as! NSDictionary)
        print("REsposne \(response)")
        //Clearing array element
        publicPhotos = [PublicPhotos]()
        self.collectionView?.reloadData()
        CommonMethods.sharedInstance.removeLoader(self)
        if let photo = Mapper<PublicPhotos>().mapArray(JSONObject: response.value(forKey: "photo")) {
            self.publicPhotos = photo
            self.collectionView?.reloadData()
            //Checking whether we have received any data or not if not it means that 
            if self.publicPhotos.count == 0 {
                CommonMethods.sharedInstance.displayAlert(message: "No photos found", cancelButtonTitle: "Ok", presentingController: self)
            }
            print(self.publicPhotos.count)
        } else
        {
            CommonMethods.sharedInstance.displayAlert(message: "Invalid Response", cancelButtonTitle: "Ok", presentingController: self)
        }
    }
}
