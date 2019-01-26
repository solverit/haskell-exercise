{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}

module Db
    ( 
        migrateDb
        ,createUser
        ,findAllUsers
    ) where
        
import Control.Monad.IO.Class  (liftIO, MonadIO)
import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.Quasi
import Database.Persist.TH
import Database.Persist.Sql (SqlPersistT, runMigration, runSqlPool)
import Data.Aeson
import Data.Aeson.Encode.Pretty
import qualified Data.ByteString.Lazy as BSL
import qualified Data.ByteString.Lazy.Char8 as LC
import Data.Text
import Data.Text.Encoding
import Data.Typeable (Typeable)
import Control.Monad.Reader

-- import Config (Config, configPool)
import Model

getJson :: ToJSON a => a -> String 
getJson d = unpack $ decodeUtf8 $ BSL.toStrict (encode d)

asSqlBackendReader :: ReaderT SqlBackend m a -> ReaderT SqlBackend m a
asSqlBackendReader = id

migrateDb :: IO ()
migrateDb = runSqlite "users.db" $ do
    runMigration Model.migrateUsers

createUser :: String -> Int -> IO String
createUser name age = runSqlite "users.db" . asSqlBackendReader
    $ do
        userId <- insert $ User name $ age
        liftIO $ return ( getJson (userId))

findAllUsers :: IO String
findAllUsers = runSqlite "users.db" . asSqlBackendReader
    $ do
        users <- selectList [][]
        liftIO $ return (getJson (users :: [Entity User])   )
        
