# tut (Table-Utilities)

[![Build Status](https://travis-ci.org/danielecook/tut.svg?branch=development)](https://travis-ci.org/danielecook/tut)

## Stack

Stacks datasets together by column. For example:

```
tut stack [files ...]
```

__df1.tsv__

| brand   | model   |   mpg |
|:--------|:--------|------:|
| tesla   | 3       |     0 |
| toyota  | previa  |    15 |

__df2.tsv__

| car   |   mpg | color   |
|:------|------:|:--------|
| ford  |    20 | red     |
| chevy |    15 | blue    |

```bash
tut stack df1.tsv df2.tsv
```

__Stacked df1.tsv df2.tsv__

| brand   | model   |   mpg | car   | color   |
|:--------|:--------|------:|:------|:--------|
| tesla   | 3       |     0 |       |         |
| toyota  | previa  |    15 |       |         |
|         |         |    20 | ford  | red     |
|         |         |    15 | chevy | blue    |

You can also attach the basename of the file it came from to keep track of
where data is coming from.

| brand   | model   |   mpg | car   | color   | basename   |
|:--------|:--------|------:|:------|:--------|:-----------|
| tesla   | 3       |     0 |       |         | df1.tsv    |
| toyota  | previa  |    15 |       |         | df1.tsv    |
|         |         |    20 | ford  | red     | df2.tsv    |
|         |         |    15 | chevy | blue    | df2.tsv    |

I frequently use this tool to combine datasets of separate samples for comparison.

## Slice

Extracts a range (1-based) from every file

```
 slice range [files ...]
```

 Where `range` is the range of lines to keep.

 * `:5` - From the beginning to the 5th line
 * `5:` - From the 5th line to the end
 * `3:5` - From the 3rd to the 5th line

## Select

Select columns from a file by column position (1-based) or name.

```
# These are equivelent:
tut select 1,2 tests/data/df1.tsv
tut select mpg,cyl tests/data/df1.tsv
```

|   mpg |   cyl |
|------:|------:|
|  21   |     6 |
|  21   |     6 |
|  22.8 |     4 |
| ... | ... |


## Global Options

### Row Numbers

Add row numbers with --row-numbers

## Compilation

```
nim c --cpu:i386 --os:linux --compileOnly tut.nim
```
