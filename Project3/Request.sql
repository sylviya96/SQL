WITH max_time_all (Студент, Урок, Макс_время_отправки2) 
    AS
    (
       SELECT student_name, CONCAT(module_id, ".", lesson_position), MAX(submission_time)
       FROM step_student INNER JOIN step USING (step_id)
                         INNER JOIN lesson USING (lesson_id)
                         INNER JOIN student USING (student_id)
       WHERE result = "correct"
       GROUP BY student_name, CONCAT(module_id, ".", lesson_position)
    ),
    
    max_time_three (Студент)
    AS
    (
       SELECT Студент
       FROM max_time_all
       GROUP BY Студент
       HAVING COUNT(Урок) = 3
    )
   
SELECT Студент, Урок, FROM_UNIXTIME(Макс_время_отправки2) AS Макс_время_отправки,  
    IFNULL(CEIL((Макс_время_отправки2 - LAG(Макс_время_отправки2) OVER (PARTITION BY Студент ORDER BY Макс_время_отправки2)) / 86400), "-") AS Интервал
FROM max_time_all
    INNER JOIN max_time_three USING(Студент)
ORDER BY Студент, Макс_время_отправки;