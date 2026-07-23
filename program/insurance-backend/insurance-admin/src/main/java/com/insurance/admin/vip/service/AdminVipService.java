package com.insurance.admin.vip.service;

import com.insurance.admin.vip.dto.AdminVipRecordQueryDTO;
import com.insurance.admin.vip.dto.AdminVipUserQueryDTO;
import com.insurance.admin.vip.vo.AdminVipRecordVO;
import com.insurance.admin.vip.vo.AdminVipUserVO;
import com.insurance.common.result.PageResult;

/**
 * 管理员VIP Service接口
 */
public interface AdminVipService {

    /**
     * 分页查询VIP用户列表
     *
     * @param queryDTO 查询参数
     * @return 分页结果
     */
    PageResult<AdminVipUserVO> listVipUsers(AdminVipUserQueryDTO queryDTO);

    /**
     * 分页查询VIP记录列表
     *
     * @param queryDTO 查询参数
     * @return 分页结果
     */
    PageResult<AdminVipRecordVO> listVipRecords(AdminVipRecordQueryDTO queryDTO);

    /**
     * 更新VIP用户状态
     *
     * @param id     用户ID
     * @param status 状态（0-禁用，1-正常）
     */
    void updateVipStatus(Long id, Integer status);

    /**
     * 延长VIP会员期限
     *
     * @param id   用户ID
     * @param days 延长天数
     */
    void extendVip(Long id, Integer days);
}
