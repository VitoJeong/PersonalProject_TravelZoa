package journal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import javax.swing.text.AbstractDocument.Content;

public class JournalDAO {

		
		// 전역변수 선언
		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		String sql ="";
		
		// 자원 해제 메서드
		public void resourceClose(){
			
			try{
				if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
				if(con != null) con.close();
			}catch(Exception e){
				System.out.println("자원해제 실패 : "+e);
			}
			
		} // resourceClose()

		private Connection getConnection() throws Exception{
			
			Connection con = null;
			Context init = new InitialContext();
			DataSource ds = (DataSource)init.lookup("java:comp/env/jdbc/travelzoa");
			con= ds.getConnection();
			
			return con;
					
		} // getConnection()
		
		
		public void insertBoard(JournalBean bBean){ 
			
			int num = 0;
			
			try {
				con = getConnection();
				sql = "select max(num) from journal";
				pstmt = con.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()){
					num = rs.getInt(1)+1;
				}else{
					num += 1;
				}

				sql = "insert into journal"
						+ "(num,id,passwd,title,content,file, "
						+ "count,date,ip) "
						+ "values(?,?,?,?,?,?,?,now(),?)";

				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, num);
				pstmt.setString(2, bBean.getId());
				pstmt.setString(3, bBean.getPasswd());
				pstmt.setString(4, bBean.getTitle());
				pstmt.setString(5, bBean.getContent());
				pstmt.setString(6, bBean.getFile());
				pstmt.setInt(7, 0); // 주글(새로 추가할 글)의 주회수 0
				pstmt.setString(8, bBean.getIp());
				
				pstmt.executeUpdate();
						
			} catch (Exception e) {
				System.out.println("insertBoard메서드 내부에서 예외 발생 : " + e); 
			}finally {
				resourceClose();
			}
			
		} // insertBoard() 끝
		
		
		public int getBoardCount(String search){

			int count=0;
			
			try {
				
				con = getConnection();
				if(search == null || search.equals("")) {
					sql = "select count(*) from journal";
					pstmt = con.prepareStatement(sql);
				}else{
					sql = "select count(*) from journal where title like ?";   
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, "%" + search + "%");
				}
				
				/*sql = "select count(*) from journal";*/
				/*pstmt = con.prepareStatement(sql);*/
				rs = pstmt.executeQuery(); // 전체 글 개수 조회후 반환
				
				if(rs.next()){
					count = rs.getInt(1);
				}
				
				
			} catch (Exception e) {
				System.out.println("getBoardCount()메서드 내부에서 예외발생 : " + e);
			} finally {
				// 자원해제
				resourceClose();
			}
			
			return count;
		} // getBoardCount
		
		// 글목록 검색해서 가져오는 메서드
		public List<JournalBean> getBoardList(String search, int startRow, int pageSize){

			List<JournalBean> boardList = new ArrayList<JournalBean>();
			
			try {
				// DB연결
				con = getConnection();
				// SQL문 만들기
				sql = "select * from journal where title like ? order by num desc limit ?,?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + search + "%");
				pstmt.setInt(2, startRow);
				pstmt.setInt(3, pageSize);
				rs = pstmt.executeQuery();
				
				
				while(rs.next()){

					JournalBean jBean = new JournalBean();

					jBean.setNum(rs.getInt("num"));
					jBean.setId(rs.getString("id"));
					jBean.setPasswd(rs.getString("passwd"));
					jBean.setTitle(rs.getString("title"));
					jBean.setContent(rs.getString("content"));
					jBean.setFile(rs.getString("file"));
					jBean.setCount(rs.getInt("count"));
					jBean.setDate(rs.getTimestamp("date"));
					jBean.setIp(rs.getString("ip"));
					// BoardBean 객체 => ArrayList배열에 추가
					boardList.add(jBean);
					
				}// while반복문 끝
				
				
			} catch (Exception e) {
				System.out.println("getBoardList()메서드 내부에서 예외발생 : " + e);
			} finally {
				resourceClose();
			}
			
			return boardList;
		} // getBoardList() 끝
		
		
		public void updateReadCount(int num){
			
			
			try {
				con = getConnection();
				sql = "update journal set count = count + 1 where num = ?";
				pstmt= con.prepareStatement(sql);
				pstmt.setInt(1, num);
				pstmt.executeUpdate();
			} catch (Exception e) {
				System.out.println("updateReadCount()메서드 내부에서 예외발생 : " + e.toString());
			} finally {
				resourceClose();
			}
		} // updateReadCount()
		
		public JournalBean getBoard(int num){
			JournalBean jBean = null;
			
			try {
				// DB연결
				con=getConnection();
				// SQL구문 만들기
				sql = "select * from journal where num=?";
				// PreparedStatement실행객체 얻기
				pstmt = con.prepareStatement(sql);
				// ?에 대응되는 글 num설정
				pstmt.setInt(1, num);
				// SELECT문 실행 후 조회한 결과 레코드 얻기
				rs = pstmt.executeQuery();

				rs.next();
				jBean = new JournalBean();
				
				jBean.setNum(rs.getInt("num"));
				jBean.setId(rs.getString("id"));
				jBean.setPasswd(rs.getString("passwd"));
				jBean.setTitle(rs.getString("title"));
				jBean.setContent(rs.getString("content"));
				jBean.setFile(rs.getString("file"));
				jBean.setCount(rs.getInt("count"));
				jBean.setDate(rs.getTimestamp("date"));
				jBean.setIp(rs.getString("ip"));
				
			} catch (Exception e) {
				System.out.println("getBoard()메서드 내부에서 예외발생 : " + e.toString());
			}finally {
				// 자원해제
				resourceClose();
			}
			
			
			
			return jBean;
		} // getBoard() 끝
		
		public int deleteBoard(int num, String passwd){
			
			int check = 0;
			
			try {
				con=getConnection();
				sql="select passwd from journal where num = ?";
				pstmt=con.prepareStatement(sql);
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					if(rs.getString("passwd").equals(passwd)){
						
						sql = "delete from reply where boardNum=?";
						pstmt = con.prepareStatement(sql);
						pstmt.setInt(1, num);
						pstmt.executeUpdate();
						
						// SQL문 만들기 : 매개변수로 전달받은 글 번호에 해당하는 글을 삭제
						sql = "delete from journal where num=?";
						pstmt = con.prepareStatement(sql);
						pstmt.setInt(1, num);
						check = pstmt.executeUpdate(); // delete실행
						
					}else{ // 사용자가 입력한 비밀번호와 DB에 저장된 비밀번호가 다르면
						check = -1;
					}
				}
			} catch (Exception e) {
				System.out.println("deleteBoard()메서드 내부에서 예외발생 : " + e);
			} finally {
				// 자원해제
				resourceClose();
			}
			
			return check;
			
		} // deleteBoard() 끝
		
		public int updateBoard(JournalBean jBean){
			int check = 0;
				
			int num = jBean.getNum();
			String title = jBean.getTitle();
			String content = jBean.getContent();
			String passwd = jBean.getPasswd();
			String file = jBean.getFile();
			System.out.println("pw입력" + passwd);
			System.out.println("글번호" + num);
			
			try {
				con=getConnection();
				sql = "select passwd from journal where num = ?";
				pstmt=con.prepareStatement(sql);
				pstmt.setInt(1, num);
				rs=pstmt.executeQuery();
				
				if(rs.next()){
					if(passwd.equals(rs.getString("passwd"))){
						check =1;
						
						sql ="update journal set title = ?, content = ? , file = ? "
								+ "where num=?";
						pstmt = con.prepareStatement(sql);
						pstmt.setString(1, title);
						pstmt.setString(2, content);
						pstmt.setString(3, file);
						pstmt.setInt(4, num);
						pstmt.executeUpdate();
					}else{
						check=0;
					}
				}
			} catch (Exception e) {
				System.out.println("updateBoard()메서드 내부에서 예외발생 : " + e);
			}finally {
				resourceClose();
			}
			
			return check;
		} // updateBoard() 끝

	
		
} // class JournalDAO 끝
		
		











