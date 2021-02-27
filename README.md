# tawk.to iOS Practical Test

## GitHub Users

## Users list

1. Github users list can be obtained from ​https://api.github.com/users?since=0​in JSON format. **`DONE`**
2. The list must support pagination (​scroll to load more​) utilizing ​since p​arameter as the integer ID of the last User loaded. **`DONE`**
3. Page size​ has to be dynamically determined after the first batch is loaded. **`DONE`**
4. The list has to display a spinner while loading data as the last list item. **`DONE`**
5. Every fourth avatar's colour should have its colours inverted. **`DONE`**
5. List item view should have a note icon if there is note information saved for the given
user.
7. Users list has to be searchable - local search only; in ​search mode,​ there is no
pagination; username and note (see Profile section) fields should be used when
searching; precise match as well as ​contains s​ hould be used. **`DONE`**
8. List (table/collection view) must be implemented using at least ​3 different cells
(normal, note & inverted) and ​Protocols

## Profile

1. Profile info can be obtained from ​https://api.github.com/users/[​username]​in JSON format (e.g. ​https://api.github.com/users/tawk)​ **`DONE`**
1. ~~The view should have the user's avatar as a header view followed by information fields (UIX is up to you)~~ **`DONE`**
2. The section must have the possibility to retrieve and save back to the database the Note​data (not available in GitHub api; local database only).

## Bonus Features

1. Coordinator and/or MVVM patterns are used.
