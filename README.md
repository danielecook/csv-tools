# csv utilities

[![Build Status](https://travis-ci.org/danielecook/csv-utilities.svg?branch=development)](https://travis-ci.org/danielecook/csv-tools)

## Stack

Stacks datasets together by column.


## Slice

Extracts a range from every file

```
 slice range [files ...]
```

 Where `range` is the range of lines to keep.

 * `:5` - From the beginning to the 5th line
 * `5:` - From the 5th line to the end
 * `3:5` - From the 3rd to the 5th line


## TODO

* [ ] cut
* [ ] diff