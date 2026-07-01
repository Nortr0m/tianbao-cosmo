package com.insurance.admin.dashboard.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.insurance.admin.dashboard.service.DashboardService;
import com.insurance.admin.dashboard.vo.CardGenerationVO;
import com.insurance.admin.dashboard.vo.DashboardStatsVO;
import com.insurance.admin.dashboard.vo.ProductDistributionVO;
import com.insurance.admin.dashboard.vo.UserTrendVO;
import com.insurance.api.entity.*;
import com.insurance.api.mapper.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 数据看板Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class DashboardServiceImpl implements DashboardService {

    private final UserInfoMapper userInfoMapper;
    private final ProductBaseMapper productBaseMapper;
    private final InsuranceCompanyMapper insuranceCompanyMapper;
    private final CardTemplateMapper cardTemplateMapper;
    private final UserVipRecordMapper userVipRecordMapper;

    @Override
    public DashboardStatsVO getDashboardStats() {
        DashboardStatsVO vo = new DashboardStatsVO();

        // 用户统计
        vo.setTotalUserCount(userInfoMapper.selectCount(null));

        LambdaQueryWrapper<UserInfo> todayWrapper = new LambdaQueryWrapper<>();
        LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LocalDateTime todayEnd = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);
        todayWrapper.between(UserInfo::getCreatedAt, todayStart, todayEnd);
        vo.setTodayNewUserCount(userInfoMapper.selectCount(todayWrapper));

        LambdaQueryWrapper<UserInfo> vipWrapper = new LambdaQueryWrapper<>();
        vipWrapper.gt(UserInfo::getMemberLevel, 0);
        vo.setVipUserCount(userInfoMapper.selectCount(vipWrapper));

        // 产品统计
        vo.setTotalProductCount(productBaseMapper.selectCount(null));
        LambdaQueryWrapper<ProductBase> onSaleWrapper = new LambdaQueryWrapper<>();
        onSaleWrapper.eq(ProductBase::getSaleStatus, 1);
        vo.setOnSaleProductCount(productBaseMapper.selectCount(onSaleWrapper));

        // 保险公司统计
        vo.setTotalCompanyCount(insuranceCompanyMapper.selectCount(null));
        LambdaQueryWrapper<InsuranceCompany> cooperationWrapper = new LambdaQueryWrapper<>();
        cooperationWrapper.eq(InsuranceCompany::getCooperationStatus, 1);
        vo.setCooperationCompanyCount(insuranceCompanyMapper.selectCount(cooperationWrapper));

        // 卡片模板统计
        vo.setTotalCardTemplateCount(cardTemplateMapper.selectCount(null));
        long totalUseCount = cardTemplateMapper.selectList(null).stream()
                .mapToLong(t -> t.getUseCountTotal() != null ? t.getUseCountTotal() : 0)
                .sum();
        vo.setTotalCardUseCount(totalUseCount);

        // VIP订单统计
        LambdaQueryWrapper<UserVipRecord> paidWrapper = new LambdaQueryWrapper<>();
        paidWrapper.eq(UserVipRecord::getStatus, 1);
        vo.setTotalVipOrderCount(userVipRecordMapper.selectCount(paidWrapper));

        BigDecimal totalAmount = userVipRecordMapper.selectList(paidWrapper).stream()
                .map(r -> r.getPurchaseAmount() != null ? r.getPurchaseAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        vo.setTotalVipOrderAmount(totalAmount);

        return vo;
    }

    @Override
    public List<ProductDistributionVO> getProductDistribution() {
        List<ProductBase> products = productBaseMapper.selectList(null);
        Map<String, Long> typeCount = products.stream()
                .collect(Collectors.groupingBy(
                        p -> {
                            Integer type = p.getProductType();
                            if (type == null) return "其他";
                            return switch (type) {
                                case 1 -> "重疾险";
                                case 2 -> "增额终身寿险";
                                case 3 -> "年金险";
                                default -> "其他";
                            };
                        },
                        Collectors.counting()
                ));

        return typeCount.entrySet().stream()
                .map(e -> {
                    ProductDistributionVO vo = new ProductDistributionVO();
                    vo.setName(e.getKey());
                    vo.setValue(e.getValue());
                    return vo;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<UserTrendVO> getUserTrend(int days) {
        List<UserTrendVO> result = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM-dd");

        for (int i = days - 1; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusDays(i);
            LocalDateTime dayStart = LocalDateTime.of(date, LocalTime.MIN);
            LocalDateTime dayEnd = LocalDateTime.of(date, LocalTime.MAX);

            // 新增用户
            LambdaQueryWrapper<UserInfo> newWrapper = new LambdaQueryWrapper<>();
            newWrapper.between(UserInfo::getCreatedAt, dayStart, dayEnd);
            long newUsers = userInfoMapper.selectCount(newWrapper);

            // 活跃用户（简化：当天注册的用户视为活跃）
            long activeUsers = newUsers;

            // VIP用户（累计到该日期的VIP用户）
            LambdaQueryWrapper<UserInfo> vipWrapper = new LambdaQueryWrapper<>();
            vipWrapper.gt(UserInfo::getMemberLevel, 0);
            vipWrapper.le(UserInfo::getCreatedAt, dayEnd);
            long vipUsers = userInfoMapper.selectCount(vipWrapper);

            UserTrendVO vo = new UserTrendVO();
            vo.setDate(date.format(formatter));
            vo.setNewUsers(newUsers);
            vo.setActiveUsers(activeUsers);
            vo.setVipUsers(vipUsers);
            result.add(vo);
        }

        return result;
    }

    @Override
    public List<CardGenerationVO> getCardGenerationStats(int days) {
        List<CardGenerationVO> result = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM-dd");

        for (int i = days - 1; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusDays(i);

            // 简化实现：使用模板使用次数作为生成统计
            // 实际业务中应该有专门的卡片生成记录表
            CardGenerationVO vo = new CardGenerationVO();
            vo.setDate(date.format(formatter));
            vo.setCount(0L);
            vo.setType("all");
            result.add(vo);
        }

        return result;
    }
}
