port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import PuzzleCss


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "build/index.css", Css.File.compile [ PuzzleCss.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
