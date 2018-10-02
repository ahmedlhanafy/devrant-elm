extractPerson : Response -> Person
extractPerson response = 
    ..

add : Int -> Int -> Int
add firstInt secondInt = 
    ..

-- Records
type alias Person = { name : String, age : Int, company : String }

-- Nested records 
type alias Group = { name : String, participants : List Person }

-- Custom Types
type Action
    = Login
    | Signup

-- With parameters
type Action
    = Login Person
    | Signup String String

reducer : State -> Action -> State
reducer state action =
    case action of
        Login person ->
            ..
        Signup username password ->
            ..

type Maybe a = Just a
    | Nothing

-- Maybe type
get : Int -> Array a -> Maybe a

type Response
    = LoginSuccessful Maybe Person

handleResponse : Response -> ..
handleResponse response =
    case response of
        LoginSuccessful maybePerson ->
            case maybePerson of
                Just person -> 
                    ..
                Nothing -> 
                    ..
