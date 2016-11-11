Schema
1. User
	1. UserId: String
	2. Username: String
	3. Email: String
	4. Password: String
2. Recipe
	1. Id: String
	2. Name: String
	3. CreatedBy: Reference to UserId
	4. Description: String
	5. PreparationTime: String
	6. ListOfIngredients: JSONArray
		1. IngredientName: String
		2. IngredientAmount: Number
		3. IngredientUnit: String
	7. Difficulty
