module Helpers.ViewHelper exposing (toCapital)

toCapital : String -> String
toCapital str =
  String.toUpper(String.left 1 str) ++ String.dropLeft 1 str
