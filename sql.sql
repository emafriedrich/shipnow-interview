SELECT dep_id, COUNT(*) AS count_employees, SUM(salary)
FROM department INNER JOIN employee ON employee.dep_id = department.dep_id
GROUP BY department.dep_id;

-- Tested on http://sqlfiddle.com/#!15/bb853/2