package com.insurance.framework.security;

import com.insurance.common.utils.JwtUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * JWT认证过滤器
 * 直接从JWT Token的claims中提取用户信息构建认证对象，
 * 不依赖UserDetailsService查询数据库。
 */
@Slf4j
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String token = getTokenFromRequest(request);

        if (StringUtils.hasText(token) && SecurityContextHolder.getContext().getAuthentication() == null) {
            try {
                if (JwtUtil.validateToken(token)) {
                    Long userId = JwtUtil.getUserId(token);
                    Object usernameObj = JwtUtil.getClaim(token, "username");
                    Object typeObj = JwtUtil.getClaim(token, "type");

                    String username = (usernameObj != null) ? usernameObj.toString() : String.valueOf(userId);
                    String type = (typeObj != null) ? typeObj.toString() : "user";

                    // 根据token类型构建权限列表
                    List<SimpleGrantedAuthority> authorities = new ArrayList<>();
                    if ("admin".equals(type)) {
                        authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
                        Object roleIdObj = JwtUtil.getClaim(token, "roleId");
                        if (roleIdObj != null) {
                            authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN_" + roleIdObj));
                        }
                    } else {
                        authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
                        Object memberLevelObj = JwtUtil.getClaim(token, "memberLevel");
                        if (memberLevelObj != null) {
                            int level = Integer.parseInt(memberLevelObj.toString());
                            if (level >= 2) {
                                authorities.add(new SimpleGrantedAuthority("ROLE_SVIP"));
                            } else if (level >= 1) {
                                authorities.add(new SimpleGrantedAuthority("ROLE_VIP"));
                            }
                        }
                    }

                    UserDetails userDetails = User.builder()
                            .username(username)
                            .password("")
                            .authorities(authorities)
                            .build();

                    UsernamePasswordAuthenticationToken authentication =
                            new UsernamePasswordAuthenticationToken(
                                    userDetails, null, userDetails.getAuthorities());
                    authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authentication);

                    // 将userId和type放入request属性，供Controller使用
                    request.setAttribute("userId", userId);
                    request.setAttribute("userType", type);
                }
            } catch (Exception e) {
                log.warn("JWT认证失败: {}", e.getMessage());
            }
        }

        filterChain.doFilter(request, response);
    }

    /**
     * 从请求中获取Token
     */
    private String getTokenFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
