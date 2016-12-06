//
//  RecipeEditViewController.swift
//  Recipe
//
//  Created by Pallavi Kurhade on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse


class RecipeEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate ,UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var addIngredientTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var squareImageView: UIImageView!
    @IBOutlet weak var panoramicImageView: UIImageView!
    
    
    
    @IBOutlet weak var errorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addIngredientTvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var directionsTextViewHeightConstraint: NSLayoutConstraint!
    
    
    let directionsTextViewHeight = CGFloat(200)
    let addIngredientTvHeight = CGFloat(325)
    let visibleConstant = CGFloat(0)
    var hiddenConstant = CGFloat(50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recipe == nil {
            recipe = Recipe()
        }
        
        addIngredientTvHeightConstraint.constant = addIngredientTvHeight
        addIngredientTableView.estimatedRowHeight = 50
        addIngredientTableView.dataSource = self
        addIngredientTableView.delegate = self
        
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
        
//        let ingredient: Dictionary<String,AnyObject> = self.recipe.ingredients[indexPath.row]
        //use ingredient object instead
        let ingredientObject: Ingredient = self.recipe.ingredientObjList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientFlexTVCell.name, for: indexPath) as! IngredientFlexTVCell
//        cell.ingredient = ingredient
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
                tableView.deselectRow(at: unwrappedSelectedIndexPath, animated: true)
                updateIngredient(index: indexPath.row, cell: selectedCell)
            }else{
                //selecting a new cell
                let oldCell = tableView.cellForRow(at: unwrappedSelectedIndexPath) as! IngredientFlexTVCell
                selectedIndexPath = indexPath
                oldCell.hideEditView()
                selectedCell.showEditView()
                updateIngredient(index: unwrappedSelectedIndexPath.row, cell: oldCell)
            }
        }else{
            print("new selection")
            //selecting a cell
            selectedIndexPath = indexPath
            tableView.beginUpdates()
            selectedCell.showEditView()
            tableView.endUpdates()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
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
    
    
    @IBAction func onAddIngredientClick(_ sender: Any) {
//        recipe.ingredients.append(Dictionary<String,AnyObject>())
        saveLastIngredient()
        let ingredient = Ingredient()
        ingredient.name = Ingredient.newIngredientName
        recipe.ingredientObjList.append(ingredient)
        let row = recipe.ingredientObjList.count - 1
        let section = 0
        selectedIndexPath = IndexPath(row: row, section: section)
        if let selectedIndexPath = selectedIndexPath{
            addIngredientTableView.reloadData()
            if let cell = addIngredientTableView.cellForRow(at: selectedIndexPath) as? IngredientFlexTVCell{
//                addIngredientTableView.beginUpdates()
                cell.showEditView()
//                addIngredientTableView.endUpdates()
                addIngredientTableView.scrollToRow(at: selectedIndexPath, at: UITableViewScrollPosition.middle, animated: true)
            }
        }
        
    }
    
    @IBAction func onDoneClick(_ sender: Any) {
        saveLastIngredient()
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
                let navCtrl = self.navigationController
                if let vcList = navCtrl?.viewControllers{
                    for vc in vcList{
                        if let vc = vc as? RecipeListViewController{
                            _ = navCtrl?.popToViewController(vc, animated: true)
                        }
                    }
                }else{
                    dismiss(animated: true, completion: nil)
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
        self.addIngredientTableView.reloadData()
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
        
        if recipe.ingredientObjList.count == 0 {
            self.onAddIngredientClick(0)
        }
    }
    
    func updateIngredient(index: Int, cell: IngredientFlexTVCell){
        recipe.ingredientObjList[index] = cell.getIngredientFromUi()
    }
    
    func deleteCell(at indexPath: IndexPath){
        addIngredientTableView.beginUpdates()
        recipe.ingredientObjList.remove(at: indexPath.row)
        addIngredientTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        addIngredientTableView.endUpdates()
    }
    
    func saveLastIngredient(){
        if let selectedIndexPath = selectedIndexPath{
            let cell = addIngredientTableView.cellForRow(at: selectedIndexPath) as! IngredientFlexTVCell
            updateIngredient(index: selectedIndexPath.row, cell: cell)
            cell.hideEditView()
            self.selectedIndexPath = nil
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
