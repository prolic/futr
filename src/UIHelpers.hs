{-# LANGUAGE OverloadedStrings #-}

module UIHelpers where

import           Control.Lens
import           Crypto.Schnorr
import           Data.Text              (Text)
import qualified Data.Text              as T
import           Monomer
import qualified Monomer.Lens           as L
{-
selectableText :: Text -> WidgetNode s e
selectableText t =
  textFieldD_ (WidgetValue t) [ readOnly ]
    `styleBasic` [ border 0 transparent, radius 0, bgColor $ rgbHex "#515151" ]

xOnlyPubKeyElem :: XOnlyPubKey -> WidgetNode s e
xOnlyPubKeyElem x =
  hstack
    [ label "XOnlyPubKey"
    , spacer
    , textFieldD_ (WidgetValue $ T.pack $ exportXOnlyPubKey x) [ readOnly ]
    ]

customDarkTheme :: Theme
customDarkTheme = darkTheme
  & L.userColorMap . at "rowBg" ?~ rgbHex "#656565"
  & L.userColorMap . at "replyBg" ?~ rgbHex "#555555"
  & L.userColorMap . at "replyFg" ?~ rgbHex "#909090"
-}
