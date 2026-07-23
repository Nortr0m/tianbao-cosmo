package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.CompanyRelation;
import org.apache.ibatis.annotations.Mapper;

/**
 * 公司间关联关系 Mapper接口
 */
@Mapper
public interface CompanyRelationMapper extends BaseMapper<CompanyRelation> {

}
