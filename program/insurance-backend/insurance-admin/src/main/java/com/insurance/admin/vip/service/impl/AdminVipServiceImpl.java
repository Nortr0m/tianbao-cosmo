package com.insurance.admin.vip.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insurance.admin.vip.dto.AdminVipRecordQueryDTO;
import com.insurance.admin.vip.dto.AdminVipUserQueryDTO;
import com.insurance.admin.vip.service.AdminVipService;
import com.insurance.admin.vip.vo.AdminVipRecordVO;
import com.insurance.admin.vip.vo.AdminVipUserVO;
import com.insurance.api.entity.UserInfo;
import com.insurance.api.entity.UserVipRecord;
import com.insurance.api.mapper.UserInfoMapper;
import com.insurance.api.mapper.UserVipRecordMapper;
import com.insurance.common.result.PageResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 管理员VIP Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AdminVipServiceImpl implements AdminVipService {

    private final UserInfoMapper userInfoMapper;
    private final UserVipRecordMapper userVipRecordMapper;

    @Override
    public PageResult<AdminVipUserVO> listVipUsers(AdminVipUserQueryDTO queryDTO) {
        Page<UserInfo> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<UserInfo> wrapper = new LambdaQueryWrapper<>();

        if (queryDTO.getUsername() != null && !queryDTO.getUsername().isEmpty()) {
            wrapper.like(UserInfo::getUsername, queryDTO.getUsername());
        }
        if (queryDTO.getMemberLevel() != null) {
            wrapper.eq(UserInfo::getMemberLevel, queryDTO.getMemberLevel());
        }
        if (queryDTO.getStatus() != null) {
            wrapper.eq(UserInfo::getStatus, queryDTO.getStatus());
        }
        wrapper.orderByDesc(UserInfo::getCreatedAt);

        Page<UserInfo> resultPage = userInfoMapper.selectPage(page, wrapper);
        List<AdminVipUserVO> list = resultPage.getRecords().stream()
                .map(this::convertUserToVO)
                .collect(Collectors.toList());
        return PageResult.of(resultPage.getCurrent(), resultPage.getSize(), resultPage.getTotal(), list);
    }

    @Override
    public PageResult<AdminVipRecordVO> listVipRecords(AdminVipRecordQueryDTO queryDTO) {
        Page<UserVipRecord> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<UserVipRecord> wrapper = new LambdaQueryWrapper<>();

        if (queryDTO.getUserId() != null) {
            wrapper.eq(UserVipRecord::getUserId, queryDTO.getUserId());
        }
        if (queryDTO.getMemberLevel() != null) {
            wrapper.eq(UserVipRecord::getMemberLevel, queryDTO.getMemberLevel());
        }
        if (queryDTO.getStatus() != null) {
            wrapper.eq(UserVipRecord::getStatus, queryDTO.getStatus());
        }
        wrapper.orderByDesc(UserVipRecord::getPurchaseTime);

        Page<UserVipRecord> resultPage = userVipRecordMapper.selectPage(page, wrapper);

        List<Long> userIds = resultPage.getRecords().stream()
                .map(UserVipRecord::getUserId)
                .distinct()
                .collect(Collectors.toList());
        Map<Long, String> usernameMap = userInfoMapper.selectBatchIds(userIds).stream()
                .collect(Collectors.toMap(UserInfo::getUserId, UserInfo::getUsername));

        List<AdminVipRecordVO> list = resultPage.getRecords().stream()
                .map(r -> convertRecordToVO(r, usernameMap.get(r.getUserId())))
                .collect(Collectors.toList());
        return PageResult.of(resultPage.getCurrent(), resultPage.getSize(), resultPage.getTotal(), list);
    }

    @Override
    public void updateVipStatus(Long id, Integer status) {
        UserInfo userInfo = userInfoMapper.selectById(id);
        if (userInfo != null) {
            userInfo.setStatus(status);
            userInfoMapper.updateById(userInfo);
            log.info("管理员更新VIP用户状态成功, userId={}, status={}", id, status);
        } else {
            log.warn("更新VIP用户状态失败, 用户不存在, userId={}", id);
            throw new RuntimeException("用户不存在");
        }
    }

    @Override
    public void extendVip(Long id, Integer days) {
        UserInfo userInfo = userInfoMapper.selectById(id);
        if (userInfo != null) {
            LocalDateTime expireTime = userInfo.getMemberExpireTime();
            if (expireTime == null || expireTime.isBefore(LocalDateTime.now())) {
                // 如果无过期时间或已过期，则从当前时间开始计算
                expireTime = LocalDateTime.now();
            }
            userInfo.setMemberExpireTime(expireTime.plusDays(days));
            userInfoMapper.updateById(userInfo);
            log.info("管理员延长VIP会员期限成功, userId={}, days={}, newExpireTime={}", id, days, userInfo.getMemberExpireTime());
        } else {
            log.warn("延长VIP会员期限失败, 用户不存在, userId={}", id);
            throw new RuntimeException("用户不存在");
        }
    }

    private AdminVipUserVO convertUserToVO(UserInfo user) {
        AdminVipUserVO vo = new AdminVipUserVO();
        BeanUtils.copyProperties(user, vo);
        switch (user.getMemberLevel() != null ? user.getMemberLevel() : 0) {
            case 1:
                vo.setMemberLevelDesc("VIP会员");
                break;
            case 2:
                vo.setMemberLevelDesc("SVIP会员");
                break;
            default:
                vo.setMemberLevelDesc("普通会员");
                break;
        }
        return vo;
    }

    private AdminVipRecordVO convertRecordToVO(UserVipRecord record, String username) {
        AdminVipRecordVO vo = new AdminVipRecordVO();
        BeanUtils.copyProperties(record, vo);
        vo.setUsername(username);
        switch (record.getMemberLevel() != null ? record.getMemberLevel() : 1) {
            case 1:
                vo.setMemberLevelDesc("VIP会员");
                break;
            case 2:
                vo.setMemberLevelDesc("SVIP会员");
                break;
            default:
                vo.setMemberLevelDesc("未知");
                break;
        }
        switch (record.getPayType() != null ? record.getPayType() : 0) {
            case 1:
                vo.setPayTypeDesc("微信支付");
                break;
            case 2:
                vo.setPayTypeDesc("支付宝");
                break;
            default:
                vo.setPayTypeDesc("未知");
                break;
        }
        switch (record.getStatus() != null ? record.getStatus() : 0) {
            case 0:
                vo.setStatusDesc("未支付");
                break;
            case 1:
                vo.setStatusDesc("已支付");
                break;
            case 2:
                vo.setStatusDesc("已退款");
                break;
            default:
                vo.setStatusDesc("未知");
                break;
        }
        return vo;
    }
}
