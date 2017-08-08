port module Styles.Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Styles.PuzzleCss


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "build/index.css", Css.File.compile [ Styles.PuzzleCss.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
