module ArrayList exposing
  ( ArrayList, isEmpty, length, reverse, member
  , head, tail, filter, take, drop
  , repeat, (::), append, concat, intersperse
  , partition, unzip
  , map, map2, map3, map4, map5
  , filterMap, concatMap, indexedMap
  , foldr, foldl
  , sum, product, maximum, minimum, all, any, scanl
  , sort, sortBy, sortWith

  , fromList, toList, cons, empty
  )

{-| A library for manipulating lists of values. Every value in a
list must have the same type.

# Type
@docs ArrayList

# Basics
@docs isEmpty, length, reverse, member

# Sub-lists
@docs head, tail, filter, take, drop

# Putting Lists Together
@docs repeat, (::), append, concat, intersperse

# Taking Lists Apart
@docs partition, unzip

# Mapping
@docs map, map2, map3, map4, map5

If you can think of a legitimate use of `mapN` where `N` is 6 or more, please
let us know on [the list](https://groups.google.com/forum/#!forum/elm-discuss).
The current sentiment is that it is already quite error prone once you get to
4 and possibly should be approached another way.

# Special Maps
@docs filterMap, concatMap, indexedMap

# Folding
@docs foldr, foldl

# Special Folds
@docs sum, product, maximum, minimum, all, any, scanl

# Sorting
@docs sort, sortBy, sortWith

# Others
@docs fromList, cons, empty, toList

-}

import Basics exposing (..)
import Maybe
import Maybe exposing ( Maybe(Just,Nothing) )
import Native.ArrayList

{-| The type, it is backed by a real array.
-}
type ArrayList a = ArrayList

{-| Add an element to the front of a list. Pronounced *cons*.

    1 :: [2,3] == [1,2,3]
    1 :: [] == [1]
-}
(::) : a -> ArrayList a -> ArrayList a
(::) =
  Native.ArrayList.cons

{-| Same as ::
-}
cons : a -> ArrayList a -> ArrayList a
cons =
  Native.ArrayList.cons


{-| Extract the first element of a list.

    head [1,2,3] == Just 1
    head [] == Nothing
-}
head : ArrayList a -> Maybe a
head =
    Native.ArrayList.head


{-| Extract the rest of the list.

    tail [1,2,3] == Just [2,3]
    tail [] == Nothing
-}
tail : ArrayList a -> Maybe (ArrayList a)
tail =
    Native.ArrayList.tail


{-| Determine if a list is empty.

    isEmpty [] == True
-}
isEmpty : ArrayList a -> Bool
isEmpty =
    Native.ArrayList.isEmpty


{-| Figure out whether a list contains a value.

    member 9 [1,2,3,4] == False
    member 4 [1,2,3,4] == True
-}
member : a -> ArrayList a -> Bool
member =
    Native.ArrayList.member


{-| Apply a function to every element of a list.

    map sqrt [1,4,9] == [1,2,3]

    map not [True,False,True] == [False,True,False]
-}
map : (a -> b) -> ArrayList a -> ArrayList b
map =
    Native.ArrayList.map


{-| Same as `map` but the function is also applied to the index of each
element (starting at zero).

    indexedMap (,) ["Tom","Sue","Bob"] == [ (0,"Tom"), (1,"Sue"), (2,"Bob") ]
-}
indexedMap : (Int -> a -> b) -> ArrayList a -> ArrayList b
indexedMap =
    Native.ArrayList.indexedMap


{-| Reduce a list from the left.

    foldl (::) [] [1,2,3] == [3,2,1]
-}
foldl : (a -> b -> b) -> b -> ArrayList a -> b
foldl =
    Native.ArrayList.foldl


{-| Reduce a list from the right.

    foldr (+) 0 [1,2,3] == 6
-}
foldr : (a -> b -> b) -> b -> ArrayList a -> b
foldr =
    Native.ArrayList.foldr


{-| Reduce a list from the left, building up all of the intermediate results into a list.

    scanl (+) 0 [1,2,3,4] == [0,1,3,6,10]
-}
scanl : (a -> b -> b) -> b -> ArrayList a -> ArrayList b
scanl =
    Native.ArrayList.scanl


{-| Keep only elements that satisfy the predicate.

    filter isEven [1..6] == [2,4,6]
-}
filter : (a -> Bool) -> ArrayList a -> ArrayList a
filter =
    Native.ArrayList.filter
    

{-| Apply a function that may succeed to all values in the list, but only keep
the successes.

    onlyTeens =
      filterMap isTeen [3, 15, 12, 18, 24] == [15, 18]

    isTeen : Int -> Maybe Int
    isTeen n =
      if 13 <= n && n <= 19 then
        Just n

      else
        Nothing
-}
filterMap : (a -> Maybe b) -> ArrayList a -> ArrayList b
filterMap =
    Native.ArrayList.filterMap


{-| Determine the length of a list.

    length [1,2,3] == 3
-}
length : ArrayList a -> Int
length =
    Native.ArrayList.length


{-| Reverse a list.

    reverse [1..4] == [4,3,2,1]
-}
reverse : ArrayList a -> ArrayList a
reverse =
    Native.ArrayList.reverse


{-| Determine if all elements satisfy the predicate.

    all isEven [2,4] == True
    all isEven [2,3] == False
    all isEven [] == True
-}
all : (a -> Bool) -> ArrayList a -> Bool
all =
    Native.ArrayList.all


{-| Determine if any elements satisfy the predicate.

    any isEven [2,3] == True
    any isEven [1,3] == False
    any isEven [] == False
-}
any : (a -> Bool) -> ArrayList a -> Bool
any =
    Native.ArrayList.any

{-| Put two lists together.

    append [1,1,2] [3,5,8] == [1,1,2,3,5,8]
    append ['a','b'] ['c'] == ['a','b','c']

You can also use [the `(++)` operator](Basics#++) to append lists.
-}
append : ArrayList a -> ArrayList a -> ArrayList a
append =
    Native.ArrayList.append


{-| Concatenate a bunch of lists into a single list:

    concat [[1,2],[3],[4,5]] == [1,2,3,4,5]
-}
concat : ArrayList (ArrayList a) -> ArrayList a
concat =
    Native.ArrayList.concat


{-| Map a given function onto a list and flatten the resulting lists.

    concatMap f xs == concat (map f xs)
-}
concatMap : (a -> ArrayList b) -> ArrayList a -> ArrayList b
concatMap f list = -- could be optimized on native
    concat (map f list)


{-| Get the sum of the list elements.

    sum [1..4] == 10
-}
sum : ArrayList number -> number
sum numbers = -- could be optimized on native
    foldl (+) 0 numbers


{-| Get the product of the list elements.

    product [1..4] == 24
-}
product : ArrayList number -> number
product numbers = -- could be optimized on native
    foldl (*) 1 numbers


{-| Find the maximum element in a non-empty list.

    maximum [1,4,2] == Just 4
    maximum []      == Nothing
-}
maximum : ArrayList comparable -> Maybe comparable
maximum list = -- could be optimized on native
    case head list of
        Nothing -> Nothing
        -- little waste by not tail'ing the list, but avoid making a copy
        Just v -> Just (foldl max v list)


{-| Find the minimum element in a non-empty list.

    minimum [3,2,1] == Just 1
    minimum []      == Nothing
-}
minimum : ArrayList comparable -> Maybe comparable
minimum list = -- could be optimized on native
    case head list of
        Nothing -> Nothing
        -- little waste by not tail'ing the list, but avoid making a copy
        Just v -> Just (foldl min v list)


{-| Partition a list based on a predicate. The first list contains all values
that satisfy the predicate, and the second list contains all the value that do
not.

    partition (\x -> x < 3) [0..5] == ([0,1,2], [3,4,5])
    partition isEven        [0..5] == ([0,2,4], [1,3,5])
-}
partition : (a -> Bool) -> ArrayList a -> (ArrayList a, ArrayList a)
partition pred list = -- could be optimized on native
  let
    step x (trues, falses) =
      if pred x then
        (push x trues, falses)

      else
        (trues, push x falses)
  in
    foldl step (empty,empty) list


{-| Combine two lists, combining them with the given function.
If one list is longer, the extra elements are dropped.

    map2 (+) [1,2,3] [1,2,3,4] == [2,4,6]

    map2 (,) [1,2,3] ['a','b'] == [ (1,'a'), (2,'b') ]

    pairs : List a -> List b -> List (a,b)
    pairs lefts rights =
        map2 (,) lefts rights
-}
map2 : (a -> b -> result) -> ArrayList a -> ArrayList b -> ArrayList result
map2 =
  Native.ArrayList.map2


{-|-}
map3 : (a -> b -> c -> result) -> List a -> List b -> List c -> List result
map3 =
  Native.ArrayList.map3


{-|-}
map4 : (a -> b -> c -> d -> result) -> List a -> List b -> List c -> List d -> List result
map4 =
  Native.ArrayList.map4


{-|-}
map5 : (a -> b -> c -> d -> e -> result) -> List a -> List b -> List c -> List d -> List e -> List result
map5 =
  Native.ArrayList.map5


{-| Decompose a list of tuples into a tuple of lists.

    unzip [(0, True), (17, False), (1337, True)] == ([0,17,1337], [True,False,True])
-}
unzip : ArrayList (a,b) -> (ArrayList a, ArrayList b)
unzip pairs = -- could be optimize on native
  let
    step (x,y) (xs,ys) =
      (push x xs, push y ys)
  in
    foldl step (empty, empty) pairs


{-| Places the given value between all members of the given list.

    intersperse "on" ["turtles","turtles","turtles"] == ["turtles","on","turtles","on","turtles"]
-}
intersperse : a -> ArrayList a -> ArrayList a
intersperse =
    Native.ArrayList.intersperse


{-| Take the first *n* members of a list.

    take 2 [1,2,3,4] == [1,2]
-}
take : Int -> ArrayList a -> ArrayList a
take =
    Native.ArrayList.take

{-| Drop the first *n* members of a list.

    drop 2 [1,2,3,4] == [3,4]
-}
drop : Int -> ArrayList a -> ArrayList a
drop =
    Native.ArrayList.drop


{-| Create a list with *n* copies of a value:

    repeat 3 (0,0) == [(0,0),(0,0),(0,0)]
-}
repeat : Int -> a -> ArrayList a
repeat =
    Native.ArrayList.repeat


{-| Sort values from lowest to highest

    sort [3,1,5] == [1,3,5]
-}
sort : ArrayList comparable -> ArrayList comparable
sort =
    Native.ArrayList.sort


{-| Sort values by a derived property.

    alice = { name="Alice", height=1.62 }
    bob   = { name="Bob"  , height=1.85 }
    chuck = { name="Chuck", height=1.76 }

    sortBy .name   [chuck,alice,bob] == [alice,bob,chuck]
    sortBy .height [chuck,alice,bob] == [alice,chuck,bob]

    sortBy String.length ["mouse","cat"] == ["cat","mouse"]
-}
sortBy : (a -> comparable) ->  ArrayList a -> ArrayList a
sortBy =
  Native.ArrayList.sortBy


{-| Sort values with a custom comparison function.

    sortWith flippedComparison [1..5] == [5,4,3,2,1]

    flippedComparison a b =
        case compare a b of
          LT -> GT
          EQ -> EQ
          GT -> LT

This is also the most general sort function, allowing you
to define any other: `sort == sortWith compare`
-}
sortWith : (a -> a -> Order) ->  ArrayList a -> ArrayList a
sortWith =
  Native.ArrayList.sortWith




{-| Push an element to the end of the list

    push 5 [1,2] == [1,2,5]
-}
push : a -> ArrayList a -> ArrayList a
push =
    Native.ArrayList.push

{-| An empty ArrayList value
-}
empty : ArrayList a
empty =
    Native.ArrayList.empty

{-| Converts a List to ArrayList
-}
fromList : List a -> ArrayList a
fromList =
    Native.ArrayList.fromList

{-| Converts an ArrayList to List
-}
toList : ArrayList a -> List a
toList =
    Native.ArrayList.toList
