# recipe-project

Summary:

The recipe app will allow users to search, create, and save recipes both to their local device and in the cloud should they decide to make them public.  The app will be designed to complete common recipe actions easily with mobile phone gestures: change ingredients, ingredient portions, or the entire recipe portion size.  The recipe search function will allow for finding recipes based on ingredients, recipe effort, and popularity if the social aspect be implemented.


User Stories:

1. Opening the app
	1. User will be able to sign up and login:
		1. via a username or a social login
		2. user can also skip this step and enjoy some features of the app not logged in
	2. User will be able to search through a list of existing recipes
	3. Selecting a recipe will bring up a detailed recipe view
2. Detailed Recipe View
	1. Detailed View will show a list of ingredients
		1. Name
		2. Amount
	2. Detailed View will show some overall metrics for the recipe
		1. Difficulty
		2. Preparation time
	3. Detailed View will include an optional summary description of the recipe
	4. Detailed will allow two types of editing:
		1. Edit current recipe
		2. Copy recipe, then edit the copy
3. Edit mode
	1. Edit mode will have a gesture interface to:
		1. Increase and decrease item quantities
		2. (*Optional) Scale the entire size of the recipe
		3. Add(delete) items to(from) the recipe
4. (*Optional) if user is logged in: Recipes can be made public, liked, copied
	1. (*Optional) sharing recepies via external applications