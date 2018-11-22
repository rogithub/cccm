module Guid
(
  newGuid,
  emptyGuid
) where

import System.Random
import Data.UUID

--newGuid $ mkStdGen 1
--let (guid, newGen) = newGuid $ mkStdGen 1
newGuid :: StdGen -> (UUID, StdGen)
newGuid gen = random $ gen

emptyGuid :: UUID
emptyGuid = read "00000000-0000-0000-0000-000000000000"
