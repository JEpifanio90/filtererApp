//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filteredImage: UIImage?
    var currentImage: UIImage?
    var currentFiltered: UIImage?
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var compareBtn: UIButton!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var negativeFilterBtn: UIButton!
    @IBOutlet weak var grayScaleBtn: UIButton!
    @IBOutlet weak var redFilterBtn: UIButton!
    @IBOutlet weak var greenFilterBtn: UIButton!
    @IBOutlet weak var blueFilterBtn: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var sliderTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.width = 1200
        compareBtn.enabled = false
        imageView.userInteractionEnabled = true
        eventButton.addTarget(self, action: Selector("holdRelease:"), forControlEvents: UIControlEvents.TouchUpInside);
        eventButton.addTarget(self, action: Selector("HoldDown:"), forControlEvents: UIControlEvents.TouchDown)
    }
    
    func HoldDown(sender:UIButton)
    {
        if(currentImage?.isEqual(NSNull) != nil && currentFiltered?.isEqual(NSNull) != nil)
        {
            if( imageView.image == currentImage)
            {
                imageView.image = currentFiltered
            }
            else
            {
                imageView.image = currentImage
            }
        }
    }
    
    func holdRelease(sender:UIButton)
    {
        if(currentImage?.isEqual(NSNull) != nil && currentFiltered?.isEqual(NSNull) != nil)
        {
            if( imageView.image == currentImage)
            {
                imageView.image = currentFiltered
            }
            else
            {
                imageView.image = currentImage
            }
        }
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    @IBAction func sliderChanged(sender: UISlider)
    {
        let currentValue = Int(sender.value)
        
        sliderTitle.text = "Value: \(currentValue)"
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func enableComparisonButton()
    {
        
        compareBtn.enabled = true
    }
    
    func showSecondaryMenu()
    {
        if((currentImage?.isEqual(NSNull)) == nil)
        {
            currentImage = imageView.image!
        }
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(84)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    
    func animateIt(filterImage: RGBAImage)
    {
        UIView.transitionWithView(imageView,
                                  duration:1,
                                  options: UIViewAnimationOptions.TransitionCrossDissolve,
                                  animations: { self.imageView.image = filterImage.toUIImage() },
                                  completion: nil)
    }
    
    func animateComparison(imageToInsert: UIImage)
    {
        UIView.transitionWithView(imageView,
                                  duration:1,
                                  options: UIViewAnimationOptions.TransitionFlipFromBottom,
                                  animations: { self.imageView.image = imageToInsert },
                                  completion: nil)
    }
    
    @IBAction func onNegativeFilterBtnClick(sender: UIButton)
    {
        var rgbaImage = RGBAImage(image: currentImage!)!
        for y in 0..<rgbaImage.height
        {
            for x in 0..<rgbaImage.width
            {
                let index = y*rgbaImage.width+x
                var pixel = rgbaImage.pixels[index]
                let red = 255 - (pixel.red)
                let green = 255-(pixel.green)
                let blue = 255-(pixel.blue)
                pixel.red = UInt8(red)
                pixel.green = UInt8(green)
                pixel.blue = UInt8(blue)
                rgbaImage.pixels[index] = pixel
            }
        }
        enableComparisonButton()
        animateIt(rgbaImage)
        currentFiltered = rgbaImage.toUIImage()
    }
    
    @IBAction func onGrayFilterBtnClick(sender: UIButton)
    {
        var rgbaImage = RGBAImage(image: currentImage!)!
        for y in 0..<rgbaImage.height
        {
            for x in 0..<rgbaImage.width
            {
                let index = y*rgbaImage.width+x
                var pixel = rgbaImage.pixels[index]
                let red = 0.21 * Double(pixel.red)
                let green = 0.72 * Double(pixel.green)
                let blue = 0.07 * Double(pixel.blue)
                let gray = red+green+blue
                pixel.red = UInt8(gray)
                pixel.green = UInt8(gray)
                pixel.blue = UInt8(gray)
                rgbaImage.pixels[index] = pixel
            }
        }
        enableComparisonButton()
        animateIt(rgbaImage)
        currentFiltered = rgbaImage.toUIImage()
    }
    
    
    @IBAction func onRedFilterBtnClick(sender: UIButton)
    {
        var rgbaImage = RGBAImage(image: currentImage!)!
        for y in 0..<rgbaImage.height
        {
            for x in 0..<rgbaImage.width
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                pixel.red = UInt8(255)
                rgbaImage.pixels[index]=pixel
            }
        }
        enableComparisonButton()
        animateIt(rgbaImage)
        currentFiltered = rgbaImage.toUIImage()
    }
    
    @IBAction func onGreenFilterBtnClick(sender: UIButton)
    {
        var rgbaImage = RGBAImage(image: currentImage!)!
        for y in 0..<rgbaImage.height
        {
            for x in 0..<rgbaImage.width
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                pixel.green = UInt8(255)
                rgbaImage.pixels[index]=pixel
            }
        }
        enableComparisonButton()
        animateIt(rgbaImage)
        currentFiltered = rgbaImage.toUIImage()
    }
    @IBAction func onBlueFilterBtnClick(sender: UIButton)
    {
        var rgbaImage = RGBAImage(image: currentImage!)!
        for y in 0..<rgbaImage.height
        {
            for x in 0..<rgbaImage.width
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                pixel.blue = UInt8(255)
                rgbaImage.pixels[index]=pixel
            }
        }
        enableComparisonButton()
        animateIt(rgbaImage)
        currentFiltered = rgbaImage.toUIImage()
    }
    
    @IBAction func onCompareBtnClick(sender: UIButton)
    {
        if(currentImage != imageView.image!)
        {
            filteredImage = imageView.image!
            animateComparison(currentImage!)
        }
        else
        {
            animateComparison(filteredImage!)
        }
    }
    @IBAction func onRedOverrideBtnClick(sender: AnyObject)
    {
        var rgbaImage = RGBAImage(image: currentImage!)!
        for y in 0..<rgbaImage.height
        {
            for x in 0..<rgbaImage.width
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                pixel.red = UInt8(valueSlider.value)
                rgbaImage.pixels[index]=pixel
            }
        }
        
        enableComparisonButton()
        animateIt(rgbaImage)
        currentFiltered = rgbaImage.toUIImage()
    }

    @IBAction func onBlueOverrideBtnClick(sender: UIButton)
    {
        var rgbaImage = RGBAImage(image: currentImage!)!
        for y in 0..<rgbaImage.height
        {
            for x in 0..<rgbaImage.width
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                pixel.blue = UInt8(valueSlider.value)
                rgbaImage.pixels[index]=pixel
            }
        }
        enableComparisonButton()
        animateIt(rgbaImage)
        currentFiltered = rgbaImage.toUIImage()
    }
    
    @IBAction func onGreenOverrideBtnClick(sender: UIButton)
    {
        var rgbaImage = RGBAImage(image: currentImage!)!
        for y in 0..<rgbaImage.height
        {
            for x in 0..<rgbaImage.width
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                pixel.green = UInt8(valueSlider.value)
                rgbaImage.pixels[index]=pixel
            }
        }
        enableComparisonButton()
        animateIt(rgbaImage)
        currentFiltered = rgbaImage.toUIImage()
    }
    
    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }

}

