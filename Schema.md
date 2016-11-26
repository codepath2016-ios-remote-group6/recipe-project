Schema
1. User
	1. UserId: String
	2. Username: String
	3. Email: String
	4. Password: String
2. Recipe
	1. objectId: String
	2. name: String
	3. createdBy: Relation to UserId
	4. *** summary: String ***
	5. *** prepTimeStr: String ***
	6. *** prepTime: Double ***
	7. *** prepUnits: Double ***
	8. Ingredients: Array
		1. name: String
		2. quantity: Number
		3. units: String
	9. *** Difficulty: Int ***
