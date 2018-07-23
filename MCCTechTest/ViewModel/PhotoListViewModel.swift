//
//  PhotoListViewModel.swift
//  MCCTechTest
//
//  Created by Zert Interactive on 7/23/18.
//  Copyright © 2018 MCC. All rights reserved.
//

import Foundation
import Alamofire
class PhotoListViewModel {
    
   private var photos: [Photo] = [Photo]()
    
    private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    var isLoading: Bool = false{
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    
    
    
    var reloadCollectionView: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
   public func fetchData() {
        self.isLoading = true
        let parameters = [
            "AppId": 9,
            "MenuId": 35
        ]
        
        guard let url = URL(string: "https://nationalappsbangladesh.com/mobsvc/ContentFile.php") else {
            return
        }
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("")
                    return
                }
                self.isLoading = false

                
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                
                // print(json)
                
                guard let jsonContent = json["contentfilelist"] as? [[String: Any]] else {
                    print("Could not get todo title from JSON")
                    return
                }
                
                for dictItem in jsonContent{
                    print("item is : \(dictItem)")
                    
                    guard let pTitle = dictItem["Title"] as? String, let imageurl = dictItem["IMG"] as? String else{
                        print("something error occured")
                        return
                    }
                    
                    self.photos.append(Photo(title: pTitle, imageUrlStirng: imageurl))
                    
                }
                
                self.processFetchedPhoto(photos: self.photos)
                
        }
    }
    
    private func processFetchedPhoto( photos: [Photo] ) {
        self.photos = photos // Cache
        var vms = [PhotoListCellViewModel]()
        for photo in photos {
            vms.append( PhotoListCellViewModel(titleText: photo.title, imageUrl: photo.imageUrlStirng) )
        }
        self.cellViewModels = vms
    }
    
}

struct PhotoListCellViewModel {
    let titleText: String
    let imageUrl: String
}
