-- Задание 1: Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с помощью которой можно 
-- переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
-- (использование транзакции с выбором commit или rollback – обязательно).


-- Создаём таблицу users_old, аналогичную таблице users:
CREATE TABLE users_old AS SELECT * FROM users WHERE 1=2;

-- Процедура для перемещения одного пользователя:
CREATE PROCEDURE move_user(IN p_user_id INT)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
START TRANSACTION;

-- Копируем выбранного пользователя из таблицы users в таблицу users_old:
INSERT INTO users_old (id, firstname, lastname, email)
SELECT id, firstname, lastname, email FROM users WHERE id = p_user_id;

-- Удаляем копии выбранного пользователя из таблицы users:
DELETE FROM users WHERE id = p_user_id;

COMMIT;
END;


-- Задание 2: Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать 
-- фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".


-- Создаём функцию hello() с типом возвращаемого значения VARCHAR(20):
CREATE FUNCTION hello()
RETURNS VARCHAR(20)

BEGIN
-- Переменной current_time присваивается текущее время:
    DECLARE current_time TIME;
    SET current_time = CURTIME();

-- С помощью конструкции IF-ELSEIF-ELSE проверяется текущее время:    
    IF current_time >= '06:00:00' AND current_time < '12:00:00'
THEN
    RETURN 'Доброе утро';
  ELSEIF current_time >= '12:00:00' AND current_time < '18:00:00'
THEN 
    RETURN 'Добрый день';
  ELSEIF current_time >= '18:00:00' AND current_time < '00:00:00'
THEN
    RETURN 'Добрый вечер';
  ELSE
    RETURN 'Доброй ночи';
  END IF;
END;

-- Для вызова функции используем следующую команду:
SELECT hello();

