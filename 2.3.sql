--- Запросы на обновление, связанные таблицы

-- Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке (supply),
-- необходимо в таблице book увеличить количество на значение, указанное в поставке,  и пересчитать цену. 
-- А в таблице  supply обнулить количество этих книг. По определенной формуле.

UPDATE book
    INNER JOIN author ON author.author_id = book.author_id
    INNER JOIN supply ON book.title = supply.title
    and supply.author = author.name_author
    SET book.price = (book.price * book.amount + supply.price * supply.amount)/(book.amount + supply.amount),
        book.amount = book.amount + supply.amount,
        supply.amount = 0
WHERE book.price != supply.price;

-- Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести все данные из таблицы author.  
-- Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author.

INSERT INTO author (name_author)
SELECT supply.author
FROM
    author
        RIGHT JOIN supply on author.name_author = supply.author
WHERE name_author IS Null


--- Добавить новые книги из таблицы supply в таблицу book на основе сформированного выше запроса. Затем вывести для просмотра таблицу book.
-- тут есть условие, что amount у supply не равен 0, если книги нет в book

INSERT INTO book (title, author_id, price, amount)
SELECT title, author_id, price, amount
FROM
    author
        INNER JOIN supply ON author.name_author = supply.author
WHERE amount <> 0;


---  Занести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия», а для книги «Остров сокровищ» Стивенсона - «Приключения». 
-- (Использовать два запроса).
-- здесь нужно просто знать id и структуру таблиц

UPDATE book
SET genre_id =
        (
            SELECT genre_id
            FROM genre
            WHERE name_genre = 'Поэзия'
        )
WHERE book_id = 10;

UPDATE book
SET genre_id =
        (
            SELECT genre_id
            FROM genre
            WHERE name_genre = 'Приключения'
        )
WHERE book_id = 11;


--- Удалить всех авторов и все их книги, общее количество книг которых меньше 20.
-- Здесь используетя каскадное удаление, так как book.author_id зависит от author

DELETE FROM author
WHERE author_id IN (
    SELECT author_id
    FROM book
    GROUP BY author_id
    HAVING SUM(amount) < 20
)

--- Удалить все жанры, к которым относится меньше 4-х книг. В таблице book для этих жанров установить значение Null.
-- здесь также используется каскадное удаление, genre_id в book становится Null

DELETE FROM genre
WHERE genre_id IN (
    SELECT genre_id
    FROM book
    GROUP BY genre_id
    HAVING COUNT(book_id) < 4
)

---Удалить всех авторов из таблицы author, у которых есть книги, количество экземпляров которых меньше 3. 
-- Из таблицы book удалить все книги этих авторов.
DELETE FROM author
USING 
    author 
    INNER JOIN book ON author.author_id = book.author_id
WHERE book.amount < 3;

--- Удалить всех авторов, которые пишут в жанре "Поэзия". 
-- Из таблицы book удалить все книги этих авторов. 
-- В запросе для отбора авторов использовать полное название жанра, а не его id.

DELETE FROM author
USING 
    author INNER JOIN book ON author.author_id = book.author_id
WHERE book.genre_id = (SELECT genre_id FROM genre WHERE genre.name_genre = 'Поэзия');


---- ДОП: Нас взломали хакеры. 
-- В жанр добавлена новая запись "Страшилки". 
-- Теперь этот жанр присвоен всем книгам Достоевского и Булгакова, книги писателей в таблице supply увеличены на 100 единиц у каждого из указанных авторов.
-- Задание - замоделировать такие изменения в базу данных.

INSERT INTO genre (name_genre)
VALUES ('Страшилки');

SELECT *
FROM genre;

UPDATE book
SET genre_id = 4
WHERE author_id IN (SELECT author_id FROM author WHERE name_author LIKE "Булгаков%" OR name_author LIKE "Достаевский%");

SELECT *
FROM book;

UPDATE supply
SET amount = amount + 100
WHERE author IN (SELECT name_author FROM author WHERE name_author LIKE "Булгаков%" OR name_author LIKE "Достаевский%");

SELECT *
FROM supply;

