{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE TemplateHaskell            #-}

module Config where

import Control.Monad
import Control.Monad.Except
import Control.Monad.IO.Class
import Control.Monad.Reader
import Control.Monad.Trans
import Data.Text               (Text)
import Database.Persist.Sqlite

data AppConfig = AppConfig {
  dbConfig ::DBConfig
  , dbPool ::ConnectionPool
}

data DBConfig = DBConfig {
  fileDB     :: String
  , poolSize :: Int
}
