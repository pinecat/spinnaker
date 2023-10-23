## [0.1.0] - 2023-10-23

This is the initial release.

### Added

- Ability to track page visits
- Tracks the following info:
    - Path
    - Title
    - Meta info (is it the index, a feed, etc.)
    - Exists (whether or not the path is valid according to the site)
    - Visits (the number of visits, as well as the time of each visit)
- Serves page data over an API
- Query the API over a specified time period:
    - Default is to get page info for the last 24 hours
    - /today: page data for the current day
    - /week: page data for the current week
    - /month: page data for the current month
