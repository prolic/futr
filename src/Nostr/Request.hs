{-# LANGUAGE OverloadedStrings   #-}

module Nostr.Request where

import Control.Concurrent.STM.TChan
import Control.Monad.STM            (atomically)
import Crypto.Random.DRBG           (CtrDRBG, genBytes, newGen, newGenIO)
import Data.Aeson
import Data.DateTime
import Data.Text                    (Text, pack)
import GHC.Exts                     (fromList)

import qualified Data.ByteString.Base16 as B16

import Nostr.Event
import Nostr.Filter
import Nostr.Relay

type SubscriptionId = Text

data Subscription = Subscription
  { filters :: [Filter]
  , subId   :: SubscriptionId
  }
  deriving (Eq, Show)

data Request
  = SendEvent Event
  | Subscribe Subscription
  | Close SubscriptionId
  | Disconnect Relay
  deriving (Eq, Show)

instance ToJSON Request where
  toJSON sr = case sr of
    SendEvent e -> Array $ fromList
       [ String $ pack "EVENT"
       , toJSON e
       ]
    Subscribe (Subscription efs s) -> Array $ fromList
      ([ String $ pack "REQ"
      , String $ s
       ] ++ map (\ef -> toJSON ef) efs)
    Close subId -> Array $ fromList
       [ String $ pack "CLOSE"
       , String subId
       ]
    Disconnect r -> String $ pack "Bye!"
