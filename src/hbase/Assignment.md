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
    hbase(main):001:0> create 'family',
    hbase(main):002:0*   { NAME => 'personal' },
    hbase(main):003:0*   { NAME => 'favorites' },
    hbase(main):004:0*   { NAME => 'location' }
    0 row(s) in 1.4180 seconds

    => Hbase::Table - family
    ```

#### Step 2 - Load five rows of data.
Make sure to have at least one row with more than one favorite food and at least one row with more than one favorite vacation location. Place the Hbase code below:

    ```
    put 'family','fam1','personal:name','Alice'
    put 'family','fam1','personal:birthday','1990-05-14'
    put 'family','fam1','favorites:food','pizza'
    put 'family','fam1','favorites:vacation','Hawaii'
    put 'family','fam1','favorites:vacation','Japan'
    put 'family','fam1','location:street','12 Green Rd'
    put 'family','fam1','location:city','Springfield'
    put 'family','fam1','location:state','MA'
    put 'family','fam1','location:zip','01109'
    put 'family','fam1','location:phone','555-1111'

    put 'family','fam2','personal:name','Bob'
    put 'family','fam2','personal:birthday','1985-02-01'
    put 'family','fam2','favorites:food','pasta'
    put 'family','fam2','favorites:vacation','Florida'
    put 'family','fam2','location:street','80 River St'
    put 'family','fam2','location:city','Springfield'
    put 'family','fam2','location:state','MA'
    put 'family','fam2','location:zip','01109'

    put 'family','fam3','personal:name','Carol'
    put 'family','fam3','personal:birthday','2000-10-21'
    put 'family','fam3','favorites:food','pizza'
    put 'family','fam3','location:street','22 Lake Ave'
    put 'family','fam3','location:city','Hartford'
    put 'family','fam3','location:state','CT'
    put 'family','fam3','location:zip','06103'

    put 'family','fam4','personal:name','David'
    put 'family','fam4','personal:birthday','1975-07-09'
    put 'family','fam4','favorites:food','tacos'
    put 'family','fam4','favorites:vacation','Texas'
    put 'family','fam4','favorites:vacation','Colorado'
    put 'family','fam4','location:city','Providence'
    put 'family','fam4','location:state','RI'

    put 'family','fam5','personal:name','Emma'
    put 'family','fam5','personal:birthday','2010-12-12'
    put 'family','fam5','favorites:food','icecream'
    put 'family','fam5','favorites:vacation','New York'
    put 'family','fam5','location:city','Boston'
    put 'family','fam5','location:state','MA'

    Result :
    hbase(main):050:0> scan 'family'
    ROW                        COLUMN+CELL
    fam1                      column=favorites:food, timestamp=1762876134412, value=pizza
    fam1                      column=favorites:vacation, timestamp=1762876134472, value=Japan
    fam1                      column=location:city, timestamp=1762876134539, value=Springfield
    fam1                      column=location:phone, timestamp=1762876134616, value=555-1111
    fam1                      column=location:state, timestamp=1762876134562, value=MA
    fam1                      column=location:street, timestamp=1762876134504, value=12 Green Rd
    fam1                      column=location:zip, timestamp=1762876134583, value=01109
    fam1                      column=personal:birthday, timestamp=1762876134385, value=1990-05-14
    fam1                      column=personal:name, timestamp=1762876134340, value=Alice
    fam2                      column=favorites:food, timestamp=1762876134705, value=pasta
    fam2                      column=favorites:vacation, timestamp=1762876134720, value=Florida
    fam2                      column=location:city, timestamp=1762876134759, value=Springfield
    fam2                      column=location:state, timestamp=1762876134776, value=MA
    fam2                      column=location:street, timestamp=1762876134742, value=80 River St
    fam2                      column=location:zip, timestamp=1762876134801, value=01109
    fam2                      column=personal:birthday, timestamp=1762876134681, value=1985-02-01
    fam2                      column=personal:name, timestamp=1762876134641, value=Bob
    fam3                      column=favorites:food, timestamp=1762876134874, value=pizza
    fam3                      column=location:city, timestamp=1762876134935, value=Hartford
    fam3                      column=location:state, timestamp=1762876134956, value=CT
    fam3                      column=location:street, timestamp=1762876134902, value=22 Lake Ave
    fam3                      column=location:zip, timestamp=1762876134981, value=06103
    fam3                      column=personal:birthday, timestamp=1762876134852, value=2000-10-21
    fam3                      column=personal:name, timestamp=1762876134833, value=Carol
    fam4                      column=favorites:food, timestamp=1762876135056, value=tacos
    fam4                      column=favorites:vacation, timestamp=1762876135103, value=Colorado
    fam4                      column=location:city, timestamp=1762876135126, value=Providence
    fam4                      column=location:state, timestamp=1762876135144, value=RI
    fam4                      column=personal:birthday, timestamp=1762876135029, value=1975-07-09
    fam4                      column=personal:name, timestamp=1762876135008, value=David
    fam5                      column=favorites:food, timestamp=1762876135285, value=icecream
    fam5                      column=favorites:vacation, timestamp=1762876135331, value=New York
    fam5                      column=location:city, timestamp=1762876135359, value=Boston
    fam5                      column=location:state, timestamp=1762876135375, value=MA
    fam5                      column=personal:birthday, timestamp=1762876135239, value=2010-12-12
    fam5                      column=personal:name, timestamp=1762876135201, value=Emma
    5 row(s) in 0.0680 seconds
    ```

#### Step 3 – Create HBase queries for the items below.

Place the Hbase code **and the results** after each query.

**Query 1:** Get complete information for a specific family member.

    ```
        hbase(main):051:0> get 'family', 'fam2'
        COLUMN                     CELL
        favorites:food            timestamp=1762876134705, value=pasta
        favorites:vacation        timestamp=1762876134720, value=Florida
        location:city             timestamp=1762876134759, value=Springfield
        location:state            timestamp=1762876134776, value=MA
        location:street           timestamp=1762876134742, value=80 River St
        location:zip              timestamp=1762876134801, value=01109
        personal:birthday         timestamp=1762876134681, value=1985-02-01
        personal:name             timestamp=1762876134641, value=Bob
        8 row(s) in 0.0240 seconds

    ```

**Query 2:** View only personal information for all family members.

    ```
        hbase(main):052:0> scan 'family', { COLUMNS => ['personal'] }
        ROW                        COLUMN+CELL
        fam1                      column=personal:birthday, timestamp=1762876134385, value=1990-05-14
        fam1                      column=personal:name, timestamp=1762876134340, value=Alice
        fam2                      column=personal:birthday, timestamp=1762876134681, value=1985-02-01
        fam2                      column=personal:name, timestamp=1762876134641, value=Bob
        fam3                      column=personal:birthday, timestamp=1762876134852, value=2000-10-21
        fam3                      column=personal:name, timestamp=1762876134833, value=Carol
        fam4                      column=personal:birthday, timestamp=1762876135029, value=1975-07-09
        fam4                      column=personal:name, timestamp=1762876135008, value=David
        fam5                      column=personal:birthday, timestamp=1762876135239, value=2010-12-12
        fam5                      column=personal:name, timestamp=1762876135201, value=Emma
        5 row(s) in 0.0460 seconds
    ```

**Query 3:** Get the name, favorite foods, and vacation locations for one family member.

    ```
    hbase(main):070:0> get 'family','fam1',{ COLUMNS => ['personal:name','favorites'] }
    COLUMN                     CELL
    favorites:food            timestamp=1762876134412, value=pizza
    favorites:vacation        timestamp=1762876134472, value=Japan
    personal:name             timestamp=1762876134340, value=Alice
    3 row(s) in 0.0100 seconds
    ```

**Query 4:** Get a range of at least two family members.

    ```
    hbase(main):072:0> scan 'family', { STARTROW => 'fam2', STOPROW => 'fam4' }
    ROW                        COLUMN+CELL
    fam2                      column=favorites:food, timestamp=1762876134705, value=pasta
    fam2                      column=favorites:vacation, timestamp=1762876134720, value=Florida
    fam2                      column=location:city, timestamp=1762876134759, value=Springfield
    fam2                      column=location:state, timestamp=1762876134776, value=MA
    fam2                      column=location:street, timestamp=1762876134742, value=80 River St
    fam2                      column=location:zip, timestamp=1762876134801, value=01109
    fam2                      column=personal:birthday, timestamp=1762876134681, value=1985-02-01
    fam2                      column=personal:name, timestamp=1762876134641, value=Bob
    fam3                      column=favorites:food, timestamp=1762876134874, value=pizza
    fam3                      column=location:city, timestamp=1762876134935, value=Hartford
    fam3                      column=location:state, timestamp=1762876134956, value=CT
    fam3                      column=location:street, timestamp=1762876134902, value=22 Lake Ave
    fam3                      column=location:zip, timestamp=1762876134981, value=06103
    fam3                      column=personal:birthday, timestamp=1762876134852, value=2000-10-21
    fam3                      column=personal:name, timestamp=1762876134833, value=Carol
    2 row(s) in 0.0290 seconds
    ```

**Query 5:** Get the addresses for all family members.

    ```
    hbase(main):073:0> scan 'family', { COLUMNS => ['location:street','location:city','location:state','location:zip'] }
    ROW                        COLUMN+CELL
    fam1                      column=location:city, timestamp=1762876134539, value=Springfield
    fam1                      column=location:state, timestamp=1762876134562, value=MA
    fam1                      column=location:street, timestamp=1762876134504, value=12 Green Rd
    fam1                      column=location:zip, timestamp=1762876134583, value=01109
    fam2                      column=location:city, timestamp=1762876134759, value=Springfield
    fam2                      column=location:state, timestamp=1762876134776, value=MA
    fam2                      column=location:street, timestamp=1762876134742, value=80 River St
    fam2                      column=location:zip, timestamp=1762876134801, value=01109
    fam3                      column=location:city, timestamp=1762876134935, value=Hartford
    fam3                      column=location:state, timestamp=1762876134956, value=CT
    fam3                      column=location:street, timestamp=1762876134902, value=22 Lake Ave
    fam3                      column=location:zip, timestamp=1762876134981, value=06103
    fam4                      column=location:city, timestamp=1762876135126, value=Providence
    fam4                      column=location:state, timestamp=1762876135144, value=RI
    fam5                      column=location:city, timestamp=1762876135359, value=Boston
    fam5                      column=location:state, timestamp=1762876135375, value=MA
    5 row(s) in 0.0430 seconds
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
