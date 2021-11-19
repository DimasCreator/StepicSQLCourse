--Связи между таблицами


--Создание таблицы с внешним ключом
CREATE TABLE book (
                      book_id INT PRIMARY KEY AUTO_INCREMENT,
                      title VARCHAR(50),
                      author_id INT NOT NULL,
                      price DECIMAL(8,2),
                      amount INT,
                      FOREIGN KEY (author_id)  REFERENCES author (author_id)
);

--Создание таблицы с двумя внешними ключами
CREATE TABLE book (
                      book_id INT PRIMARY KEY AUTO_INCREMENT,
                      title VARCHAR(50),
                      author_id INT NOT NULL,
                      genre_id INT,
                      price DECIMAL(8,2),
                      amount INT,
                      FOREIGN KEY (author_id)  REFERENCES author (author_id),
                      FOREIGN KEY (genre_id)  REFERENCES genre (genre_id)
);
--Теория
С помощью выражения ON DELETE можно установить действия, которые выполняются для записей подчиненной таблицы при удалении связанной строки из главной таблицы. При удалении можно установить следующие опции:

CASCADE: автоматически удаляет строки из зависимой таблицы при удалении  связанных строк в главной таблице.
SET NULL: при удалении  связанной строки из главной таблицы устанавливает для столбца внешнего ключа значение NULL. (В этом случае столбец внешнего ключа должен поддерживать установку NULL).
SET DEFAULT похоже на SET NULL за тем исключением, что значение  внешнего ключа устанавливается не в NULL, а в значение по умолчанию для данного столбца.
RESTRICT: отклоняет удаление строк в главной таблице при наличии связанных строк в зависимой таблице.
--Пример запроса
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2),
    amount INT,
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE SET NULL
);
-- При удалении автора из таблицы author удалится вся зависимая строка из таблицы book, 
-- а при удалении жанра из таблицы genre в genre_id у зависимых строк будет Null.

-- Добавление 3-х последних полей в таблицу
INSERT INTO book (title, author_id, genre_id, price, amount)
VALUES
    ('Стихотворения и поэмы', 3, 2, 650.00, 15),
    ('Черный человек', 3, 2, 570.20, 6),
    ('Лирика', 4, 2, 518.99, 2)

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
