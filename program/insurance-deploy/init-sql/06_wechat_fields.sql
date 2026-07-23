-- ============================================================
-- 数据库初始化脚本 06：微信相关字段扩展
-- 为 user_info 表添加微信登录/绑定所需的额外字段
-- ============================================================

USE `tianbao_insurance`;

-- 检查并添加微信昵称字段
ALTER TABLE `user_info` ADD COLUMN IF NOT EXISTS `wechat_nickname` VARCHAR(128) DEFAULT NULL COMMENT '微信昵称' AFTER `wechat_unionid`;

-- 检查并添加微信头像字段
ALTER TABLE `user_info` ADD COLUMN IF NOT EXISTS `wechat_avatar` VARCHAR(512) DEFAULT NULL COMMENT '微信头像URL' AFTER `wechat_nickname`;

-- 检查并添加微信绑定状态字段
ALTER TABLE `user_info` ADD COLUMN IF NOT EXISTS `wechat_bound` TINYINT(1) DEFAULT 0 COMMENT '是否绑定微信 0-未绑定 1-已绑定' AFTER `wechat_avatar`;

-- 为 wechat_unionid 添加索引（用于跨应用用户关联）
ALTER TABLE `user_info` ADD INDEX IF NOT EXISTS `idx_wechat_unionid` (`wechat_unionid`);

-- 为 wechat_bound 添加索引（用于查询已绑定微信的用户）
ALTER TABLE `user_info` ADD INDEX IF NOT EXISTS `idx_wechat_bound` (`wechat_bound`);
