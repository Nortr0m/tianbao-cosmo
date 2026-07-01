package com.insurance.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.admin.entity.AdminPermission;
import org.apache.ibatis.annotations.Mapper;

/**
 * 权限 Mapper接口
 */
@Mapper
public interface AdminPermissionMapper extends BaseMapper<AdminPermission> {
}
