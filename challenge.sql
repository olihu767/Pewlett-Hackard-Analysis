CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
  emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

DROP TABLE dept_emp

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY(dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no,dept_no)
);
DROP TABLE titles;

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no,from_date)
);

DROP TABLE retirement_info;

-- Retirement eligibility
SELECT emp_no,first_name, last_name
INTO retirement_info 
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT*FROM retirement_info;
SELECT*FROM departments;
SELECT*FROM employees;
SELECT*FROM dept_manager;
SELECT*FROM salaries;
SELECT*FROM dept_emp;
SELECT*FROM titles;

--COUNT Retirement emp_no
SELECT COUNT (emp_no)
FROM retirement_info ;

DROP TABLE current_emp; 
--Current employees
SELECT ri.emp_no, ri.first_name, ri.last_name,de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date=('9999-01-01');

SELECT*FROM current_emp
--Count # of current hired
SELECT COUNT (emp_no)
FROM current_emp

DROP TABLE title_retiring;
--Number of titles Retiring
SELECT ri.emp_no,
ri.first_name,
ri.last_name,
t.title,
t.from_date,
s.salary

INTO title_retiring
FROM retirement_info as ri
LEFT JOIN titles as t
ON ri.emp_no = t.emp_no
INNER JOIN salaries AS s
ON ri.emp_no = s.emp_no;
SELECT * FROM title_retiring;


--ONLY the Most Recent Title
SELECT count(*),title
INTO title_count
FROM title_retiring
GROUP BY title
HAVING count(*) >1
ORDER BY count DESC;

SELECT *FROM current_emp ;
SELECT*FROM employees;
DROP TABLE mentor;
-- WHo's Ready for a Mentor?
SELECT e.emp_no,
e.first_name,
e.last_name,
t.title,
t.from_date,
t.to_date
INTO mentor
FROM employees as e
LEFT JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (t.to_date = '9999-01-01');

SELECT*FROM mentor;
