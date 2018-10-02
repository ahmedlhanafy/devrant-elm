module Msg exposing (..)

import Http exposing (Error)
import Types exposing (Rant)


type Msg
    = SetRants (Result Error (List Rant))
