package com.myspring.vampir.item.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.myspring.vampir.item.vo.ItemVO;

@Repository("itemDAO")
public class ItemDAOImpl implements ItemDAO {
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public List selectAllItemList() throws DataAccessException {
		List<ItemVO> itemsList = null;
		itemsList = sqlSession.selectList("mapper.item.selectAllitemList");
		return itemsList;
	}

}
