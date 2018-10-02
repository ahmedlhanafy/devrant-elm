type alias Person = { name : String, age : Int, company : String }

person : Person
person = { name = "Ahmed", age = 24, company = "Microsoft" }
person = Person "Ahmed" 24 "Microsoft"

name = person.name
name = .name person

newPerson = { person | age = person.age + 1 }

