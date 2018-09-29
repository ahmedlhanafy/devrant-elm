module Msg exposing (..)

import Http exposing (Error)
import Types exposing (Rant)
import Time exposing (Posix)


type Msg
    = SetRants (Result Error (List Rant))
    | Tick Posix
    | LoadMore Int
