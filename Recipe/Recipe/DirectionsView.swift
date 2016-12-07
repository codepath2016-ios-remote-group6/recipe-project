//
//  DirectionsView.swift
//  Recipe
//
//  Created by Craig Vargas on 12/6/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class DirectionsView: UIView {
    
    public static let name = "DirectionsView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var directionsTextView: UITextView!
    
    var directions: String?{
        didSet{
            directionsTextView.text = directions
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        self.directions = "wrong initializer"
        super.init(frame: frame)
        initSubviews()
    }
    
    init(frame: CGRect, directions: String?) {
        self.directions = directions
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.directions = "init coder"
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    func initSubviews(){
        let nib = UINib(nibName: DirectionsView.name, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        directionsTextView.text = directions
        addSubview(contentView)
    }

}
