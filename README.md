# North American City Autocomplete
## What
A JSON endpoint built using Elixir and Phoenix that provides a basic autocomplete service

## Why
Elixir and Phoenix were chosen as this was a great opportunity to experiment with a new language and its libraries. Elixir has been of interest to me for quite some time now, and the backend coding challenge was the perfect sized project to test and evaluate the langauge, the BEAM, and the basics of OTP in a non-trivial setting.

## How
 - City information is stored in a prefix trie
 - Upon a query, suggestion candidates are collected via prefix matching and fuzzy matching (by levenshtein automata)
 - Suggestion candidates are then given a score taking into consideration its Jaro-Winklar distance from the query, its population size, and, if provided, its location information. More populous cities are scored higher. Likewise, cities that are closer to the provided location (estimated via longitude and latitude) are given a higher score.
 - The best scoring cities among the candidates are suggested

### Example
```
https://limitless-shore-64325.herokuapp.com/suggestions?q=london
https://limitless-shore-64325.herokuapp.com/suggestions?q=london&latitude=45.5&longitude=-73.56
```

### Misc 
To run the unit tests: `mix test`.
