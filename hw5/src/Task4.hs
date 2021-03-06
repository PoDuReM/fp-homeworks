module Task4
  ( sqrtIntJS
  , fibJS
  , factJS
  ) where

import           Task2 (MonadJS (..), Val(..), VarJS (..))

sqrtIntJS :: MonadJS m s => m Val -> m Val
sqrtIntJS =
  sFun1 $ \x res ->
    sIf 
      (liftPure (0 :: Int) @>@ x) 
      (res @= (0 :: Int))
    (sWithVar (0 :: Int) $ \l ->
      sWithVar (0 :: Int) $ \r ->
          r @=@ x @+ (1 :: Int) #
          sWhile
             (sReadVar r @-@ sReadVar l @> (1 :: Int))
             (sWithVar Undefined $ \m ->
                (m @=@ (sReadVar r @+@ sReadVar l) @/ (2 :: Int)) #
                sIf
                  (sReadVar m @*@ sReadVar m @>@ x)
                  (r @=@ sReadVar m)
                  (l @=@ sReadVar m)
              ) #
          res @=@ sReadVar l
    )

fibJS :: MonadJS m s => m Val -> m Val
fibJS = sFun1 $ \n res ->
          res @= (1 :: Int) #
          sWithVar (1 :: Int) (\a ->
            sWithVar (1 :: Int) $ \b ->
              sWithVar (2 :: Int) $ \cur ->
                sWhile
                  (n @>@ sReadVar cur)
                  (
                    res @=@ sReadVar a @+@ sReadVar b #
                    a @=@ sReadVar b #
                    b @=@ sReadVar res #
                    cur @=@ sReadVar cur @+ (1 :: Int)
                  ))

factJS :: MonadJS m s => m Val -> m Val
factJS = sFun1 $ \n res ->
          res @= (1 :: Int) #
          sWithVar Undefined (\cur ->
            cur @=@ n #
            sWhile
              (sReadVar cur @> (1 :: Int))
              (
                res @=@ sReadVar res @*@ sReadVar cur #
                cur @=@ sReadVar cur @- (1 :: Int)
              )
          )
          