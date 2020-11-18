package test3;

import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ClassName test3
 * Description TODO
 * Author 30712
 * Date 2020-11-18
 * Time 14:42
 */
public class Test2 {
    public static void main(String[] args) {
        List<Info> list = query("计算机");
        System.out.println(list);
    }
    //模拟文本框输入图书分类名称，查询信息
    //实现一个方法，参数为传入的班级的名称，返回类型是List<Info>
    public static List<Info> query(String name) {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            // 创建数据库连接
            //通过连接池的办法来进行数据库连接
            MysqlDataSource ds = new MysqlDataSource();
            ds.setUrl("jdbc:mysql://localhost:3306/ebook?user=root&password=123456&useUnicode=true&characterEncoding=UTF-8&useSSL=false");
            connection = ds.getConnection();
            System.out.println(connection);

            //创建操作命令
            //执行SQL语句
            String sql = " select book.name book_name,book.author,student.name student_name,borrow_info.start_time,borrow_info.end_time " +
                    "      from borrow_info " +
                    "      join  book on book.id = borrow_info.book_id " +
                    "      join category on book.category_id = category.id " +
                    "      join student on borrow_info.student_id = student.id " +
                    "      and category.name =?";

            //2.PreparedStatement 预编译的操作命令对象，使用String sql 作为传入参数
            //发送sql，让数据库进行预编译：语法分析、执行顺序分析，执行优化等
            statement = connection.prepareStatement(sql);//先进行预编译（语法分析）
            statement.setString(1,name);//替换占位符：指定占位符的位置（从1开始）,数据类型
            resultSet = statement.executeQuery();//预编译的操作命令对象PreparedStatement一定要使用无参的方法


            List<Info> list = new ArrayList<>();//使用list保存对象
            //处理结果集
            while (resultSet.next()) {
                String bookName = resultSet.getString("book_name");
                String bookAuthor = resultSet.getString("author");
                String studentName = resultSet.getString("student_name");
                Timestamp startTime = resultSet.getTimestamp("start_time");
                Timestamp endTime = resultSet.getTimestamp("end_time");


                System.out.printf("bookName = %s,bookAuthor = %s,studentName= %s,startTime = %s,endTime= %s%n",
                        bookName,bookAuthor,studentName,startTime,endTime);

                //使用Info类把对象进行封装
                Info info = new Info();
                info.setBookName(bookName);
                info.setBookAuthor(bookAuthor);
                info.setStudentName(studentName);
                info.setStartTime(startTime);
                info.setEndTime(endTime);
                list.add(info);
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            //执行某个功能，如果出现异常，再次抛出异常
            throw new RuntimeException("查询信息出错了",e);
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
        private String bookName;
        private String bookAuthor;
        private String studentName;
        private Timestamp startTime;
        private Timestamp endTime;

        @Override
        public String toString() {
            return "Info{" +
                    "bookName='" + bookName + '\'' +
                    ", bookAuthor='" + bookAuthor + '\'' +
                    ", studentName='" + studentName + '\'' +
                    ", startTime=" + startTime +
                    ", endTime=" + endTime +
                    '}';
        }

        public String getBookName() {
            return bookName;
        }

        public void setBookName(String bookName) {
            this.bookName = bookName;
        }

        public String getBookAuthor() {
            return bookAuthor;
        }

        public void setBookAuthor(String bookAuthor) {
            this.bookAuthor = bookAuthor;
        }

        public String getStudentName() {
            return studentName;
        }

        public void setStudentName(String studentName) {
            this.studentName = studentName;
        }

        public Timestamp getStartTime() {
            return startTime;
        }

        public void setStartTime(Timestamp startTime) {
            this.startTime = startTime;
        }

        public Timestamp getEndTime() {
            return endTime;
        }

        public void setEndTime(Timestamp endTime) {
            this.endTime = endTime;
        }
    }
}
