--ЗАПРОСЫ СОЗДАНИЯ И КОРРЕКТИРОВКИ ДАННЫХ
--Создать таблицу поставка (supply), которая имеет ту же структуру, что и таблиц book из прошлых модулей.
CREATE TABLE supply(
                       supply_id INT PRIMARY KEY AUTO_INCREMENT,
                       title VARCHAR(50),
                       author VARCHAR(30),
                       price DECIMAL(8,2),
                       amount INT
)

--Добавление новых элементов в таблицу
INSERT INTO supply (title, author, price, amount)
VALUES
    ('Лирика', 'Пастернак Б.Л.', 518.99, 2),
    ('Черный человек', 'Есенин С.А.', 570.20, 6),
    ('Белая гвардия', 'Булгаков М.А.', 540.50, 7),
    ('Идиот', 'Достоевский Ф.М.', 360.80, 3);

--Добавление в таблицу элементов из другой таблицы
--Добавить из таблицы supply в таблицу book, все книги, кроме книг, написанных Булгаковым М.А. и Достоевским Ф.М.
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN('Достоевский Ф.М.', 'Булгаков М.А.');

--Добавление записей с применением вложенных запросов
--Занести из таблицы supply в таблицу book только те книги, авторов которых нет в  book.
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN(
    SELECT author
    FROM book
);

--Запросы на обновление
--Уменьшить на 30% цену книг в таблице book.
UPDATE book
SET price = 0.7 * price;

--Уменьшить на 30% цену тех книг в таблице book, количество которых меньше 5.
UPDATE book
SET price = 0.7 * price
WHERE amount < 5;

--Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы.
UPDATE book
SET price = 0.9 * price
WHERE amount BETWEEN 5 AND 10;

--Запросы на обновление нескольких столбцов
-- В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, 
-- чтобы оно не превышало количество экземпляров книг, указанных в столбце amount. 
-- А цену тех книг, которые покупатель не заказывал, снизить на 10%.
UPDATE book
SET price = IF(buy = 0, 0.9 * price, price), 
    buy = IF(buy > amount, amount, buy);

-- Запросы на обновление нескольких таблиц 
-- В запросах на обновление можно использовать несколько таблиц, но тогда
---- для столбцов, имеющих одинаковые имена, необходимо указывать имя таблицы, к которой они относятся, например, book.price – столбец price из таблицы book, supply.price – столбец price из таблицы supply;
---- все таблицы, используемые в запросе, нужно перечислить после ключевого слова UPDATE;
---- в запросе обязательно условие WHERE, в котором указывается условие при котором обновляются данные.

-- Если в таблице supply  есть те же книги, что и в таблице book, добавлять эти книги в таблицу book не имеет смысла. 
-- Необходимо увеличить их количество на значение столбца amount таблицы supply.
UPDATE book, supply
SET book.amount = book.amount + supply.amount
WHERE book.title = supply.title AND book.author = supply.author;

-- Для тех книг в таблице book , которые есть в таблице supply, 
-- не только увеличить их количество в таблице book ( увеличить их количество на значение столбца amount таблицы supply), 
-- но и пересчитать их цену (для каждой книги найти сумму цен из таблиц book и supply и разделить на 2).
UPDATE book, supply
SET book.amount = book.amount + supply.amount, book.price = (book.price + supply.price) / 2
WHERE book.title = supply.title AND book.author = supply.author;

-- Запросы на удаление
-- Удалить все записи из таблицы supply
DELETE FROM supply;

-- Удалить из таблицы supply все книги, названия которых есть в таблице book.
DELETE FROM supply
WHERE title IN (
    SELECT title
    FROM book
);

-- Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.
DELETE FROM supply
WHERE author IN(
    SELECT author
    FROM book
    GROUP BY author
    HAVING SUM(amount) > 10
)

--Запросы на создание таблицы
-- Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше 4. 
-- Для всех книг указать одинаковое количество экземпляров 5.
CREATE TABLE ordering AS
SELECT author, title, 5 AS amount
FROM book
WHERE amount < 4;

-- Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше 4. 
-- Для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.
CREATE TABLE ordering AS
SELECT author, title,
       (
           SELECT ROUND(AVG(amount))
           FROM book
       ) AS amount
FROM book
WHERE amount < 4;

-- Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, 
-- количество экземпляров которых в таблице book меньше среднего количества экземпляров книг в таблице book. 
-- В таблицу включить столбец amount, в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.
CREATE TABLE ordering AS 
SELECT author, title, (
    SELECT FLOOR(AVG(amount))
    FROM book
    ) AS amount
FROM book
WHERE amount < (SELECT AVG(amount) FROM book)