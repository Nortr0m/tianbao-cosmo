package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.UserVipRecord;
import org.apache.ibatis.annotations.Mapper;

/**
 * VIP会员记录 Mapper接口
 */
@Mapper
public interface UserVipRecordMapper extends BaseMapper<UserVipRecord> {
}
