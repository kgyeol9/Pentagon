package com.myspring.vampir.item.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

@Repository("itemDAO")
public class ItemDAOImpl implements ItemDAO {
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public List<Map<String,Object>> selectAllUnified() throws DataAccessException {
	    // (����) ����״� weapon ���ӽ����̽���
	    String curDb = sqlSession.selectOne("mapper.weapon.currentDatabase");
	    Integer w    = sqlSession.selectOne("mapper.weapon.countWeapon");
	    System.out.println("[DEBUG] DB=" + curDb + ", weaponDB count=" + w);

	    // ���� ���
	    return sqlSession.selectList("mapper.itemUnified.selectAllAsMap");
	}


}
