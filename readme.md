
<p align="center">
  <img width="33%" alt="reina-github-icon" src="https://github.com/user-attachments/assets/a6b78d62-2be9-4d3c-a70a-7fc5524ef765"/>
</p>

## Reina Kana
[![Swift Version](https://img.shields.io/badge/Swift-6.1--6.2-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![Appstore](https://img.shields.io/badge/Appstore-Reina_Kana-179e8c.svg?style=flat)](https://apps.apple.com/fr/app/reina-kana/id6749651401)

Reina kana is an iOS app made to help you learn Japanese Hiragana and Katakana
It has mnemonics, writing exercices and (soon) articles to learn all there is to know to begin learning Japanese

<p align="center">
<img width="200" style="display: inline-block;" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-26 at 17 42 34" src="https://github.com/user-attachments/assets/64be2a12-fd65-418d-a09a-06b671f29b9b" />
<img width="200" style="display: inline-block;" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-26 at 17 42 49" src="https://github.com/user-attachments/assets/290e500a-85b4-4816-9950-538a57ef0065" />
<img width="200" style="display: inline-block;" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-26 at 17 41 03" src="https://github.com/user-attachments/assets/5ef202b1-0f6d-4484-918c-1621fde7942c" />
<img width="200" style="display: inline-block;" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-26 at 17 42 26" src="https://github.com/user-attachments/assets/efee261e-1b75-4cac-a30e-e3925a99dfed" />
<img width="200" style="display: inline-block;" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-26 at 17 41 24" src="https://github.com/user-attachments/assets/2e745770-ff38-4b93-9811-509e3637ba9d" />
<img width="200" style="display: inline-block;" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-26 at 17 41 24" src="https://github.com/user-attachments/assets/e2a42903-ff66-443d-92e9-b821224a236e" />
<img width="200" style="display: inline-block;" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-26 at 17 41 30" src="https://github.com/user-attachments/assets/60ff1328-c434-4f11-aba8-1b9d5d1eeb95" />
<img width="200" style="display: inline-block;" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-26 at 17 42 14" src="https://github.com/user-attachments/assets/3507a7ae-c825-41fa-9277-ff9f286a1677" />
</p>

## Setup to build and run
run 
```make```

You're ready to use the app

## To build the full words database
Download the jmdict.yml file
Run the following to build the database
```bash
swift run  --package-path ./JMdictTools jmdict-tools ./jmdict.xml -o sqlite
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
SELECT * FROM reinawords WHERE easinessscore = 10 ORDER BY RANDOM() LIMIT 1;
```
