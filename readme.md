## Setup
run 
```make```

You're ready to use the app

## To build the full words database
Download the jmdict.yml file or use the small-dict.yml to test out things on a smaller scale
Run the following to build the database
```bash
cd ./JMdictTools
swift run JMdictToolsCLI ./CLI/small-dict.yml -o sqlite
```
Ignoring the -o will print the output to the console, you can swap the path to your dict

Query it using sqlite
```sql
sqlite3 reina_words.sqlite

-- To get the table description
pragma table_info('reinawords');

-- See the easiness scores with their count (higher is simpler 1 - 10)
select easinessScore, count(easinessScore) from reinawords group by easinessScore;

-- Get a random easy element
SELECT * FROM reinawords WHERE easinessscore = 9 ORDER BY RANDOM() LIMIT 1;
```