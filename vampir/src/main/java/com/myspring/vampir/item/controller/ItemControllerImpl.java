package com.myspring.vampir.item.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.item.service.ItemService;

@Controller // ("itemController") ���� ��õ
public class ItemControllerImpl implements ItemController {

    @Autowired
    private ItemService itemService;

    // ��Ʈ ���� �� ������� �����̷�Ʈ
    @RequestMapping(value = { "/", "/main.do" }, method = RequestMethod.GET)
    public ModelAndView main() {
        return new ModelAndView("redirect:/item/listItems.do");
    }

    @Override
    @RequestMapping(value = "/item/listItems.do", method = RequestMethod.GET)
    public ModelAndView listItems(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // �� ����(Map) ����Ʈ ȣ��
        List<Map<String, Object>> itemsList = itemService.listItemsUnified();

        System.out.println("[DEBUG] itemsList size = " + (itemsList == null ? "null" : itemsList.size()));

        // �� �ٷ� itemDB.jsp ���� (ViewResolver�� ���� ��� ����)
        ModelAndView mav = new ModelAndView("itemDB");
        mav.addObject("itemsList", itemsList);
        return mav;
    }

    // (����) ���� /itemDB.do ��������Ʈ�� ������� �����̷�Ʈ�ϰų� ���� ���� ����
    @RequestMapping(value = "/itemDB.do", method = RequestMethod.GET)
    public ModelAndView itemDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("redirect:/item/listItems.do");
    }
}
