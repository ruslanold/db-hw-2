-- 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT * FROM client WHERE LENGTH(firstname) < 6;

-- 2. +Вибрати львівські відділення банку.+
SELECT * FROM department WHERE DepartmentCity = 'Lviv';

-- 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT * FROM client WHERE education = 'high' ORDER BY firstname;


-- 4. +Виконати сортування у зворотньому порядку над таблицею Заявка 
-- і вивести 5 останніх елементів.
SELECT * FROM application ORDER BY idApplication DESC LIMIT 5;


-- 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
FROM client WHERE lastname LIKE '%o' or lastname LIKE '%a';

-- 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT * FROM client WHERE city = 'Kyiv';

-- 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
SELECT firstname f FROM client GROUP BY f;

-- 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
SELECT * FROM client AS c JOIN application AS a ON c.idClient = a.Client_idClient WHERE sum > 5000;

-- 9. +Порахувати кількість клієнтів усіх відділень 
SELECT COUNT(idclient), Department_idDepartment  FROM client GROUP BY Department_idDepartment;
-- та лише львівських відділень.
SELECT COUNT(idclient), departmentcity FROM client c JOIN department d ON c.Department_idDepartment = d.iddepartment WHERE departmentcity = 'Lviv';


-- 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT  Client_idClient, MAX(sum) FROM application GROUP BY Client_idClient;


-- 11. Визначити кількість заявок на крдеит для кожного клієнта.
SELECT  Client_idClient, COUNT(idapplication) FROM application GROUP BY Client_idClient;

-- 12. Визначити найбільший та найменший кредити.
SELECT MAX(sum), MIN(sum) FROM application;


-- 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
SELECT COUNT(Client_idClient) FROM application a JOIN client c ON a.Client_idClient = c.idclient WHERE education = 'high';

-- 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
SELECT AVG(sum) avgsum, client_idclient, firstname,lastname,education, passport, city, age, department_iddepartment 
FROM client c JOIN application a ON c.idClient = a.Client_idClient 
GROUP BY client_idclient 
ORDER BY avgsum DESC 
LIMIT 1;

-- 15. Вивести відділення, яке видало в кредити найбільше грошей
SELECT SUM(sum) avgsum, 
       department_iddepartment did, 
       departmentcity, 
       countofworkers, 
       currency FROM client c 
       JOIN application a ON c.idClient = a.Client_idClient 
       JOIN department d ON c.department_iddepartment = d.iddepartment  
GROUP BY did, currency 
ORDER BY avgsum DESC 
LIMIT 1;


-- 16. Вивести відділення, яке видало найбільший кредит.
SELECT MAX(sum) avgsum, 
       department_iddepartment did, 
       departmentcity, 
       countofworkers, 
       currency FROM client c 
       JOIN application a ON c.idClient = a.Client_idClient 
       JOIN department d ON c.department_iddepartment = d.iddepartment  
GROUP BY did, currency 
ORDER BY avgsum DESC 
LIMIT 1;


-- 17. Усім клієнтам, які мають вищу освіту, 
-- встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application SET sum = 6000  
WHERE client_idclient IN(SELECT idclient FROM client WHERE education = 'high');


-- 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client SET city = 'Kyiv' 
WHERE department_iddepartment IN(SELECT iddepartment FROM department WHERE departmentcity = 'Kyiv');


-- 19. Видалити усі кредити, які є повернені.
DELETE FROM application WHERE creditState = 'Returned';


-- 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
DELETE FROM application 
WHERE client_idclient 
IN( SELECT idclient FROM client 
    WHERE 
        firstname LIKE '_a%' OR 
        firstname LIKE '_e%' OR 
        firstname LIKE '_i%' OR 
        firstname LIKE '_o%' OR 
        firstname LIKE '_u%'
  );









-- Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT SUM(sum) avgsum, 
       department_iddepartment did, 
       departmentcity, 
       countofworkers 
       FROM client c 
       JOIN application a ON c.idClient = a.Client_idClient 
       JOIN department d ON c.department_iddepartment = d.iddepartment 
WHERE departmentcity = 'Lviv' 
GROUP BY did 
HAVING SUM(sum) > 5000  
ORDER BY avgsum DESC;

---------------without HAVING--------------------------
SELECT s.avgsum, s.did, s.city, s.countw FROM ( SELECT SUM(sum) avgsum, 
                                department_iddepartment did, 
                                departmentcity city, 
                                countofworkers countw 
                                FROM client c 
                                JOIN application a ON c.idClient = a.Client_idClient 
                                JOIN department d ON c.department_iddepartment = d.iddepartment 
                        WHERE departmentcity = 'Lviv' 
                        GROUP BY did ) s
WHERE avgsum > 5000;


















-- Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT * FROM (SELECT SUM(sum) su, 
                      idclient, 
                      firstname, 
                      lastname FROM client c 
                      JOIN application a ON c.idclient = a.client_idclient 
                      WHERE creditstate = 'Returned' 
                      GROUP BY idclient) s
WHERE s.su > 5000 ;




-- /* Знайти максимальний неповернений кредит.*/
SELECT MAX(sum) FROM application WHERE creditstate = 'Not returned'; 

                    



-- /*Знайти клієнта, сума кредиту якого найменша*/
SELECT MIN(sum) su, 
       idclient, 
       firstname, 
       lastname FROM client c 
       JOIN application a ON c.idclient = a.client_idclient
GROUP BY idclient
ORDER BY su
LIMIT 1;




-- /*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
SELECT sum FROM application
WHERE sum > (SELECT AVG(sum) from application);





-- /*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/

INSERT INTO client (idclient,FirstName, LastName, Education, Passport, city, Age, Department_idDepartment)
VALUES (11,'Ruslan', 'Ruslan', 'high', 'KC850245', 'Krasne', 25, 1);

SELECT idClient, FirstName, LastName, Education, Passport, city, Age, Department_idDepartment  FROM client
JOIN (SELECT COUNT(client_idclient) count, 
                     client_idclient id,
                     city ct
          FROM application a
          JOIN client c ON c.idclient = a.client_idclient
          GROUP BY client_idclient
          ORDER BY count DESC
          LIMIT 1
        ) u
WHERE city = u.ct AND idClient != u.id;




-- #місто чувака який набрав найбільше кредитів
SELECT u.city  FROM (SELECT COUNT(client_idclient) count, 
                     client_idclient id,
                     city
          FROM application a
          JOIN client c ON c.idclient = a.client_idclient
          GROUP BY client_idclient
          ORDER BY count DESC
          LIMIT 1
        ) u;

