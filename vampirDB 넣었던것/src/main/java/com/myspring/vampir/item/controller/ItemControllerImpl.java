package com.myspring.vampir.item.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.item.service.ItemService;
import com.myspring.vampir.item.vo.ItemVO;

@Controller("ItemController")
public class ItemControllerImpl implements ItemController {

	@Autowired
	private ItemService itemService;
	@Autowired
	private ItemVO itemVO;

	@RequestMapping(value = { "/", "/main.do" }, method = RequestMethod.GET)
	public ModelAndView main() {
		return new ModelAndView("redirect:/item/listItems.do");
	}

	@Override
	@RequestMapping(value = "/item/listItems.do", method = RequestMethod.GET)
	public ModelAndView listItems(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List itemsList = itemService.listItems();
		
		System.out.println("[DEBUG] itemsList size = " + (itemsList == null ? "null" : itemsList.size()));
		
		ModelAndView mav = new ModelAndView("main"); // ← 여기 포인트
		mav.addObject("itemsList", itemsList);
		return mav;
	}
	
	@RequestMapping(value = "/itemDB.do" , method = RequestMethod.GET)
	public ModelAndView itemDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List itemsList = itemService.listItems();
		
		ModelAndView mav = new ModelAndView("itemDB");
		mav.addObject("itemsList" , itemsList);
		return mav;
	}
}
