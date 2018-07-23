//
//  PhotoGridViewController.swift
//  MCCTechTest
//
//  Created by Zert Interactive on 7/23/18.
//  Copyright © 2018 MCC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class PhotoGridViewController: UIViewController {

    
    
    @IBOutlet weak var gridCollectionVIew: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let CELLREUSEIDENTIFIER = "gridCell"
    
    lazy var viewModel: PhotoListViewModel = {
        return PhotoListViewModel()
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCollectionViewNib()
        customizeNavVIew()
        initVM()
        

        // Do any additional setup after loading the view.
    }
    
    private func customizeNavVIew(){
        self.title = "MCC App"
    }
    
   private func initVM() {
    
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.gridCollectionVIew.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.gridCollectionVIew.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadCollectionView = { [weak self] () in
            DispatchQueue.main.async {
                self?.gridCollectionVIew.reloadData()
            }
        }
        
        viewModel.fetchData()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   private func registerCollectionViewNib(){
        self.gridCollectionVIew.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CELLREUSEIDENTIFIER)
    }
}

extension PhotoGridViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   // Pragma mark - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PhotoCollectionViewCell = self.gridCollectionVIew.dequeueReusableCell(withReuseIdentifier: CELLREUSEIDENTIFIER, for: indexPath) as! PhotoCollectionViewCell
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.title.text = cellVM.titleText
        
        Alamofire.request(cellVM.imageUrl).responseImage { response in
            if let image = response.result.value {
                DispatchQueue.main.async {
                    cell.imageVIew.image = image
                }
            }
        }
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfCells
    }
    
    // Pragma mark - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice().userInterfaceIdiom == .pad {
            
            return CGSize(width:200,height:200)
            
        }else{
            
            return CGSize(width: 150, height: 150)
        }
    }
    
    
    
}
