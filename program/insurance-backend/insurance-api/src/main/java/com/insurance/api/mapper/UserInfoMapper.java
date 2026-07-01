package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.UserInfo;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户信息 Mapper接口
 */
@Mapper
public interface UserInfoMapper extends BaseMapper<UserInfo> {
}
