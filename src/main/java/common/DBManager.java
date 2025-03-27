package common;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

// conection pool로 부터 connection 객체를 가져온다
// Connection 객체를 생성, 전달
// ResultSet, PreparedStatement, Connection 객체 종료 close()
public class DBManager {

    public static Connection getConnection() {
        Connection con = null;
        try {
        	Context context = new InitialContext();
        	
        	DataSource ds = (DataSource) context.lookup("java:comp/env/jdbc/madang");
            con = ds.getConnection();
        }catch(Exception e) {
            e.printStackTrace();
        }
        
        return con;     
    }
    
    // (Ctrl + Shift + O) 자동 임포트
    // Connection Pool 로부터 얻는 Connection 객체의 close() 메소드는 overiding 되어 있다
    // Connection 을 끊지 않고 Connection Pool 에 반납되도록 
    // releaseConnection Variable Args  ... (개인적으로는 별로 for... 때문)
    public static void releaseConnection(PreparedStatement pstmt, Connection con) {
        try {
            if( pstmt != null ) pstmt.close();
            if( con != null ) con.close();
        }catch(SQLException e) {
            e.printStackTrace();
        }
    }
    
    public static void releaseConnection(ResultSet rs, PreparedStatement pstmt, Connection con) {
        try {
            if( rs != null ) rs.close();
            if( pstmt != null ) pstmt.close();
            if( con != null ) con.close();
        }catch(SQLException e) {
            e.printStackTrace();
        }
    }
}