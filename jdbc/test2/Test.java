package test2;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ClassName Test
 * Description TODO
 * Author 30712
 * Date 2020-11-15
 * Time 15:02
 */
public class Test {
    public static void main(String[] args) {
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            // 加载JDBC驱动程序：反射，这样调用初始化com.mysql.jdbc.Driver类，即将该类加载到JVM方法区，并执行该类的静态方法块、静态属性。
            Class.forName("com.mysql.jdbc.Driver");
            // 创建数据库连接
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?user=root&password=123456&useUnicode=true&characterEncoding=UTF-8");
            System.out.println(connection);
            //创建操作命令
            statement = connection.createStatement();
            //执行SQL语句
            String sql = "select cla.name classes_name,stu.sn,stu.name student_name,stu.qq_mail,sco.score,cou.name course_name " +
                    " from student stu " +
                    " join  score sco on stu.id = sco.student_id " +
                    " join  course cou on  sco.course_id = cou.id " +
                    " join classes cla on  stu.classes_id = cla.id " +
                    " and cla.name = '计算机系2019级1班'";
            
            resultSet = statement.executeQuery(sql);

            List<Info>list = new ArrayList<>();//使用list保存对象
            //处理结果集
            while (resultSet.next()) {
                String className = resultSet.getString("classes_name");
                Integer sn = resultSet.getInt("sn");
                String studentName = resultSet.getString("student_name");
                String qqMail = resultSet.getString("qq_mail");
                String courseName = resultSet.getString("course_name");
                BigDecimal score = resultSet.getBigDecimal("score");
                System.out.printf("className = %s,sn = %s,studentName= %s,qqMail = %s,courseName= %s,score = %s",
                        className,sn,studentName,qqMail,courseName,score);
                System.out.println();
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
            System.out.println(list);
        } catch (Exception e) {
            e.printStackTrace();
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
