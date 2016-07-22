var _aaronps$elm_arraylist$Native_ArrayList = (function () {
    var empty = [];


    return {
        cons: F2(cons),
        head: head,
        tail: tail,
        isEmpty: isEmpty,
        member: F2(member),
        map: F2(map),
        indexedMap: F2(indexedMap),
        foldl: F3(foldl),
        foldr: F3(foldr),
        scanl: F3(scanl),
        filter: F2(filter),
        filterMap: F2(filterMap),
        length: length,
        reverse: reverse,
        all: F2(all),
        any: F2(any),
        append: F2(append),
        concat: concat,

        map2: F3(map2),
        map3: F4(map3),
        map4: F5(map4),
        map5: F6(map5),

        intersperse: F2(intersperse),
        take: F2(take),
        drop: F2(drop),
        repeat: F2(repeat),

        sort: sort,
        sortBy: F2(sortBy),
        sortWith: F2(sortWith),


        // extra functions
        push: F2(push),
        empty: empty,

        initialize: F2(initialize),
        fromList: _elm_lang$core$Native_List.toArray,


        slice: F3(slice),

        toList: _elm_lang$core$Native_List.fromArray,
        toIndexedList: toIndexedList,
        set: F3(setValue),
        get: F2(getValue)
    };

    function cons(item, array) {
        return [item].concat(array);
    }

    function head(array) {
        return array.length === 0
            ? _elm_lang$core$Maybe$Nothing
            : _elm_lang$core$Maybe$Just(array[0]);
    }

    function tail(array) {
        return array.length <= 1
            ? _elm_lang$core$Maybe$Nothing
            : _elm_lang$core$Maybe$Just(array.slice(1));
    }

    function isEmpty(array) {
        return array.length === 0;
    }

    function member(item, array) {
        return array.indexOf(item) !== -1;
    }

    function map(fun, array) {
        return array.map(fun);
    }

    function indexedMap(fun, array) {
        var len = array.length;
        if (len === 0)
            return empty;

        var result = new Array(len);
        var i;
        for (i = 0; i < len; i++)
            result[i] = A2(fun, i, array[i]);

        return result;
    }

    function foldl(fun, accumulator, array) {
        var i, ie;
        for (i = 0, ie = array.length; i < ie; i++) {
            accumulator = A2(fun, array[i], accumulator);
        }
        return accumulator;
    }

    function foldr(fun, accumulator, array) {
        var i = array.length;
        while (--i >= 0) {
            accumulator = A2(fun, array[i], accumulator);
        }
        return accumulator;
    }

    function scanl(fun, accumulator, array) {
        var i = 0,
            ie = array.length,
            result = new Array(ie + 1);

        result[0] = accumulator;

        while ( i < ie ) {
            accumulator = A2(fun, array[i], accumulator);
            result[++i] = accumulator;
        }

        return result;
    }

    function filter(fun, array) {
        return array.filter(fun);
    }

    function filterMap(fun, array) {
        var i, ie, result = [], value;
        for (i = 0, ie = array.length; i < ie; i++) {
            value = fun(array[i]);
            if ( value.ctor === 'Just' ) {
                result.push(value._0);
            }
        }
        return result;
    }

    function length(array) {
        return array.length;
    }

    function reverse(array) {
        // we could do a loop and reverse ourselves.... being lazy
        return array.slice(0).reverse();
    }

    function all(fun, array) {
        return array.every(fun);
    }

    function any(fun, array) {
        return array.some(fun);
    }

    function append(a, b) {
        return a.concat(b);
    }

    function concat(arrayOfArrays) {
        return Array.prototype.concat.apply([], arrayOfArrays);
    }

    function map2(fun, a1, a2) {
        var len = Math.min(a1.length, a2.length);
        if ( len === 0 )
            return empty;
        
        var result = new Array(len);
        var i;
        for ( i = 0; i < len; i++ ) {
            result[i] = A2(fun, a1[i], a2[i]);
        }

        return result;
    }

    function map3(fun, a1, a2, a3) {
        var len = Math.min(a1.length, a2.length);
        if ( a3.len < len ) len = a3.len;

        if ( len === 0 )
            return empty;
        
        var result = new Array(len);
        var i;
        for ( i = 0; i < len; i++ ) {
            result[i] = A3(fun, a1[i], a2[i], a3[i]);
        }

        return result;
    }

    function map4(fun, a1, a2, a3, a4) {
        var len = Math.min(a1.length, a2.length);
        if ( a3.len < len ) len = a3.len;
        if ( a4.len < len ) len = a4.len;

        if ( len === 0 )
            return empty;
        
        var result = new Array(len);
        var i;
        for ( i = 0; i < len; i++ ) {
            result[i] = A4(fun, a1[i], a2[i], a3[i], a4[i]);
        }

        return result;
    }

    function map5(fun, a1, a2, a3, a4, a5) {
        var len = Math.min(a1.length, a2.length);
        if ( a3.len < len ) len = a3.len;
        if ( a4.len < len ) len = a4.len;
        if ( a5.len < len ) len = a5.len;

        if ( len === 0 )
            return empty;
        
        var result = new Array(len);
        var i;
        for ( i = 0; i < len; i++ ) {
            result[i] = A5(fun, a1[i], a2[i], a3[i], a4[i], a5[i]);
        }

        return result;
    }

    function intersperse(value, array) {
        var len = array.length;
        if ( len <= 1 )
            return array;
        
        var result = new Array(len + len - 1);
        result[0] = array[0];

        var i = 1, dsti = 1;
        for ( ; i < len; i++, dsti++ ) {
            result[dsti] = value;
            result[++dsti] = array[i];
        }
        return result;
    }

    function take(count, array) {
        if ( count <= 0 )
            return empty;
        
        return array.slice(0, count);
    }

    function drop(count, array) {
        if ( count <= 0 )
            return array;
        
        return array.slice(count);
    }

    function repeat(length, value) {
        // @note: looks like IE, maybe EDGE too, doesn't support Array.fill
        // @note: not failinig on negative values
        if (length <= 0)
            return empty;

        var result = new Array(length);
        var i;
        for (i = 0; i < length; i++)
            result[i] = value;

        return result;
    }

    function sort(array) {
        return array.slice(0).sort(_elm_lang$core$Native_Utils.cmp);
    }

    function sortBy(fun, array) {
        return array.slice(0).sort(function(a,b) {
            return _elm_lang$core$Native_Utils.cmp(fun(a), fun(b));
        });
    }

    function sortWith(fun, array) {
        return array.slice(0).sort(function(a,b) {
            // XXX was fun(a)(b).ctor
            var ord = A2(fun,a,b).ctor;
            return ord === 'EQ' ? 0 : ord === 'LT' ? -1 : 1;
        });
    }




    // extra functions
    function push(value, array) {
        return array.concat(value);
    }


    function allocate(count) {
        return new Array(count);
    }

    

    function initialize(length, fun) {
        // @note: not failinig on negative values
        if (length <= 0)
            return empty;

        var result = new Array(length);
        var i;
        for (i = 0; i < length; i++)
            result[i] = fun(i);

        return result;
    }

    

    





    function setValue(index, value, array) {
        if (index < 0 || index >= array.length) {
            return array;
        }

        var newArray = array.slice(0)
        newArray[index] = value;
        return newArray;
    }

    function getValue(index, array) {
        // @note javascript will give undefined if out of bounds, so..
        var value = array[index];

        // @note just 2 '==' so null and undefined will return Nothing
        return value == null ? _elm_lang$core$Maybe$Nothing
            : _elm_lang$core$Maybe$Just(value);
    }

    function slice(from, to, array) {
        return array.slice(from, to);
    }

    



    

    function toIndexedList(array) {
        var result = _elm_lang$core$Native_List.Nil,
            Cons = _elm_lang$core$Native_List.Cons,
            Tuple2 = _elm_lang$core$Native_Utils.Tuple2,
            i = array.length, value;
        while (--i >= 0) {
            value = array[i];
            // @note '!=' so it includes undefined
            if (value != null)
                result = Cons(Tuple2(i, array[i]), result);
        }
        return result;
    }

})();
