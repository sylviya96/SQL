WITH t1 (Студент, Шаг, Результат, Время_попытки_юникс, Время_отправки, id)
    AS (
        SELECT student_name,
            CONCAT(module_id, ".", lesson_position, ".", step_position),
            result,
            IF((submission_time - attempt_time) > 3600, (
                SELECT ROUND(AVG(submission_time - attempt_time), 0)
                FROM step_student
                    INNER JOIN student USING(student_id)
                WHERE student_name = "student_59" AND (submission_time - attempt_time) <= 3600
                ), submission_time - attempt_time),
            submission_time,
            step_id
        FROM step_student
            INNER JOIN student USING(student_id)
            INNER JOIN step USING(step_id)
            INNER JOIN lesson USING(lesson_id)
        WHERE student_name = "student_59"
    )
SELECT Студент, Шаг,
    ROW_NUMBER() OVER (PARTITION BY Шаг ORDER BY Время_отправки) AS Номер_попытки,
    Результат,
    SEC_TO_TIME(Время_попытки_юникс) AS Время_попытки,
    ROUND(Время_попытки_юникс / SUM(Время_попытки_юникс) OVER (PARTITION BY Шаг) * 100, 2) AS Относительное_время
FROM t1
ORDER BY id, Номер_попытки;