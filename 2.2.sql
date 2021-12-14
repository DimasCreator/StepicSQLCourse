----JOIN запросы - запросы к нескольким таблицам

-----ТАБЛИЦЫ

Таблица genre:
+----------+-------------+
| genre_id | name_genre  |
+----------+-------------+
| 1        | Роман       |
| 2        | Поэзия      |
| 3        | Приключения |
+----------+-------------+

Таблица author:
+-----------+------------------+
| author_id | name_author      |
+-----------+------------------+
| 1         | Булгаков М.А.    |
| 2         | Достоевский Ф.М. |
| 3         | Есенин С.А.      |
| 4         | Пастернак Б.Л.   |
| 5         | Лермонтов М.Ю.   |
+-----------+------------------+

Таблица book:
+---------+-----------------------+-----------+----------+--------+--------+
| book_id | title                 | author_id | genre_id | price  | amount |
+---------+-----------------------+-----------+----------+--------+--------+
| 1       | Мастер и Маргарита    | 1         | 1        | 670.99 | 3      |
| 2       | Белая гвардия         | 1         | 1        | 540.50 | 5      |
| 3       | Идиот                 | 2         | 1        | 460.00 | 10     |
| 4       | Братья Карамазовы     | 2         | 1        | 799.01 | 3      |
| 5       | Игрок                 | 2         | 1        | 480.50 | 10     |
| 6       | Стихотворения и поэмы | 3         | 2        | 650.00 | 15     |
| 7       | Черный человек        | 3         | 2        | 570.20 | 6      |
| 8       | Лирика                | 4         | 2        | 518.99 | 2      |
+---------+-----------------------+-----------+----------+--------+--------+

--Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.

SELECT title, name_genre, price
FROM book INNER JOIN genre
ON genre.genre_id = book.genre_id
WHERE amount > 8
ORDER BY price DESC

---Внешнее соединение LEFT и RIGHT OUTER JOIN
--1. В результат включается внутреннее соединение (INNER JOIN) первой и второй таблицы в соответствии с условием;
--2. Затем в результат добавляются те записи первой таблицы, которые не вошли во внутреннее соединение на шаге 1, для таких записей соответствующие поля второй таблицы заполняются значениями NULL.
--Соединение RIGHT JOIN действует аналогично, только в пункте 2 первая таблица меняется на вторую и наоборот.

--Вывести все жанры, которые не представлены в книгах на складе.
SELECT name_genre
FROM genre LEFT JOIN book
ON genre.genre_id = book.genre_id
WHERE book.title IS NULL

---Перекрестное соединение CROSS JOIN
--Оператор перекрёстного соединения, или декартова произведения CROSS JOIN (в запросе вместо ключевых слов можно поставить запятую между таблицами) соединяет две таблицы. 
--Порядок таблиц для оператора неважен, поскольку оператор является симметричным.

--Задание
--Есть список городов, хранящийся в таблице city:

--city_id	name_city
--1	        Москва
--2	        Санкт-Петербург
--3	        Владивосток
--Необходимо в каждом городе провести выставку книг каждого автора в течение 2020 года. 
--Дату проведения выставки выбрать случайным образом.
--Создать запрос, который выведет город, автора и дату проведения выставки.
--Последний столбец назвать Дата. Информацию вывести, отсортировав сначала в алфавитном порядке по названиям городов, а потом по убыванию дат проведения выставок.
SELECT name_city, name_author, DATE_ADD('2020-01-01',INTERVAL FLOOR(RAND() * 365) DAY) AS  Дата
FROM city, author
ORDER BY name_city ASC, Дата DESC

---Запросы на выборку из нескольких таблиц
--Пример
SELECT title, name_author, name_genre, price, amount
FROM author
INNER JOIN  book ON author.author_id = book.author_id
INNER JOIN genre ON genre.genre_id = book.genre_id
WHERE price BETWEEN 500 AND 700;
+-----------------------+----------------+------------+--------+--------+
| title                 | name_author    | name_genre | price  | amount |
+-----------------------+----------------+------------+--------+--------+
| Мастер и Маргарита    | Булгаков М.А.  | Роман      | 670.99 | 3      |
| Белая гвардия         | Булгаков М.А.  | Роман      | 540.50 | 5      |
| Стихотворения и поэмы | Есенин С.А.    | Поэзия     | 650.00 | 15     |
| Черный человек        | Есенин С.А.    | Поэзия     | 570.20 | 6      |
| Лирика                | Пастернак Б.Л. | Поэзия     | 518.99 | 2      |
+-----------------------+----------------+------------+--------+--------+

--Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в отсортированном по названиям книг виде.
SELECT name_genre, title, name_author
FROM book
INNER JOIN genre ON book.genre_id = genre.genre_id
INNER JOIN author ON book.author_id = author.author_id
WHERE name_genre LIKE '%роман%'
ORDER BY title

---Запросы для нескольких таблиц с группировкой
--Пример
SELECT name_author, count(title) AS Количество
FROM author INNER JOIN book
on author.author_id = book.author_id
GROUP BY name_author
ORDER BY name_author;
+------------------+------------+
| name_author      | Количество |
+------------------+------------+
| Булгаков М.А.    | 2          |
| Достоевский Ф.М. | 3          |
| Есенин С.А.      | 2          |
| Пастернак Б.Л.   | 1          |
+------------------+------------+
--При использовании соединения INNER JOIN мы не можем узнать, что книг Лермонтова на складе нет, но предполагается, что они могут быть.  
--Чтобы автор Лермонтов был включен в результат, нужно изменить соединение таблиц.
SELECT name_author, count(title) AS Количество
FROM author LEFT JOIN book
on author.author_id = book.author_id
GROUP BY name_author
ORDER BY name_author;
+------------------+------------+
| name_author      | Количество |
+------------------+------------+
| Булгаков М.А.    | 2          |
| Достоевский Ф.М. | 3          |
| Есенин С.А.      | 2          |
| Лермонтов М.Ю.   | 0          |
| Пастернак Б.Л.   | 1          |
+------------------+------------+

--Задание
--Посчитать количество экземпляров  книг каждого автора из таблицы author.  
--Вывести тех авторов,  количество книг которых меньше 10, в отсортированном по возрастанию количества виде. 
--Последний столбец назвать Количество.
SELECT name_author, SUM(amount) AS Колличество
FROM book RIGHT JOIN author
ON book.author_id = author.author_id
GROUP BY name_author
HAVING Колличество < 10 OR Колличество IS NULL
ORDER BY Колличество
    +----------------+-------------+
    | name_author    | Колличество |
    +----------------+-------------+
    | Лермонтов М.Ю. | NULL        |
    | Пастернак Б.Л. | 2           |
    | Булгаков М.А.  | 8           |
    +----------------+-------------+
    
---Запросы для нескольких таблиц со вложенными запросами
--В запросах, построенных на нескольких таблицах, можно использовать вложенные запросы. 
--Вложенный запрос может быть включен:  после ключевого слова SELECT,  после FROM и в условие отбора после WHERE (HAVING).

--Вывести авторов, общее количество книг которых на складе максимально.
SELECT name_author, SUM(amount) as Количество
FROM author INNER JOIN book
on author.author_id = book.author_id
GROUP BY name_author
HAVING Количество =
       (
           SELECT MAX(sum_amount) AS max_sum_amount
           FROM
               (
                   SELECT author_id, SUM(amount) AS sum_amount
                   FROM book GROUP BY author_id
               ) query_in
       );

--Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре. 
--Поскольку у нас в таблицах так занесены данные, что у каждого автора книги только в одном жанре, для этого запроса внесем изменения в таблицу book. 
--Пусть у нас  книга Есенина «Черный человек» относится к жанру «Роман», а книга Булгакова «Белая гвардия» к «Приключениям» (эти изменения в таблицы уже внесены).
--Вложенные запросы могут использоваться в операторах соединения JOIN. 
--При этом им необходимо присваивать имя, которое записывается сразу после закрывающей скобки вложенного запроса.

SELECT name_author
FROM author
         INNER JOIN
     (
         SELECT author_id, COUNT(DISTINCT genre_id) as unic
         FROM book
         GROUP BY author_id
         HAVING unic = 1
     ) query_in
     ON author.author_id = query_in.author_id
ORDER BY name_author

---Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество экземпляров книги), 
-- написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде. 
-- Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально.

SELECT title, name_author, name_genre, price, amount
FROM book
         INNER JOIN genre ON genre.genre_id = book.genre_id
         INNER JOIN author ON author.author_id = book.author_id
         INNER JOIN(
    SELECT genre_id
    FROM(
         (SELECT MAX(sum_amount) AS max_sum_amount
          FROM(
                  SELECT genre_id, SUM(amount) AS sum_amount
                  FROM book
                  GROUP BY genre_id ) query_in_max ) max_amount
            INNER JOIN
        (SELECT genre_id, SUM(amount) AS sum_amount
         FROM book
         GROUP BY genre_id ) query_in_max
        ON query_in_max.sum_amount = max_amount.max_sum_amount)
) query_in ON query_in.genre_id = book.genre_id
ORDER BY title

---Оператор Using()
---Если в таблицах supply  и book есть одинаковые книги, которые имеют равную цену, 
-- вывести их название и автора, а также посчитать общее количество экземпляров книг в таблицах supply и book,  
-- столбцы назвать Название, Автор  и Количество.
 
SELECT book.title AS Название, name_author AS Автор, supply.amount + book.amount AS Количество
FROM author
         INNER JOIN book USING(author_id)
         INNER JOIN supply ON book.title = supply.title and book.price = supply.price

--ВЫВОД ВСЕГО
SELECT title, name_author, name_genre, price, amount
FROM book
         INNER JOIN genre ON book.genre_id = genre.genre_id
         INNER JOIN author ON book.author_id = author.author_id
ORDER BY name_author