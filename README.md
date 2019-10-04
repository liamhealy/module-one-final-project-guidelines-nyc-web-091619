# Flatiron School
## Module one project

### Traveler -> Ticket -> Flight

Our domain model demonstrates the relationship between travelers and their flights through the tickets they purchase.

Traveler:
- Name

Flight:
- Origin
- Destination
- Departure Time
- Arrival Time
- Status

The Traveler and their Flight are connected by the purchase of a ticket.
 
Ticket: 
- traveler_id
- flight_id
 
### User Stories:
1. As a traveler, I should be able to enter my name and view flights that I have purchased a ticket for.
2. As a traveler, I should be able to specify a destination, and purchase a ticket for an available flight.
3. As an airport administrator, I should be able to view all travelers that have purchased tickets for flights.
4. As an airport administrator, I should be able to cancel my flights when necessary.

Gems we included in our application:
* [TTY-Prompt](https://github.com/piotrmurach/tty-prompt#26-menu)
* [TTY-Font](https://github.com/piotrmurach/tty-font)
