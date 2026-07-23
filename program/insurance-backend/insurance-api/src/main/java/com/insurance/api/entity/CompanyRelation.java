package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 公司间关联关系实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("company_relation")
public class CompanyRelation extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 主键ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /** 公司A ID */
    private Long companyId;

    /** 公司B ID */
    private Long relatedCompanyId;

    /** 关联类型：1=同一集团, 2=同一股东, 3=母子公司, 4=参股投资, 5=接管重组 */
    private Integer relationType;

    /** 关联名称/说明 */
    private String relationName;

    /** 持股比例（如果是参股） */
    private BigDecimal shareRatio;

    /** 关联说明 */
    private String description;
}
