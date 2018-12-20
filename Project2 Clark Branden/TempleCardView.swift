//
//  TempleCard.swift
//  Project2 Clark Branden
//
//  Created by Branden Clark on 10/17/18.
//  Copyright © 2018 Branden Clark. All rights reserved.
//

import UIKit

class TempleCardView: UIView {
    // MARK: - Constants
    struct Storyboard {
        static let ModeSwitchAnimationTime = 0.75
        static let TempleImageHeight: CGFloat = 80
        static let BorderWidth: CGFloat = 2
        static let NameFontSize: CGFloat = 12
        static let Font = "palatino-bold"
        static let FontVertOffset: CGFloat = 0.85
    }
    @IBOutlet weak var TempleCellHeight: NSLayoutConstraint!
    @IBOutlet weak var TempleCellWidth: NSLayoutConstraint!
    
    
    
    // MARK: - Properties
    var templeCard: TempleCard!
    var nameLength: Int = 0
    
    
    
    // MARK: - Computed Properties
    var cornerRadius : CGFloat { return bounds.width * 0.05}
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func setup() {
        backgroundColor = UIColor.clear
        isOpaque = false
    }
    
    
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        guard let templeImage = UIImage(named: templeCard.getFileName()) else {
            return
        }
        
        updateCellDimensions(image: templeImage)
        drawBaseCard()
        drawBorder()
        drawTempleImage(image: templeImage)
        
        if templeCard.getIsStudyMode() {
            UIView.animate(withDuration: Storyboard.ModeSwitchAnimationTime){
                self.drawNameLabel()
            }
        }
    }
    
    
    private func drawBaseCard() {
        let roundedRect = UIBezierPath(roundedRect: bounds,
                                       cornerRadius: cornerRadius)
        
        roundedRect.addClip()
        UIColor.white.setFill()
        UIRectFill(bounds)
    }
    
    
    private func drawBorder() {
        self.layer.borderWidth = Storyboard.BorderWidth
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    
    
    private func drawNameLabel() {
        let font = templeCardFont(ofSize: Storyboard.NameFontSize)
        let nameLabel = NSAttributedString(string: "\(templeCard.getName())",
            attributes:
                [
                    .font: font,
                    .foregroundColor: UIColor.white,
                    .backgroundColor: UIColor.gray
                ])
        
        //Center the text area
        var textBounds = CGRect.zero
        textBounds.size = nameLabel.size()
        textBounds.origin = CGPoint(x: ((bounds.width / 2)
                                        - ((textBounds.size.width) / 2)),
                                    y: (bounds.height * Storyboard.FontVertOffset))
        
        nameLabel.draw(in: textBounds)
    }
    
    
    private func drawTempleImage(image: UIImage) {
        let width = bounds.width
        
        let templeImageRect = CGRect(x: 0,
                                     y: 0,
                                     width: width,
                                     height: Storyboard.TempleImageHeight)

        image.draw(in: templeImageRect)
    }
    
    
    private func updateCellDimensions(image: UIImage) {
        TempleCellWidth.constant = image.size.width/image.size.height
                                    * Storyboard.TempleImageHeight
        TempleCellHeight.constant = Storyboard.TempleImageHeight
        
    }
    
    
    
    // MARK: - Helpers
    private func templeCardFont(ofSize fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: Storyboard.Font, size: fontSize) {
            return font
        }
        
        return UIFont.preferredFont(forTextStyle: .footnote)
    }
}
