{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE RankNTypes #-}
{-# OPTIONS_GHC -fno-warn-unused-binds #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

module Main where

import Aws.Lambda 
import GHC.Generics
import Data.Either ()
import Data.Text as T
import Data.Text.Lazy (toStrict)
import Data.Text.Lazy.Encoding (decodeUtf8)
import Network.HTTP.Types.Header


main :: IO ()
main = runLambdaHaskellRuntime defaultDispatcherOptions (return ()) id (addStandaloneLambdaHandler "simplyMyHandler" myStandaloneCallback)

myStandaloneCallback :: String -> Context () -> IO (Either String String)
myStandaloneCallback s _ = return $ Right s

myHandler :: Handler StandaloneHandlerType IO () String String String
myHandler = StandaloneLambdaHandler myStandaloneCallback 