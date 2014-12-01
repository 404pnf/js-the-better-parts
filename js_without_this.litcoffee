# inspired by javascript: the better part

Good enough is not enough. :)

How to make it better:
1. do not use this
1. do not use __proto__
1. do not use for
1. do not use for in

## javascript without this
source: <http://radar.oreilly.com/2014/03/javascript-without-the-this.html>

    # example from the article
    createCar = (numberOfDoors) ->
      describe = ->
        "I have " + numberOfWheels + " wheels and " + numberOfDoors + " doors"
      numberOfWheels = 4
      describe: describe

    suv = createCar(4)
    console.log suv.describe()

### Use privileged function to access private var

Direct reference is not going to work. E.g status = isOn. Because closure will close over the _value_ of isOn on the creation
of the returned object, therefore, there is no way to change the
value of status.

    makeLightBulb = ->
      isOn = true
      flip = ->
        isOn = !isOn
      status = ->
        isOn
      o =
        flip: flip
        status: status
      o

    # each obj has its own private closure.
    # turn off b1 doesn't affect b2.
    b1 = makeLightBulb()
    b2 = makeLightBulb()
    b1.flip()
    console.log "b1 is #{b1.status()}"
    console.log "b2 is #{b2.status()}"

### Private variable doesn't get mixed up
So long as they are accessed by privileged methods of different names.

Example taken from the book "Javascript Application Programming"

    oA = ->
      a = true
      getA = -> # use function getA to get the value of a
        a
      getA: getA

    oB = ->
      a = false  # yes, this private var is named 'a', too
      getB = -> # use function getA to get the value of a
        a
      getB: getB

    a = oA()
    b = oB()
    console.log a.getA() # => true.  As expected
    console.log b.getB() # => false  As expected

    extend = (obj, extension...) ->
      for e in extension
        for k, v of e
          obj[k] = v
      obj

    mixed= ->
      # extend object with "constructor function" (for lack of a btter name),
      # not the object constructed from the constructor function.
      extend {}, oA(), oB()

    # private vars don't get mixed up with object extension
    m = mixed()
    console.log "m.getA() is #{m.getA()}"
    console.log "m.getB() is #{m.getB()}"
