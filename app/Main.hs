{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.JsonRpc.Server
import System.IO (BufferMode (LineBuffering), hSetBuffering, stdout)
import qualified Data.ByteString.Lazy.Char8 as B
import Data.List (intercalate)
import Data.Maybe (fromMaybe)
import Data.Aeson
import Control.Monad (forM_, when)
import Control.Monad.Trans (liftIO)
import Control.Monad.Except (throwError)
import Control.Monad.Reader (ReaderT, ask, runReaderT)
import Control.Concurrent.MVar (MVar, newMVar, modifyMVar)
import Db

main :: IO ()
main  = do
    migrateDb
    hSetBuffering stdout LineBuffering
    contents <- B.getContents
    count <- newMVar 0
    forM_ (B.lines contents) $ \request -> do
           response <- runReaderT (call methods request) count
           B.putStrLn $ fromMaybe "" response

type Server = ReaderT (MVar Integer) IO

methods :: [Method Server]
methods = [create, findAll]

create = toMethod "create" f (Required "name" :+: Required "age" :+: ())
    where f :: String -> Int -> RpcResult Server String
          f name age = do
            resp <- liftIO $ createUser name age
            liftIO $ return (resp)

findAll = toMethod "findAll" f ()
    where f :: RpcResult Server String
          f = do  
            resp <- liftIO $ findAllUsers
            liftIO $ return (resp)
