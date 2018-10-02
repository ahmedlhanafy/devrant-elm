person = { name = "Ahmed", age = 24, company = "Microsoft" }

isAllowed person = 
   if person.age >= 18 then 
     True 
   else 
     False

-- explain currying

greaterThan x y = x > y

isAllowed person -- True

greaterThan 10 20

isAllowed (extractPerson "Ahmed" (parse input)) 

input 
    |> parse
    |> extractPerson "Ahmed"
    |> isAllowed

-- Operators are Functions Too
(+) 2 5 -- Same as 2 + 5
(/) 10 2
(>) 20 10