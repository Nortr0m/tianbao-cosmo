package com.insurance.admin.card.controller;

import com.insurance.admin.card.dto.AdminCardTemplateCreateDTO;
import com.insurance.admin.card.dto.AdminCardTemplateQueryDTO;
import com.insurance.admin.card.dto.AdminCardTemplateStatusDTO;
import com.insurance.admin.card.dto.AdminCardTemplateUpdateDTO;
import com.insurance.admin.card.service.AdminCardTemplateService;
import com.insurance.admin.card.vo.AdminCardTemplateVO;
import com.insurance.admin.card.vo.CardTemplateStatsVO;
import com.insurance.common.result.PageResult;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * 管理员卡片模板Controller
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/admin/card-template")
@RequiredArgsConstructor
public class AdminCardTemplateController {

    private final AdminCardTemplateService adminCardTemplateService;

    /**
     * 分页查询卡片模板列表
     */
    @GetMapping("/list")
    public Result<PageResult<AdminCardTemplateVO>> listCardTemplates(@Validated AdminCardTemplateQueryDTO queryDTO) {
        return Result.success(adminCardTemplateService.listCardTemplates(queryDTO));
    }

    /**
     * 创建卡片模板
     */
    @PostMapping
    public Result<Long> createCardTemplate(@Validated @RequestBody AdminCardTemplateCreateDTO createDTO) {
        return Result.success(adminCardTemplateService.createCardTemplate(createDTO));
    }

    /**
     * 更新卡片模板
     */
    @PutMapping("/{templateId}")
    public Result<Void> updateCardTemplate(@PathVariable Long templateId,
                                            @RequestBody AdminCardTemplateUpdateDTO updateDTO) {
        adminCardTemplateService.updateCardTemplate(templateId, updateDTO);
        return Result.success();
    }

    /**
     * 删除卡片模板
     */
    @DeleteMapping("/{templateId}")
    public Result<Void> deleteCardTemplate(@PathVariable Long templateId) {
        adminCardTemplateService.deleteCardTemplate(templateId);
        return Result.success();
    }

    /**
     * 更新卡片模板状态
     */
    @PutMapping("/{templateId}/status")
    public Result<Void> updateCardTemplateStatus(@PathVariable Long templateId,
                                                  @RequestBody AdminCardTemplateStatusDTO statusDTO) {
        adminCardTemplateService.updateCardTemplateStatus(templateId, statusDTO.getIsActive());
        return Result.success();
    }

    /**
     * 上传卡片模板图片
     */
    @PostMapping("/upload")
    public Result<Map<String, String>> uploadImage(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return Result.fail("上传文件不能为空");
        }

        try {
            // 获取文件扩展名
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }

            // 生成唯一文件名
            String newFilename = UUID.randomUUID().toString() + extension;

            // 保存到静态资源目录
            String uploadDir = "static/card-bg";
            String projectDir = System.getProperty("user.dir");
            Path uploadPath = Paths.get(projectDir, uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            Path filePath = uploadPath.resolve(newFilename);
            Files.copy(file.getInputStream(), filePath);

            String url = "/card-bg/" + newFilename;

            Map<String, String> result = new HashMap<>();
            result.put("url", url);
            result.put("thumbnail", url);

            return Result.success(result);
        } catch (IOException e) {
            log.error("上传图片失败", e);
            return Result.fail("上传失败: " + e.getMessage());
        }
    }

    /**
     * 获取卡片模板统计
     */
    @GetMapping("/stats")
    public Result<CardTemplateStatsVO> getStats() {
        return Result.success(adminCardTemplateService.getStats());
    }
}