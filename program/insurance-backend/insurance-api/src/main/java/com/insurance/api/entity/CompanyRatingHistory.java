package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 评级历史实体
 */
@Data
@TableName("company_rating_history")
public class CompanyRatingHistory {

    private static final long serialVersionUID = 1L;

    /** 历史记录ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long historyId;

    /** 保险公司ID */
    private Long companyId;

    /** 评级季度（如：2024Q1） */
    private String ratingQuarter;

    /** 信用评级 */
    private String creditRating;

    /** 综合偿付能力充足率 */
    private BigDecimal solvencyRatio;

    /** 核心偿付能力充足率 */
    private BigDecimal coreSolvencyRatio;

    /** 净利润（万元） */
    private BigDecimal netProfit;

    /** 保费收入（万元） */
    private BigDecimal premiumIncome;

    /** 发布日期 */
    private LocalDate publishDate;

    /** 备注 */
    private String remark;
}
