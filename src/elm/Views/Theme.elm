module Views.Theme exposing (theme)

import Css exposing (..)


type alias Theme =
    { sidebarWidth : Px
    , bodyBackground : Color
    , primaryText : Color
    , secondaryText : Color
    , border : Color
    , contentWrapperBackground : ColorValue NonMixable
    , contentBackground : Color
    , sidebarIcon : Color
    , sidebarIconActive : Color
    }


theme : Theme
theme =
    { sidebarWidth = (px 74)
    , bodyBackground = hex "20212b"
    , primaryText = rgba 255 255 255 0.9
    , secondaryText = rgba 255 255 255 0.6
    , border = rgba 255 255 255 0.1
    , contentWrapperBackground = transparent
    , contentBackground = rgba 0 0 0 0.16
    , sidebarIcon = rgba 255 255 255 0.4
    , sidebarIconActive = rgba 255 255 255 0.9
    }
