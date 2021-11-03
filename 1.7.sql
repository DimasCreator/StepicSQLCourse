-- Практика


-- Создать таблицу fine следующей структуры:
Поле	        Описание
fine_id	        ключевой столбец целого типа с автоматическим увеличением значения ключа на 1
name	        строка длиной 30
number_plate	строка длиной 6
violation	    строка длиной 50
sum_fine	    вещественное число, максимальная длина 8, количество знаков после запятой 2
date_violation	дата
date_payment	дата

-- Добавить новые строки

INSERT INTO fine (name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES
    ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', NULL, '2020-02-14', NULL),
    ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', NULL, '2020-02-23', NULL),
    ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', NULL, '2020-03-03', NULL)

-- Для тех, кто уже оплатил штраф, вывести информацию о том, изменялась ли стандартная сумма штрафа.

SELECT  f.name, f.number_plate, f.violation,
        if(
            f.sum_fine = tv.sum_fine, "Стандартная сумма штрафа",
            if(
                f.sum_fine < tv.sum_fine, "Уменьшенная сумма штрафа", "Увеличенная сумма штрафа"
            )
        ) AS description
FROM  fine f, traffic_violation tv
WHERE tv.violation = f.violation and f.sum_fine IS NOT Null;

-- Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. 
-- При этом суммы заносить только в пустые поля столбца  sum_fine.

UPDATE fine AS f, traffic_violation AS tv
SET f.sum_fine = IF(f.sum_fine IS NULL,
    (SELECT sum_fine FROM traffic_violation WHERE violation = f.violation),
    f.sum_fine)
--Или
UPDATE fine AS f, traffic_violation AS tv
SET f.sum_fine = tv.sum_fine
WHERE f.sum_fine IS NULL AND f.violation = tv.violation

-- Группировка данных по нескольким столбцам
-- Например
SELECT name, number_plate, violation, count(*)
FROM fine
GROUP BY name, number_plate, violation;

-- Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило два и более раз. 
-- При этом учитывать все нарушения, независимо от того оплачены они или нет. 
-- Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.

SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(*) > 1
ORDER BY name, number_plate, violation 

-- В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей. 

UPDATE fine AS f, 
    (SELECT name, number_plate, violation
    FROM fine
    GROUP BY name, number_plate, violation
    HAVING COUNT(*) > 1 ) AS q
SET f.sum_fine = f.sum_fine * 2
WHERE f.date_payment IS NULL 
    AND f.name = q.name 
    AND f.number_plate = q.number_plate 
    AND f.violation = q.violation

-- в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
-- уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в таблицу payment) , 
-- если оплата произведена не позднее 20 дней со дня нарушения.

    payment_id	name	        number_plate	violation	                        date_violation	    date_payment
    1	        Яковлев Г.Р.	М701АА	        Превышение скорости(от 20 до 40)	2020-01-12	        2020-01-22
    2	        Баранов П.Е.	Р523ВТ	        Превышение скорости(от 40 до 60)	2020-02-14	        2020-03-06
    3	        Яковлев Г.Р.	Т330ТТ	        Проезд назапрещающий сигнал	        2020-03-03	        2020-03-23

UPDATE fine AS f, payment AS p
SET f.sum_fine = IF(DATEDIFF(p.date_payment, p.date_violation) <= 20, f.sum_fine / 2, f.sum_fine),
    f.date_payment = p.date_payment
WHERE f.date_payment IS NULL AND f.name = p.name AND f.number_plate = p.number_plate AND f.violation = p.violation


-- Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах 
-- (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.

CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL

-- Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года. 
DELETE FROM fine
WHERE YEAR(date_violation) <= 2020 AND MONTH(date_violation) < 2
-- ИЛИ
DELETE FROM fine
WHERE DATEDIFF("2020.02.01", date_violation) > 0;

