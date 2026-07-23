package com.insurance.api.vip.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * VIP套餐列表VO
 */
@Data
public class VipPlanListVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 套餐列表 */
    private List<VipPlanVO> plans;

    /** 当前用户VIP状态 */
    private VipStatusVO currentStatus;
}
