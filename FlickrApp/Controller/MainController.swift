//
//  MainViewController.swift
//  FlickrApp
//
//  Created by Shariar Razm1 on 2018-06-21.
//  Copyright © 2018 Shariar Razm. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

class MainController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let cellId = "cellId"
    var arrPhotos = [Photo]()
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter text here"
        sb.barTintColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1.0)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1.0)
        sb.delegate = self
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationItem.title = "TITLE"
        
        
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.safeAreaLayoutGuide.topAnchor, leading: navBar?.safeAreaLayoutGuide.leadingAnchor, bottom: navBar?.safeAreaLayoutGuide.bottomAnchor, trailing: navBar?.safeAreaLayoutGuide.trailingAnchor)
        
        collectionView?.register(MainCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MainCell
        let photo = arrPhotos[indexPath.row] as! Photo
        //Setting title of phot
        cell.nameLabel.text = photo.title
        //Setting image from url
        cell.profileImageView.sd_setImage(with: URL(string: photo.url_o!), placeholderImage: UIImage(named: Constants.kNoImage))
        //cell.profileImageView.backgroundColor = .red
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = arrPhotos[indexPath.row] as! Photo
        let layout = UICollectionViewFlowLayout()
        let detailController = DetailController(collectionViewLayout: layout)
        detailController.ownerId = photo.owner!
        let navController = UINavigationController(rootViewController: detailController)
        present(navController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search bar clicked")
        self.view.endEditing(true)
        var strText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if strText?.count == 0 {
            
        }
        else
        {
            self.callGetPhotos(str: strText!)
        }
        
    }
    func callGetPhotos(str: String) {
    
        //SwiftLoader.show(title: Constants.kLoading, animated: true)
        CommonMethods.sharedInstance.showLoader(self, strMsg: Constants.kLoading)
        let strUrl = "\(Constants.kGetPhotoURL)\(str)"
    WebServiceManager.sharedInstance.sendAPIRequestForGet(andURLString: strUrl, withOwner: self, withSelector: #selector(self.getresonse(obj:)))
    }
    
    @objc func getresonse(obj: AnyObject){
        var response = ((obj as! NSDictionary).value(forKey: "photos") as! NSDictionary)
        print("REsposne \(response)")
        self.arrPhotos = [Photo]()
        self.collectionView?.reloadData()
        
        CommonMethods.sharedInstance.removeLoader(self)
        //SwiftLoader.hide()
        if let photo = Mapper<Photo>().mapArray(JSONObject: response.value(forKey: "photo")) {
            self.arrPhotos = photo
            
            if self.arrPhotos.count == 0 {
                CommonMethods.sharedInstance.displayAlert(message: "No photos found", cancelButtonTitle: "Ok", presentingController: self)
            }
            self.collectionView?.reloadData()
            print(self.arrPhotos.count)
        } else
        {
            CommonMethods.sharedInstance.displayAlert(message: "Invalid Response", cancelButtonTitle: "Ok", presentingController: self)
            //
            //self.showAlert(error: App.Errors.invalidResponse)
        }
    }
}


