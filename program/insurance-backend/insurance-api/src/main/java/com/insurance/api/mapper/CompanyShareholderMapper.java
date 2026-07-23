package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.CompanyShareholder;
import org.apache.ibatis.annotations.Mapper;

/**
 * 公司-股东关联 Mapper接口
 */
@Mapper
public interface CompanyShareholderMapper extends BaseMapper<CompanyShareholder> {

}
