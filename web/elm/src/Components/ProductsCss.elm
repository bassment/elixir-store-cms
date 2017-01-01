module ProductsCss exposing (css)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import SharedStyles exposing (..)


css =
    (stylesheet << namespace productsNamespace.name)
        [ header
            [ backgroundColor (rgb 90 90 90)
            , boxSizing borderBox
            , padding (px -80)
            , boxShadow5 inset (px 2) (px 3) (px 4) (hex "333")
            ]
        , nav
            [ display inlineBlock
            , paddingBottom (px 12)
            ]
        , (.) NavLink
            [ margin (px 12)
            , color (rgb 255 255 255)
            ]
        ]
