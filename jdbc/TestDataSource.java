package test2;

import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ClassName TestDataSource
 * Description TODO
 * Author 30712
 * Date 2020-11-17
 * Time 16:53
 */
public class TestDataSource {
    public static void main(String[] args) {
        List<Info> list = query("中文系2019级3班");
        System.out.println(list);
    }
    //模拟文本框输入班级名称，查询信息
    //实现一个方法，参数为传入的班级的名称，返回类型是List<Info>
    public static List<Info> query(String name) {//传入某一个班级的名称就能够查询出该班级学生的成绩
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
    // 创建数据库连接
            // 1.加载JDBC驱动程序：反射，这样调用初始化com.mysql.jdbc.Driver类，即将该类加载到JVM方法区，并执行该类的静态方法块、静态属性。
            //Class.forName("com.mysql.jdbc.Driver");
            // connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?user=root&password=123456&useUnicode=true&characterEncoding=UTF-8&useSSL=false");

            //2.通过连接池的办法来进行数据库连接
            MysqlDataSource ds = new MysqlDataSource();
            ds.setUrl("jdbc:mysql://localhost:3306/test?user=root&password=123456&useUnicode=true&characterEncoding=UTF-8&useSSL=false");
            connection = ds.getConnection();
            System.out.println(connection);

    //创建操作命令
            //1.创建简单的操作命令对象statement
            //statement = connection.createStatement();
            //执行SQL语句
            String sql = "select cla.name classes_name,stu.sn,stu.name student_name,stu.qq_mail,sco.score,cou.name course_name " +
                    " from student stu " +
                    "  join  score sco on stu.id = sco.student_id " +
                    "  join  course cou on  sco.course_id = cou.id " +
                    "  join classes cla on  stu.classes_id = cla.id " +
                    "   and cla.name =?" ;//占位符，指定多个占位符：在执行sql的时候替换值
                   // "  and cla.name ='"+ name+ "'";

            //2.PreparedStatement 预编译的操作命令对象，使用String sql 作为传入参数
            //发送sql，让数据库进行预编译：语法分析、执行顺序分析，执行优化等
            statement = connection.prepareStatement(sql);//先进行预编译（语法分析）
            statement.setString(1,name);//替换占位符：指定占位符的位置（从1开始）,数据类型
            resultSet = statement.executeQuery();//预编译的操作命令对象PreparedStatement一定要使用无参的方法


            List<Info> list = new ArrayList<>();//使用list保存对象
    //处理结果集
            while (resultSet.next()) {
                String className = resultSet.getString("classes_name");
                Integer sn = resultSet.getInt("sn");
                String studentName = resultSet.getString("student_name");
                String qqMail = resultSet.getString("qq_mail");
                String courseName = resultSet.getString("course_name");
                BigDecimal score = resultSet.getBigDecimal("score");

                System.out.printf("className = %s,sn = %s,studentName= %s,qqMail = %s,courseName= %s,score = %s,%n",
                        className,sn,studentName,qqMail,courseName,score);

                //使用Info类把对象进行封装
                Info info = new Info();
                info.setClassesName(className);
                info.setSn(sn);
                info.setStudentName(studentName);
                info.setQqMail(qqMail);
                info.setCourseName(courseName);
                info.setScore(score);
                list.add(info);
            }
            //System.out.println(list);
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            //执行某个功能，如果出现异常，再次抛出异常
            throw new RuntimeException("查询班级信息出错了",e);//？？？？？
        } finally {
            try {
                if(resultSet != null)
                    resultSet.close();
                if(statement != null)
                    statement.close();
                if(connection != null)
                    connection.close();
            }catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }
    //创建一个Info类
    private static class Info{
        private String classesName;
        private  Integer sn;
        private String studentName;
        private String qqMail;
        private String courseName;
        private BigDecimal score;

        @Override
        public String toString() {
            return "Info{" +
                    "classesName='" + classesName + '\'' +
                    ", sn=" + sn +
                    ", studentName='" + studentName + '\'' +
                    ", qqMail='" + qqMail + '\'' +
                    ", courseName='" + courseName + '\'' +
                    ", score=" + score +
                    '}';
        }
        //使用getter、setter方法
        public String getClassesName() {
            return classesName;
        }

        public void setClassesName(String classesName) {
            this.classesName = classesName;
        }

        public Integer getSn() {
            return sn;
        }

        public void setSn(Integer sn) {
            this.sn = sn;
        }

        public String getStudentName() {
            return studentName;
        }

        public void setStudentName(String studentName) {
            this.studentName = studentName;
        }

        public String getQqMail() {
            return qqMail;
        }

        public void setQqMail(String qqMail) {
            this.qqMail = qqMail;
        }

        public String getCourseName() {
            return courseName;
        }

        public void setCourseName(String courseName) {
            this.courseName = courseName;
        }

        public BigDecimal getScore() {
            return score;
        }

        public void setScore(BigDecimal score) {
            this.score = score;
        }
    }
}
