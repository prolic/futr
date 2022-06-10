{-# LANGUAGE OverloadedStrings   #-}

module Nostr.Filter where

import           Crypto.Schnorr
import           Data.Aeson
import           Data.DateTime
import           Data.Text              (Text, pack)
import qualified Data.Vector            as V
import           GHC.Exts               (fromList)

import Nostr.Keys
import Nostr.Kind
import Nostr.Profile

data Filter
  = LoadMetadataFilter XOnlyPubKey
  | InitialFilter XOnlyPubKey
  | ContactsFilter [XOnlyPubKey]
  | TextNoteFilter [XOnlyPubKey]
  deriving (Eq, Show)

instance ToJSON Filter where
  toJSON (LoadMetadataFilter xo) =
    object $ fromList
      [ ( "kinds", toJSON [ Metadata ] )
      , ( "authors", toJSON [ xo ] )
      , ( "limit", Number 1 )
      ]
  toJSON (InitialFilter xo) =
    object $ fromList
      [ ( "kinds", toJSON [ Contacts, Metadata] )
      , ( "authors", toJSON [ xo ] )
      , ( "limit", Number 2 )
      ]
  toJSON (ContactsFilter xos) =
    object $ fromList
      [ ( "kinds", toJSON [ Contacts ] )
      , ( "authors", toJSON xos )
      ]
  toJSON (TextNoteFilter xos) =
    object $ fromList
      [ ( "kinds", toJSON [ TextNote ] )
      , ( "authors", toJSON xos )
      , ( "limit", Number 500 )
      ]

{-
data Filter
  = AllProfilesFilter (Maybe DateTime)
  | OwnEventsFilter XOnlyPubKey DateTime
  | MentionsFilter XOnlyPubKey DateTime
  | FollowersFilter [Profile] DateTime
  | ProfileFollowers XOnlyPubKey
  deriving (Eq, Show)

instance ToJSON Filter where
  toJSON (AllProfilesFilter Nothing) =
    object $ fromList
      [ ( "kinds", Array $ fromList $ [ Number 0 ]) ]
  toJSON (AllProfilesFilter (Just d)) =
    object $ fromList
      [ ( "kinds", Array $ fromList $ [ Number 0 ])
      , ( "since", Number $ fromIntegral $ toSeconds d)
      ]
  toJSON (OwnEventsFilter xo d) =
    object $ fromList
      [ ( "kinds", Array $ fromList $ [ Number 1, Number 3, Number 4 ] )
      , ( "authors", Array $ fromList $ [ String $ pack $ exportXOnlyPubKey xo ])
      , ( "since", Number $ fromIntegral $ toSeconds d)
      ]
  toJSON (MentionsFilter xo  d) =
    object $ fromList
      [ ( "kinds", Array $ fromList $ [ Number 1, Number 4 ])
      , ( "#p", Array $ fromList $ [ String $ pack $ exportXOnlyPubKey xo ])
      , ( "since", Number $ fromIntegral $ toSeconds d)
      ]
  toJSON (FollowersFilter ps d) =
    object $ fromList
      [ ( "kinds", Array $ fromList $ [ Number 1, Number 3 ] )
      , ( "authors", Array $ fromList $ map String $ map (pack . exportXOnlyPubKey) keys)
      , ( "since", Number $ fromIntegral $ toSeconds d)
      ]
      where
        keys = map (\(Profile xo _ _) -> xo) ps
  toJSON (ProfileFollowers xo) =
    object $ fromList
      [ ( "kinds", Array $ fromList $ [ Number 3 ] )
      , ( "authors", Array $ fromList [ String $ pack $ exportXOnlyPubKey xo ] )
      , ( "limit", Number $ fromIntegral 1 )
      ]
-}