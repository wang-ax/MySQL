package test3;


import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;
import java.sql.*;

/**
 * ClassName test3
 * Description TODO
 * Author 30712
 * Date 2020-11-18
 * Time 14:01
 */
public class Test {
    public static void main(String[] args) throws SQLException {
        PreparedStatement preparedStatement = null;
        Connection connection = null;
        try {
            //建立数据库连接
            MysqlDataSource ds = new MysqlDataSource();
            ds.setUrl("jdbc:mysql://localhost:3306/ebook?user=root&password=123456&useUnicode=true&characterEncoding=UTF-8&useSSL=false");
            connection = ds.getConnection();
            System.out.println(connection);

            //创建操作命令对象
            String sql = " insert into borrow_info(book_id, student_id, start_time, end_time) " +
                         "select  b.id,s.id,?,?  from  book b,student s where b.name= ? and s.name=?";
             preparedStatement = connection.prepareStatement(sql);//先进行预编译（语法分析）
            preparedStatement.setTimestamp(1, Timestamp.valueOf("2019-09-25 17:50:00"));
            preparedStatement.setTimestamp(2, Timestamp.valueOf("2019-10-25 17:50:00"));
            preparedStatement.setString(3,"诗经");//替换占位符：指定占位符的位置（从1开始）,数据类型
            preparedStatement.setString(4,"貂蝉");
            System.out.println(preparedStatement);

            int result = preparedStatement.executeUpdate();
            System.out.println(result);

        } catch (Exception e) {
            e.printStackTrace();
            //执行某个功能，如果出现异常，再次抛出异常
            throw new RuntimeException("插入数据错误了",e);
        } finally {
            try {
                if(preparedStatement != null)
                    preparedStatement.close();
                if(connection != null)
                    connection.close();
            }catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }
}
