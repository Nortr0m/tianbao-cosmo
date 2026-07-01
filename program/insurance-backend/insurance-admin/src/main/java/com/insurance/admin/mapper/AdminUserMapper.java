package com.insurance.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.admin.entity.AdminUser;
import org.apache.ibatis.annotations.Mapper;

/**
 * 管理员 Mapper接口
 */
@Mapper
public interface AdminUserMapper extends BaseMapper<AdminUser> {
}
