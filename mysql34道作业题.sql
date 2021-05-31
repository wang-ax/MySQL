 CREATE TABLE `emp` (
  `EMPNO` int(4) NOT NULL,
  `ENAME` varchar(10) DEFAULT NULL,
  `JOB` varchar(9) DEFAULT NULL,
  `MGR` int(4) DEFAULT NULL,
  `HIREDATE` date DEFAULT NULL,
  `SAL` double(7,2) DEFAULT NULL,
  `COMM` double(7,2) DEFAULT NULL,
  `DEPTNO` int(2) DEFAULT NULL,
  PRIMARY KEY (`EMPNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

 CREATE TABLE `dept` (
  `DEPTNO` int(2) NOT NULL,
  `DNAME` varchar(14) DEFAULT NULL,
  `LOC` varchar(13) DEFAULT NULL,
  PRIMARY KEY (`DEPTNO`)
);
 CREATE TABLE `salgrade` (
  `GRADE` int(11) DEFAULT NULL,
  `LOSAL` int(11) DEFAULT NULL,
  `HISAL` int(11) DEFAULT NULL
);
select * from dept;
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
+--------+------------+----------+
select * from emp;
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
+-------+--------+-----------+------+------------+---------+-----------------------

select * from salgrade;
+-------+-------+-------+
| GRADE | LOSAL | HISAL |
+-------+-------+-------+
|     1 |   700 |  1200 |
|     2 |  1201 |  1400 |
|     3 |  1401 |  2000 |
|     4 |  2001 |  3000 |
|     5 |  3001 |  9999 |
+-------+-------+-------+

-- 1.取得每个部门最高薪水的人员名称
-- 先取得每个部门最高的薪水
select deptno ,max(sal) as maxsal from emp group by deptno;
-- 将以上的结果作为临时表，和e表进行连接
select e.ename ,t.*
from (select deptno ,max(sal) as maxsal from emp group by deptno) t
join emp e
on t.deptno = e.deptno  and t.maxsal = e.sal;

-- 2.哪些人的薪水在部门的平均薪水之上
-- 先找到部门的平均薪水
select deptno ,avg(SAL) avgsal from emp group by deptno;
-- 将上面的查询结果和emp表再进行连接
select e.ENAME,e.sal,t.*
from emp e
join (select deptno ,avg(SAL) avgsal from emp group by deptno) t
on e.deptno = t.deptno
where e.sal > t.avgsal;

-- 3.取得部门中（所有人的）平均的薪水等级
-- 先找出每个人的薪水等级
select e.ENAME,e.SAL,e.deptno,s.GRADE
from emp e
join salgrade s
on e.sal between s.LOSAL and s.HISAL;
-- 再按照deptno进行分组，求grade的平均值
select e.deptno ,avg(s.GRADE)
from emp e
join salgrade s
on e.SAL between s.LOSAL and s.HISAL
group by e.deptno;

-- 4.不准用组函数（Max ），取得最高薪水
select e.ename,e.sal
from emp e
order by sal desc limit 1;

--5.取得平均薪水最高的部门的部门编号
-- 每个部门的平均薪水
select deptno , avg(sal)
from emp
group by deptno;
--
select d.DEPTNO,avg(e.sal) as avgsal
from emp e
join dept d
on e.deptno = d.DEPTNO
group by d.DEPTNO
order by avgsal desc limit 1;

-- 6.取得平均薪水最高的部门的部门名称
select
	d.dname,avg(e.sal) as avgsal
from
	emp e
join
	dept d
on
	e.deptno = d.deptno
group by
	d.dname
order by
	avgsal desc
limit
	1;

-- 7.求平均薪水的等级最低的部门的部门名称
-- 找出每一个部门的平均薪水
select deptno,avg(sal) as avgsal
from  emp
group by deptno;
-- 找出每个部门薪水对应的等级
select
	t.*,s.grade
from
	(select d.dname,avg(sal) as avgsal from emp e join dept d on e.deptno = d.deptno group by d.dname) t
join
	salgrade s
on
	t.avgsal between s.losal and s.hisal
where
    -- 等级最低的
    -- 平均薪水最低的对应的等级一定是最低的.
	s.grade =
	(select grade
	from salgrade
	where (select avg(sal) as avgsal from emp group by deptno order by avgsal asc limit 1) between losal and hisal);

--8.取得比普通员工(员工代码没有在 mgr 字段上出现的) 的最高薪水还要高的领导人姓名
-- 比普通员工的最高薪水还要高的一定是领导
-- 找出普通员工的最高薪水
 select max(SAL)
 from emp
 where  EMPNO not in (select distinct  MGR from emp where MGR is not null );

-- 找出高于上面查询出来的
 select ENAME,sal from emp where  sal >(select max(SAL)
 from emp
 where  EMPNO not in (select distinct  MGR from emp where MGR is not null ));


--9.取得薪水最高的前五名员工
select ENAME,SAL
from emp
order by SAL desc limit 5;
-- 10.取得薪水最高的第六到第十名员工
select ENAME,SAL
from emp
order by SAL desc limit 5,5;

-- 11.取得最后入职的 5 名员工，日期也可以降序，升序。
select ENAME,HIREDATE from emp order by HIREDATE desc limit 5;

-- 12.取得每个薪水等级有多少员工
select s.GRADE,count(*)
from emp e
join salgrade s
on e.SAL between  s.LOSAL and  s.HISAL
group by GRADE ;
-- 13.
-- 面试题：
-- 有 3 个表 S(学生表)，C（课程表），SC（学生选课表）
-- S（SNO，SNAME）代表（学号，姓名）
-- C（CNO，CNAME，CTEACHER）代表（课号，课名，教师）
-- SC（SNO，CNO，SCGRADE）代表（学号，课号，成绩）
-- 问题：
-- 1，找出没选过“黎明”老师的所有学生姓名。
-- 2，列出 2 门以上（含2 门）不及格学生姓名及平均成绩。
-- 3，即学过 1 号课程又学过 2 号课所有学生的姓名。



14.列出所有员工及领导的姓名
-- 左外连接
select a.ENAME as '员工',b.ENAME as '领导'
from emp a
left join emp b
on a.mgr = b.EMPNO;

15.列出受雇日期早于其直接上级的所有员工的编号,姓名,部门名称
select a.EMPNO,a.ENAME '员工',a.HIREDATE ,b.ENAME '领导' ,b.HIREDATE,d.dname
from  emp a
join emp b
on  a.MGR = b.EMPNO
join dept d
on a.deptno = d.deptno
where  a.HIREDATE < b.HIREDATE;

16. 列出部门名称和这些部门的员工信息, 同时列出那些没有员工的部门
select d.DNAME,e.*
from emp e
right join dept d
on  e.deptno = d.DEPTNO;

17.列出至少有 5 个员工的所有部门 按照部门编号分组,计数,筛选出 >= 5
select deptno
from emp
group by deptno
having count(*) >=5;

18.列出薪金比"SMITH" 多的所有员工信息
select *
from emp
where sal > (select SAL from emp where  ENAME = 'SMITH');

19. 列出所有"CLERK"( 办事员) 的姓名及其部门名称, 部门的人数
select e.ENAME,d.DNAME
from emp e
join dept d
on e.deptno = d.DEPTNO
where e.JOB ='CLERK';
-- 每个部门的人数
select count(*) deptcount from emp group by DEPTNO;
-- 将以上的两张表进行连接
select t1.*,t2.deptcount
from (select  e.ename,e.job,d.dname,d.deptno
from emp e
join dept d
on e.deptno = d.DEPTNO
where e.JOB ='CLERK') t1
join (select DEPTNO, count(*) deptcount from emp group by DEPTNO) t2
on t1.deptno = t2.deptno;

20.列出最低薪金大于 1500 的各种工作及从事此工作的全部雇员人数
select JOB,count(*)
from emp
group by JOB
having min(SAL) >1500;

21.列出在部门"SALES"< 销售部> 工作的员工的姓名, 假定不知道销售部的部门编号.
select deptno from dept where dname = 'SALES';

select ENAME
from emp
where  deptno = (select deptno from dept where dname = 'SALES');
22.列出薪金高于公司平均薪金的所有员工, 所在部门, 上级领导, 雇员的工资等级
--平均薪水
select  avg(sal) from emp ;

select e1.ENAME '员工',d.DNAME,e2.ENAME '领导',s.GRADE
from emp e1
join dept d
on  e1.deptno = d.DEPTNO
left join emp e2
on e1.MGR = e2.EMPNO
join salgrade s
on e1.SAL between  s.LOSAL and  s.HISAL
where  e1.sal > (select avg(SAL) from emp);

23. 列出与"SCOTT" 从事相同工作的所有员工及部门名称
--
select *
from emp
where  JOB = (select JOB from emp where  ENAME ='SCOTT');
----
select
	e.ename,e.job,d.dname
from
	emp e
join
	dept d
on
	e.deptno = d.deptno
where
	e.job = (select job from emp where ename = 'SCOTT')
and
	e.ename <> 'SCOTT';

24.列出薪金等于部门 30 中员工的薪金的其他员工的姓名和薪金.
select distinct sal from emp where deptno = 30;
---------------
select ENAME,SAL
from emp
where  SAL in (select distinct sal from emp where deptno = 30)
and deptno <> 30;

25.列出薪金高于在部门 30 工作的所有员工的薪金的员工姓名和薪金. 部门名称
select max(sal) from emp where deptno = 30;
+----------+
| max(sal) |
+----------+
|  2850.00 |
+----------+
select e.ENAME,e.SAL,d.DNAME
from emp e
join dept d
on e.deptno = d.DEPTNO
where  sal > (select max(sal) from emp where  DEPTNO = 30);
+-------+---------+------------+
| ENAME | SAL     | DNAME      |
+-------+---------+------------+
| JONES | 2975.00 | RESEARCH   |
| SCOTT | 3000.00 | RESEARCH   |
| KING  | 5000.00 | ACCOUNTING |
| FORD  | 3000.00 | RESEARCH   |
+-------+---------+------------+
26.列出在每个部门工作的员工数量, 平均工资和平均服务期限
/**
在mysql当中怎么计算两个日期的“年差”，差了多少年？
	TimeStampDiff(间隔类型, 前一个日期, 后一个日期)
	TimeStampDiff(YEAR, hiredate, now())
	间隔类型：
		SECOND   秒，
		MINUTE   分钟，
		HOUR   小时，
		DAY   天，
		WEEK   星期
		MONTH   月，
		QUARTER   季度，
		YEAR   年
 */
select d.deptno, count(e.ename) ecount,ifnull(avg(e.sal),0) as avgsal,ifnull(avg(timestampdiff(YEAR, hiredate, now())), 0) as avgservicetime
from emp e
right join dept d
on e.deptno = d.DEPTNO
group by d.DEPTNO;

27.列出所有员工的姓名,部门名称和工资.
select e.ename ,d.dname,e.sal
from emp e
join dept d
on e.deptno = d.deptno;

28.列出所有部门的详细信息和人数
select d.deptno,d.dname,d.loc,count(e.ename)
from emp e
right join dept d
on e.deptno =d.DEPTNO
group by d.DEPTNO;



29.列出各种工作的最低工资及从事此工作的雇员姓名

select
	e.ename,t.*
from
	emp e
join
	(select
		job,min(sal) as minsal
	from
		emp
	group by
		job) t
on
	e.job = t.job and e.sal = t.minsal;

30.列出各个部门的 MANAGER( 领导) 的最低薪金

select deptno,min(SAL)
from emp
where  JOB = 'MANAGER'
group  by deptno;

31.列出所有员工的 年工资, 按 年薪从低到高排序
select ENAME,(sal + ifnull(comm,0)) * 12 as yearsal
from emp
order by yearsal ;

32.求出员工领导的薪水超过3000的员工名称与领导
select 	a.ename '员工',b.ename '领导'
from emp a
join emp b
on a.mgr = b.empno
where b.sal > 3000;

33.求出部门名称中, 带'S'字符的部门员工的工资合计、部门人数
select d.deptno,d.dname,d.loc,count(e.ename),ifnull(sum(e.sal),0) as sumsal
from emp e
right join dept d
on e.deptno = d.DEPTNO
where  d.DNAME like '%S%'
group by d.deptno;

34.给任职日期超过 30 年的员工加薪 10%.
update emp set sal = sal * 1.1 where  timestampdiff(YEAR, hiredate, now()) > 30;
