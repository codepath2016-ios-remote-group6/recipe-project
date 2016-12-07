//
//  RecipeEditViewController.swift
//  Recipe
//
//  Created by Pallavi Kurhade on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse


class RecipeEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate ,UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    public static let vcTitle = "Edit Recipe"
    
    private static let noRecipeNameMessage = "Oops... Your recipe needs a name."

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    
    @IBOutlet weak var recipeDirectionsTextView: UITextView!
    
    var recipe: Recipe!
    var lastIngredientSaved = true
    
    var items = [""]
    var ingredientDetails = [["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25"],["1/8","1/4","1/3","1/2","2/3","3/4"]]
    
    var flexCell = IngredientFlexTVCell()
    var flexCellNib = UINib(nibName: IngredientFlexTVCell.name, bundle: nil)
    
    var selectedIndexPath: IndexPath? = nil
    
    @IBOutlet weak var addIngredientTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var squareImageView: UIImageView!
    @IBOutlet weak var panoramicImageView: UIImageView!
    
    @IBOutlet weak var addIngredientButton: UIButton!
    
    
    @IBOutlet weak var errorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addIngredientTvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var directionsTextViewHeightConstraint: NSLayoutConstraint!
    
    
    let directionsTextViewHeight = CGFloat(200)
    let visibleConstant = CGFloat(0)
    var hiddenConstant = CGFloat(50)
    let maxTvHeight = CGFloat(275)
    var addIngredientTvHeight: CGFloat{
        get{
            if selectedIndexPath == nil{
                var count = recipe.ingredientObjList.count
                if count == 0{
                    count = 1
                }
                return (count*45)<275 ? CGFloat(count*45) : maxTvHeight
            }else{
                return maxTvHeight
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recipe == nil {
            recipe = Recipe()
        }
//        addIngredientTvHeightConstraint.constant = addIngredientTvHeight
        addIngredientTableView.estimatedRowHeight = 50
        addIngredientTableView.dataSource = self
        addIngredientTableView.delegate = self
        
        addIngredientButton.layer.cornerRadius = 20
        
        addIngredientTableView.register(flexCellNib, forCellReuseIdentifier: IngredientFlexTVCell.name)
        
        directionsTextViewHeightConstraint.constant = directionsTextViewHeight
        
        // Style the directions text area so users know
        // to type in the area.
        recipeDirectionsTextView.layer.borderColor = UIColor.lightGray.cgColor
        recipeDirectionsTextView.layer.borderWidth = 1
        recipeDirectionsTextView.layer.cornerRadius = 5
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        hiddenConstant = visibleConstant - errorViewHeightConstraint.constant
        hideErrorView(animated: false)
        
        attachGestureListeners()
        
        populateView()
        
        self.title = RecipeEditViewController.vcTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return recipe.ingredientObjList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("TV Function: cell for row at")
        
        //use ingredient object instead
        let ingredientObject: Ingredient = self.recipe.ingredientObjList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientFlexTVCell.name, for: indexPath) as! IngredientFlexTVCell
        cell.ingredientObject = ingredientObject
        
        if let selectedIndexPath = selectedIndexPath{
            if selectedIndexPath == indexPath{
                print("TV Function: cell for row at -> found selection")
                print("TV Function: cell for row at -> height = \(cell.cellHeight)")
                cell.showEditView()
            }
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TV Function: did select row at")
        tableView.deselectRow(at: indexPath, animated: false)
        saveLastIngredient(unselect: false)
        let selectedCell = tableView.cellForRow(at: indexPath) as! IngredientFlexTVCell
        print("TV Function: did select row at -> height = \(selectedCell.cellHeight)")
        print("TV Function: did select row at -> contentOffset = \(tableView.contentOffset)")
        print("TV Function: did select row at -> TV rowHeight = \(tableView.rowHeight)")

        
        if let unwrappedSelectedIndexPath = selectedIndexPath{
            print("change selection")
            if unwrappedSelectedIndexPath == indexPath{
                //unselecting the selected cell
                selectedIndexPath = nil
                selectedCell.hideEditView()
            }else{
                //changing selected cells
                if let oldCell = tableView.cellForRow(at: unwrappedSelectedIndexPath) as? IngredientFlexTVCell{
                    oldCell.hideEditView()
                }
                selectedIndexPath = indexPath
                selectedCell.showEditView()
            }
        }else{
            //selecting a cell
            print("new selection")
            selectedIndexPath = indexPath
            selectedCell.showEditView()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        addIngredientTvHeightConstraint.constant = addIngredientTvHeight
        view.layoutIfNeeded()

        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedIndexPath = selectedIndexPath{
            if let cell = tableView.cellForRow(at: indexPath) as? IngredientFlexTVCell{
                if selectedIndexPath == indexPath{
                    print("TV Function: height for row at -> found selection")
                    print("TV Function: height for row at -> height = \(cell.visibleHeight)")
                    return cell.visibleHeight
                }else{
                    print("TV Function: height for row at -> height = \(cell.hiddenHeight)")
                    return cell.hiddenHeight
                }
            }
        }
        print("TV Function: height for row at -> height = 50 (default)")
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            print("Swipe action: delete")
            deleteCell(at: indexPath)
        }else if editingStyle == UITableViewCellEditingStyle.none{
            print("Swipe action: none")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        saveLastIngredient(unselect: false)
    }
    
    
    @IBAction func onAddIngredientClick(_ sender: Any) {
        saveLastIngredient(unselect: true)
        let ingredient = Ingredient()
        ingredient.name = Ingredient.newIngredientName
        recipe.ingredientObjList.append(ingredient)
        let row = recipe.ingredientObjList.count - 1
        let section = 0
        selectedIndexPath = IndexPath(row: row, section: section)
        addIngredientTvHeightConstraint.constant = maxTvHeight
        view.layoutIfNeeded()

        if let selectedIndexPath = selectedIndexPath{
            addIngredientTableView.reloadData()
            if let cell = addIngredientTableView.cellForRow(at: selectedIndexPath) as? IngredientFlexTVCell{
                cell.showEditView()
                addIngredientTableView.scrollToRow(at: selectedIndexPath, at: UITableViewScrollPosition.middle, animated: true)
            }
        }
        
    }
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDoneClick(_ sender: UIBarButtonItem) {
        saveLastIngredient(unselect: true)
        recipe.prepareIngredientsForDbStorage()
        
        recipe.directionsString = recipeDirectionsTextView.text
        if recipe.inspiredBy == nil || recipe.inspiredBy == ""{
            if let user = PFUser.current(){
                if let nickname = user[User.nicknameKey] as? String{
                    recipe.inspiredBy = nickname
                }
            }
        }
        if let name = recipeNameTextField.text{
            if name == ""{
                showErrorView(message: RecipeEditViewController.noRecipeNameMessage)
            }else{
                recipe.saveToDb()
                if let tabCtrl = presentingViewController as? UITabBarController{
                    if let navCtrl = tabCtrl.selectedViewController as? UINavigationController{
                        navCtrl.dismiss(animated: true, completion: nil)
//                        navCtrl.popToRootViewController(animated: true)
//                        dismiss(animated: true, completion: nil)
                    }
                }
                if let nav1 = presentingViewController as? UINavigationController{
                    if let tabCtrl = nav1.presentingViewController as? UITabBarController{
                        if let nav2 = tabCtrl.selectedViewController as? UINavigationController{
                            nav2.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    

    
    @IBAction func didExitTextField(_ sender: UITextField) {
        recipe.name = recipeNameTextField.text
        if !errorView.isHidden{
            hideErrorView(animated: true)
        }
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        recipe.name = recipeNameTextField.text
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        if !errorView.isHidden{
            hideErrorView(animated: true)
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return ingredientDetails.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ingredientDetails[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ingredientDetails[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         print(component)
         print(row)
        
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setRecipe(recipe: Recipe?){
        if let recipe = recipe{
            self.recipe = recipe
            self.lastIngredientSaved = true
        }else{
            self.recipe = Recipe()
            self.lastIngredientSaved = false
        }
        print("Recipe ObjectId: \(recipe?.objectId)")
    }
    
    func populateView(){
        //Name
        self.recipeNameTextField.text = self.recipe.name
        //Ingredients
        if recipe.ingredientObjList.isEmpty{
            onAddIngredientClick(self)
        }else{
            self.addIngredientTableView.reloadData()
            addIngredientTvHeightConstraint.constant = addIngredientTvHeight
            view.layoutIfNeeded()
        }
        
        //Directions
        self.recipeDirectionsTextView.text = self.recipe.directionsString ?? ""
        //Photo
        if let picFile = recipe.imageFile{
            picFile.getDataInBackground(block: {(imageData: Data?, error: Error?)->Void in
                if error == nil{
                    if let imageData = imageData{
                        self.squareImageView.image = UIImage(data: imageData)
                        self.panoramicImageView.image = UIImage(data: imageData)
                    }
                }else{
                    print("Error getting data from image file: \(error!.localizedDescription)")
                }})
        }else if let url = recipe.imageUrl{
            self.squareImageView.setImageWith(url)
            self.panoramicImageView.setImageWith(url)
        }else{
            self.squareImageView.image = #imageLiteral(resourceName: "placeholder")
            self.panoramicImageView.image = #imageLiteral(resourceName: "placeholder")
        }
        self.squareImageView.layer.cornerRadius = 3.0
        self.squareImageView.clipsToBounds = true
        self.panoramicImageView.layer.cornerRadius = 3.0
        self.panoramicImageView.clipsToBounds = true
    }
    
    func updateIngredient(index: Int, cell: IngredientFlexTVCell){
        recipe.ingredientObjList[index] = cell.getIngredientFromUi()
    }
    
    func deleteCell(at indexPath: IndexPath){
        if selectedIndexPath == indexPath{
            selectedIndexPath = nil
        }
        addIngredientTableView.beginUpdates()
        recipe.ingredientObjList.remove(at: indexPath.row)
        addIngredientTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        addIngredientTableView.endUpdates()
    }
    
    func saveLastIngredient(unselect: Bool){
        if let selectedIndexPath = selectedIndexPath{
            if let cell = addIngredientTableView.cellForRow(at: selectedIndexPath) as? IngredientFlexTVCell{
                updateIngredient(index: selectedIndexPath.row, cell: cell)
                if unselect{
                    cell.hideEditView()
                    self.selectedIndexPath = nil
                }
            }
        }
    }
    
    func showErrorView(message: String){
        errorLabel.text = message
        self.errorView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.errorViewTopConstraint.constant = self.visibleConstant
            self.errorView.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    func hideErrorView(animated: Bool){
        if animated{
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.errorView.alpha = 0.0
                    self.errorViewTopConstraint.constant = self.hiddenConstant
                    self.view.layoutIfNeeded()
                },
                completion: {(isDone: Bool)->Void in
                    self.errorView.isHidden = true})
        }else{
            self.errorView.alpha = 0.0
            self.errorViewTopConstraint.constant = self.hiddenConstant
            self.view.layoutIfNeeded()
            self.errorView.isHidden = true
        }
    }
    
    func attachGestureListeners(){
        let squareImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeRecipePhoto))
        let panoramicImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeRecipePhoto))
        self.squareImageView.addGestureRecognizer(squareImageTapGesture)
        self.panoramicImageView.addGestureRecognizer(panoramicImageTapGesture)
        self.squareImageView.isUserInteractionEnabled = true
        self.panoramicImageView.isUserInteractionEnabled = true
    }
    
    func changeRecipePhoto(sender: UITapGestureRecognizer){
        let imagePickerCtrl = UIImagePickerController()
        imagePickerCtrl.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePickerCtrl.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePickerCtrl, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        squareImageView.image = image
        panoramicImageView.image = image
        
        if let pic = UIImageJPEGRepresentation(image, CGFloat(0.8)){
            recipe.imageFile = PFFile(name: "recipe.jpg", data: pic)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
