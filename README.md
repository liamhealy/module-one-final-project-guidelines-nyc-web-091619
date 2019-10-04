# GotFlights?
## Flatiron School - Module one project

### Traveler -> Ticket -> Flight

Our domain model demonstrates the relationship between travelers and their flights through the tickets they purchase.

Traveler:

| id        | name       |
| ----------|:----------:|
| `integer` | `string`   |



Flight:

id          | origin        | destination   | departure  |   arrival   |   status  |
----------- | ------------- |:-------------:| ----------:| -----------:| ---------:|
`integer`   | `string`      | `string`      | `datetime` | `datetime`  | `string`  |


 
Ticket: 

| id        | traveler_id     | flight_id |
| ----------|:---------------:|:---------:|
| `integer` | `integer`       | `integer` |

The Traveler and their Flight are connected by the purchase of a ticket.

### User Stories:
1. As a traveler, I should be able to enter my name and view flights that I have purchased a ticket for.
2. As a traveler, I should be able to specify a destination, and purchase a ticket for an available flight.
3. As an airport administrator, I should be able to view all travelers that have purchased tickets for flights.
4. As an airport administrator, I should be able to cancel my flights when necessary.

Gems we included in our application:
* [TTY-Prompt](https://github.com/piotrmurach/tty-prompt#26-menu)
* [TTY-Font](https://github.com/piotrmurach/tty-font)
* [rest-client](https://github.com/rest-client/rest-client)
* [JSON](https://github.com/flori/json)
* [rake](https://github.com/ruby/rake)
* [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord)
* [pry](https://github.com/pry/pry)
* [sqlite3](https://github.com/sparklemotion/sqlite3-ruby)

API:

To populate each field in our flights table we used the 'Flight Stats' API.

[Flight Stats](https://developer.flightstats.com)
