package com.myspring.vampir.item.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

public interface ItemDAO {
	public List selectAllItemList() throws DataAccessException;
}
