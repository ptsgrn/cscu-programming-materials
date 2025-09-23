# ============================================================================
# การบ้านสถิติ: การแจกแจงของค่าเฉลี่ยตัวอย่างและทฤษฎีบทลิมิตสู่ส่วนกลาง
# ============================================================================

# รหัสนิสิต 10 หลัก: 6734446323
a1 <- 6; a2 <- 7; a3 <- 3; a4 <- 4; a5 <- 4
a6 <- 4; a7 <- 6; a8 <- 3; a9 <- 2; a10 <- 3

# พารามิเตอร์สำหรับแต่ละการแจกแจง
nb <- a4 + a5 + a6 + a7 + a8        # การแจกแจงทวินาม: n
p <- (a1 + a2 + a3 + 8*a8) / 100    # การแจกแจงทวินาม: p
mu <- (a4 * a5 + a9 + a10) / 2      # การแจกแจงปัวซง: μ
chi_v <- a4 + 4                      # การแจกแจงไคสแควร์: degrees of freedom
t_v <- a5 + 5                        # การแจกแจงที: degrees of freedom
f_v1 <- a6 + 6                       # การแจกแจงเอฟ: v1
f_v2 <- a7 + 7                       # การแจกแจงเอฟ: v2

cat("พารามิเตอร์ที่คำนวณได้:\n")
cat("การแจกแจงทวินาม: Bin(", nb, ",", p, ")\n")
cat("การแจกแจงปัวซง: Poi(", mu, ")\n")
cat("การแจกแจงไคสแควร์: χ²(", chi_v, ")\n")
cat("การแจกแจงที: t(", t_v, ")\n")
cat("การแจกแจงเอฟ: F(", f_v1, ",", f_v2, ")\n\n")

# ติดตั้งและโหลด packages ที่จำเป็น
install_if_needed <- function(package_name) {
  if (!require(package_name, character.only = TRUE)) {
    install.packages(package_name)
    library(package_name, character.only = TRUE)
  }
}

install_if_needed("ggplot2")
install_if_needed("gridExtra")
install_if_needed("reshape2")

# ตั้งค่าการสุ่มตัวอย่าง
sample_sizes <- c(5, 30, 100)  # ขนาดตัวอย่างต่างๆ อย่างน้อย 3 ค่า
n_simulations <- 1000          # จำนวนชุด 1000 ชุด

# ============================================================================
# ฟังก์ชันสำหรับการสร้างและแสดงผลการแจกแจงของค่าเฉลี่ยตัวอย่าง
# ============================================================================

analyze_sampling_distribution <- function(dist_name, sample_function, sample_sizes, n_simulations) {
  cat("=== ", dist_name, " ===\n")
  
  plots <- list()
  results <- data.frame()
  
  for (i in 1:length(sample_sizes)) {
    n <- sample_sizes[i]
    sample_means <- numeric(n_simulations)
    
    # สุ่มค่าเฉลี่ยตัวอย่าง 1000 ชุด
    for (j in 1:n_simulations) {
      samples <- sample_function(n)
      sample_means[j] <- mean(samples)
    }
    
    # คำนวณสถิติ
    mean_of_means <- mean(sample_means)
    sd_of_means <- sd(sample_means)
    
    # เก็บผลลัพธ์
    results <- rbind(results, data.frame(
      Distribution = dist_name,
      Sample_Size = n,
      Mean = round(mean_of_means, 4),
      SD = round(sd_of_means, 4)
    ))
    
    # สร้างฮิสโทแกรม
    df_plot <- data.frame(sample_means = sample_means)
    
    p <- ggplot(df_plot, aes(x = sample_means)) +
      geom_histogram(aes(y = after_stat(density)), bins = 30, 
                     fill = "lightblue", color = "black", alpha = 0.7) +
      geom_density(color = "red", linewidth = 1) +
      stat_function(fun = dnorm, 
                   args = list(mean = mean_of_means, sd = sd_of_means),
                   color = "blue", linewidth = 1, linetype = "dashed") +
      labs(title = paste(dist_name, "(n =", n, ")"),
           x = "ค่าเฉลี่ยตัวอย่าง",
           y = "ความหนาแน่น") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))
    
    plots[[i]] <- p
    
    cat("ขนาดตัวอย่าง n =", n, ": ค่าเฉลี่ย =", round(mean_of_means, 4), 
        ", ส่วนเบียงเบนมาตรฐาน =", round(sd_of_means, 4), "\n")
  }
  
  # แสดงกราห์ทั้ง 3 แบบเคียงข้างกัน
  grid.arrange(grobs = plots, ncol = 3, 
               top = paste("การแจกแจงของค่าเฉลี่ยตัวอย่าง:", dist_name))
  
  cat("\n")
  return(results)
}

# ============================================================================
# 1. การแจกแจงทวินาม Binomial Distribution
# ============================================================================
binomial_sampler <- function(n) rbinom(n, size = nb, prob = p)
binomial_results <- analyze_sampling_distribution("Binomial", binomial_sampler, sample_sizes, n_simulations)

# ============================================================================
# 2. การแจกแจงปัวซง Poisson Distribution  
# ============================================================================
poisson_sampler <- function(n) rpois(n, lambda = mu)
poisson_results <- analyze_sampling_distribution("Poisson", poisson_sampler, sample_sizes, n_simulations)

# ============================================================================
# 3. การแจกแจงไคสแควร์ Chi-square Distribution
# ============================================================================
chisq_sampler <- function(n) rchisq(n, df = chi_v)
chisq_results <- analyze_sampling_distribution("Chi-square", chisq_sampler, sample_sizes, n_simulations)

# ============================================================================
# 4. การแจกแจงที t-Distribution
# ============================================================================
t_sampler <- function(n) rt(n, df = t_v)
t_results <- analyze_sampling_distribution("t-Distribution", t_sampler, sample_sizes, n_simulations)

# ============================================================================
# 5. การแจกแจงเอฟ F-Distribution
# ============================================================================
f_sampler <- function(n) rf(n, df1 = f_v1, df2 = f_v2)
f_results <- analyze_sampling_distribution("F-Distribution", f_sampler, sample_sizes, n_simulations)

# ============================================================================
# รวมผลลัพธ์และสร้างตารางสรุป
# ============================================================================
all_results <- rbind(binomial_results, poisson_results, chisq_results, t_results, f_results)

cat("========================================================================\n")
cat("ตารางสรุปผลลัพธ์การทดลอง\n")
cat("========================================================================\n")
print(all_results)

# ============================================================================
# การทดสอบความเป็นการแจกแจงปกติ
# ============================================================================
cat("\n========================================================================\n")
cat("การทดสอบความเป็นการแจกแจงปกติด้วย Shapiro-Wilk Test\n")
cat("========================================================================\n")

test_normality <- function(dist_name, sample_function, sample_sizes, n_simulations) {
  cat("\n", dist_name, ":\n")
  
  for (n in sample_sizes) {
    sample_means <- numeric(n_simulations)
    
    for (j in 1:n_simulations) {
      samples <- sample_function(n)
      sample_means[j] <- mean(samples)
    }
    
    # ทดสอบ Shapiro-Wilk (ใช้ 500 observations เนื่องจากข้อจำกัดของ test)
    test_sample <- sample(sample_means, min(500, length(sample_means)))
    shapiro_result <- shapiro.test(test_sample)
    
    cat("n =", n, ": p-value =", format.pval(shapiro_result$p.value, digits = 4))
    
    if (shapiro_result$p.value > 0.05) {
      cat(" → ไม่ปฏิเสธ H0 (เป็นการแจกแจงปกติ)\n")
    } else {
      cat(" → ปฏิเสธ H0 (ไม่เป็นการแจกแจงปกติ)\n")
    }
  }
}

# ทดสอบทุกการแจกแจง
test_normality("Binomial", binomial_sampler, sample_sizes, n_simulations)
test_normality("Poisson", poisson_sampler, sample_sizes, n_simulations)
test_normality("Chi-square", chisq_sampler, sample_sizes, n_simulations)
test_normality("t-Distribution", t_sampler, sample_sizes, n_simulations)
test_normality("F-Distribution", f_sampler, sample_sizes, n_simulations)

# ============================================================================
# กราฟเปรียบเทียบทั้ง 5 การแจกแจง
# ============================================================================
cat("\n========================================================================\n")
cat("การเปรียบเทียบทั้ง 5 การแจกแจงในขนาดตัวอย่างเดียวกัน (n=30)\n")
cat("========================================================================\n")

# สร้างข้อมูลสำหรับการเปรียบเทียบ
set.seed(123)
comparison_data <- data.frame()

samplers <- list(
  "Binomial" = binomial_sampler,
  "Poisson" = poisson_sampler, 
  "Chi-square" = chisq_sampler,
  "t-Distribution" = t_sampler,
  "F-Distribution" = f_sampler
)

for (dist_name in names(samplers)) {
  sample_means <- numeric(n_simulations)
  
  for (j in 1:n_simulations) {
    samples <- samplers[[dist_name]](30)  # ใช้ n=30
    sample_means[j] <- mean(samples)
  }
  
  temp_data <- data.frame(
    means = sample_means,
    distribution = dist_name
  )
  comparison_data <- rbind(comparison_data, temp_data)
}

# สร้างกราฟเปรียบเทียบ
comparison_plot <- ggplot(comparison_data, aes(x = means, fill = distribution)) +
  geom_density(alpha = 0.6) +
  facet_wrap(~distribution, scales = "free", ncol = 3) +
  labs(title = "การเปรียบเทียบการแจกแจงของค่าเฉลี่ยตัวอย่าง (n=30)",
       x = "ค่าเฉลี่ยตัวอย่าง",
       y = "ความหนาแน่น") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5))

print(comparison_plot)

# ============================================================================
# สรุปผลการทดลองและทฤษฎีบทลิมิตสู่ส่วนกลาง
# ============================================================================
cat("\n", paste(rep("=", 80), collapse = ""), "\n")
cat("สรุปผลการทดลอง: ทฤษฎีบทลิมิตสู่ส่วนกลาง (Central Limit Theorem)\n")
cat(paste(rep("=", 80), collapse = ""), "\n")
cat("จากการทดลองข้างต้น สังเกตได้ว่า:\n\n")
cat("1. เมื่อขนาดตัวอย่าง (n) เพิ่มขึ้น การแจกแจงของค่าเฉลี่ยตัวอย่าง\n")
cat("   จะมีรูปร่างเข้าใกล้การแจกแจงปกติมากขึ้น\n\n")
cat("2. ความผันแปร (ส่วนเบียงเบนมาตรฐาน) ของการแจกแจงค่าเฉลี่ยตัวอย่าง\n")
cat("   จะลดลงเมื่อขนาดตัวอย่างเพิ่มขึ้น (ตามสูตร σ/√n)\n\n")
cat("3. ผลนี้เป็นจริงไม่ว่าการแจกแจงเดิม (population distribution)\n")
cat("   จะมีรูปร่างอย่างไรก็ตาม\n\n")
cat("4. สิ่งนี้สนับสนุนทฤษฎีบทลิมิตสู่ส่วนกลางที่ระบุว่า:\n")
cat("   การแจกแจงของค่าเฉลี่ยตัวอย่าง X̄ จะเข้าใกล้ N(μ, σ²/n) เมื่อ n → ∞\n\n")
cat("5. การทดสอบ Shapiro-Wilk แสดงให้เห็นว่าเมื่อ n เพิ่มขึ้น\n") 
cat("   p-value มักจะเพิ่มขึ้น ซึ่งบ่งชี้ว่าการแจกแจงเข้าใกล้ปกติมากขึ้น\n\n")
cat("*** การทำงานเสร็จสิ้น ***\n")
