package com.mall.filter;

import javax.servlet.*;
import java.io.IOException;

/**
 * 字符编码过滤器，解决中文乱码问题
 */
public class CharacterEncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String enc = filterConfig.getInitParameter("encoding");
        if (enc != null && !enc.isEmpty()) {
            encoding = enc;
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding(encoding);
        response.setCharacterEncoding(encoding);
        response.setContentType("text/html;charset=" + encoding);
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
    }
}

