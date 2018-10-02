-- x = 1 + 2
-- text = "Hello World"
-- welcomeMessage = if x > 4 then "Welcome" else "Hello" 

-- longWelcomeMessage = """
-- Occaecat eu quis amet voluptate culpa nostrud ex laborum reprehenderit amet.
-- """

-- stringConcatentation = welcomeMessage ++ longWelcomeMessage

-- goodByeMessage =
--     case x of
--         0 -> "Goodbye"
--         _ -> "See you later!"

intList = [ 1, 2, 3 ]
charList = [ 'a', 'b', 'c' ]
stringList = [ "JS", "Typescript", "Elm" ]

list = [ 1, 'a' ] -- INVALID



[ 1, 2, 3 ] ++ [ 4, 5, 6 ] -- [ 1, 2, 3, 4, 5, 6 ]
1 :: [ 2, 3 ] -- [ 1, 2, 3 ]

List.length intList
List.filter (\x -> x <= 3) [ 1, 2, 3, 4, 5 ] -- [ 1, 2, 3 ]
List.map (\x -> x * 2) [ 1, 2, 3 ] -- [ 2, 3, 6 ]
List.foldl (\x a -> x + a) 0 [ 1, 2, 3, 4 ] -- 10

-- + is an operator which is defined like a func
List.foldl (+) 0 [ 1, 2, 3, 4 ] -- 10

-- When explaining Maybe
List.head [ 1, 2, 3, 4, 5 ] -- Just 1
List.tail [ 1, 2, 3, 4, 5 ] -- Just [2,3,4,5]
List.head [] -- Nothing
List.tail [] -- Nothing