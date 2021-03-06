{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Widgets.ViewPosts where

import Control.Lens
import Crypto.Schnorr
import Data.DateTime
import Data.Default
import Data.Map (Map)
import Data.Text (Text, strip)
import Monomer

import qualified Data.Map     as Map
import qualified Data.Text    as T
import qualified Monomer.Lens as L

import Futr
import Helpers
import Nostr.Event            as NE
import Nostr.Profile
import Widgets.ProfileImage
import UIHelpers
import Debug.Trace

viewPosts
  :: (WidgetModel sp, WidgetEvent ep)
  => (ReceivedEvent -> ep)
  -> (XOnlyPubKey -> ep)
  -> WidgetEnv sp ep
  -> FutrModel
  -> [ReceivedEvent]
  -> WidgetNode sp ep
viewPosts viewDetailsAction viewProfileAction wenv model events =
  vscroll_ [ scrollOverlay ] posts
  where
    posts = vstack postRows
    postFade idx ev = animRow
      where
        item = postRow wenv model idx ev viewDetailsAction viewProfileAction
        animRow =
          animFadeOut_ [] item `nodeKey` (T.pack $ exportEventId $ eventId $ fst ev)
    postRows = zipWith postFade [ 0 .. ] events

postRow
  :: (WidgetModel s, WidgetEvent e)
  => WidgetEnv s e
  -> FutrModel
  -> Int
  -> ReceivedEvent
  -> (ReceivedEvent -> e)
  -> (XOnlyPubKey -> e)
  -> WidgetNode s e
postRow wenv model idx re viewDetailsAction viewProfileAction = row
  where
    event = fst re
    xo = NE.pubKey event
    (profileName, pictureUrl) = case Map.lookup xo (model ^. profiles) of
      Just ((Profile name _ _ pictureUrl), _) ->
        (name, pictureUrl)
      Nothing ->
        ("", Nothing)
    rowBg = wenv ^. L.theme . L.userColorMap . at "rowBg" . non def
    profileBox =
      hstack
        [ profileImage pictureUrl xo Small `styleBasic` [ width 40, height 40 ]
        , spacer
        , vstack
            [ (label $ shortXOnlyPubKey xo) `styleBasic` [ textSize 10 ]
            , spacer
            , label profileName `styleBasic` [ textFont "Bold", textUnderline ]
            ]
        ]
    row =
      vstack
        [ hstack
            [ box_ [ onClick (viewProfileAction xo) ] profileBox
                `styleBasic` [ cursorHand ]
            , filler
            , (label $ xTimeAgo (created_at event) (model ^. time))
                `styleBasic` [ textSize 10 ]
            ] `styleBasic` [ paddingB 10 ]
        , box_ [ onClick $ viewDetailsAction re ] $
            hstack
              [ label_ (content event) [ multiline, ellipsis ] `styleBasic` [ paddingL 50 ]
              , filler
              ] `styleBasic` [ cursorHand ]
        ] `styleBasic` [ paddingT 15, paddingR 20, borderB 1 rowSepColor ]
