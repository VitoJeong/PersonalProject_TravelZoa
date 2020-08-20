package reply;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ReplyDAO {

	Connection conn;
	PreparedStatement pstmt;
	ResultSet rs;

	private Connection getConnection() throws Exception {
		Context init = new InitialContext();
		DataSource ds = (DataSource) init.lookup("java:comp/env/jdbc/travelzoa");
		Connection conn = ds.getConnection();
		return conn;
	}

	private void freeResource() {
		try {
			if (conn != null)
				conn.close();
			if (pstmt != null)
				pstmt.close();
			if (rs != null)
				rs.close();
		} catch (SQLException e) {
			System.out.println("freeResource()메소드 내부에서 예외발생 : " + e.toString());
		}
	}

	public int insertReply(ReplyBean replyBean) {
		String sql = "";
		int num = 0;

		if(replyBean.getReplyContent()==null || replyBean.getReplyContent().equals("")) {
			return -1;
		}else {
			try {
				conn = getConnection();
				sql = "select max(replyNum) from reply";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
	
				if (rs.next()) {
					num = rs.getInt(1) + 1;
				} else {
					num = 1;
				}
	
				sql = "insert into reply(replyNum,boardNum,id,replyContent,replyDate)"
						+ "values(?,?,?,?,now())";
	
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				pstmt.setInt(2, replyBean.getBoardNum());
				pstmt.setString(3, replyBean.getId());
				pstmt.setString(4, replyBean.getReplyContent());
	
				return pstmt.executeUpdate();
	
			} catch (Exception e) {
				System.out.println("insertReply()메소드 내부에서 예외발생 : " + e.toString());
			} finally {
				freeResource();
			}
		}
		
		return 0; 
	}//insertReply

	public ReplyBean getLastReply() {
		String sql = "";
		int num = 0;
		
		try {
			conn = getConnection();
			sql = "select max(replyNum) from reply";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				num = rs.getInt(1);
			} else {
				num = 1;
			}
			
			sql = "select * from reply where replyNum = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);

			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				ReplyBean replyBean = new ReplyBean();
				replyBean.setReplyNum(rs.getInt("replyNum"));
				replyBean.setBoardNum(rs.getInt("boardNum"));
				replyBean.setId(rs.getString("id"));
				replyBean.setReplyContent(rs.getString("replyContent"));
				replyBean.setReplyDate(rs.getTimestamp("replyDate"));
				return replyBean;
			}

		} catch (Exception e) {
			System.out.println("ReplyBean()메소드 내부에서 예외발생 : " + e.toString());
		} finally {
			freeResource();
		}
		
		return null;
	}//ReplyBean

	public List<ReplyBean> getReplyList(int boardNum) {
				
		String sql = "";
		List<ReplyBean> replyList = new ArrayList<ReplyBean>();
		
		try {
			conn = getConnection();			
			sql = "select * from reply where boardNum=? order by replyNum";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardNum);			
			rs = pstmt.executeQuery();

			while (rs.next()) {
				ReplyBean replyBean = new ReplyBean();
				
				replyBean.setReplyNum(rs.getInt("replyNum"));
				replyBean.setBoardNum(rs.getInt("boardNum"));
				replyBean.setId(rs.getString("id"));
				replyBean.setReplyContent(rs.getString("replyContent"));
				replyBean.setReplyDate(rs.getTimestamp("replyDate"));

				replyList.add(replyBean);
			}

		} catch (Exception e) {
			System.out.println("getReplyList()메소드 내부에서 예외발생 : " + e.toString());
		} finally {
			freeResource();
		}

		return replyList;
	}//getReplyList

	public int deleteReply(int replyNum, String userId) {
		String sql = "select id from reply where replyNum=?";
		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, replyNum);
			rs = pstmt.executeQuery();
			if (rs.next()) {				
				if(userId.equals(rs.getString("id"))) {
					sql = "delete from reply where replyNum=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, replyNum);
					return pstmt.executeUpdate();
				}else {
					return -1;
				}
			}
		} catch (Exception e) {
			System.out.println("deleteReply()메소드 내부에서 예외발생 : " + e.toString());
		} finally {
			freeResource();
		}
		
		return 0;
	}//deleteReply

	public int getReplyCount(int boardNum) {
		
		String sql = "";
		int count = 0;

		try {

			conn = getConnection();			
	
			sql = "select count(*) from reply where boardNum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardNum);			
			rs = pstmt.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			System.out.println("getReplyCount()메소드 내부에서 예외발생 : " + e.toString());
		} finally {
			freeResource();
		}

		return count;
		
	}//getReplyCount
	
}//ReplyDAO
