package com.insurance.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.admin.entity.AdminRolePermission;
import org.apache.ibatis.annotations.Mapper;

/**
 * 角色权限关联 Mapper接口
 */
@Mapper
public interface AdminRolePermissionMapper extends BaseMapper<AdminRolePermission> {
}
