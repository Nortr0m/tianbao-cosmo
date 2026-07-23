package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 疾病字典实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("disease")
public class Disease extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 疾病ID */
    @TableId(type = IdType.AUTO)
    private Long diseaseId;

    /** 疾病名称 */
    private String diseaseName;

    /** 疾病编码 */
    private String diseaseCode;

    /** 疾病类型：1=重疾, 2=中症, 3=轻症 */
    private Integer diseaseType;

    /** 疾病大类：恶性肿瘤、心脑血管、神经系统等 */
    private String diseaseCategory;

    /** ICD-10编码 */
    private String icdCode;

    /** 疾病定义/描述 */
    private String description;

    /** 赔付条件 */
    private String payoutCondition;

    /** 是否高发疾病：0=否, 1=是 */
    private Integer isHighIncidence;

    /** 是否法定疾病（银保监会规定）：0=否, 1=是 */
    private Integer isStatutory;

    /** 排序 */
    private Integer sortOrder;
}
