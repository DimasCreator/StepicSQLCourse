--- Работа с базой данных

--Структура БД - https://stepik.org/lesson/308891/step/5?unit=291017


--Вывести фамилии всех клиентов, которые заказали книгу Булгакова «Мастер и Маргарита».
SELECT DISTINCT name_client
FROM
    client
        INNER JOIN buy ON client.client_id = buy.client_id
        INNER JOIN buy_book ON buy_book.buy_id = buy.buy_id
        INNER JOIN book ON buy_book.book_id=book.book_id
WHERE title ='Мастер и Маргарита' and author_id = 1;

--Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал) 
-- в отсортированном по номеру заказа и названиям книг виде.

SELECT buy.buy_id, title, price, buy_book.amount
FROM client
         INNER JOIN buy ON buy.client_id = client.client_id
         INNER JOIN buy_book ON buy.buy_id = buy_book.buy_id
         INNER JOIN book ON buy_book.book_id = book.book_id
WHERE client.name_client = 'Баранов Павел'
ORDER BY buy.buy_id, title;

-- Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора 
-- (нужно посчитать, сколько раз была заказана каждая книга).  
-- Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество. 
-- Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
--COALESCE - заменит значение на чтото, в случае None
SELECT name_author, title, COALESCE(SUM(buy_book.amount), 0) AS Количество
FROM book
         INNER JOIN author ON book.author_id = author.author_id
         LEFT JOIN buy_book ON book.book_id = buy_book.book_id
GROUP BY book.book_id
ORDER BY name_author, title;

-- Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. 
-- Указать количество заказов в каждый город, этот столбец назвать Количество. 
-- Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.

SELECT name_city, COUNT(buy.buy_id) AS Количество
FROM city
         INNER JOIN client ON client.city_id = city.city_id
         INNER JOIN buy ON client.client_id = buy.client_id
GROUP BY name_city
ORDER BY Количество DESC, name_city;

-- Вывести номера всех оплаченных заказов и даты, когда они были оплачены.

SELECT buy_id, date_step_end FROM buy_step
WHERE step_id IN (SELECT step_id FROM step WHERE name_step = "Оплата") AND date_step_end IS NOT NULL

-- Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость 
-- (сумма произведений количества заказанных книг и их цены), в отсортированном по номеру заказа виде. 
-- Последний столбец назвать Стоимость.

SELECT buy.buy_id, name_client, SUM(book.price * buy_book.amount) AS Стоимость
FROM buy
         INNER JOIN client ON buy.client_id = client.client_id
         INNER JOIN buy_book ON buy.buy_id = buy_book.buy_id
         INNER JOIN book ON buy_book.book_id = book.book_id
GROUP BY buy.buy_id
ORDER BY buy.buy_id;