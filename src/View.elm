module View exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Array exposing (Array)
import Model exposing (..)
import Msg exposing (..)


cellSize : number
cellSize =
    120


toPx : number -> String
toPx num =
    toString num ++ "px"


cellStyle : List ( String, String )
cellStyle =
    [ ( "display", "inline-block" )
    , ( "boxSizing", "border-box" )
    , ( "width", toPx cellSize )
    , ( "fontSize", toPx (cellSize * 0.7) )
    , ( "textAlign", "center" )
    , ( "height", toPx cellSize )
    , ( "backgroundColor", "Teal" )
    , ( "color", "White" )
    , ( "borderRadius", toPx 5 )
    , ( "border", "1px solid White" )
    ]


view : Model -> Html Msg
view model =
    div [ style [ ( "width", toPx (cellSize * model.size) ) ] ] (cells model.cells)


cells : Array Cell -> List (Html Msg)
cells cells =
    List.map cell (Array.toList cells)


cell : Cell -> Html Msg
cell cell =
    case cell of
        Part number ->
            div [ style cellStyle ] [ text (number + 1 |> toString) ]

        Empty ->
            div [ style <| List.append cellStyle [ ( "backgroundColor", "white" ) ] ] [ text " . " ]
