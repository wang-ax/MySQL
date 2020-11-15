package test;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ClassName Test
 * Description TODO
 * Author 30712
 * Date 2020-11-15
 * Time 10:59
 */
public class Test {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            // 加载JDBC驱动程序：反射，这样调用初始化com.mysql.jdbc.Driver类，即将该类加载到JVM方法区，并执行该类的静态方法块、静态属性。
            Class.forName("com.mysql.jdbc.Driver");
            // 创建数据库连接
             connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?user=root&password=123456&useUnicode=true&characterEncoding=UTF-8&useSSL=false");
            System.out.println(connection);
            //创建操作命令
             statement = connection.createStatement();
            //执行SQL语句
            String sql = "select id,name,role,salary from emp";
             resultSet = statement.executeQuery(sql);

            List<Emp> empList = new ArrayList<>();
            //处理结果集
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                String role = resultSet.getString("role");
                BigDecimal salary = resultSet.getBigDecimal("salary");
                System.out.printf("id=%s,name=%s,role=%s,salary=%s%n",id,name,role,salary);

                //面向对象的方式
                Emp emp = new Emp();
                //设置对象的值
                emp.setId(id);
                emp.setName(name);
                emp.setRole(role);
                emp.setSalary(salary);
                empList.add(emp);//将对象插入到list中
            }
            System.out.println(empList);//打印list（重写同toString方法）
        } catch (Exception e) {
            e.printStackTrace();//打印？？？
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

    /**
     * 封装一个内部类，属性为各个字段名
     * 对象属性不提供对外直接修改，一般采取getter、setter或者构造方法
     * getter（获取属性）、setter（设置属性）方法
     * 构造方法：默认是无参的，如果定义了之后，默认的就失效了
     */
    private static class Emp{
        private Integer id;
        private String name;
        private String role;
        private BigDecimal salary;

        @Override
        public String toString() {
            return "Emp{" +
                    "id=" + id +
                    ", name='" + name + '\'' +
                    ", role='" + role + '\'' +
                    ", salary=" + salary +
                    '}';
        }

        public Integer getId() {
            return id;
        }

        public void setId(Integer id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getRole() {
            return role;
        }

        public void setRole(String role) {
            this.role = role;
        }

        public BigDecimal getSalary() {
            return salary;
        }

        public void setSalary(BigDecimal salary) {
            this.salary = salary;
        }
    }
}
