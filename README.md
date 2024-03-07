# DOS Tasks
Небольшие проекты на языке ассемблера Turbo Assembler для MS-DOS. Отладка и
сборка проводились в эмуляторе DOSBox.

## Рамка
Просто рисует рамку на экране, пользуясь прямым доступом к сегменту видеопамяти.

## Резидент
Подменяет прерывания клавиатуры (`09h`) и таймера (`08h`) и по нажатию горячей
клавиши выводит обновляющуюся по таймеру рамку. В рамке -- значения регистров
в данный момент времени.

## Crackme
Программа с намеренно оставленными уязвимостями. 

## Crack
Небольшая программа на C++, предназначенная для бинарного патча определенного 
вида COM-файлов.
