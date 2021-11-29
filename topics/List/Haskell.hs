mapM_ print [1..4]

//or

forM_ "test" $ \char -> do 
    putChar char
    putChar char