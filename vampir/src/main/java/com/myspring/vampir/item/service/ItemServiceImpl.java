package com.myspring.vampir.item.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.vampir.item.dao.ItemDAO;

@Service("itemService")
@Transactional(propagation = Propagation.REQUIRED)
public class ItemServiceImpl implements ItemService {
	@Autowired
	private ItemDAO itemDAO;
	
	@Override
	public List listItems() throws DataAccessException {
		List itemsList = null;
		itemsList = itemDAO.selectAllItemList();
		return itemsList;
	}
	
}
