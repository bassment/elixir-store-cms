port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import ProductsCss as Products


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "products.css", Css.File.compile [ Products.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
