# Assignment 4 - Columnar Databases and HBase

## 7in7 - HBase - Day 1

### Part 1 - Interactive Reading

Read Day 1 and work through the examples in the chapter.
Save your final database in a directory `day1` as follows.

```
./save.bash wiki day1
```

You can use the same script to save your database between work sessions.
But you cannot save over an existing save. So use temporary names like:
`day1a`, `day1b`, etc. You can use the `./load.bash` script to restore
an empty database from a saved state.

Here are some additional tips:

* Skip **Configuring HBase**.
* Begin with the last command on p57: `version`.
* p59 - Do not run these in the shell, which is Ruby.
    These are illustrative examples in python.
* p64 - The last example is split over 2 lines. `hbase>` and `hbase*` are
    not part of the command.
* I have not been able to use the colons inside of quotes in the hbase commands. If they don't work with the colon, try them without.
* The command to allow unlimited  versions is:

`alter 'wiki', {NAME => 'text', VERSIONS => 2147483647 }`

### Part 2 - 7in7 - HBase Day 1 - Find

1. Figure our how to use the shell to do the following:

    * Delete individual column values in a row:

        ```
        hbase(main):021:0> scan 'wiki'
        ROW                        COLUMN+CELL
        Home                      column=text:, timestamp=1762874332332, value=Welcome to the wiki!
        HomePage                  column=revision:author, timestamp=1762875468168, value=Alice
        HomePage                  column=revision:comment, timestamp=1762875477703, value=Initial draft
        HomePage                  column=revision:text, timestamp=1762875492531, value=Welcome to the wiki!
        HomePage                  column=revision:timestamp, timestamp=1762875484673, value=2025-11-11T10:0
                                0:00
        2 row(s) in 0.0220 seconds

        hbase(main):022:0> delete 'wiki', 'HomePage', 'revision:comment'
        0 row(s) in 0.0160 seconds

        hbase(main):023:0> scan 'wiki'
        ROW                        COLUMN+CELL
        Home                      column=text:, timestamp=1762874332332, value=Welcome to the wiki!
        HomePage                  column=revision:author, timestamp=1762875468168, value=Alice
        HomePage                  column=revision:text, timestamp=1762875492531, value=Welcome to the wiki!
        HomePage                  column=revision:timestamp, timestamp=1762875484673, value=2025-11-11T10:0
                                0:00
        2 row(s) in 0.0110 seconds
        ```

    * Delete an entire row

        ```
         hbase(main):023:0> scan 'wiki'
        ROW                        COLUMN+CELL
        Home                      column=text:, timestamp=1762874332332, value=Welcome to the wiki!
        HomePage                  column=revision:author, timestamp=1762875468168, value=Alice
        HomePage                  column=revision:text, timestamp=1762875492531, value=Welcome to the wiki!
        HomePage                  column=revision:timestamp, timestamp=1762875484673, value=2025-11-11T10:0
                                0:00
        2 row(s) in 0.0110 seconds

        hbase(main):024:0> deleteall 'wiki', 'HomePage'
        0 row(s) in 0.0050 seconds

        hbase(main):025:0> scan 'wiki'
        ROW                        COLUMN+CELL
        Home                      column=text:, timestamp=1762874332332, value=Welcome to the wiki!
        1 row(s) in 0.0090 seconds
        ```


2. Bookmark the HBase API documentation for the version of HBase you’re using.

    ```
    https://hbase.apache.org/book.html
    ```

### Part 3 - Create a family database

#### Step 1 - Create an hbase table that represents a family.

Specifically, you should have column families for the following:
* personal information: names of family members and birthdays
* favorites: foods and vacation locations
* location information: addresses including street, city, state, and zip. and phone numbers

Place the Hbase code to create the families below:
```

```

#### Step 2 - Load five rows of data.
Make sure to have at least one row with more than one favorite food and at least one row with more than one favorite vacation location. Place the Hbase code below:
```

```

#### Step 3 – Create HBase queries for the items below.

Place the Hbase code **and the results** after each query.

**Query 1:** Get complete information for a specific family member.
```
ANSWER HERE
```

**Query 2:** View only personal information for all family members.
```
ANSWER HERE
```

**Query 3:** Get the name, favorite foods, and vacation locations for one family member.
```
ANSWER HERE
```

**Query 4:** Get a range of at least two family members.
```
ANSWER HERE
```

**Query 5:** Get the addresses for all family members.
```
ANSWER HERE
```

**Query 6:** Get the names of family members who like a specific favorite food (e.g., pizza).
```
ANSWER HERE
```

**Query 7:** Create a vacation preference list with names.
```
ANSWER HERE
```

### Part 4 - 7in7 - Day 3 - Wrap Up

Read Day 3 - Wrap Up. Then answer the following.

1. List the pros of HBase as described in our text.

    ```
    ANSWER HERE
    ```

2. List the cons of HBase as described in our text.

    ```
    ANSWER HERE
    ```


### 7in7 - Day 2 - OPTIONAL

OPTIONAL - You may safely skip Day 2.

This section contains a code-heavy example of loading a large amount
of data into your HBase database. If you feel like a challenge and are
interested, feel free to work through it.

If you do this section, please **do not** use ./save.bash to save
your database, because it may become very large.

So if you are ready for the challenge, below are some instructions to
help you along. Good luck!

1. Download and extract the source code for the text: https://pragprog.com/titles/pwrdata/seven-databases-in-seven-weeks-second-edition/

2. Drag the following files into 02_hbase/local/scripts on GitPod.
    * source_code/02_hbase/import_from_wikipedia.rb
    * source_code/02_hbase/create_wiki_schema.rb

3. Start your database.

4. Run the following to create the wiki table.

    ```
    ./shell.bash create_wiki_schema.rb
    ```

5. Now you should be able to run the command below.
    BEFORE YOU DO... be ready to press CTRL+C to stop the process. This
    command will load a lot of data very fast.

    ```
    curl https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2 | bzcat | ./shell.bash import_from_wikipedia.rb
    ```

6. After it appears to be working, press CTRL+C to stop it.

7. Connect to your database.

8. Run the command below to count the number of
    rows in your 'wiki' table.

    ```
    count 'wiki'
    ```

    Copy and paste the output of this command below.

9. Run the command below to get information about your database's regions.

    ```
    scan 'hbase:meta',{FILTER=>"PrefixFilter('wiki')"}
    ```

    Copy and past the output of this command below.
