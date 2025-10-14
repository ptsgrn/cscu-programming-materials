/**
 * Generates an Arithmetic-Progression-Free sequence for numbers from 0 to n
 * using the Divide and Conquer (Recursive) approach.
 * Time Complexity: O(N log N) where N = n + 1 (number of elements).
 * * @param n The maximum non-negative integer in the sequence (0 to n).
 * @returns The new AP-Free sequence as an array of numbers.
 */
function generateAPFreeSequence_DandC(n: number): number[] {
  // Base Case: ถ้า n เป็น 0 หรือ -1 (กรณีที่ n < 0) ให้คืนค่าลำดับ [0] หรือ []
  if (n < 0) {
    return [];
  }
  if (n === 0) {
    return [0];
  }

  // 1. Divide (กำหนดขอบเขตของปัญหาย่อย)
  // ขนาดของลำดับย่อยที่เป็นเลขคู่ (0, 2, 4, ...) คือ floor(n/2)
  const n_even = Math.floor(n / 2);
  // ขนาดของลำดับย่อยที่เป็นเลขคี่ (1, 3, 5, ...) คือ floor((n-1)/2)
  const n_odd = Math.floor((n - 1) / 2);

  // 2. Conquer (เรียกซ้ำ)
  // R_Even คือลำดับที่จัดเรียงของ {0, 1, ..., n_even}
  const R_Even_transformed = generateAPFreeSequence_DandC(n_even);
  // R_Odd คือลำดับที่จัดเรียงของ {0, 1, ..., n_odd}
  const R_Odd_transformed = generateAPFreeSequence_DandC(n_odd);

  // 3. Combine (ประกอบผลลัพธ์)

  // แปลง R_Even_transformed กลับให้เป็นตัวเลขคู่จริง (0, 2, 4, ...)
  const R_E = R_Even_transformed.map((y) => 2 * y);

  // แปลง R_Odd_transformed กลับให้เป็นตัวเลขคี่จริง (1, 3, 5, ...)
  const R_O = R_Odd_transformed.map((y) => 2 * y + 1);

  // รวม: ลำดับคู่ตามด้วยลำดับคี่
  return R_E.concat(R_O);
}

// ตัวอย่างการใช้งาน
const n_DandC = 5;
const sequence_DandC = generateAPFreeSequence_DandC(n_DandC);
console.log(`D&C (n=${n_DandC}): ${sequence_DandC.join(" ")}`); // Output: 0 4 2 1 5 3

const n_DandC_large = 100;
console.log(
  `D&C (n=${n_DandC_large}): ${generateAPFreeSequence_DandC(n_DandC_large).join(
    " "
  )}`
);
// Output: 0 8 4 2 6 10 1 9 5 3 7

/**
 * Generates an Arithmetic-Progression-Free sequence for numbers from 0 to n
 * using the Iterative approach, which simulates the D&C structure.
 * Time Complexity: O(N log N) where N = n + 1 (number of elements).
 * * @param n The maximum non-negative integer in the sequence (0 to n).
 * @returns The new AP-Free sequence as an array of numbers.
 */
function generateAPFreeSequence_Iterative(n: number): number[] {
  if (n < 0) {
    return [];
  }

  // 1. Initialization
  // Remaining_Numbers คือลำดับของตัวเลขที่ต้องนำไปจัดเรียงในรอบปัจจุบัน
  // โดยเริ่มต้นจาก 0, 1, 2, ..., n
  let remainingNumbers: number[] = Array.from({ length: n + 1 }, (_, i) => i);
  const resultSequence: number[] = [];

  // 2. Iteration (จำลองการแบ่งและรวม)
  while (remainingNumbers.length > 0) {
    // แยกกลุ่มที่ต้องจัดเรียงในรอบนี้ออกเป็นคู่และคี่
    const evenGroup: number[] = [];
    const oddGroup: number[] = [];

    for (const x of remainingNumbers) {
      if (x % 2 === 0) {
        evenGroup.push(x);
      } else {
        oddGroup.push(x);
      }
    }

    // Combine: นำกลุ่มคู่ตามด้วยกลุ่มคี่ไปต่อท้ายลำดับผลลัพธ์ (การจัดเรียงในรอบนี้)
    resultSequence.push(...evenGroup);
    resultSequence.push(...oddGroup);

    // Prepare for next iteration:
    // แปลงค่าเพื่อลดขนาดปัญหา (จำลองการเรียกซ้ำไปยังปัญหาย่อย)
    const nextNumbers: number[] = [];
    // ลำดับคู่ (0, 2, 4, ...) ถูกแปลงเป็น (0, 1, 2, ...)
    for (const x of evenGroup) {
      nextNumbers.push(x / 2);
    }
    // ลำดับคี่ (1, 3, 5, ...) ถูกแปลงเป็น (0, 1, 2, ...)
    for (const x of oddGroup) {
      nextNumbers.push((x - 1) / 2);
    }

    // อัปเดตลำดับที่เหลือสำหรับรอบถัดไป
    remainingNumbers = nextNumbers;
  }

  return resultSequence;
}

// ตัวอย่างการใช้งาน
const n_Iterative = 5;
const sequence_Iterative = generateAPFreeSequence_Iterative(n_Iterative);
console.log(`Iterative (n=${n_Iterative}): ${sequence_Iterative.join(" ")}`); // Output: 0 4 2 1 5 3

const n_Iterative_large = 10;
console.log(
  `Iterative (n=${n_Iterative_large}): ${generateAPFreeSequence_Iterative(
    n_Iterative_large
  ).join(" ")}`
);
// Output: 0 8 4 2 6 10 1 9 5 3 7
