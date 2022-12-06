WITH get_rate_lesson(mod_id, imya, rate) 
AS
(
   SELECT module_id, student_name, COUNT(DISTINCT step_id)
   FROM step_student INNER JOIN step USING (step_id)
                     INNER JOIN lesson USING (lesson_id)
                     INNER JOIN student USING (student_id)
   WHERE result = "correct"
   GROUP BY module_id, student_name
)
SELECT mod_id AS Модуль, imya AS Студент, rate AS Пройдено_шагов, 
    ROUND(rate / MAX(rate) OVER (PARTITION BY mod_id) * 100, 1) AS Относительный_рейтинг
FROM get_rate_lesson
ORDER BY Модуль, Относительный_рейтинг DESC, Студент;