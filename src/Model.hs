{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}

module Model where

import Control.Monad.IO.Class  (liftIO, MonadIO)
import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.Quasi
import Database.Persist.TH
import Data.Typeable (Typeable)

share [mkPersist sqlSettings, mkMigrate "migrateUsers"] 
    [persistLowerCase|
        User json
            name String
            age Int
            deriving Eq
            deriving Show
    |]
