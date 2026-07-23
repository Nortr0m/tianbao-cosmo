package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 公司-股东关联实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("company_shareholder")
public class CompanyShareholder extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 主键ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /** 保险公司ID */
    private Long companyId;

    /** 股东ID */
    private Long shareholderId;

    /** 持股比例（%），如60.0000表示60% */
    private BigDecimal shareRatio;

    /** 持股金额（万元） */
    private BigDecimal shareAmount;

    /** 股份类型：1=普通股, 2=优先股 */
    private Integer shareType;

    /** 是否控股股东：0=否, 1=是 */
    private Integer isControlling;

    /** 股东排名 */
    private Integer ranking;
}
