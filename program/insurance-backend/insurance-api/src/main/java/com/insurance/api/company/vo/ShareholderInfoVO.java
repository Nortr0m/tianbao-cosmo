package com.insurance.api.company.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 公司股东信息VO
 */
@Data
public class ShareholderInfoVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 股东ID */
    private Long shareholderId;

    /** 股东名称 */
    private String shareholderName;

    /** 股东类型：1=企业法人, 2=自然人, 3=政府机构, 4=央企, 5=地方国资, 6=外资, 7=其他 */
    private Integer shareholderType;

    /** 股东类型描述 */
    private String shareholderTypeDesc;

    /** 国籍/注册地 */
    private String country;

    /** 是否实际控制人：0=否, 1=是 */
    private Integer isActualController;

    /** 是否国资背景：0=否, 1=是 */
    private Integer isStateOwned;

    /** 股东简介 */
    private String description;

    /** 持股比例（%） */
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
