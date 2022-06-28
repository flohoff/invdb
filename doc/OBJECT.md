
There should be a middleware dealing with all aspects of the needs of the Frontend
and other tools. Database specific identifier should not be exposed.

Example Object
==============

Objects are identified by their UUID. The only "essential" attribute
for an object is the *type*. Everyhing else is "key, value" store where
values are always arrays of values. 

    {
      "uuid": "4e665e17-b40a-4c73-b879-31aa9bc7aab1",
      "type": "host",
      "attributes": {
        "address": [
          "8.8.8.8"
        ],
        "name": [
          "foobar"
        ]
      }
    }

Example Link
============

Links build up the directed graph this database builds. A link is
identified by its UUID. It references a *from* and *to* object
and the *type* of link. Currently no other options/attributes
are supported.

    {
      "uuid": "fb8001b5-4834-493f-9fe0-e5068c095b66",
      "type": "is-in",
      "from": "b56582e8-a452-4e42-903b-9b5cc2a7267f",
      "to": "4e665e17-b40a-4c73-b879-31aa9bc7aab1"
    }
