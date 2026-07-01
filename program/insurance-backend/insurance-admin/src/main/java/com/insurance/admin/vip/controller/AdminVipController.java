package com.insurance.admin.vip.controller;

import com.insurance.admin.vip.dto.AdminVipExtendDTO;
import com.insurance.admin.vip.dto.AdminVipRecordQueryDTO;
import com.insurance.admin.vip.dto.AdminVipStatusUpdateDTO;
import com.insurance.admin.vip.dto.AdminVipUserQueryDTO;
import com.insurance.admin.vip.service.AdminVipService;
import com.insurance.admin.vip.vo.AdminVipRecordVO;
import com.insurance.admin.vip.vo.AdminVipUserVO;
import com.insurance.common.result.PageResult;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 管理员VIP Controller
 */
@RestController
@RequestMapping("/api/v1/admin/vip")
@RequiredArgsConstructor
public class AdminVipController {

    private final AdminVipService adminVipService;

    /**
     * 分页查询VIP用户列表
     */
    @GetMapping("/users")
    public Result<PageResult<AdminVipUserVO>> listVipUsers(@Validated AdminVipUserQueryDTO queryDTO) {
        return Result.success(adminVipService.listVipUsers(queryDTO));
    }

    /**
     * 分页查询VIP记录列表
     */
    @GetMapping("/records")
    public Result<PageResult<AdminVipRecordVO>> listVipRecords(@Validated AdminVipRecordQueryDTO queryDTO) {
        return Result.success(adminVipService.listVipRecords(queryDTO));
    }

    /**
     * 更新VIP用户状态
     */
    @PutMapping("/user/{id}/status")
    public Result<Void> updateVipStatus(@PathVariable Long id, @RequestBody @Validated AdminVipStatusUpdateDTO dto) {
        adminVipService.updateVipStatus(id, dto.getStatus());
        return Result.success();
    }

    /**
     * 延长VIP会员期限
     */
    @PutMapping("/user/{id}/extend")
    public Result<Void> extendVip(@PathVariable Long id, @RequestBody @Validated AdminVipExtendDTO dto) {
        adminVipService.extendVip(id, dto.getDays());
        return Result.success();
    }
}
