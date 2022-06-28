# InvDB

The motivation for this project was the experience to automate the it
infrastrtuctre needs a single source of truth.

The project founders are working together at a hosting company and see the
opportunity to work on the "single source of truth" system.

Very helpfull was the experience of the implementror of this system from a
former company, who has developed this kind of database for network equimpment.

It was pretty clear to us that we need a database with a soft schema. We would
like to model every technical entity in our environment into this database.

We decide to no enforce to fill information into the properities. This kind of
enforcement leads to bogus data in your "single source of truths", which are
not true. It much better to have no information, than wrong information. It's
much more easier to detect missing information than dectect wrong information.

Our mantry was "Shit in, shit out". If the automation failed, because the data
was not complete, then you know that you have to some work to make the
automation successfully happen.

To see the challenge of that, we designed a object model for the database, that
every type of an entoty could have his own properties.  Server has other
properties as a patchcable or rack. Every entity in this database has an id
implemeted as uuid and a type describing the entitytype.

The next building block is a directed graph between those entities, who also
have a type. This way you are able to model dependencies between entities.

Last, but not least, we would like to find every entity in this database and
want the experience of daily used searcdh engines.

With this three basic assumptions we are able to implement a database to model
the full it infrastructure. Based on that we write the software to extract the
needed information to automate a task for example to install a bare metal server
from scratch with the defined os and configuration.

The remote hands at the datacenter gets an precise documentaion for the server
installation into the rack with information about exact place, power circuits,
switchports and cable plan. This helps alot and encrease the installation
quality.

Depending on the switch and switchport data we are able to automate the
configuratiomn of those with all the needed data like vlan tag, default vlan tag
and some specific protecting countermeasures for network health.

Sadly, one by one, the project members leaving this company, because this is how
life is. All of them are grateful to be able to develop this system and prove it
in real life work. It was amazing to see how this concept begin to work and
help to automate things in a good, precise way.

We are able to describe systems and dependencies. Based on that we are able to
automate boring daily task servber installation, switchport configuration,
monitoring, graphing and system documentation.

The project founders want that kind of automation back! Leaving the company has
the consequence to work without this level of automation. Until now none of the
project founders see this degree of automation in the other companies.

This is why they start this project. They want that back.

# vim:set ts=4 sts=4 sw=4 ai et tw=80 syntax=markdown:
