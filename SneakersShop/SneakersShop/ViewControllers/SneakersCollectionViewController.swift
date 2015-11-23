//
//  ViewController.swift
//  SneakersShop
//
//  Created by Kamil Wasag on 15/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//

import UIKit

class SneakersCollectionViewController: UICollectionViewController, UIAlertViewDelegate {
    
    var refreshControl = UIRefreshControl()
    var downloadingMoreSneakerNow:Bool = false
    private var productsArrays:Array<Array<SRProduct>>{
        var arrays = Array<Array<SRProduct>>()
        
        if let featured = self.featuredProducts {
            arrays.append(featured)
        }
        if let sneakers = self.sneakersProducts {
            arrays.append(sneakers)
        }
        
        return arrays
    }
    
    private var numberOfSections:Int {
        return self.productsArrays.count
    }
    
    //MARK: - Data model
    private var sneakersProducts:[SRProduct]?
    private var featuredProducts:[SRFeaturedProduct]?
    private var currentPage = 0
    
    //MARK: - Outlets
    @IBOutlet weak var cView:UICollectionView!
    @IBOutlet weak var noDataAlert: UIView!
    
    //MARK: - Contrant values
    private let defaultFeturedCellSize = CGSize(width: 500, height: 300)
    private let defaultSnekersCellSize = CGSize(width: 240, height: 300)
    private let defaultCellMargin = CGFloat(5)
    private let gender = NSUserDefaults.standardUserDefaults().stringForKey(UserDefaultsKeys.genderParameter)!
    private let serverConnection = SRFServerConnection.sharedInstance()
    
    //MARK: - Alert handling
    
    private func displayAlertAfterDownloadIfNeed() {
        if (self.productsArrays.count < 1)
        {
            self.noDataAlert.hidden = false
        }else if (self.productsArrays.count < 2){
            let message = self.sneakersProducts == nil ? "Only Feature product was download. Reload data?" : "Feature product was not download. Reload data?"
            
            
            let alert = UIAlertView(title: "Warning", message: message, delegate: self, cancelButtonTitle: "NO", otherButtonTitles: "OK")
            alert.tag = 0
            alert.show()
        }
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadInitialData()
        self.refreshControl.addTarget(self, action: Selector("downloadInitialData"), forControlEvents: UIControlEvents.ValueChanged)
        self.cView.addSubview(self.refreshControl)
    }
    
    //MARK: - Downloading data methods
    
    func downloadInitialData(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Downloading..."
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.serverConnection.downloadFeaturedForGender(self.gender) { (featured:[SRFeaturedProduct]?, error:NSError?) -> Void in
            if let prod = featured {
                self.featuredProducts = prod
            }
            self.currentPage=1
            self.serverConnection.downloadSneakersForGender(self.gender, withPageNumber: Int32(self.currentPage)) { (products:[SRProduct]?, error:NSError?) -> Void in
                if let prod = products {
                    self.sneakersProducts = prod
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.cView.reloadData()
                    })
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    hud.hide(true)
                    self.refreshControl.endRefreshing()
                    self.displayAlertAfterDownloadIfNeed()
                })
            }
        }
    }
    
    func downloadMoreSneakers(){
        if !self.downloadingMoreSneakerNow {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            let HUDyPosition = hud.frame.height - 20
            hud.center = CGPoint(x: self.view.center.x, y: HUDyPosition )
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.downloadingMoreSneakerNow = true
            self.serverConnection.downloadSneakersForGender(self.gender, withPageNumber: Int32(++self.currentPage)) { (products:[SRProduct]?, error:NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    hud.hide(true)
                })
                if let nProducts = products {
                    self.sneakersProducts?.appendContentsOf(nProducts)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.cView.reloadData()
                    })
                }else{
                    --self.currentPage
                    let alert = UIAlertView(title: "Warning", message: "There was problem during downloading new sneakers. Try again?", delegate: self, cancelButtonTitle: "NO", otherButtonTitles: "YES")
                    alert.tag = 1
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        alert.show()
                    })
                }
                self.downloadingMoreSneakerNow = false
                
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func reloadData(sender: UIButton) {
        self.noDataAlert.hidden = true
        self.downloadInitialData()
    }
    
    //MARK: - UIAlertViewDelegate methods
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex>0{
            if alertView.tag == 0 {
                self.downloadInitialData()
            }else{
                self.downloadMoreSneakers()
            }
        }else{
            self.cView.reloadData()
        }
    }

    //MARK: - UICollectionViewCells data setup methods
    
    private func setupFeaturedCell(cell:SRFeaturedSneakersCell, withProduct product:SRFeaturedProduct){
        cell.image = nil
        cell.designer = product.designer
        cell.price = product.price
        cell.productDescription = product.productDescription
        cell.tag = Int(product.productID)
        if let image = product.thumbnailImage {
            cell.image = image
        }else {
            product.downloadThumbnailImageWithCompletionHandler({ (error:NSError?) -> Void in
                if (error == nil){
                    if cell.tag == Int(product.productID) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.image = product.thumbnailImage
                        })
                    }
                }
            })
        }
    }
    
    private func setupSneakersCell(cell:SRSneakersCell, withProduct product:SRProduct){
        cell.image = nil
        cell.price = product.price
        cell.designer = product.designer
        cell.tag = Int(product.productID)
        if let image = product.thumbnailImage {
            cell.image = image
        }else{
            product.downloadThumbnailImageWithCompletionHandler({ (error:NSError?) -> Void in
                if(error == nil){
                    if cell.tag == Int(product.productID){
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.image = product.thumbnailImage
                        })
                        
                    }
                }
            })
        }
    }
    
    //MARK: - UICollectionViewDataSource method
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.numberOfSections
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productsArrays[section].count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let featuredProductIdentifeir = "featuredProductIdentifeir"
        let sneackerProductCellIdentifier = "sneackerProductCellIdentifier"
        
        let product = self.productsArrays[indexPath.section][indexPath.row]
        
        var curentIdentifier = sneackerProductCellIdentifier
        if let _ = product as? SRFeaturedProduct {
            curentIdentifier = featuredProductIdentifeir
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(curentIdentifier, forIndexPath: indexPath)
        
        if let fCell = cell as? SRFeaturedSneakersCell{
            self.setupFeaturedCell(fCell, withProduct: product as! SRFeaturedProduct)
        }
        
        if let sCell = cell as? SRSneakersCell{
            self.setupSneakersCell(sCell, withProduct: product)
        }
        
        return cell
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        var size = CGSizeZero
        if let array = self.featuredProducts {
            if self.productsArrays[indexPath.section]==array{
                if self.view.bounds.width-2*self.defaultCellMargin < self.defaultFeturedCellSize.width
                {
                    let cellRatio = self.defaultFeturedCellSize.width/self.defaultFeturedCellSize.height
                    size.width = self.view.bounds.width-2*self.defaultCellMargin
                    size.height = size.width/cellRatio
                }else{
                    size = self.defaultFeturedCellSize
                }
            }
        }
        
        if let array = self.sneakersProducts {
            if self.productsArrays[indexPath.section]==array {
                if self.view.bounds.width-3*self.defaultCellMargin < self.defaultSnekersCellSize.width*2{
                    let cellRatio = self.defaultSnekersCellSize.width/self.defaultSnekersCellSize.height
                    size.width = (self.view.bounds.width-3*self.defaultCellMargin)/2
                    size.height = size.width/cellRatio
                }else{
                    size = self.defaultSnekersCellSize
                }
            }
        }
        return size
    }

    
    //MARK: - UICollectionViewDelegate methods
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(self.productsArrays[indexPath.section][indexPath.row].url)
    }
    
    //MARK: - UIScrollViewDelegate methods
    
    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        self.checkToDownloadMoreDataWitchScrollView(scrollView)
    }
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate: Bool){
        self.checkToDownloadMoreDataWitchScrollView(scrollView)
    }
    
    private func checkToDownloadMoreDataWitchScrollView(scrollView:UIScrollView){
        let offset = scrollView.contentOffset;
        let bounds = scrollView.bounds;
        let size = scrollView.contentSize;
        let inset = scrollView.contentInset;
        let y = offset.y + bounds.size.height - inset.bottom;
        let h = size.height;
        
        let reload_distance = self.defaultSnekersCellSize.height;
        if(y + reload_distance > h ) {
            self.downloadMoreSneakers()
        }
    }
}

