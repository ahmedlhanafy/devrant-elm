module Types exposing (..)

import Time exposing (Posix, millisToPosix)


type alias Response =
    { rants : List Rant, success : Bool }


type alias RantResponse =
    { rant : Rant
    , comments : List Comment
    }


type alias Rant =
    { text : String
    , id : Int
    , attached_image : Maybe AttachedImage
    , user_username : String
    , user_score : Int
    , score : Int
    , tags : List String
    , user_avatar : Maybe UserAvatar
    , created_time : Float
    , num_comments : Int
    , user_id : Int
    , link : String
    }


type alias AttachedImage =
    { url : String
    }


type alias UserAvatar =
    { b : String
    , i : String
    }


type alias Comment =
    { id : Int
    , rant_id : Int
    , body : String
    , score : Int
    , created_time : Float
    , vote_state : Int
    , user_id : Int
    , user_username : String
    , user_score : Int
    , user_avatar : Maybe UserAvatar
    }
