package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 股东实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("shareholder")
public class Shareholder extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 股东ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long shareholderId;

    /** 股东名称 */
    private String shareholderName;

    /** 股东类型：1=企业法人, 2=自然人, 3=政府机构, 4=央企, 5=地方国资, 6=外资, 7=其他 */
    private Integer shareholderType;

    /** 统一社会信用代码 */
    private String unifiedSocialCreditCode;

    /** 国籍/注册地 */
    private String country;

    /** 是否实际控制人：0=否, 1=是 */
    private Integer isActualController;

    /** 是否国资背景：0=否, 1=是 */
    private Integer isStateOwned;

    /** 股东简介 */
    private String description;

    /** 排序 */
    private Integer sortOrder;
}
