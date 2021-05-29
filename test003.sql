select d.*
from emp e
right join dept d
on e.deptno = d.deptno
where e.empno is null;

select e.ename '员工' ,d.dname,s.grade,e1.ename '领导'
from emp e
join dept d
on e.deptno = d.deptno
join salgrade s
on e.sal between s.losal and s.hisal
left join emp e1
on e.mgr = e1.empno;

Enter password: *******
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 21
Server version: 5.7.31-log MySQL Community Server (GPL)

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| bjpowernode        |
| my_servlet_blog    |
| mysql              |
| performance_schema |
| servlet_blog       |
| sys                |
| test               |
+--------------------+
8 rows in set (0.00 sec)

mysql> use bjpowernode;
Database changed
mysql> -- 外连接
mysql> -- 每一个员工的领导
mysql> show tables;
+-----------------------+
| Tables_in_bjpowernode |
+-----------------------+
| dept                  |
| emp                   |
| salgrade              |
+-----------------------+
3 rows in set (0.00 sec)

mysql> desc emp;
+----------+-------------+------+-----+---------+-------+
| Field    | Type        | Null | Key | Default | Extra |
+----------+-------------+------+-----+---------+-------+
| EMPNO    | int(4)      | NO   | PRI | NULL    |       |
| ENAME    | varchar(10) | YES  |     | NULL    |       |
| JOB      | varchar(9)  | YES  |     | NULL    |       |
| MGR      | int(4)      | YES  |     | NULL    |       |
| HIREDATE | date        | YES  |     | NULL    |       |
| SAL      | double(7,2) | YES  |     | NULL    |       |
| COMM     | double(7,2) | YES  |     | NULL    |       |
| DEPTNO   | int(2)      | YES  |     | NULL    |       |
+----------+-------------+------+-----+---------+-------+
8 rows in set (0.03 sec)

mysql> select * from emp;
+-------+--------+-----------+------+------------+---------+---------+--------+
| EMPNO | ENAME  | JOB       | MGR  | HIREDATE   | SAL     | COMM    | DEPTNO |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7369 | SMITH  | CLERK     | 7902 | 1980-12-17 |  800.00 |    NULL |     20 |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1981-02-20 | 1600.00 |  300.00 |     30 |
|  7521 | WARD   | SALESMAN  | 7698 | 1981-02-22 | 1250.00 |  500.00 |     30 |
|  7566 | JONES  | MANAGER   | 7839 | 1981-04-02 | 2975.00 |    NULL |     20 |
|  7654 | MARTIN | SALESMAN  | 7698 | 1981-09-28 | 1250.00 | 1400.00 |     30 |
|  7698 | BLAKE  | MANAGER   | 7839 | 1981-05-01 | 2850.00 |    NULL |     30 |
|  7782 | CLARK  | MANAGER   | 7839 | 1981-06-09 | 2450.00 |    NULL |     10 |
|  7788 | SCOTT  | ANALYST   | 7566 | 1987-04-19 | 3000.00 |    NULL |     20 |
|  7839 | KING   | PRESIDENT | NULL | 1981-11-17 | 5000.00 |    NULL |     10 |
|  7844 | TURNER | SALESMAN  | 7698 | 1981-09-08 | 1500.00 |    0.00 |     30 |
|  7876 | ADAMS  | CLERK     | 7788 | 1987-05-23 | 1100.00 |    NULL |     20 |
|  7900 | JAMES  | CLERK     | 7698 | 1981-12-03 |  950.00 |    NULL |     30 |
|  7902 | FORD   | ANALYST   | 7566 | 1981-12-03 | 3000.00 |    NULL |     20 |
|  7934 | MILLER | CLERK     | 7782 | 1982-01-23 | 1300.00 |    NULL |     10 |
+-------+--------+-----------+------+------------+---------+---------+--------+
14 rows in set (0.00 sec)

mysql> select a.name '员工',b.name '领导' from emp a join emp b on a.mgr = b.empno;
ERROR 1054 (42S22): Unknown column 'a.name' in 'field list'
mysql> select a.ename '员工',b.ename '领导' from emp a join emp b on a.mgr = b.empno;
+--------+--------+
| 员工   | 领导   |
+--------+--------+
| SMITH  | FORD   |
| ALLEN  | BLAKE  |
| WARD   | BLAKE  |
| JONES  | KING   |
| MARTIN | BLAKE  |
| BLAKE  | KING   |
| CLARK  | KING   |
| SCOTT  | JONES  |
| TURNER | BLAKE  |
| ADAMS  | SCOTT  |
| JAMES  | BLAKE  |
| FORD   | JONES  |
| MILLER | CLARK  |
+--------+--------+
13 rows in set (0.00 sec)

mysql> select a.ename '员工',b.ename '领导' from emp a left  join emp b on a.mgr = b.empno;
+--------+--------+
| 员工   | 领导   |
+--------+--------+
| SMITH  | FORD   |
| ALLEN  | BLAKE  |
| WARD   | BLAKE  |
| JONES  | KING   |
| MARTIN | BLAKE  |
| BLAKE  | KING   |
| CLARK  | KING   |
| SCOTT  | JONES  |
| KING   | NULL   |
| TURNER | BLAKE  |
| ADAMS  | SCOTT  |
| JAMES  | BLAKE  |
| FORD   | JONES  |
| MILLER | CLARK  |
+--------+--------+
14 rows in set (0.00 sec)

mysql> select * frin dept;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'frin dept' at line 1
mysql> select * from dept;
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
+--------+------------+----------+
4 rows in set (0.01 sec)

mysql> select e.* ,d.*
    -> from emp e
    -> right join dept d
    -> on e.deptno = d.deptno
    -> where e.empno is null;
+-------+-------+------+------+----------+------+------+--------+--------+------------+--------+
| EMPNO | ENAME | JOB  | MGR  | HIREDATE | SAL  | COMM | DEPTNO | DEPTNO | DNAME      | LOC    |
+-------+-------+------+------+----------+------+------+--------+--------+------------+--------+
|  NULL | NULL  | NULL | NULL | NULL     | NULL | NULL |   NULL |     40 | OPERATIONS | BOSTON |
+-------+-------+------+------+----------+------+------+--------+--------+------------+--------+
1 row in set (0.01 sec)

mysql> select d.*
    -> from emp e
    -> right join dept d
    -> on e.deptno = d.deptno
    -> where e.empno is null;
+--------+------------+--------+
| DEPTNO | DNAME      | LOC    |
+--------+------------+--------+
|     40 | OPERATIONS | BOSTON |
+--------+------------+--------+
1 row in set (0.00 sec)

mysql> -- 查询每一个员工的部门名称和工资的等级
mysql> select e.ename,d.dname,s.grade
    -> from emp e
    -> join dept d
    -> on e.deptno = d.deptno
    -> join salgrade s
    -> on e.sal between s.losal and s.hisal;
+--------+------------+-------+
| ename  | dname      | grade |
+--------+------------+-------+
| SMITH  | RESEARCH   |     1 |
| ALLEN  | SALES      |     3 |
| WARD   | SALES      |     2 |
| JONES  | RESEARCH   |     4 |
| MARTIN | SALES      |     2 |
| BLAKE  | SALES      |     4 |
| CLARK  | ACCOUNTING |     4 |
| SCOTT  | RESEARCH   |     4 |
| KING   | ACCOUNTING |     5 |
| TURNER | SALES      |     3 |
| ADAMS  | RESEARCH   |     1 |
| JAMES  | SALES      |     1 |
| FORD   | RESEARCH   |     4 |
| MILLER | ACCOUNTING |     2 |
+--------+------------+-------+
14 rows in set (0.01 sec)

mysql> -- 查询每一个员工的部门名称和工资的等级和上级领导
mysql>
mysql> select e.ename,d.dname,s.grade
    ->     -> from emp e
    ->     -> join dept d
    ->     -> on e.deptno = d.deptno
    ->     -> join salgrade s
    ->     -> on s.sal between s.losal and s.hisal
    -> left join emp e1
    -> left join emp e1^C
mysql>
mysql>
mysql>
mysql> select e.ename '员工' ,d.dname,s.grade,e1.ename '领导'
    -> from emp e
    -> join dept d
    -> on e.deptno = d.deptno
    -> join salgrade s
    -> on s.sal between s.losal and hisal
    -> left join emp e1
    -> on e.mgr = e1.empno;
ERROR 1054 (42S22): Unknown column 's.sal' in 'on clause'
mysql> on e.mgr = e1.empno;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'on e.mgr = e1.empno' at line 1
mysql> select e.ename '员工' ,d.dname,s.grade,e1.ename '领导'
    ->     -> from emp e
    ->     -> join dept d
    ->     -> on e.deptno = d.deptno
    ->     -> join salgrade s
    -> on e.sal between s.losal and s.hisal
    ->  left join emp e1
    ->     -> on e.mgr = e1.empno;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '-> from emp e
    -> join dept d
    -> on e.deptno = d.deptno
    -> join salgr' at line 2
mysql>
mysql> select e.ename '员工' ,d.dname,s,grade,e1.ename '领导'
    -> from emp e
    -> join dept d
    -> on e.deptno = d.deptno
    -> join salgrade s
    -> on e.sal between s.losal and s.hisal
    -> left join emp e1
    -> on e.mgr = e1.empno;
ERROR 1054 (42S22): Unknown column 's' in 'field list'
mysql> select e.ename '员工' ,d.dname,s.grade,e1.ename '领导'
    -> from emp e
    -> join dept d
    -> on e.deptno = d.deptno
    -> join salgrade s
    -> on e.sal between s.losal and s.hisal
    -> left join emp e1
    -> on e.mgr = e1.empno;
+--------+------------+-------+--------+
| 员工   | dname      | grade | 领导   |
+--------+------------+-------+--------+
| SMITH  | RESEARCH   |     1 | FORD   |
| ADAMS  | RESEARCH   |     1 | SCOTT  |
| JAMES  | SALES      |     1 | BLAKE  |
| WARD   | SALES      |     2 | BLAKE  |
| MARTIN | SALES      |     2 | BLAKE  |
| MILLER | ACCOUNTING |     2 | CLARK  |
| ALLEN  | SALES      |     3 | BLAKE  |
| TURNER | SALES      |     3 | BLAKE  |
| JONES  | RESEARCH   |     4 | KING   |
| BLAKE  | SALES      |     4 | KING   |
| CLARK  | ACCOUNTING |     4 | KING   |
| SCOTT  | RESEARCH   |     4 | JONES  |
| FORD   | RESEARCH   |     4 | JONES  |
| KING   | ACCOUNTING |     5 | NULL   |
+--------+------------+-------+--------+
14 rows in set (0.00 sec)

;
-- 平均薪水的等级
select t.*,s.grade
from (select deptno ,avg(sal) as avgsal from emp group by deptno) t
join salgrade s
on t.avgsal between s.losal and s.hisal
order by deptno;

-- 每个部门平均的薪水等级
--先找出每一个员工的薪水等级
select e.ename ,e.sal ,e.deptno,s.grade
from emp e join salgrade s
on e.sal between s.losal and s.hisal;
--------+---------+--------+-------+
| ename  | sal     | deptno | grade |
+--------+---------+--------+-------+
| SMITH  |  800.00 |     20 |     1 |
| ALLEN  | 1600.00 |     30 |     3 |
| WARD   | 1250.00 |     30 |     2 |
| JONES  | 2975.00 |     20 |     4 |
| MARTIN | 1250.00 |     30 |     2 |
| BLAKE  | 2850.00 |     30 |     4 |
| CLARK  | 2450.00 |     10 |     4 |
| SCOTT  | 3000.00 |     20 |     4 |
| KING   | 5000.00 |     10 |     5 |
| TURNER | 1500.00 |     30 |     3 |
| ADAMS  | 1100.00 |     20 |     1 |
| JAMES  |  950.00 |     30 |     1 |
| FORD   | 3000.00 |     20 |     4 |
| MILLER | 1300.00 |     10 |     2 |
+--------+---------+--------+-------+
 -- 再按照部门编号进行分组，求grade的平均值
 -- 基于上面的结果，按照deptno分组，求grade的平均值
select e.deptno,avg(s.grade)
from emp e join salgrade s
on e.sal between s.losal and s.hisal
group by e.deptno;
+--------+--------------+
| deptno | avg(s.grade) |
+--------+--------------+
|     10 |       3.6667 |
|     20 |       2.8000 |
|     30 |       2.5000 |
+--------+--------------+


select e.ename,d.dname
from emp e
join dept d
on e.deptno = d.deptno ;

select e.ename ,(select d.dname from dept d where e.deptno = d.deptno) as dname
 from emp e;