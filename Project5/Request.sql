WITH third (Группа, Студент, Номера_Шагов)
    AS (
        SELECT "III", student_name, step_id
        FROM step_student
            INNER JOIN student USING(student_id)
        GROUP BY "III", student_name, step_id
        HAVING SUM(CASE result WHEN "correct" THEN 0 ELSE 1 END)=COUNT(CASE result WHEN "correct" THEN 0 ELSE 1 END)
        /*ORDER BY COUNT(step_id) DESC*/
    ),
    third_end (Группа, Студент, Количество_шагов)
    AS (
        SELECT Группа, Студент, COUNT(Номера_Шагов)
        FROM third
        GROUP BY Группа, Студент
    ),
    
    second (Группа, Студент, Номера_Шагов)
    AS (
        SELECT "II", student_name, step_id
        FROM step_student
            INNER JOIN student USING(student_id)
        GROUP BY "II", student_name, step_id
        HAVING SUM(CASE result WHEN "correct" THEN 1 ELSE 0 END)>1
        /*ORDER BY COUNT(step_id) DESC*/
    ),
    second_end (Группа, Студент, Количество_шагов)
    AS (
        SELECT Группа, Студент, COUNT(Номера_Шагов)
        FROM second
        GROUP BY Группа, Студент
        /*ORDER BY COUNT(Номера_Шагов)*/
    ),
    
    first (Группа, Студент, Номера_Шагов, Разница)
    AS (
        SELECT "I", student_name, step_id, LAG(CASE result WHEN "correct" THEN 1 ELSE 0 END) OVER (PARTITION BY student_name, step_id ORDER BY submission_time) - (CASE result WHEN "correct" THEN 1 ELSE 0 END) 
        FROM step_student
            INNER JOIN student USING(student_id)
        ORDER BY submission_time
        /*ORDER BY COUNT(step_id) DESC*/
    ),
    first_end (Группа, Студент, Количество_шагов)
    AS (
        SELECT Группа, Студент, COUNT(Номера_Шагов)
        FROM first
        WHERE Разница=1
        GROUP BY Группа, Студент
        
        /*ORDER BY COUNT(Номера_Шагов)*/
    )
SELECT * 
FROM first_end

UNION ALL

SELECT * 
FROM second_end

UNION ALL

SELECT * 
FROM third_end
ORDER BY Группа, Количество_шагов DESC, Студент;
