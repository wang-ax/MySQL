package test3;

import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 * ClassName test3
 * Description TODO
 * Author 30712
 * Date 2020-11-18
 * Time 15:18
 */
public class Test3 {
    public static void main(String[] args) {
        PreparedStatement preparedStatement = null;
        Connection connection = null;
        try {
            //建立数据库连接
            MysqlDataSource ds = new MysqlDataSource();
            ds.setUrl("jdbc:mysql://localhost:3306/ebook?user=root&password=123456&useUnicode=true&characterEncoding=UTF-8&useSSL=false");
            connection = ds.getConnection();
            System.out.println(connection);

            //创建操作命令对象
            String sql = "update book set price = 61.20 where  book.name ='深入理解Java虚拟机'";
            preparedStatement = connection.prepareStatement(sql);//先进行预编译（语法分析）
            System.out.println(preparedStatement);

            int result = preparedStatement.executeUpdate();
            System.out.println(result);

        } catch (Exception e) {
            e.printStackTrace();
            //执行某个功能，如果出现异常，再次抛出异常
            throw new RuntimeException("更新数据出错了",e);
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
