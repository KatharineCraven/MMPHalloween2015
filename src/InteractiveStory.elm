module InteractiveStory where

import StartApp
import InteractiveStory.Core exposing (..)
import InteractiveStory.Action exposing (..)
import Effects
import Signal exposing ((<~))
import Mouse
import Task exposing (Task)
import Effects exposing (Never)
import Maybe
import Window
import Dict
import StoryContent

import Howler exposing (emptyAudioObject)

addAudioExtensions file = List.map (\ext -> "assets/audio/" ++ file ++ ext) [".ogg", ".aac", ".mp3"]

app = StartApp.start {
    init = init StoryContent.stuff [
      ("mansion-bgm", { emptyAudioObject | src <- addAudioExtensions "541205_Halloween-Waltz-LOOP", html5 <- Just True}),
      ("portal-bgm", { emptyAudioObject | src <- addAudioExtensions "452916_happy_halloween", html5 <- Just True, volume <- Just 0.9}),
      ("trick-or-treat-bgm", { emptyAudioObject | html5 <- Just True, src <- addAudioExtensions "563651_KH-Halloween-Town-Remix-2"})
      ],
    view = render,
    update = update,
    inputs = [(always <| NextBlock) <~ Mouse.clicks, WindowResize <~ windowDimensions]
    }

main = app.html

port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks

windowDimensions =
  Signal.merge
    (Signal.sampleOn startAppMailbox.signal Window.dimensions)
    Window.dimensions

startAppMailbox =
  Signal.mailbox ()

port startApp : Signal (Task error ())
port startApp =
  Signal.constant (Signal.send startAppMailbox.address ())
