package data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import javax.swing.text.AbstractDocument.Content;

public class BoardDAO {

		
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
		
		
		public void insertBoard(BoardBean bBean){ 
			
			int num = 0;
			
			try {
				con = getConnection();
				sql = "select max(num) from archive";
				pstmt = con.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()){
					num = rs.getInt(1)+1;
				}else{
					num += 1;
				}

				sql = "insert into archive"
						+ "(num,id,passwd,title,content,saveFile, "
						+ "originFile, count,date,ip) "
						+ "values(?,?,?,?,?,?,?,?,now(),?)";

				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, num);
				pstmt.setString(2, bBean.getId());
				pstmt.setString(3, bBean.getPasswd());
				pstmt.setString(4, bBean.getTitle());
				pstmt.setString(5, bBean.getContent());
				pstmt.setString(6, bBean.getSaveFile());
				pstmt.setString(7, bBean.getOriginFile());
				pstmt.setInt(8, 0); // 주글(새로 추가할 글)의 주회수 0
				pstmt.setString(9, bBean.getIp());
				
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
					sql = "select count(*) from archive";
					pstmt = con.prepareStatement(sql);
				}else{
					sql = "select count(*) from archive where title like ?";   
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, "%" + search + "%");
				}
				
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
		public List<BoardBean> getBoardList(String search, int startRow, int pageSize){

			List<BoardBean> boardList = new ArrayList<BoardBean>();
			
			try {
				// DB연결
				con = getConnection();
				// SQL문 만들기
				sql = "select * from archive where title like ? order by num desc limit ?,?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + search + "%");
				pstmt.setInt(2, startRow);
				pstmt.setInt(3, pageSize);
				rs = pstmt.executeQuery();
				
				
				while(rs.next()){

					BoardBean bBean = new BoardBean();

					bBean.setNum(rs.getInt("num"));
					bBean.setId(rs.getString("id"));
					bBean.setPasswd(rs.getString("passwd"));
					bBean.setTitle(rs.getString("title"));
					bBean.setContent(rs.getString("content"));
					bBean.setSaveFile(rs.getString("saveFile"));
					bBean.setOriginFile(rs.getString("originFile"));
					bBean.setCount(rs.getInt("count"));
					bBean.setDate(rs.getTimestamp("date"));
					bBean.setIp(rs.getString("ip"));
					// BoardBean 객체 => ArrayList배열에 추가
					boardList.add(bBean);
					
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
				sql = "update archive set count = count + 1 where num = ?";
				pstmt= con.prepareStatement(sql);
				pstmt.setInt(1, num);
				pstmt.executeUpdate();
			} catch (Exception e) {
				System.out.println("updateReadCount()메서드 내부에서 예외발생 : " + e.toString());
			} finally {
				resourceClose();
			}
		} // updateReadCount()
		
		public BoardBean getBoard(int num){
			BoardBean bBean = null;
			
			try {
				// DB연결
				con=getConnection();
				// SQL구문 만들기
				sql = "select * from archive where num=?";
				// PreparedStatement실행객체 얻기
				pstmt = con.prepareStatement(sql);
				// ?에 대응되는 글 num설정
				pstmt.setInt(1, num);
				// SELECT문 실행 후 조회한 결과 레코드 얻기
				rs = pstmt.executeQuery();

				rs.next();
				bBean = new BoardBean();
				
				bBean.setNum(rs.getInt("num"));
				bBean.setId(rs.getString("id"));
				bBean.setPasswd(rs.getString("passwd"));
				bBean.setTitle(rs.getString("title"));
				bBean.setContent(rs.getString("content"));
				bBean.setSaveFile(rs.getString("saveFile"));
				bBean.setOriginFile(rs.getString("originFile"));
				bBean.setCount(rs.getInt("count"));
				bBean.setDate(rs.getTimestamp("date"));
				bBean.setIp(rs.getString("ip"));
				
			} catch (Exception e) {
				System.out.println("getBoard()메서드 내부에서 예외발생 : " + e.toString());
			}finally {
				// 자원해제
				resourceClose();
			}
			
			
			
			return bBean;
		} // getBoard() 끝
		
		public int deleteBoard(int num, String passwd){
			
			int check = 0;
			
			try {
				con=getConnection();
				sql="select passwd from archive where num = ?";
				pstmt=con.prepareStatement(sql);
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					if(rs.getString("passwd").equals(passwd)){
						
						
						// SQL문 만들기 : 매개변수로 전달받은 글 번호에 해당하는 글을 삭제
						sql = "delete from archive where num=?";
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
		
		
} // class BoardDAO 끝
		
		











