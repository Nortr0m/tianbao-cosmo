package com.insurance.api.vip.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.insurance.api.entity.UserInfo;
import com.insurance.api.entity.UserVipRecord;
import com.insurance.api.mapper.UserInfoMapper;
import com.insurance.api.mapper.UserVipRecordMapper;
import com.insurance.api.vip.dto.CreateOrderDTO;
import com.insurance.api.vip.service.VipService;
import com.insurance.api.vip.vo.OrderStatusVO;
import com.insurance.api.vip.vo.PaymentResultVO;
import com.insurance.api.vip.vo.VipPermissionVO;
import com.insurance.api.vip.vo.VipPlanListVO;
import com.insurance.api.vip.vo.VipPlanVO;
import com.insurance.api.vip.vo.VipStatusVO;
import com.insurance.common.exception.BusinessException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * VIP会员Service实现类
 * PRD v1.8.19: VIP=19.9元/30天, SVIP=29.9元/30天
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class VipServiceImpl implements VipService {

    private final UserInfoMapper userInfoMapper;
    private final UserVipRecordMapper userVipRecordMapper;

    /** VIP套餐价格：VIP=19.9元/30天 */
    private static final BigDecimal VIP_PRICE = new BigDecimal("19.90");
    /** SVIP套餐价格：SVIP=29.9元/30天 */
    private static final BigDecimal SVIP_PRICE = new BigDecimal("29.90");
    /** 订单过期时间（分钟） */
    private static final int ORDER_EXPIRE_MINUTES = 30;
    /** VIP有效天数 */
    private static final int VIP_DURATION_DAYS = 30;

    @Override
    public VipStatusVO getVipStatus(Long userId) {
        UserInfo user = userInfoMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        VipStatusVO vo = new VipStatusVO();
        vo.setUserId(userId);
        vo.setUsername(user.getUsername());
        vo.setMemberLevel(user.getMemberLevel());
        vo.setMemberExpireTime(user.getMemberExpireTime());

        boolean isVip = user.getMemberLevel() != null && user.getMemberLevel() > 0;
        vo.setIsVip(isVip);

        // 过期自动降级
        if (isVip && user.getMemberExpireTime() != null) {
            boolean expired = user.getMemberExpireTime().isBefore(LocalDateTime.now());
            vo.setIsExpired(expired);
            if (expired) {
                // 自动降级为普通会员
                user.setMemberLevel(0);
                user.setMemberExpireTime(null);
                userInfoMapper.updateById(user);
                vo.setMemberLevel(0);
                vo.setIsVip(false);
            }
        } else {
            vo.setIsExpired(false);
        }

        switch (vo.getMemberLevel() != null ? vo.getMemberLevel() : 0) {
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

    @Override
    public VipPermissionVO getVipPermissions(Long userId) {
        UserInfo user = userInfoMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        VipPermissionVO vo = new VipPermissionVO();
        vo.setUserId(userId);
        vo.setMemberLevel(user.getMemberLevel());

        List<String> permissions = new ArrayList<>();
        List<String> features = new ArrayList<>();

        int level = user.getMemberLevel() != null ? user.getMemberLevel() : 0;

        // 免费用户权限
        permissions.add("product:view");
        permissions.add("company:view");
        features.add("产品浏览");
        features.add("公司查询");
        features.add("对比产品（最多3款）");
        features.add("分红实现率（100%）");

        if (level >= 1) {
            // VIP权限
            permissions.add("compare:use");
            permissions.add("calculate:use");
            permissions.add("custom:column");
            permissions.add("background:template");
            features.add("产品对比（最多5款）");
            features.add("费率计算");
            features.add("利益演示");
            features.add("自定义列");
            features.add("背景模板库");
            features.add("自定义水印");
            features.add("分红实现率（全部5档）");
            features.add("4曲线分红对比图表");
        }
        if (level >= 2) {
            // SVIP权限
            permissions.add("advanced:report");
            permissions.add("data:export");
            permissions.add("personal:qrcode");
            features.add("产品对比（最多8款）");
            features.add("高级报告生成");
            features.add("数据导出");
            features.add("个人专属二维码");
            features.add("1对1顾问服务");
            features.add("优先体验新功能");
        }

        vo.setPermissions(permissions);
        vo.setFeatures(features);
        return vo;
    }

    @Override
    public VipPlanListVO getVipPlans(Long userId) {
        UserInfo user = userInfoMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // PRD v1.8.19: VIP=19.9元/30天, SVIP=29.9元/30天
        List<VipPlanVO> plans = new ArrayList<>();

        VipPlanVO plan1 = new VipPlanVO();
        plan1.setPlanId(1);
        plan1.setPlanName("VIP月度会员");
        plan1.setMemberLevel(1);
        plan1.setDurationMonths(1);
        plan1.setPrice(new BigDecimal("19.90"));
        plan1.setOriginalPrice(new BigDecimal("29.90"));
        plan1.setDescription("解锁产品对比、费率计算等核心功能");
        plan1.setFeatures("[\"产品对比（最多5款）\",\"费率计算\",\"利益演示\",\"自定义列\",\"背景模板库\",\"自定义水印\",\"全部分红率\",\"4曲线分红对比\"]");
        plan1.setIsRecommended(true);
        plan1.setSortOrder(1);
        plans.add(plan1);

        VipPlanVO plan2 = new VipPlanVO();
        plan2.setPlanId(2);
        plan2.setPlanName("SVIP月度会员");
        plan2.setMemberLevel(2);
        plan2.setDurationMonths(1);
        plan2.setPrice(new BigDecimal("29.90"));
        plan2.setOriginalPrice(new BigDecimal("49.90"));
        plan2.setDescription("全功能解锁，高级报告+数据导出+个人二维码");
        plan2.setFeatures("[\"VIP全部功能\",\"产品对比（最多8款）\",\"高级报告生成\",\"数据导出\",\"个人专属二维码\",\"1对1顾问服务\"]");
        plan2.setIsRecommended(false);
        plan2.setSortOrder(2);
        plans.add(plan2);

        VipPlanListVO result = new VipPlanListVO();
        result.setPlans(plans);
        result.setCurrentStatus(getVipStatus(userId));
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PaymentResultVO createOrder(Long userId, CreateOrderDTO dto) {
        // 校验用户
        UserInfo user = userInfoMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 校验套餐ID
        Integer planId = dto.getPlanId();
        if (planId == null || (planId != 1 && planId != 2)) {
            throw new BusinessException("无效的套餐ID，仅支持1(VIP)和2(SVIP)");
        }

        // 校验支付方式
        String paymentMethod = dto.getPaymentMethod();
        if (!"wechat".equalsIgnoreCase(paymentMethod) && !"alipay".equalsIgnoreCase(paymentMethod)) {
            throw new BusinessException("无效的支付方式，仅支持wechat和alipay");
        }

        // 确定套餐价格和等级
        BigDecimal amount;
        Integer memberLevel;
        Integer payType;
        if (planId == 1) {
            amount = VIP_PRICE;
            memberLevel = 1;
        } else {
            amount = SVIP_PRICE;
            memberLevel = 2;
        }
        payType = "wechat".equalsIgnoreCase(paymentMethod) ? 1 : 2;

        // 生成订单号：VIP + 时间戳 + 4位随机数
        String orderNo = generateOrderNo();

        // 创建订单记录
        UserVipRecord record = new UserVipRecord();
        record.setUserId(userId);
        record.setMemberLevel(memberLevel);
        record.setPurchaseAmount(amount);
        record.setOrderNo(orderNo);
        record.setPayType(payType);
        record.setStatus(0); // 0-未支付
        record.setPurchaseTime(LocalDateTime.now());
        record.setExpireTime(LocalDateTime.now().plusMinutes(ORDER_EXPIRE_MINUTES)); // 订单过期时间
        userVipRecordMapper.insert(record);

        log.info("创建VIP订单成功, userId={}, orderNo={}, planId={}, amount={}, payType={}",
                userId, orderNo, planId, amount, payType);

        // 构建返回结果
        PaymentResultVO vo = new PaymentResultVO();
        vo.setOrderId(record.getRecordId());
        vo.setOrderNo(orderNo);
        // 模拟支付URL（未接入真实支付）
        vo.setPaymentUrl("about:blank");
        vo.setStatus("pending");
        vo.setAmount(amount);
        vo.setExpireAt(LocalDateTime.now().plusMinutes(ORDER_EXPIRE_MINUTES));

        return vo;
    }

    @Override
    public OrderStatusVO getOrderStatus(Long orderId) {
        UserVipRecord record = userVipRecordMapper.selectById(orderId);
        if (record == null) {
            throw new BusinessException("订单不存在");
        }

        OrderStatusVO vo = new OrderStatusVO();
        vo.setOrderId(record.getRecordId());
        vo.setOrderNo(record.getOrderNo());
        vo.setStatus(convertStatus(record.getStatus()));
        vo.setPaidAt(record.getStatus() == 1 ? record.getPurchaseTime() : null);
        vo.setVipExpireAt(record.getStatus() == 1 ? record.getExpireTime() : null);

        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public OrderStatusVO mockPaySuccess(Long userId, Long orderId) {
        // 查询订单
        UserVipRecord record = userVipRecordMapper.selectById(orderId);
        if (record == null) {
            throw new BusinessException("订单不存在");
        }

        // 校验订单归属
        if (!record.getUserId().equals(userId)) {
            throw new BusinessException("无权操作此订单");
        }

        // 校验订单状态
        if (record.getStatus() != 0) {
            throw new BusinessException("订单状态异常，当前状态：" + convertStatus(record.getStatus()));
        }

        // 更新订单状态为已支付
        record.setStatus(1); // 1-已支付
        record.setPurchaseTime(LocalDateTime.now());
        LocalDateTime vipExpireAt = LocalDateTime.now().plusDays(VIP_DURATION_DAYS);
        record.setExpireTime(vipExpireAt);
        userVipRecordMapper.updateById(record);

        // 更新用户会员等级和过期时间
        UserInfo user = userInfoMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 如果用户当前VIP未过期，则在现有过期时间上延长
        LocalDateTime newExpireTime;
        if (user.getMemberLevel() != null && user.getMemberLevel() > 0
                && user.getMemberExpireTime() != null
                && user.getMemberExpireTime().isAfter(LocalDateTime.now())) {
            // SVIP续费SVIP或VIP续费VIP，在原过期时间上延长
            if (record.getMemberLevel() <= user.getMemberLevel()) {
                newExpireTime = user.getMemberExpireTime().plusDays(VIP_DURATION_DAYS);
            } else {
                // 升级（如VIP续费SVIP），取较晚的过期时间
                newExpireTime = LocalDateTime.now().plusDays(VIP_DURATION_DAYS);
            }
        } else {
            newExpireTime = vipExpireAt;
        }

        // 如果新购买的等级更高，则升级
        if (user.getMemberLevel() == null || record.getMemberLevel() > user.getMemberLevel()) {
            user.setMemberLevel(record.getMemberLevel());
        }
        user.setMemberExpireTime(newExpireTime);
        userInfoMapper.updateById(user);

        log.info("模拟支付成功, userId={}, orderId={}, orderNo={}, memberLevel={}, newExpireTime={}",
                userId, orderId, record.getOrderNo(), record.getMemberLevel(), newExpireTime);

        // 返回订单状态
        OrderStatusVO vo = new OrderStatusVO();
        vo.setOrderId(record.getRecordId());
        vo.setOrderNo(record.getOrderNo());
        vo.setStatus("paid");
        vo.setPaidAt(record.getPurchaseTime());
        vo.setVipExpireAt(newExpireTime);

        return vo;
    }

    /**
     * 生成订单号：VIP + yyyyMMddHHmmss + 4位随机数
     */
    private String generateOrderNo() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        String timestamp = LocalDateTime.now().format(formatter);
        Random random = new Random();
        int randomNum = random.nextInt(10000);
        return String.format("VIP%s%04d", timestamp, randomNum);
    }

    /**
     * 将数据库状态码转换为前端状态字符串
     *
     * @param status 数据库状态（0-未支付，1-已支付，2-已退款）
     * @return 前端状态字符串（pending/paid/cancelled/expired）
     */
    private String convertStatus(Integer status) {
        if (status == null) {
            return "pending";
        }
        switch (status) {
            case 0:
                return "pending";
            case 1:
                return "paid";
            case 2:
                return "cancelled";
            default:
                return "pending";
        }
    }
}
