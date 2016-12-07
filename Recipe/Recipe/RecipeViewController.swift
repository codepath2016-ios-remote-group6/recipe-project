//
//  RecipeViewController.swift
//  Recipe
//
//  Created by Iria on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var directionsTextView: UITextView!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var prepTimeUnitLabel: UILabel!
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var editButtonImageView: UIImageView!
    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var ingredientTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editButtonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editButtonViewWidthConstraint: NSLayoutConstraint!
    
    
    var recipe: Recipe!
    var ingredientsArray: [Ingredient]!
    var sourceType: String?
    var scrollViewWidth: CGFloat!
    let titles = ["INGREDIENTS","DIRECTIONS"]
    let smallDim = CGFloat(50.0)
    let largeDim = CGFloat(150.0)
    
    var ingredientsView: IngredientsView!
    var directionsView: DirectionsView!
    
    var menuEditLabel: UILabel!
    var menuCopyLabel: UILabel!
    var menuCancelLabel: UILabel!
    var menuDiv1View: UIView!
    var menuDiv2View: UIView!
    var editTap: UITapGestureRecognizer!
    var copyTap: UITapGestureRecognizer!
    var cancelTap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsArray = recipe.ingredientObjList
        

        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.alwaysBounceVertical = false
        ingredientsTableView.allowsSelection = false
        ingredientsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // This assumes there is always at least one ingredient
        var tableViewHeight = CGFloat(ingredientsTableView.rowHeight) * CGFloat((ingredientsArray.count))
        
        // Restrict max height to 250
        tableViewHeight = tableViewHeight < 250 ? tableViewHeight : 250
        
        ingredientTableViewHeightConstraint.constant = tableViewHeight
        
        // Don't allow editing of a recipe from an external source
        if sourceType == "edamam" {
            editButton.tintColor = UIColor.lightText
        }
        
        setupSubviews()
        setupGestureRecognizers()
        setupMenuItems()
        formatView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        recipe.setImageIn(imageView: recipeImageView, placeholder: #imageLiteral(resourceName: "placeholder"))
        recipeImageView.clipsToBounds = true
        recipeNameLabel.text = recipe.name
        
        difficultyLabel.text = recipe.getDifficulty()
        
        // Only display prep time if one is set.
        if recipe.prepTime > 0 {
            prepTimeLabel.text = "\(Int(recipe.prepTime))"
            prepTimeUnitLabel.text = recipe.prepTimeUnits
        } else {
            prepTimeLabel.text = ""
            prepTimeUnitLabel.text = ""
        }
        
        // Show a link if we are looking at a recipe copied from the API, otherwise show the directions
        if let inspiredByRecipeUrl = recipe.inspiredByRecipeUrl {
            directionsTextView.text = "\(inspiredByRecipeUrl)"
        } else {
            directionsTextView.text = recipe.directionsString
        }
        
        // Show the user that there is some scrollable content here
        directionsTextView.flashScrollIndicators()
        ingredientsTableView.flashScrollIndicators()
        
        ingredientsTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Make sure the text area starts displaying from the top
        directionsTextView.setContentOffset(CGPoint.zero, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "unwindToRecipeList", sender: self)
    }
    
    @IBAction func didTapEdit(_ sender: UIBarButtonItem) {
        if editButtonView.bounds.width == smallDim{
            expandEditButtonView(animated: true)
        }else{
            collapseEditButtonView(animated: true)
        }
    }
    
    @IBAction func didTapClose(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToRecipeList", sender: self)
    }
    
    @IBAction func pageValueChanged(_ sender: UIPageControl) {
        let correctOffsetX = CGFloat(sender.currentPage) * scrollViewWidth
        if contentScrollView.contentOffset.x != correctOffsetX{
            contentScrollView.setContentOffset(CGPoint(x: correctOffsetX, y: 0.0), animated: true)
            setContentTitle(index: sender.currentPage, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "IngredientListCell", for: indexPath) as! IngredientListCell
        
        let ingredient = ingredientsArray[indexPath.row]
        
        cell.quantityLabel.text = "\((ingredient.quantity))"
        cell.unitLabel.text = ingredient.unit
        cell.nameLabel.text = ingredient.name
        
        cell.alternativeTextLabel.text = ingredient.alternativeText
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("DidScroll: contentOffset->\(scrollView.contentOffset)")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        hideContentTitle(animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollViewWidth)
        pageControl.currentPage = page
        self.contentTitleLabel.text = self.titles[page]
        showContentTitle(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("segue identifier \(segue.identifier)")
        let destinationVc = segue.destination
        var recipeForNextVc: Recipe!
        if let identifier = segue.identifier{
            if identifier == "editSegue"{
                recipeForNextVc = self.recipe
            }else{
                recipeForNextVc = self.recipe.getCopy()
            }
        }
        if let navCtrl = destinationVc as? UINavigationController{
            if let recipeEditVc = navCtrl.topViewController as? RecipeEditViewController{
                recipeEditVc.setRecipe(recipe: recipeForNextVc)
            }
        }
    }
    
    func setupSubviews(){
        view.layoutIfNeeded()

        let nc = navigationController
        let navbar = nc?.navigationBar
        let batteryViewHeight = CGFloat(20.0)
        let extraHeight = batteryViewHeight + (navbar?.frame.maxY)!
        let width = contentView.bounds.width
        let height = contentView.bounds.height - extraHeight
        scrollViewWidth = width
        print("scrollViewBounds: width->\(width), height->\(height)")
        ingredientsView = IngredientsView(
            frame: CGRect(x: 0, y: 0, width: width, height: height),
            ingredients: recipe.ingredientObjList)
        directionsView = DirectionsView(
            frame: CGRect(x: width, y: 0, width: width, height: height),
            directions: recipe.directionsString)
        contentScrollView.contentSize = CGSize(width: 2.0*width, height: height/1.0)
        contentScrollView.isPagingEnabled = true
        contentScrollView.addSubview(ingredientsView)
        contentScrollView.addSubview(directionsView)
        contentScrollView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        print("scrollViewBounds: content size-> \(contentScrollView.contentSize)")
        print("scrollViewBounds: content offset-> \(contentScrollView.contentOffset)")
        print("scrollViewBounds: content inset-> \(contentScrollView.contentInset)")
    }
    
    func setupMenuItems(){
        let numMenuItems = 3
        let menuItemWidth = largeDim
        let menuItemHeight = largeDim / CGFloat(numMenuItems)
        
        //Edit
        menuEditLabel = UILabel(frame: CGRect(x: 0, y: 0, width: menuItemWidth, height: menuItemHeight))
        menuEditLabel.text = "EDIT"
        menuEditLabel.textAlignment = NSTextAlignment.center
        editTap = UITapGestureRecognizer(target: self, action: #selector(didTapMenuItem))
        menuEditLabel.addGestureRecognizer(editTap)
        menuEditLabel.isUserInteractionEnabled = true
        
        //Copy
        menuCopyLabel = UILabel(frame: CGRect(x: 0, y: 1.0 * menuItemHeight, width: menuItemWidth, height: menuItemHeight))
        menuCopyLabel.text = "COPY"
        menuCopyLabel.textAlignment = NSTextAlignment.center
        copyTap = UITapGestureRecognizer(target: self, action: #selector(didTapMenuItem))
        menuCopyLabel.addGestureRecognizer(copyTap)
        menuCopyLabel.isUserInteractionEnabled = true
        
        //Cancel
        menuCancelLabel = UILabel(frame: CGRect(x: 0, y: 2.0 * menuItemHeight, width: menuItemWidth, height: menuItemHeight))
        menuCancelLabel.text = "CANCEL"
        menuCancelLabel.textAlignment = NSTextAlignment.center
        cancelTap = UITapGestureRecognizer(target: self, action: #selector(didTapMenuItem))
        menuCancelLabel.addGestureRecognizer(cancelTap)
        menuCancelLabel.isUserInteractionEnabled = true
        
        //Dividers
        let divFactor = CGFloat(0.8)
        let divWidth = menuItemWidth * divFactor
        let divHeight = CGFloat(1.0)
        let divX = (menuItemWidth * (1.0 - divFactor))/2.0
        menuDiv1View = UIView(frame: CGRect(x: divX, y: 1.0 * menuItemHeight, width: divWidth, height: divHeight))
        menuDiv1View.backgroundColor = UIColor.lightGray
        menuDiv2View = UIView(frame: CGRect(x: divX, y: 2.0 * menuItemHeight, width: divWidth, height: divHeight))
        menuDiv2View.backgroundColor = UIColor.lightGray
        
        
        //Set up display
        editButtonView.addSubview(menuEditLabel)
        editButtonView.addSubview(menuDiv1View)
        editButtonView.addSubview(menuCopyLabel)
        editButtonView.addSubview(menuDiv2View)
        editButtonView.addSubview(menuCancelLabel)
        menuEditLabel.alpha = 0.0
        menuEditLabel.isHidden = true
        menuDiv1View.alpha = 0.0
        menuDiv1View.isHidden = true
        menuCopyLabel.alpha = 0.0
        menuCopyLabel.isHidden = true
        menuDiv2View.alpha = 0.0
        menuDiv2View.isHidden = true
        menuCancelLabel.alpha = 0.0
        menuCancelLabel.isHidden = true
    }
    
    func formatView() {
        editButtonView.layer.cornerRadius = smallDim / 2.0
        editButtonView.clipsToBounds = true
        editButtonView.layer.borderWidth = CGFloat(1.0)
        editButtonView.layer.borderColor = UIColor.darkGray.cgColor
        editButtonView.backgroundColor = Colors.appSecondary
        editButtonImageView.tintColor = UIColor.white
    }
    
    func setContentTitle(index: Int, animated: Bool){
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.contentTitleLabel.alpha = 0.0},
            completion: {(completed: Bool)->Void in
                self.contentTitleLabel.text = self.titles[index]
                if completed{
                    UIView.animate(withDuration: 0.3, animations: {
                        self.contentTitleLabel.alpha = 1.0
                    })
                }})
    }
    
    func hideContentTitle(animated: Bool){
        UIView.animate(withDuration: 0.4, animations: {
            self.contentTitleLabel.alpha = 0.0
        })
    }
    
    func showContentTitle(animated: Bool){
        UIView.animate(withDuration: 0.4, animations: {
            self.contentTitleLabel.alpha = 1.0
        })
    }
    
    func setupGestureRecognizers(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        contentView.addGestureRecognizer(panGesture)
        contentView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEditButtonView))
        editButtonView.addGestureRecognizer(tapGesture)
        editButtonView.isUserInteractionEnabled = true
    }
    
    func didPan(sender: UIPanGestureRecognizer){
        if sender.state == UIGestureRecognizerState.ended{
            print("panned")
            let velocity = sender.velocity(in: view)
            if velocity.x > 0{
                pageLeft()
            }else{
                pageRight()
            }
        }
    }
    
    func didTapEditButtonView(sender: UITapGestureRecognizer){
//        editButtonView.layoutIfNeeded()
        expandEditButtonView(animated: true)
        
//        if editButtonViewWidthConstraint.constant == smallDim{
//            UIView.animate(withDuration: 1.0, animations: {
//                self.editButtonViewWidthConstraint.constant = self.largeDim
//                self.editButtonViewHeightConstraint.constant = self.largeDim
//                self.editButtonImageView.alpha = 0.0
//                self.editButtonView.layoutIfNeeded()
//            })
//        }else{
//            UIView.animate(withDuration: 1.0, animations: {
//                self.editButtonViewWidthConstraint.constant = self.smallDim
//                self.editButtonViewHeightConstraint.constant = self.smallDim
//                self.editButtonImageView.alpha = 1.0
//                self.editButtonView.layoutIfNeeded()
//            })
//        }
    }
    
    func pageLeft(){
        if pageControl.currentPage - 1 >= 0{
            pageControl.currentPage = pageControl.currentPage - 1
            pageValueChanged(pageControl)
        }
    }
    
    func pageRight(){
        if pageControl.currentPage + 1 <= pageControl.numberOfPages{
            pageControl.currentPage = pageControl.currentPage + 1
            pageValueChanged(pageControl)
        }
    }
    
    func didTapMenuItem(sender: UITapGestureRecognizer){
        if sender.isEqual(editTap){
            editRecipe()
        }else if sender.isEqual(copyTap){
            copyRecipe()
        }else if sender.isEqual(cancelTap){
            collapseEditButtonView(animated: true)
        }
    }
    
    func collapseEditButtonView(animated: Bool){
        UIView.animate(
            withDuration: 1.0,
            animations: {
                //Shrink view size
                self.editButtonViewWidthConstraint.constant = self.smallDim
                self.editButtonViewHeightConstraint.constant = self.smallDim
                self.editButtonView.backgroundColor = Colors.appSecondary
                //Show hide buttons
                self.editButtonImageView.alpha = 1.0
                self.menuEditLabel.alpha = 0.0
                self.menuCopyLabel.alpha = 0.0
                self.menuCancelLabel.alpha = 0.0
                self.menuDiv1View.alpha = 0.0
                self.menuDiv2View.alpha = 0.0
                //Update layout
                self.editButtonView.layoutIfNeeded()
            },
            completion: {(completed: Bool)->Void in
                self.editButton.title = "Edit Menu"
                self.menuEditLabel.isHidden = true
                self.menuCopyLabel.isHidden = true
                self.menuCancelLabel.isHidden = true
                self.menuDiv1View.isHidden = true
                self.menuDiv2View.isHidden = true})
    }
    
    func expandEditButtonView(animated: Bool){
        UIView.animate(withDuration: 1.0, animations: {
            //Shrink view size
            self.editButtonViewWidthConstraint.constant = self.largeDim
            self.editButtonViewHeightConstraint.constant = self.largeDim
            self.editButtonView.backgroundColor = UIColor.white
            //Show/hide buttons
            self.editButtonImageView.alpha = 0.0
            //Make sure EDIT button is applicable
            if self.sourceType != "edamam"{
                self.menuEditLabel.isHidden = false
                self.menuEditLabel.alpha = 1.0
                self.menuEditLabel.textColor = UIColor.black
                self.menuEditLabel.isUserInteractionEnabled = true
            }else{
                self.menuEditLabel.isHidden = false
                self.menuEditLabel.alpha = 1.0
                self.menuEditLabel.textColor = Colors.inactive
                self.menuEditLabel.isUserInteractionEnabled = false
            }
            self.menuDiv1View.isHidden = false
            self.menuDiv1View.alpha = 1.0
            self.menuCopyLabel.isHidden = false
            self.menuCopyLabel.alpha = 1.0
            self.menuDiv2View.isHidden = false
            self.menuDiv2View.alpha = 1.0
            self.menuCancelLabel.isHidden = false
            self.menuCancelLabel.alpha = 1.0
            //Update layout
            self.editButtonView.layoutIfNeeded()
            self.editButton.title = "Hide Menu"})
    }
    
    func copyRecipe(){
        collapseEditButtonView(animated: true)
        performSegue(withIdentifier: "copySegue", sender: self)
    }
    
    func editRecipe(){
        if sourceType == "database"{
            collapseEditButtonView(animated: true)
            performSegue(withIdentifier: "editSegue", sender: self)
        }
    }

}
