#import "lib.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *


#show: qooklet.with(
  title: "Data Structures",
  author: "Saranya Maneeroj (ศรันญา มณีโรจน์)",
  header-cap: [2301260 Programming Techniques],
  footer-cap: [ศรันญา มณีโรจน์],
  outline-on: true,
  paper: "a4",
  lang: "th",
  par-leading: 2.5em,
  list-indent: 2.5em,
  block-above: 1.5em,
  block-below: 1.5em,
  // figure-break: false,
)

= อะไรคือโครงสร้างข้อมูล

โครงสร้างข้อมูล คือ การนำข้อมูลที่มีอยู่มาสร้างเป็นโครงสร้างตามนิยามที่ได้กำหนดขึ้น

== ขั้นตอนการสร้างโครงสร้างข้อมูล
1. สร้างนิยาม (Abstract Data Type หรือ ADT) ของแต่ละโครงสร้างข้อมูล
2. Implement ADT ที่นิยามขึ้น โดยการเขียนโปรแกรมด้วยภาษาคอมพิวเตอร์เช่น ภาษา C ภาษา Java ตามนิยาม (ADT) ที่ได้สร้างขึ้นจาก step 1
3. หลังจาก implement เสร็จจะได้ โครงสร้างข้อมูลตัวใหม่ ตามนิยาม (ADT) ที่ได้สร้างขึ้นจาก step 1

=== Abstract Data Type (ADT)

เป็นนิยามของแต่ละโครงสร้างข้อมูลซึ่งประกอบด้วย

1. เซตของข้อมูล
2. ความสัมพันธ์ของข้อมูล
3. กลุ่มของตัวกระทำ

ตัวอย่างของ Abstract Data Type เช่น ADT ของ Stack

1. เซตของข้อมูล เช่น ```java {3, 1, 7, 15, 29}```
2. ความสัมพันธ์ของข้อมูล: จัดเก็บข้อมูลโดยข้อมูลที่ใส่เข้ามาทีหลังจะถูกดึงออกไปใช้ก่อน
3. กลุ่มของตัวกระทำ
  + Push: ใส่ข้อมูลเข้า
  + Pop: ดึงข้อมูลออกมาใช้

โดยจะเริ่มต้นด้วย Abstract Data Type ง่าย ๆ 2 ตัว คือ Collection และ List

==== Collection ADT
1. เซตของข้อมูล เช่น ```java {3, 1, 7, 15, 29}```
2. ความสัมพันธ์ของข้อมูล: จัดเก็บข้อมูลเปรียบเสมือนถังของข้อมูลที่รองรับแค่เพิ่มและลบ
3. กลุ่มของตัวกระทำ
  - ```java add(Object O)```: เพิ่มข้อมูล O เข้าไปในถัง
  - ```java remove(Object O)```: ลบข้อมูล O ออกจากถัง
  - ```java contains(Object O)```: ถามว่าในถังมีข้อมูล O อยู่หรือไม่ ถ้ามีจะ return true ถ้าไม่มีจะ return false
  - ```java isEmpty()```: ถามว่าถังข้อมูลนี้ว่างอยู่หรือไม่ ถ้าว่างจะ return true ถ้าไม่ว่างจะ return false
  - ```java size()```: ตอบจำนวนข้อมูลที่อยู่ในถัง

==== List ADT
1. เซตของข้อมูล เช่น ```java {3, 1, 7, 15, 29}```
2. ความสัมพันธ์ของข้อมูล: จัดเก็บข้อมูลเปรียบเสมือนถังของข้อมูลที่รองรับการเพิ่มและลบอย่างมีลำดับการเข้าออกของข้อมูล คือมีตำแหน่งของข้อมูลว่าตัวไหนอยู่ก่อนข้อมูลตัวไหนตามลำดับการใส่เข้ามาในถัง
3. กลุ่มของตัวกระทำ ประกอบด้วย 5 ตัวที่มีอยู่ใน Collection ADT รวมทั้งอีก 4 ตัวดังนี้

  - ```java add(int i, Object O)```: เพิ่มข้อมูล O เข้าไปในถัง ณ ตำแหน่ง `i`
  - ```java remove(int i)```: ลบข้อมูล ณ ตำแหน่ง `i` ออกจากถัง
  - ```java get(int i)```: ดึงข้อมูล ณ ตำแหน่ง `i` ออกมาใช้โดยไม่ลบข้อมูลออกจากถัง
  - ```java set(int i, Object O)```: ทับข้อมูล ณ ตำแหน่ง `i` ด้วยข้อมูลตัวใหม่นั่นคือ O

== สร้างโครงสร้างข้อมูล

หลังจากมีนิยามของ Collection และ List จากนี้จะทำการ Implement นิยามเพื่อให้ได้โครงสร้างข้อมูล Collection และ List เนื่องจาก Array เป็นโครงสร้างข้อมูลพื้นฐาน เริ่มต้นจึงนำ Array มา Implement นิยามของ Collection และ List

Array เป็นโครงสร้างข้อมูลพื้นฐานที่สามารถเก็บข้อมูลเป็นกลุ่ม โดยที่มีคุณสมบัติดังนี้
1. ข้อมูลตัวติดกันอยู่ในช่องที่มี address ที่ติดกัน
2. ข้อมูลที่อยู่ใน Array ต้องเป็นข้อมูลชนิดเดียวกัน
3. เมื่อจอง Array แล้ว ไม่สามารถขยาย หรือ หด จำนวนช่องที่จองไว้แล้วได้

=== Collection implement โดย array
5 methods ใน interface ข้างล่างนี้แสดงถึงตัวกระทำ 5 ตัว ในนิยามของ Collection นั่นคือส่วนของ interface ```java Collection``` นี้ เปรียบเสมือน Abstract Data Type ของ Collection

```java
public interface Collection {
  public void add(Object e);
  public void remove(Object e);
  public boolean contains(Object e);
  public boolean isEmpty();
  public int size();
}
```

คลาส ```java ArrayCollection``` ข้างล่างนี้ได้ทำการ implement 5 methodsใน interface ข้างบนให้สมบูรณ์ เปรียบเสมือนคลาสนี้คือโครงสร้างข้อมูลใหม่ชื่อ Collection ที่สร้างขึ้นจากนิยามข้างบน

```java
public class ArrayCollection implements Collection {
  private Object[] data;
  private int size;

  public ArrayCollection() {
    data = new Object[1];
    size = 0;
  }

  public void add(Object e) {
    capacity(size+1); // กรณีที่ array เต็ม จะทำการการเสมือนขยายขนาดก่อน แล้วค่อย เพิ่มข้อมูลใหม่เข้าไป
    data[size] = e;
    size++;
  }

  public int size() {
    return size;
  }

  public boolean isEmpty() {
    return size == 0;
  }

  public boolean contains(Object e) {
    return indexOf(e) != -1;
  }

  // ในกรณีที่ remove ข้อมูลจาก array ที่ไม่เรียงลำดับ ให้เอาข้อมูลตัวสุดท้ายมาทับข้อมูลตัวที่ต้องการลบทิ้ง
  public void remove(object e) {
    int i = indexOf(e);
    // ถ้าไมพบข้อมูล e ที่ต้องการลบ ก็จะไม่ทำ การ remove
    if(i != -1) {
      //เอาข้อมูลตัวสุดท้ายมาทับข้อมูลตัวที่ต้องการลบทิ้ง
      data[i] = data[size-1];
      size--;
      data[size] = null;
    }
  }
  private int indexOf(Object e) {
    for(int i = 0; i < size; i++) {
      if(data[i].equals(e)) return i;
    }
    return -1;
  }

  //ทำเสมือนขยาย ขนาด array ให้เป็น 2 เท่า
  private void capacity(int a) {
    if(a > data.length) {
      Object[] arr = new Object[2*data.length];
      for(int i = 0; i < size; i++)
      arr[i] = data[i];
      data = arr;
    }
  }
}
// end of class ArrayCollection

public class Test {
  public static void main(String[] args)  {
    ArrayCollection a = new ArrayCollection();
    Integer ob1 = new Integer(20);
    Integer ob2 = new Integer(30);
    a.add(ob1);
    a.add(ob2);
    a.remove(ob1);
    System.out.print(a.size());
    boolean c = a.contains(ob2);
  }
}
```

=== List implement โดย Array

interface ข้างล่างนี้แสดงถึงตัวกระทำ 9 ตัว โดย 5 ตัวแรกดึงมาจากในนิยามของ Collection และมีการเพิ่มขึ้นอีก 4 ตัว นั่นคือนิยามหรือ Abstract Data Type ของ List จะมีตัวกระทำอยู่ 9 ตัว เพราะฉะนั้น interface List ข้างล่างนี้จะมีทั้งหมด 9 methods โดย extends จาก interface Collection 5 methods

```java
public interface List extends Collection {
  public void add(int i, Object e);
  public void remove(int i);
  public Object get(int i);
  public void set(int i, Object e);
}

/*
 * คลาส ArrayList ข้างล่างนี้ได้ทำการ implement 9 methods ใน interface ข้างบนให้สมบูรณ์ เปรียบเสมือนคลาสนี้คือโครงสร้างข้อมูลใหม่ชื่อ List ที่สร้างขึ้นจากนิยามข้างบน
*/
public class ArrayList implements List {
  private Object[] data;
  private int size;
  public ArrayList() {
      data = new Object[1];
      size = 0;
  }

  public void add(Object e) {
      add(size, e);
  }

  public int size() {
      return size;
  }

  public boolean isEmpty() {
      return size == 0;
  }

  public boolean contains(Object e) {
      return indexOf(e) != -1;
  }

  public void remove(Object e) {
      int i = indexOf(e);
      if (i != -1) { // ถ้าไมพบข้อมูล e ที่ต้องการลบ ก็จะไม่ทำ การ remove
          remove(i);
      }
  }

  private int indexOf(Object e) {
      for (int i = 0; i < size; i++) {
          if (data[i] != null && data[i].equals(e)) {
              return i;
          }
      }
      return -1;
  }

  // ทำเสมือนขยาย ขนาด array ให้เป็น 2 เท่า
  private void capacity(int a) {
      if (a > data.length) {
          Object[] arr = new Object[2 * data.length];
          for (int i = 0; i < size; i++) {
              arr[i] = data[i];
          }
          data = arr;
      }
  }

  public void remove(int i) {
      if (i >= 0 && i < size) { // จะไม่ลบข้อมูลในตำแหน่งที่ไม่มีข้อมูล (ใช้ i < size แทน i <= size-1)
          // เลื่อนสมาชิกทุกตัวที่อยู่ถัดจากตำแหน่ง i ขึ้น 1 ตำแหน่ง
          for (int j = i + 1; j < size; j++) {
              data[j - 1] = data[j];
          }
          size--;
          data[size] = null; // ล้างข้อมูลในตำแหน่งสุดท้ายหลังจากลดขนาด
      }
  }

  public Object get(int i) {
      // จะไม่ดึงข้อมูลถ้า i คือตำแหน่งที่ไม่มีข้อมูลอยู่
      if (i >= 0 && i < size) { // ใช้ i < size แทน i <= size-1
          return data[i];
      }
      return null; // ควรคืนค่า null หรือโยน Exception เมื่อตำแหน่งไม่ถูกต้อง
  }

  public void set(int i, Object e) {
      // จะไม่เปลี่ยนข้อมูลใหม่ข้อมูลถ้า i คือตำแหน่งที่ไม่มีข้อมูลอยู่
      if (i >= 0 && i < size) { // ใช้ i < size แทน i <= size-1
          data[i] = e;
      }
  }

  public void add(int i, Object e) {
    // จะแทรกข้อมูลเข้าไปได้เฉพาะตำแหน่งที่มีข้อมูลอยู่ รวมทั้งเพิ่มข้อมูลเข้าไปช่องถัดจากข้อมูลตัวสุดท้าย
    if (i >= 0 && i <= size) { // ตำแหน่งที่แทรกได้คือ 0 ถึง size (รวม size เพื่อเพิ่มต่อท้าย)
      capacity(size + 1);
      // เลื่อนสมาชิกตัวที่อยู่ที่ตำแหน่งที่ต้องการแทรกและทุกตัวถัดจากตำแหน่งที่ต้องการแทรก ลง 1 ตำแหน่ง
      for (int j = size - 1; j >= i; j--) {
          data[j + 1] = data[j];
      }
      // insert สมาชิกตัวใหม่ เข้าไปในช่องที่ว่าง
      data[i] = e;
      size++;
    }
  }
} // end of class ArrayList

public class Test {
    public static void main(String[] args) {
        ArrayList a = new ArrayList();
        Integer ob1 = new Integer(20);
        Integer ob2 = new Integer(30);
        Integer ob3 = new Integer(50);
        Integer ob4 = new Integer(70);

        a.add(ob1);
        a.add(ob2);
        a.add(1, ob3);
        a.add(0, ob4);
        a.remove(ob1);
        System.out.print(a.size());
        boolean c = a.contains(ob2);
        a.remove(1);
    }
}
```

เนื่องจาก List ข้อมูลมีการเรียงลำดับการเข้า เพราะฉะนั้นวิธีการ remove ข้อมูล ณ ตำแหน่งที่ต้องการ คือ
การเลื่อนสมาชิกทุกตัวที่อยู่ถัดจากตำแหน่งที่ต้องการลบ ขึ้น 1 ตำแหน่ง เพื่อเลื่อนขึ้นมาทับตัวที่ต้องการลบ เช่นต้องการลบตำแหน่งที่ `i`

เนื่องจาก List ข้อมูลมีการเรียงลำดับการเข้า เพราะฉะนั้นวิธีการ add ไปยังตำแหน่งที่ต้องการ คือ การเลื่อนสมาชิกตัวที่อยู่ที่ตำแหน่งที่ต้องการแทรกและทุกตัวถัดจากตำแหน่งที่ต้องการแทรก ลง 1 ตำแหน่ง เพื่อเปิดช่องที่ต้องการแทรก
เช่นต้องการแทรกข้อมูลที่ตำแหน่งที่ `i`

ไม่ว่าจะลบหรือแทรกข้อมูลจะมีการเลื่อนข้อมูลมากสุดแค่ `n` ตัว โดยใช้แค่ for loop เดียว เพราะฉะนั้น จึงมี complexcity แค่ $O(n)$

== แบบฝึกหัดท้ายบท

จงเขียนโปรแกรมสำหรับสร้าง Data Structure List โดยใช้ Array ซึ่งมีรายละเอียดต่าง ๆ ดังนี้

1. สร้าง interface ```java Collection``` เพื่อระบุรายการของ method ต่าง ๆ ที่จำเป็น คือ
  - ```java add(Object o)``` สำหรับเพิ่มข้อมูลที่ต้องการ
  - ```java remove(Object o)``` สำหรับลบข้อมูลที่ต้องการ
  - ```java contains(Object o)``` สำหรับค้นหาข้อมูลที่ต้องการ
  - ```java isEmpty()``` สำหรับตรวจสอบว่ามีข้อมูลภายในถังข้อมูลนี้หรือไม่
  - ```java size()``` สำหรับตรวจสอบจำนวนของข้อมูล
  - ```java add(int i, Object e)``` สำหรับเพิ่มข้อมูล ณตำแหน่ง `i`
  - ```java remove(int i)``` สำหรับลบข้อมูล ณตำแหน่ง `i`
  - ```java get(int i)``` สำหรับดึงข้อมูล ณตำแหน่ง `i`
  - ```java set(int i, Object e)``` สำหรับแทนข้อมูล ณ ตำแหน่ง `i` ด้วยข้อมูล `e`

2. สร้างคลาส ```java ArrayList``` เพื่อสร้าง Data Structure List โดยใช้ Array โดย implement จากอินเทอร์เฟซ List และทำให้ abstract method ใน interface นี้เป็น method ที่สมบูรณ์
3. สร้าง Test Class ชื่อ ```java Test2``` เพื่อตรวจสอบการทำงานของการเก็บข้อมูล โดยแสดงผลลัพธ์ที่ได้ออกมาทางจอภาพหลังจากที่ได้ดำเนินการต่าง ๆ ดังนี้
  + เพิ่มโหนดข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 20 และ 30
  + ลบโหนดข้อมูลซึ่งมีค่า 20 ออกจากถังข้อมูล
  + ลบโหนดข้อมูลซึ่งมีค่า 50 ออกจากถังข้อมูล
  + ค้นหาโหนดข้อมูลซึ่งมีค่า 30 ในถังข้อมูล

= Linked List

โครงสร้างข้อมูลตัวถัดไปคือ Linked List คือโครงสร้างข้อมูลที่นำโหนด (Node) มาเชื่อมต่อกันเป็นลูกโซ่ มี 3 ประเภท
- Singly Linked List
- Circular Linked List
- Doubly Linked List

== Singly Linked List

มีเงื่อนไขตามเอกสารเล่มนี้ดังนี้

1. ต้องมีตัวชี้(pointer) ชี้ไปยังโหนดแรก ในที่นี้ชื่อ first
2. โหนดสุดท้ายตรงส่วนของ next ต้องเป็น null ซึ่งเป็นการแสดงว่าไม่มี address ของโหนดถัดไป
3. ตัวชี้ first เลื่อนไม่ได้ ต้องชี้ที่โหนดแรกเท่านั้นเพื่อเป็นตัวชี้ที่ทำหน้าที่เข้าถึง Linked List เนื่องจากจะเข้าถึงโหนดไหนใน Linked List ก็ตามต้องเข้ามาทางโหนดแรกเท่านั้น

#figure()[
  #image("assets/image.png", width: auto, height: 80pt)
]

ข้อแตกต่างระหว่าง Linked List กับ Array คือ
1. Array ข้อมูลตัวติดกันอยู่ในช่องที่มี address ที่ติดกัน แต่ใน Linked List ไม่จำเป็นต้องมี address ติดกัน
2. ข้อมูลที่อยู่ใน Array ต้องเป็นข้อมูลชนิดเดียวกัน แต่ใน Linked List ไม่จำเป็นต้องเป็นชนิดเดียวกัน
3. เมื่อจอง Array แล้ว ไม่สามารถขยาย หรือ หด จำนวนช่องที่จองไว้แล้วได้ แต่ใน Linked List ขยายได้ไม่จำกัด

=== โหนด

เนื่องจาก Linked List ประกอบด้วยโหนดมาเชื่อมต่อกัน ก่อนจะสร้าง Linked List ต้องทำการรู้จักกับโหนดก่อน
โหนดประกอบด้วย 2 ส่วน
- ส่วนที่เก็บข้อมูล (`data`) จากรูปข้างล่าง โหนดแรก ส่วน data เก็บข้อมูล `a`
- ส่วนที่เก็บ address ของโหนดถัดไป (`next`) ดังรูปข้างล่างรูป โหนดแรกส่วน `next` เก็บ address ของโหนดถัดไปนั่นคือ address ของโหนดที่มีข้อมูล `b`

#figure()[
  #image("image.png", width: auto, height: 100pt)
]

- ถ้าโหนดส่วน `next` ยังไม่เก็บ address ของโหนดใด ๆ จะเป็นดังรูปข้างล่างนี้

#figure()[
  #image("image-1.png", width: auto, height: 100pt)
]

จะสร้างโหนดได้ก็ต้องมีคลาสโหนด ในคลาสโหนดมี instance variable 2 ตัวคือ `data` กับ `next` ไว้เก็บข้อมูลและ address ของโหนดถัดไปตามลำดับ จึงมี instance methods อยู่ 4 methods สำหรับดึงข้อมูล (get) และ เปลี่ยนข้อมูลใหม่ (set) บน ข้อมูล `data` กับ `next`

```java
public class MyNode {
 	private Object data;
 	private MyNode next;

 	public MyNode(Object obj, MyNode node){
 		data = obj;
 		next = node;
 	}
 	public void setNext(MyNode node){
 		next = n;
 	}
 	public void setData(Object data){
 		data = d;
 	}
 	public MyNode getNext() {
 		return next;
 	}
 	public Object getData() {
 		return data;
  }
}
```

=== การสร้าง Singly Linked list

1. เริ่มต้นที่ Linked List ว่าง หรือถังข้อมูลว่าง Linked List ว่าง คือ `first` ไม่มีโหนดถัดไปให้ชี้ไป เพราะฉะนั้น

#codly(skip-number: [3])
```java
first = null;
```

#figure()[
  #image("image-3.png", width: auto, height: 100pt)
]

2. ใส่ข้อมูลตัวแรกเข้าไปใน Linked List เช่นต้องการใส่ข้อมูล `'a'` เข้าในถังว่าง ก่อนใส่ข้อมูล`'a'` เข้าไปใน Linked List ต้องสร้างโหนดเพื่อเก็บข้อมูล `'a'` ก่อน

#codly(lang-format: (_, _, _) => [(1)], number-format: none)
```java
Mynode t = new Mynode(a, null);
```

หลังจากนั้นนำ `first` มาชี้ดังรูปข้างล่างนี้

#codly(lang-format: (_, _, _) => [(2)], number-format: none)
```java
first = t;
```

ขณะนี้ first ชี้อยู่ที่โหนดแรกและ next ของโหนดสุดท้ายก็เป็น null นั่นคือตรงตามเงื่อนไขความเป็น Linked List แล้ว เพราะฉะนั้นขณะนี้ข้อมูล ‘a’ เข้าไปอยู่ในถังหรือ Linked List เป็นตัวแรกแล้ว


// หรือสามารถรวมคำสั่ง (1) กับ (2) ได้เป็นหนึ่งคำสั่งตามคำสั่งด้านบนนี้

//     3. ใส่โหนดใหม่เข้าไปต่อท้าย (method addEnd)
// สมมติว่าใน Linked List มีข้อมูล 3 อยู่แล้ว  แต่จะใส่ข้อมูล 1 เข้าไปต่อท้าย

// เนื่องจากตัวชี้ first เลื่อนไม่ได้ ต้องชี้ที่โหนดแรกเท่านั้น จึงต้องสร้างตัวชี้อีกตัวหนึ่งมาเพื่อเลื่อนไปยังไหนดสุดท้ายในที่นี้ตัวชี้นั้นชื่อ start โดยคำสั่งข้างล่างนี้
//      while(start.getNext() != null)
//       start = start.getNext();

// เมื่อ start มาชี้ที่โหนดสุดท้ายแล้ว ทำการ set ค่าส่วน next ของ start ให้เป็น address ของโหนดที่สร้างขึ้นมาใหม่ซึ่งโหนดใหม่นี้มีค่า 1 ดั่งรูปข้างล่างนี้


//     4. ใส่โหนดใหม่เข้าไปแทรกหน้า (method add)
// ถ้าใน Linked List มีข้อมูล 2 อยู่แล้วจะใส่ข้อมูล 4 เข้าไปแทรกข้างหน้า

// อันดับแรกสร้างโหนดใหม่ซึ่งเก็บค่า 4 พร้อมกับset ค่าให้ส่วน next ของโหนดใหม่นี้ให้ เป็น address ของโหนดแรกซึ่ง address นี้เดิมเก็บอยู่ในตัวแปร first ดังภาพและคำสั่งข้างล่างนี้


// จากนั้นเปลี่ยนให้ first มาชี้ใหนดใหม่แทนเพราะขณะนี้โหนดใหม่เป็นโหนดแรกใน Linked List ตามคำสั่งและ
// รูปข้างล่างนี้ นั่นคือให้ตัวแปร first เก็บ address ของโหนดใหม่ซึ่งเก็บอยู่ในตัวแปร  p

//     5. ลบโหนดออกจาก Linked List (method remove)
// มีความเป็นไปได้ที่โหนดที่ต้องการลบจะเป็น โหนดแรก โหนดกลาง หรือโหนดท้าย
// 5.1 ลบโหนดแรก
// ถ้าต้องการลบโหนดที่มีค่า 8 ข้างล่างนี้ ซึ่งเป็นโหนดแรก

// ให้ย้าย first ไปชี้ที่โหนดที่สองแทนโหนดแรก ดังคำสั่งและรูปข้างล่าง



// 5.2 ลบโหนดกลาง
// ถ้าต้องกรลบโหนดที่มีค่า 3 ข้างล่างนี้ ซึ่งเป็นโหนดกลาง

// เนื่องจากตัวชี้ first เลื่อนไม่ได้ จึงต้องสร้างตัวชี้อีกตัวหนึ่งขึ้นมาเพื่อเลื่อนไปยังไหนดที่ต้องการลบ ในที่นี้ตัวชี้นั้นชื่อ start เนื่องจากจะต้องให้ส่วน next ของตัวก่อนหน้าโหนดที่จะลบชี้ไปยังโหนดของตัวถัดจากตัวที่จะลบจึงต้องมีตัวชี้เพิ่มอีกตัวเพื่อเลื่อนไปอยู่ก่อนหน้าตัวชี้ start ในที่นี้ตัวชี้นั้นชื่อ pre
// 	ก่อนที่จะเลื่อนตัวชี้ pre และ start กำหนดให้ pre และ start เท่ากับ first หมายความว่าให้ pre และ start เริ่มต้นชี้ที่โหนดแรก


// ก่อนที่จะเลื่อน start ต้องให้ pre มาเท่ากับ start ตัวเดิมก่อน นั่นคือเมื่อ start เลื่อน  pre จะเลื่อนตาม start มาติด ๆดังคำสั่งและภาพข้างล่างนี้



// จากนั้นกำหนดค่าในส่วน next ของโหนดที่ตัวชี้ pre ชี้อยู่ให้เป็น address ของโหนดที่อยู่ถัดจากโหนดที่ต้องการลบซึ่งโหนดที่ต้องการลบมี start ชี้อยู่ (โหนดที่มีค่า 3)  ดังคำสั่งและภาพข้างล่างนี้




// 5.3 ลบโหนดท้าย
// ถ้าต้องการลบโหนดที่มีค่า 5 ข้างล่างนี้ ซึ่งเป็นโหนดท้ายสุด

// 	ก่อนที่จะเลื่อนตัวชี้ pre และ start กำหนดให้ pre และ start เท่ากับ first หมายความว่าให้ pre และ start เริ่มต้นชี้ที่โหนดแรก

// เลื่อนตัวชี้ pre และ start คู่กันไปโดย start จะไปหยุดยังโหนดที่ต้องการลบซึ่งคือโหนดท้ายสุด และ  pre จะหยุดที่โหนดตัวก่อนโหนดที่ start ชี้ ดังคำสั่งและรูป 2 รูปข้างล่างนี้




// ตัดโหนดท้ายสุดซึ่งคือโหนดที่เก็บค่า 5 ออกโดย กำหนดค่าของส่วน next ของโหนดก่อนหน้าโหนดที่ต้องการลบซึ่งมีตัวชี้ pre ชี้อยู่ ให้กลายเป็น null นั่นคือไม่มี address ของโหนดถัดไป แสดงให้เห็นว่าขณะนี้โหนดที่ pre ชี้อยู่กลายเป็นโหนดสุดท้ายแล้วดังคำสั่งและรูปข้างล่างนี้

// 2.2 Collection implement โดย Linked List
// ถึงเวลาที่จะสร้างโครงสร้างข้อมูล Collection โดยใช้ Linked List อันดับแรกต้องมี Abstract Data Type ของ Collection ก่อน ซึ่งก็คือส่วน interface Collection ซึ่งมีทั้งหมด 5 methods

// public interface Collection {
// public void add(Object e);
// public void remove(Object e);
// public boolean contains(Object e);
// public boolean isEmpty();
// public int size();
// }

// ก่อนที่จะสร้างโครงสร้างข้อมูลโดยใช้ Linked List ต้องมีคลาสโหนดเพื่อเอาไว้สร้างโหนดเพื่อเก็บข้อมูลแต่ละตัว เนื่องจากแต่ละโหนดมี 2 instance variable นั่นคือ data และ next ดังที่อธิบายข้างบน  ดังนั้นclass นี้จึงมี 4 methods เพื่อที่จะ set และ get  instance variable 2 ตัวนี้

// public class MyNode {
//    private Object data;
//    private MyNode next;


//    public  MyNode(Object obj, MyNode n) {
//       data =  obj;
//        next = n;
// }
//  public void SetNext(MyNode  n) {
//    next = n;
// }

// public void setData(Object  d) {
//    data = d;
// }

// public MyNode getNext() {
//    return next;
// }

// public Object getData()  {
//    return data;
// }
// }

// ต่อไปสร้างถังโดยใช้ Linked List และจัดการข้อมูลในถังใบนี้โดยใช้คลาส LinkedCollection ข้างล่างนี้ ซึ่งเป็นโครงสร้างข้อมูล Collection ซึ่งimplement โดยใช้ Linked List นั่นคือคลาสนี้จะมีการจัดการ
//   	- สร้างถังเปล่า ตรง constructor ของคลาส โดยจะให้ first = null;
// - ใส่ข้อมูลเข้าไปในLinked List
// นำโหนดของข้อมูลมาเชื่อมต่อกันโดยใช้ method add (แทรกข้างหน้า) หรือ method addEnd (ใส่ต่อท้าย)
// จากนิยามของ Collection การเก็บหรือลบข้อมูลจะไม่มีลำดับ เพราะฉะนั้นเมื่อจะใส่ข้อมูลใหม่เข้าไปจะใส่เข้าด้านหน้า หรือต่อท้าย Linked List ก็สามารถทำได้ ดังนั้นคลาส LinkedCollection ข้างล่างซึ่งเป็นโครงสร้างข้อมูล Collection  จึงมีแค่ method add (แทรกข้างหน้า)หรือ method addEnd (ใส่ต่อท้าย) สำหรับการใส่ข้อมูลใหม่
// - การลบข้อมูล ออกจาก Linked List โดย method remove(Object o)
// อันดับแรกต้องค้นหาก่อนว่า ข้อมูล o อยู่โหนดไหนใน Linked List นี้ โดยใช้ while loop เลื่อนตัวชี้ start ไปยังโหนดที่เก็บข้อมูลตัวที่ต้องการลบ และ ตัวชี้ pre ไปชี้ที่โหนดก่อนหน้าตัวชี้ start

// จากนั้นเมื่อออกจาก while loop ถ้าไม่เจอโหนดที่บรรจุ ข้อมูล o ให้ออกจาก method remove โดยใช้ keyword return แต่ถ้าเจอโหนดที่บรรจุข้อมูลที่ต้องการลบ o ให้ตรวจสอบว่า เป็นโหนดแรกของ Linked list หรือ เป็นโหนดตรงกลางของ Linked list หรือ เป็นโหนดท้ายสุดของ Linked List จากนั้นเมื่อรู้ว่าเป็นโหนดแรกหรือโหนดกลางหรือโหนดท้ายแล้วให้ทำตามการลบที่อธิบายไว้ใน ส่วน 5.1-5.3 ในส่วนของ 2.1.2 ที่อธิบายไว้ข้างบน ตามลำดับ
// - ถามว่ามีข้อมูลที่ระบุอยู่ใน Linked List นี้หรือไม่ โดยใช้ method contain(Object o)
// ค้นหาก่อนว่า ข้อมูล o อยู่โหนดไหนใน Linked List นี้ โดยใช้ while loop เลื่อนตัวชี้ start ไปยังโหนดที่เก็บข้อมูลตัวที่ต้องการค้นหา คล้ายกับ while loop ของ method remove แต่การค้นหาไม่ต้องการตัวชี้ pre  เมื่อจบ while loop ตัวชี้ start จะไปชี้อยู่ที่โหนดที่บรรจุข้อมูล o คือโหนดที่กำลังค้นหา ถ้าไม่พบโหนดที่บรรจุข้อมูล o นี้  ตัวชี้ start จะเลื่อนไปสุด โดยวิ่งไปที่ null นั่นคือส่วน next ของโหนดสุดท้าย
// - ถามว่าถังข้อมูลนี้หรือ Linked List นี้ว่างหรือไม่ โดยใช้ method isEmpty()
// ถ้าตัวชี้ first ไม่ได้ชี้ไปแม้แต่โหนดเดียว แสดงว่าไม่มีข้อมูลอยู่ในถังข้อมูลนี้ นั่นคือ first = null
// - ถามว่าถังใบนี้มีข้อมูลกี่ตัว หรือ Linked List นี้มีกี่โหนด โดยใช้ method size()
// นำตัวแปร size ออกมา นั่นคือ return ตัวแปร size
// - ส่วน method ที่เสริมขึ้นมาไม่อยู่ใน Collection ADT คือ method printlist() มีไว้เพื่อแสดงออกทางหน้าจอว่าขณะนี้ใน Linked List มีข้อมูลอะไรอยู่บ้างตั้งแต่โหนดแรกจนถึงโหนดสุดท้าย method นี้ทำงานโดย ทำการเลื่อนตัวชี้ start ไปทีละโหนดแล้ว print ค่าของโหนดนั้นออกมา ทำจนกระทั่งสิ้นสุด Linked List คือไปยังโหนดสุดท้ายของ Linked List

// public class LinkedCollection implements Collection{
//     private MyNode first;
//     private int size;

//    public  LinkedCollection() { //เริ่มต้นที่ถังข้อมูลว่างเปล่า
//       first = null;
//       size=0;  }
//     public boolean isEmpty() {
//       return first == null;   //  หรือsize == 0;
//  }
//    public int size() {
//     return size;
// }
// public void add(Object value) //การนำ node เข้าทางด้านหน้า
//  {
//      first = new MyNode(value, first);
//      size++;
// }
//  public void printlist()   // การท่องเข้าไปใน list
// {   MyNode start = first;
//     while( start !=null )
//      {
//           System.out.println(start.getData());
//           start = start.getNext();
//       }
//  }
// public void addEnd(Object obj) //การนำ node  ต่อเพิ่มทางด้านหลัง
//  {    if(isEmpty())
//          add(obj);
//     else {     MyNode start = first;
//      while(start.getNext() != null)
//       start = start.getNext();
//      MyNode tmp = new MyNode(obj, start.getNext());
//      start.setNext(tmp);
//      size++;
//    }
// }
// public void remove(Object  o)
// {
//    if(isEmpty()) // ถ้าไม่มีข้อมูลอยู่ก็ remove ไม่ได้
//       return;
//   MyNode pre;
//   MyNode start = first;
//   while (start.getNext() != null && !(start.getData().equal(o)))
//    {      pre = start;
//          start = start.getNext();
// //เลื่อน start ไปยังโหนดที่มีข้อมูลที่ต้องการลบ
//     }

// if(!(start.getData().equal(o))   // กรณีไม่พบข้อมูลที่ต้องการลบ
//    System.out.println(“Not Found”);
// else
//    {
//      if (start == first)
//       first  = first.getNext();  // ลบ node แรกสุดของ Linked List
//      else
//        pre.setNext(start.getNext()); // ลบnode ตรงกลาง หรือnode ท้ายสุดของ Linked List
//      size--;
//    }
//  } // จบ remove

//    public boolean contains(Object o)
//    {
//        MyNode start = first;
//         while (start != null && !(start.getData().equal(o)))
//         {start = start.getNext();  //พยายามเลื่อน start ไปยัง node ที่ต้องการค้นหา
//          }
//        return  start !=null;  //ถ้า start=null แสดงว่าไม่พบข้อมูลที่ต้องการค้นหา
//    }
//  } // จบ class LinkedCollection

// Test class ข้างล่างนี้เป็นคลาสที่ใช้ทดสอบคลาส LinkedCollection โครงสร้างข้อมูลที่สร้างโดยใช้ Linked List  ว่าใส่ข้อมูลเข้า ลบข้อมูลออก ถามว่ามีข้อมลที่ระบุหรือไม่ ถามว่าถังใบนี้มีข้อมูลกีตัว หรือถามว่าถังข้อมูลนี้ว่างเปล่าหรือไม่ ทั้งหมดนี้ทำงานได้อย่างถูกต้องหรือไม่

// public class Test{
//     public static void main(String[] args) {
//     LinkedCollection  list = new LinkedCollection();
//        Integer ob1 = new Integer(20);
//        Integer ob2 = new Integer(30);
//        Integer ob3 = new Integer(50);
//         list.add(ob1);
//         list.add(ob2);
//         list.remove(ob1);
//         System.out.print(list.size());
//         boolean c = list.contains(ob2);
//            list.remove(ob3);
//            }
// }

// 2.3 List implement โดย Linked List
// ต่อไปจะสร้างโครงสร้างข้อมูลของ List  โดยใช้ Linked List อันดับแรกต้องมี Abstract Data Type ของ List ก่อน ซึ่งก็คือส่วน interface List ซึ่งมีทั้งหมด 9 methods โดย extend จาก collection มา 5 methods และ เพิ่มขึ้นมา 4 methods

// public interface List extends Collection {
// public void add(int i, Object e);
// public void remove(int i);
// public Object get(int i);
// public void set(int i, Object e );
// }
// ก่อนที่จะสร้างโครงสร้างข้อมูลโดยใช้ Linked List ต้องมีคลาสโหนดเพื่อเอาไว้สร้างโหนดเพื่อเก็บข้อมูลแต่ละตัว ซึ่งก็จะเป็นคลาสโหนดเดียวกันกับ ตอนสร้างโครงสร้าง Collection เพราะยังใช้ singly Linked List เหมือนกัน

// public class MyNode {
//    private Object data;
//    private MyNode next;

//    public  MyNode(Object obj, MyNode n) {
//       data =  obj;
//        next = n;
// }
//  public void SetNext(MyNode  n) {
//    next = n;
// }
// public void setData(Object  d) {
//    data = d;
// }
// public MyNode getNext() {
//    return next;
// }

// public Object getData()  {
//    return data;
// }
// }
// ต่อไปสร้างถังโดยใช้ Linked List และจัดการข้อมูลในถังใบนี้โดยใช้คลาส LinkedList ข้างล่างนี้ ซึ่งเป็นโครงสร้างข้อมูล List ซึ่ง implement โดยใช้ Linked List นั่นคือคลาสนี้จะมีการจัดการ
// - สร้างถังเปล่า ตรง constructor ของคลาส โดยให้ first = null;
// - ใส่ข้อมูลเข้าไปใน Linked List
// นำโหนดของข้อมูลมาเชื่อมต่อกันโดยใช้ method add (Object obj)
// จากนิยามของ List การเก็บหรือลบข้อมูลจะมีลำดับการเข้าออกของข้อมูล เพราะฉะนั้นเมื่อจะใส่ข้อมูลใหม่เข้าไปจะใส่เข้าต่อท้าย Linked List  ดังนั้นคลาส LinkedList ข้างล่างซึ่งเป็นโครงสร้างข้อมูล List  จึงมีแค่ method add(Object obj) สำหรับการใส่ข้อมูลใหม่เข้าไปต่อท้าย
// - การลบข้อมูล ออกจาก Linked List โดย method remove(Object o)
// อันดับแรกต้องค้นหาก่อนว่า ข้อมูล o อยู่โหนดไหนใน Linked List นี้ โดยใช้ while loop เลื่อนตัวชี้ start ไปยังโหนดที่เก็บข้อมูลตัวที่ต้องการลบ และ ตัวชี้ pre ชี้ไปที่โหนดก่อนหน้าตัวชี้ start จากนั้นเมื่อออกจาก while loop ถ้าไม่เจอโหนดที่บรรจุ ข้อมูล o ให้ออกจาก method remove โดยใช้ keyword  return
// แต่ถ้าเจอโหนดที่บรรจุข้อมูลที่ต้องการลบ o ให้ตรวจสอบว่า เป็นโหนดแรกของ Linked list หรือ เป็นโหนดตรงกลางของ Linked list หรือ เป็นโหนดท้ายสุดของ Linked List จากนั้นเมื่อรู้ว่าเป็นโหนดแรกหรือโหนดกลางหรือโหนดท้ายแล้ว ให้ทำตามการลบที่อธิบายไว้ใน ส่วน 5.1-5.3 .ในส่วนของ 2.1.2 ที่อิบายไว้ข้างบน ตามลำดับ
// - ถามว่ามีข้อมูลที่ระบุอยู่ในLinked List นี้หรือไม่ โดย method contains(Object o)
// ค้นหาก่อนว่า ข้อมูล o อยู่โหนดไหนใน Linked List นี้ โดยใช้ while loop เลื่อนตัวชี้ start ไปยังโหนดที่เก็บข้อมูลตัวที่ต้องการค้นหา คล้ายกับ while loop ของ method remove แต่การค้นหาไม่ต้องการตัวชี้ pre เมื่อจบ while loop ตัวชี้ start จะไปชี้อยู่ที่โหนดที่บรรจุข้อมูล o คือโหนดที่กำลังค้นหา ถ้าไม่พบโหนดที่บรรจุข้อมูล o ตัวชี้start จะเลื่อนไปสุดโดยวิ่งไปที่ null นั่นคือส่วน next ของโหนดสุดท้าย
// - ถามว่าถังข้อมูลนี้หรือ Linked List นี้ว่างหรือไม่ โดยใช้ method isEmpty()
// ถ้าตัวชี้ first ไม่ได้ชี้ไปแม้แต่โหนดเดียว แสดงว่าไม่มีข้อมูลอยู่ในถังข้อมูลนี้ นั่นคือ first = null
// - ถามว่าถังใบนี้มีข้อมูลกี่ตัว หรือ Linked List นี้มีกี่โหนด โดย method size()
// นำตัวแปร size ออกมา นั่นคือ return ตัวแปร size
// -ส่วน method ที่เสริมขึ้นมาไม่อยู่ใน List ADT คือ method printlist() มีไว้เพื่อแสดงออกทางหน้าจอว่าขณะนี้ใน Linked List ว่ามีข้อมูลอะไรอยู่บ้างตั้งแต่โหนดแรกจนถึงโหนดสุดท้าย method นี้ทำงานโดยทำการเลื่อนตัวชี้ start ไปทีละโหนดแล้ว print ค่าของโหนดนั้นออกมา ทำจนกระทั่งสิ้นสุด Linked List

// public class LinkedList implements List{
//     private MyNode first;
//     private int size;

//    public  LinkedList() {
//       first = null;
//       size=0;
// }
//     public boolean isEmpty() {
//       return first == null;   //  size == 0;
//  }
//    public int size() {
//     return size;
// }
// public void printlist()   // การท่องเข้าไปใน list
// {   MyNode start = first;
//     while( start !=null )
//      {
//           System.out.println(start.getData());
//           start = start.getNext();
//       }
//  }
// public void add(Object obj) //การนำ node  ต่อเพิ่มทางด้านหลังเข้าด้านหน้าไม่ได้เพราะมีลำดับ
//  {
//     if(isEmpty())
// first = new MyNode(obj, first);
//     else {
//      MyNode cur = first;
//      while(cur.getNext() != null)
//       cur = cur.getNext();
//      MyNode tmp = new MyNode(obj, cur.getNext());
//      cur.setNext(tmp);
//      size++;
//    }
// }



// public void remove(Object  o)
// {
//    if(isEmpty())
//       return;
//   MyNode pre;
//   MyNode start = first;
//   while (start.getNext() != null && !(start.getData().equal(o)))
//    {      pre = start;
//          start = start.getNext();
//     }
// if(!(start.getData().equal(o))   // กรณีไม่พบ
//    System.out.println(“Not Found”);
// else
//    {
//      if (start == first)
//       first  = first.getNext();  // ลบ node แรกสุด
//      else
//        pre.setNext(start.getNext());
//      size--;
//    }
//  } // จบ remove


//    public boolean contains(Object o)
//    {
//        MyNode start = first;
//         while (start != null && !(start.getData().equal(o)))
//         {start = start.getNext(); }
//        return  start !=null;
//    }

// public void  remove(int i)
// { // remove โดยระบุตำแหน่ง ซึ่งโหนดแรกมีตำแหน่งเป็น 0
//    if(i >= 0 && i <= size-1)
//         {  if (i ==0)  first = first.getNext();
//             else {
//                  MyNode pre, start = first;
//                       for(int j= 1; j <=i; j++)
//                        {    pre = start;
//                             start = start.getNext();
//                         }
//                   pre.setNext(start.getNext());

//                   }// จบ else
//             size--;
//           }
// }

// 2.4 Sort implement โดย Linked List
// 	นิยาม Abstract Data Type ขึ้นมาอีกตัว ชื่อ Sort
// Sort ADT
//     1. เซตของข้อมูล เช่น {3, 1, 7, 15, 29}
//     2. ความสัมพันธ์ของข้อมูล : จัดเก็บข้อมูลเปรียบเสมือนถังของข้อมูลที่รองรับเพิ่มและลบตามลำดับค่าของข้อมูลเช่นเรียงจากค่ามากไปถึงน้อย
//     3. กลุ่มของตัวกระทำ
//     • add(Object O) : เพิ่มข้อมูล O เข้าไปในถัง
//     • remove(Object O) : ลบข้อมูล O ออกจากถัง
//     • contains(Object O) : ถามว่าในถังมีข้อมูล O อยู่หรือไม่ ถ้ามีจะreturn true  ถ้าไม่มีจะ return false
//     • isEmpty() : ถามว่าถังข้อมูลนี้ว่างอยู่หรือไม่ ถ้าว่างจะ return true    ถ้าไม่ว่างจะ return false
// ต่อไปจะใช้ Singly Linked List ในการ implement Sort Abstract Data Type ตามนิยามด้านบน
// 	เนื่องจากทุก method ของ Sort คล้ายกับ Collection ยกเว้น method add ที่แตกต่างกัน เพราะว่า Collection จะใส่ข้อมูลข้างหน้า หรือต่อท้ายก็ได้เพราะแค่ต้องการใส่ข้อมูลเข้าไปในถังได้ก็พอ แต่ Sort เวลาใส่ข้อมูลใหม่เข้าไป ต้องตรวจสอบว่า ข้อมูลที่จะใส่เข้าไปควรต้องไปอยู่ที่ลำดับเท่าไหร่ เช่น เดิมมีข้อมูล   3, 8, 10, 35 อยู่ ถ้าจะใส่ 9 เข้าไป ต้องเอาเข้าไปไว้ระหว่าง โหนดที่เก็บข้อมูล 8 และ โหนดที่เก้บข้อมูล 10 จะแทรกหน้า หรือเอาไปต่อท้าย Linked List เลยไม่ได้ เพราะฉะนั้นข้อมูลที่จะใส่เข้าไปในถัง Sort มีโอกาสที่จะแทรกเข้าไปข้างหน้าสุดของ Linked List หรือ จะแทรกเข้าไปตรงกลางของ Linked List หรือ จะถูกนำไปต่อท้ายสุดของ Linked List  ขึ้นอยู่กับค่าข้อมูลว่าจะแทรกเข้าไปที่ตำแหน่งไหน
// 2.4.1 กรณีแทรกโหนดเข้าไปด้านหน้า Linked List
// 	ถ้าต้องการใส่ 2  ลงไปในถังใบนี้หรือ Linked List ข้างล่างนี้  เนื่องจาก Sort มีการเรียงค่าข้อมูล เพราะฉะนั้น ข้อมูล 2 ต้องถูกแทรกเข้าไปที่หน้าสุดของ Linked List


// สร้างโหนดเพื่อเก็บค่า 2 แล้ว set ค่าส่วน next ของโหนดใหม่นี้ให้เป็น address ของโหนดแรกซึ่งตัวแปร first เก็บค่า address นั้นอยู่  นั่นคือให้โหนดใหม่นี้ชี้ไปยังโหนดแรกซึ่งคือโหนดที่เก็บค่า 3  หลังจากนั้นย้ายตัวชี้ first ไปชี้ที่โหนดใหม่แทนโดยการให้ตัวแปร first มาเก็บ address ของโหนดใหม่ซึ่งคือโหนด 2 แทน address ของ โหนด 3  นั่นคือโหนดใหม่นี้ที่เก็บค่า 2 ได้กลายเป็นโหนดแรกของ Linked List






// 2.4.2 กรณีแทรกโหนดใหม่เข้าไปตรงกลางLinked List
// 	ถ้าต้องการใส่ 4 ลงไปในถังใบนี้หรือ Linked List ข้างล่างนี้ เนื่องจาก Sort มีการเรียงค่าของข้อมูลเพราะฉะนั้น ข้อมูล 4  ต้องถูกใส่เข้าไปตรงกลางของ Linked List คืออยู่ระหว่างโหนดที่มีค่า 3 และโหนดที่มีค่า 4

// 	เนื่องจากต้องรู้ก่อนว่าค่าใหม่ที่จะใส่เข้าไปควรจะต้องไปอยู่ที่ตำแหน่งไหน จึงต้องมี while loop คอยเลื่อนตัวชี้ไปเรื่อย ๆจนกว่าจะเจอโหนดที่มีค่ามากกว่าข้อมูลที่จะใส่เข้าไป(ในกรณีที่เรียงจากน้อยไปมากตามตัวอย่าง) ตัวชี้นี้ชื่อ cur1 และมีตัวชี้ cur2 เลื่อนตามมาติด ๆเพื่อมาหยุดก่อนหน้า ตัวชี้ cur1
// เริ่มต้นกำหนดให้ตัวชี้ cur1 และ cur2 ชี้ยังโหนดแรกนั่นคือ ให้ cur1, cur2 เท่ากับ first ดังคำสั่งและภาพข้างล่างนี้



// 	ทำการเลื่อนตัวชี้ cur1 ไปหยุดที่โหนดที่มีค่ามากกว่าข้อมูลที่จะใส่เข้าไป โดยเลื่อนตัวชี้ cur2 มาติด ๆ โดยมาหยุดที่โหนดก่อนหน้าโหนดที่ตัวชี้ cur1 ชี้อยู่ ดังภาพข้างล่างโดยใช้ 2คำสั่งข้างล่างให้อยู่ใน while loop  ดู method add (Object value) ในคลาส LinkedSort



// 	จากนั้นสร้างโหนดใหม่เก็บค่า 4 และกำหนดค่า (set) ให้ส่วน next ของโหนด cur2 ให้เป็น address ของโหนดใหม่คือให้ชี้ไปยังโหนดใหม่ แล้วกำหนดค่า (set) ให้ส่วน next ของโหนดใหม่ให้เป็น address ของโหนด cur1 คือให้โหนดใหม่ชี้ไปยังโหนดที่ cur1 ชี้อยู่ นั่นคือแทรกโหนดไปให้อยู่ระหว่างโหนด cur2 และ โหนด cur1 ดังภาพข้างล่างโดยใช้คำสั่งข้างล่าง




// 2.4.3 กรณีเพิ่มโหนดใหม่โดยไปต่อท้ายของ Linked List
// 	ถ้าต้องการใส่ 8 ลงไปในถังใบนี้หรือ Linked List นี้  เนื่องจาก Sort มีการเรียงค่าข้อมูลเพราะฉะนั้น ข้อมูล 8  ต้องถูกต่อเข้าไปท้ายสุดของ Linked List

// 	เริ่มต้นให้ตัวชี้ cur1, cur2 ชี้ที่โหนดแรกคือให้ cur1,cur2 เท่ากับ first ซึ่งเก็บ address ของโหนดแรกอยู่ ดังรูปและ 2 คำสั่งข้างล่างนี้


// 	เนื่องจาก while loop ใน method add(Object value) ของคลาส LinkedSort ข้างล่าง มีคำสั่ง cur2=cur1; cur1=cur1.getNext(); ซึ่ง จะทำการเลื่อนตัวชี้ cur1 ไปหยุดที่โหนดที่มีค่ามากกว่าข้อมูลที่จะใส่เข้าไป แต่กรณีที่ไปต่อท้าย Linked List นี้ ตัวที่จะใส่เข้ามาจะมีค่ามากกว่าทุกตัว ใน Linked List เพราะฉะนั้นตัวชี้ cur1 จึงไปหยุดที่ null คือส่วน next ของ โหนดสุดท้าย   ส่วนตัวชี้ cur2 จะไปหยุดก่อนหน้า cur1 นั่นคือจะไปหยุดที่โหนดสุดท้ายตาม 3 รูป ข้างล่าง






// 	สร้างโหนดใหม่ให้เก็บ 8 แล้วกำหนด (set) ส่วน next ให้มีค่าเท่ากับ cur1 นั่นคือมีค่าเท่ากับ null จากนั้น set ค่าส่วน next ของโหนดสุดท้ายที่ตัวชี้ cur2 ชี้อยู่ให้เท่ากับ address ของโหนดใหม่นั่นคือให้ไปชี้ที่โหนดใหม่เป็นการต่อพ่วงโหนดใหม่เข้าไปด้านท้ายของ Linked List ตามคำสั่งและรูปข้างล่างนี้


// 2.4.4 Implement Sort โดยใช้ Singly Linked List
// ถึงเวลาที่จะสร้างโครงสร้างข้อมูลโดยใช้ Linked List อันดับแรกต้องมี Abstract Data Type ของ Sort ก่อน ซึ่งก็คือส่วนของ Interface Sort ซึ่งมีทั้งหมด 4 methods
// public interface Sort {
//   public void add(Object e);
//   public void remove(Object e);
//   public boolean contains(Object e);
//   public boolean isEmpty();
// }
// ก่อนที่จะสร้างโครงสร้างข้อมูลโดยใช้ Linked List ต้องมีคลาสโหนดเพื่อเอาไว้สร้างโหนดเพื่อเก็บข้อมูลแต่ละตัว
// เนื่องจาก ใช้ singly Linked List สร้างโครงสร้างข้อมูล Sort จึงใช้คลาส MyNode ในการสร้างแต่ละโหนดเหมือนเดิม

// public class MyNode {
// 	private Object data;
// 	private MyNode next;

// 	public MyNode(Object obj, MyNode n){
// 		data = obj;
// 		next = n;
// 	}
// 	public void setNext(MyNode n){
// 		next = n;
// 	}
// 	public void setData(Object d){
// 		data = d;
// 	}
// 	public MyNode getNext(){
// 		return next;
// 	}
// 	public Object getData(){
// 		return data;
// 	}
// }

// มาถึงการสร้างโครงสร้างข้อมูล Sort จากคลาส LinkedSort ข่างล่างนี้ เนื่องจากใช้ singly Linked List ในการสร้างข้อมูลเหมือนกับ Collection เพราะฉะนั้น method ส่วนใหญ่จึงถูก implemented คล้ายกัน ยกเว้น method add ที่มีความแตกต่างกันมากระหว่างโครงสร้างข้อมูล Sort และ Collection
// - เริ่มจาก constructor ซึ่งแสดงถึงถังข้อมูลว่างเปล่า มีคำสั่งเหมือนของโครงสร้างข้อมูล collection นั่นคือ first=null;

// - method add(Object value)  ที่แตกต่างกัน เพราะว่า Collection จะใส่ข้อมูลข้างหน้า หรือต่อท้ายก็ได้เพราะแค่ต้องการใส่ข้อมูลเข้าไปในถังได้ก็พอ แต่ Sort เวลาใส่ข้อมูลใหม่เข้าไป ต้องตรวจสอบว่า ข้อมูลที่จะใส่เข้าไปควรต้องไปอยู่ที่ลำดับเท่าไหร่ เช่น เดิมมีข้อมูล   3, 8, 10, 35 อยู่ ถ้าจะใส่ 9 เข้าไป ต้องเอาเข้าไปไว้ระหว่าง โหนดที่เก็บข้อมูล 8 และ โหนดที่เก้บข้อมูล 10 จะแทรกหน้า หรือเอาไปต่อท้ายไม่ได้ เพราะฉะนั้นข้อมูลที่จะใส่เข้าไปในถัง Sort มีโอกาสที่จะแทรกเข้าไปข้างหน้าสุดของ Linked List หรือ จะแทรกเข้าไปตรงกลางของ Linked List หรือ จะถูกนำไปต่อท้ายสุดของ Linked List โดยมีขั้นตอนการทำงานดังที่อธิบายไว้ที่ ส่วน 2.4.1 – 2.4.3 ข้างบน

// - method remove(Object o) คล้ายกับ remove ของคลาส LinkedCollection เพราะอย่างไรก็จะมีโอกาสที่จะลบได้อยู่ 3 แบบคือ ลบโหนดแรก ลบโหนดตรงกลาง หรือ ลบโหนดท้ายสุดของ Linked List   ต่างกันตรงที่การเลื่อนตัวชี้ start ไปยังโหนดที่เก็บข้อมูลที่ต้องการลบ ถ้าเป็น Collection ไม่มีการเรียงลำดับของค่าข้อมูล จึงจำเป็นที่ต้องหาข้อมูลที่ต้องการลบตั้งแต่โหนดแรกไปจนถึงโหนดสุดท้ายของ Linked List ขณะที่ Sort มีการเรียงลำดับของค่าข้อมูลใน Linked List อยู่แล้ว เพราะฉะนั้น ถ้าเลื่อนตัวชี้ start ไปถึงแค่โหนดที่มีค่ามากกว่าตัวที่ต้องการลบ (ถ้าเรียงลำดับค่าข้อมูลจากน้อยไปหามาก) แล้วยังไม่เจอ แสดงว่าไม่เจอตัวที่ต้องการลบ จึงหยุดเลื่อนตัวชี้ นั่นคือหยุดการค้นหาโดยไม่ต้องค้นหาไปยังโหนดสุดท้ายของ Linked List

// - method contains(Object o) โครงสร้างข้อมูล Sort จะมีส่วนต่างจาก method contains ของโครงสร้างข้อมูล Collection เฉพาะตรงที่การเลื่อนตัวชี้ start ไปยังโหนดที่ต้องการค้นหา คือเมื่อเจอโหนดที่มีค่ามากกว่าตัวที่ต้องค้นหา (ถ้าเรียงลำดับค่าข้อมูลจากน้อยไปหามาก) แสดงว่าไม่เจอตัวที่ต้องการค้นหา จึงหยุดเหยุดการค้นหาได้เลย เหตุผลเดียวกับ method remove ข้างบนนี้
// -method isEmpty()  เหมือนกันทั้งใน Collection และ Sort คือแค่ตรวจสอบว่าถ้าตัวชี้ first ไม่มีแม้แต่โหนดเดียวให้ชี้ไป หรือ first = null แสดงว่าถังข้อมูลนี้ว่างเปล่า
// - ส่วน method ที่เสริมขึ้นมาไม่อยู่ใน Sort ADT คือ method printlist() มีไว้เพื่อแสดงออกทางหน้าจอว่าขณะนี้ใน Linked List ว่ามีข้อมูลอะไรอยู่บ้างตั้งแต่โหนดแรกจนถึงโหนดสุดท้าย    method นี้ทำงานโดยเลื่อนตัวชี้ start ไปทีละโหนดแล้ว print ค่าของโหนดนั้นออกมา ทำจนกระทั่งสิ้นสุด Linked List

// public class LinkedSort implements Sort {
//     private MyNode first;

//     public LinkedSort(){ //เริ่มต้นถังข้อมูลว่างเปล่า
//         first = null;
//             }
//     public boolean isEmpty(){ //ถามว่าถังข้อมูลว่างหรือไม่ ถ้าว่างนั่นคือ first=null
//         return first == null;
//     }
//     public void printList(){ // แสดงข้อมูลทุกตัวในLinked List ออกทางจอภาพ
//         MyNode start = first;

//         while(start != null){
//             System.out.print(start.getData()+ "\t");
//             start = start.getNext();
//         }
//         System.out.println();
//         System.out.println("------------------------------------------------");
//     }

// public void remove(Object o){ // ทำการลบโหนดที่มีค่า o
//         if(isEmpty())
//             return;
//         else
//             System.out.println("Remove Value: " + o);

//         MyNode pre = null, start = first;
//         int a = (Integer)start.getData();
//         int v = (Integer)o;
//        // ตรงที่เช็ค a<v คือเช็คว่าถ้าเจอโหนดที่มากกว่าข้อมูลที่ต้องการลบแสดงว่าไม่เจอ ให้หยุดค้นหา
//         while(start.getNext() != null && !(start.getData().equals(o)) && (a < v)){
//             pre = start;
//             start = start.getNext();
//             a = (Integer)start.getData();
//         }
//         if(!(start.getData().equals(o)))
//             System.out.println("Not Found");
//         else{
//             if(start == first) // ลบโหนดแรกสุดของ Linked List
//                 first = first.getNext();
//             else
//                 pre.setNext(start.getNext()); //ลบโหนดตรงหลางหรือโหนดท้ายสุดของ Linked List
//         }
//      }
//     public boolean contains(Object o){
//         MyNode start = first;
//             while(start != null && !(start.getData().equals(o)))
//       {     Integer b = (Integer) o;
//             Integer a = (Integer)start.getData();
//             if(a>b)   //ถ้าเจอโหนดทีมีค่าข้อมูลมากกว่าตัวที่ต้องการค้นหาให้หยุดและ return ออกจาก method
//          {
//                   return false;
//             }
//             start = start.getNext()
//         }
//                return start != null;
//     }
// public void add(Object value){
//             if(contains(value)){ // ถ้ามีข้อมูลที่จะใส่เข้าไปอยู่ใน Linked List อยู่แล้ว
//                 System.out.println(value + " has already existed in List"); // แจ้งว่ามีอยู่แล้ว
//                 return;         //ไม่ทำการ add ให้ออกจาก method
//             }
//             else // เริ่มทำการ add
//                 System.out.println("Add Value: " + value)
//             if(isEmpty())
//              { //ถ้าข้อมูลที่จะใส่เข้าไปเป็นข้อมูลตัวแรกและตัวเดียวของ Linked List
//                 first = new MyNode(value, first);
//             }
//             else{
//                 MyNode cur1 = first, cur2 = null;
//                 int a = (Integer)cur1.getData();
//                 int v = (Integer)value;
//                 if(a > v){// แทรกข้อมูลตัวใหม่เข้าไปหน้าสุดของ linked List
//                     first = new MyNode(value, first);
//                 }
//                 else{
//                     // เลื่อนตัวชี้ cur1 ไปหยุดที่โหนดที่มีค่าข้อมูลมากกว่าข้อมูลที่จะใส่เข้าไป และ cur2 ไปหยุดก่อนหน้าcur1



//  while (cur1 != null && a < v)
//                   {
//                         cur2 = cur1;
//                         cur1 = cur1.getNext();
//                         if (cur1t != null)
//                        {
//                             a = (Integer)cur1.getData();
//                         }
//                    }     // ปิด while
//                  }
//                     MyNode tmp = new MyNode(value, cur1);
//                     cur2.setNext(tmp); // แทรกโหนดใหม่เข้าไปตรงกลางหรือท้ายสุดของ Linked List
//                        }
//            }
//         }
// }
// Test class ข้างล่างนี้เป็นคลาสที่ใช้ทดสอบคลาส LinkedSort โครงสร้างข้อมูลที่สร้างโดยใช้ Linked List ว่าใส่ข้อมูลเข้า ลบข้อมูลออก ถามว่ามีข้อมลที่ระบุหรือไม่ หรือถามว่าถังข้อมูลนี้ว่างเปล่าหรือไม่ ทั้งหมดนี้ทำงานได้อย่างถูกต้องหรือไม่

// public class Main {
//     public static void main(String[] args) {
//         LinkedSort  list = new LinkedSort();
//             Integer ob1 = new Integer(20);
//             Integer ob2 = new Integer(30);
//             Integer ob3 = new Integer(15);
//             Integer ob4 = new Integer(25);
//             Integer ob5 = new Integer(30);
//             Integer ob6 = new Integer(40);
//             Integer ob7 = new Integer(28);
//             Integer ob8 = new Integer(35);
//             list.add(ob1);
//             list.printList();
//             list.add(ob2);
//             list.printList();
//             list.add(ob3);
//             list.printList();
//             list.add(ob4);
//             list.printList();
//             list.add(ob5);
//             list.add(ob6);
//             list.printList();

//             System.out.println("Is " + ob2 + " in the List?");
//             boolean a = list.contains(ob2);
//             System.out.println(a);
//             System.out.println("Is " + ob7 + " in the List?");
//             boolean b = list.contains(ob7);
//             System.out.println(b);

//             list.remove(ob3);
//             list.printList();
//             list.remove(ob4);
//             list.printList();
//             list.remove(ob8);
//             list.printList();

//     }
// }
// แบบฝึกหัดท้ายบท
// 1. จงเขียนโปรแกรมสำหรับสร้าง Data Structure Collection โดยใช้ Linked list (ข้อมูลแบบโยง) ซึ่งมีรายละเอียดต่าง ๆ ดังนี้
//     1. สร้าง interface Collection    เพื่อระบุรายการของ method ต่าง ๆ ที่จำเป็นในการเก็บข้อมูลแบบโยง  คือ
// - add   		สำหรับเพิ่มโหนดข้อมูลเข้าทางด้านหน้าของการโยง
// - remove 	สำหรับลบโหนดข้อมูลที่ต้องการ
// - contains 	สำหรับค้นหาโหนดข้อมูลที่ต้องการ
// - isEmpty	สำหรับตรวจสอบว่ามีโหนดข้อมูลภายในข้อมูลแบบโยงนี้หรือไม่
// - size		สำหรับตรวจสอบขนาดของข้อมูลแบบโยง
//     2. สร้างคลาส MyNode    เพื่อระบุ attribute และ method ของโหนดข้อมูล
//     3. สร้างคลาส LinkedCollection เพื่อสร้าง Data Structure Collection โดยใช้ Linked list โดย implement จากอินเทอร์เฟซ Collection และทำให้ abstract method ใน interface นี้เป็น method ที่สมบูรณ์
//     4. สร้าง Test Class ชื่อ Test1 เพื่อตรวจสอบการทำงานของการเก็บข้อมูลแบบโยง   โดยแสดงผลลัพธ์ที่ได้ออกมาทางจอภาพหลังจากที่ได้ดำเนินการต่าง ๆ   ดังนี้
//         4.1 เพิ่มโหนดข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 20 และ 30 ลงในข้อมูลแบบโยง
//         4.2 ลบโหนดข้อมูลซึ่งมีค่า 20 ออกจากข้อมูลแบบโยง
//         4.3 ลบโหนดข้อมูลซึ่งมีค่า 50 ออกจากข้อมูลแบบโยง
//         4.4 ค้นหาโหนดข้อมูลซึ่งมีค่า 30 ในข้อมูลแบบโยง
// 2.จงเขียนโปรแกรมสร้าง Data Structure List โดยใช้ Linked list    ซึ่งมีรายละเอียดของโปรแกรม   ดังนี้
//     1. สร้าง Interface ชื่อ List ซึ่ง inherit มาจาก Interface Collection    เพื่อถ่ายทอดรายการของ method ที่ระบุใน interface Collection และเพิ่มความสามารถในการทำงานของ List    โดยระบุรายการของ method เพิ่มเติม ดังนี้
// - add (int i, Object e)	เพิ่ม Object e ไว้ที่เลขลำดับที่ i ในรายการ
// - remove (int i)		ลบข้อมูลซึ่งถูกจัดเก็บที่เลขลำดับที่ i ในรายการ
// - get (int i) 		ขอข้อมูลซึ่งถูกจัดเก็บที่เลขลำดับที่ i ในรายการ
// - set (int i, Object e)	เปลี่ยนข้อมูลซึ่งถูกจัดเก็บที่เลขลำดับที่ i ในรายการ   ให้เป็น Object e
//     2. สร้างคลาสชื่อ MyNode    เพื่อระบุ attribute และ method ของโหนดข้อมูล
//     3. สร้างคลาสชื่อ LinkedList เพื่อสร้าง Data Structure List โดยใช้ Linked list โดย implement จาก Interface List และทำให้ abstract methods ใน Interface นี้เป็น method ที่สมบูรณ์ นอกจากนี้สร้าง method printList เพื่อแสดงผลข้อมูลทั้งหมดในรายการออกมาทางจอภาพ
//     4. สร้างคลาสชื่อ Main เพื่อตรวจสอบการทำงานของ Linked list   โดยแสดงผลลัพธ์ที่ได้ออกมาทางจอภาพด้วย method printList   หลังจากที่ได้ดำเนินการต่าง ๆ  ดังนี้
//         4.1 เพิ่มข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 20 และ 30 ลงในรายการ
//         4.2 เพิ่มข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 70 และ 90 ลงที่เลขลำดับที่ 0 และ 2 ในรายการ ตามลำดับ
//         4.3 ลบข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 20 ออกจากรายการ
//         4.4 แสดงผลขนาดของรายการออกมาทางจอภาพ
//         4.5 ค้นหาข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 30 ในรายการ
//         4.6 ขอข้อมูลซึ่งถูกจัดเก็บที่เลขลำดับที่ 2 และ 0 ในรายการ ตามลำดับ
//         4.7 เปลี่ยนข้อมูลซึ่งถูกจัดเก็บที่เลขลำดับที่ 0 และ 2 ในรายการ   ให้เป็นข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 100 และ 200 ตามลำดับ
//         4.8 ลบข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 50 ออกจากรายการ
//         4.9 ลบข้อมูลซึ่งถูกจัดเก็บที่เลขลำดับที่ 0 และ 2 ออกจากรายการ ตามลำดับ

// บทที่ 3  Circular Linked List และ Doubly Linked List
// 3.1 Circular Linked List
//     เป็น Linked List อีกประเภทที่มีเงื่อนไขดังนี้
//     1. ต้องมีตัวชี้(pointer) ชี้ไปยังโหนดสุดท้าย ในที่นี้ชื่อ last
//     2. โหนดสุดท้ายตรงส่วนของ next ต้องเก็บ address ของโหนดแรกสุดเสมอ นั่นคือจะได้วงกลมจากโหนดสุดท้ายเชื่อมกลับมาที่โหนดแรกสุด
//     3. ตัวชี้ last เลื่อนไม่ได้ ต้องชี้ที่โหนดสุดท้ายเท่านั้น เพื่อเป็นตัวชี้ที่ทำหน้าที่เข้าถึง Linked List เนื่องจากจะเข้าถึงโหนดไหนใน Linked List ก็ตามต้องเข้ามาทางโหนดสุดท้ายนี้เท่านั้น
// 3.1.1 การสร้าง Circular Linked List
// เริ่มต้นที่ถังข้อมูลว่างเปล่า แสดงว่าตัวชี้ last ไม่ได้ชี้ไปแม้แต่โหนดเดียว นั่นคือ last มีค่าเท่ากับ null
// เมื่อจะใส่ข้อมูล ‘a’ เข้าไปในถังเปล่า เริ่มแรกต้องสร้างโหนดเพื่อเก็บค่า ‘a’ ก่อน
// MyNode t = new MyNode(a,null);

// ดังรูปข้างล่างนี้

// 3.1.1.1 กรณีใน Circular Linked List มีโหนดแรกโหนดเดียว
// จากนั้นให้ตัวชี้ last มาชี้ยังโหนดใหม่นี้ เนื่องจากเป็นโหนดสุดท้ายเพราะเป็นโหนดเดียว จากนั้น set ค่าส่วน next ของโหนดสุดท้ายให้ไปชี้ยังโหนดแรก ดัง 2 คำสั่งข้างล่าง  เนื่องจากขณะนี้มีโหนดเดียว จึงวนกลับมาชี้ตัวเองดังรูปข้างล่างนี้ เพราะมันเป็นทั้งโหนดแรกและโหนดสุดท้าย







// 3.1.1.2 กรณีเพิ่มโหนดใหม่โดยไปต่อท้ายของ Circular Linked List
// ถ้าต้องการใส่โหนดใหม่ซึ่งเก็บค่า 8 เข้าไปที่ด้านท้ายของ Circular Linked List



// เริ่มต้นให้ตัวชี้ cur1 และ cur2 ชี้ตามตัวชี้ last จากนั้น เลื่อนตัวชี้ cur1 และ cur2 ไปชี้ยังโหนดแรกซึ่งในที่นี้มีค่า 3  และโหนดสุดท้ายซึ่งในที่นี้มีค่า 7 ตามลำดับ ดัง 2 รูปข้างล่าง



// จากนั้นกำหนดให้โหนดสุดท้ายใน Linked List ชี้ไปยังโหนดใหม่และให้โหนดใหม่ชี้ไปยังโหนดแรกของ Linked List จากนั้นเปลี่ยนตัวชี้ last ให้ไปชี้ยังโหนดใหม่เพราะขณะนี้โหนดใหม่กลายเป็นโหนดสุดท้ายใน  Linked List แล้ว ดังรูปข้างล่างนี้

// 3.1.1.3 กรณีแทรกโหนดเข้าไปด้านหน้าของ Circular Linked List
// ถ้าต้องการใส่โหนดใหม่ซึ่งมีค่า 2 เข้าไปที่ด้านหน้าของ Circular Linked list

// เริ่มต้นให้ตัวชี้ cur1 และ cur2 ชี้ตามตัวชี้ last จากนั้น เลื่อนตัวชี้ cur1 และ cur2 ไปชี้ยังโหนดแรกซึ่งในที่นี้มีค่า 3  และโหนดสุดท้ายซึ่งในที่นี้มีค่า 7 ตามลำดับ ดัง 2 รูปข้างล่าง





// จากนั้นกำหนดให้โหนดสุดท้ายใน Linked List ชี้ไปยังโหนดใหม่และให้โหนดใหม่ชี้ไปยังโหนดแรกของ Linked list โดยที่ตัวชี้ last ไม่เปลี่ยนที่เพราะโหนดสุดท้ายใน  Linked List  ยังเป็นโหนดที่มีค่า 7  เหมือนเดิม ดังรูปข้างล่างนี้




// 3.1.1.4 กรณีแทรกโหนดใหม่เข้าไปตรงกลางของ Circular Linked List
// ถ้าต้องการใส่โหนดใหม่ซึ่งมีค่า 4 เข้าไปตรงกลางของ Circular Linked List คือให้อยู่ระหว่างโหนดที่มีค่า 3 กับโหนดที่มีค่า 5


// เริ่มต้นให้ตัวชี้ cur1 และ cur2 ชี้ตามตัวชี้ last จากนั้น เลื่อนตัวชี้ cur1 และ cur2 ไปชี้ยังโหนดที่คาดว่าจะอยู่หลังโหนดที่จะเติมเข้าไปใหม่ซึ่งในที่นี้มีค่า 5 และโหนดที่คาดว่าจะอยู่ก่อนหน้าโหนดที่จะเติมเข้าไปใหม่ ซึ่งในที่นี้มีค่า 3 ตามลำดับ ดัง 3 รูปข้างล่าง







// จากนั้นsetส่วน next ของโหนดก่อนหน้า(โหนดที่มีค่า 3)ให้ชี้ไปยังโหนดใหม่(โหนดที่มีค่า 4) แล้วset ส่วน next ของโหนดใหม่(โหนดที่มีค่า 4)ให้ชี้ปยังโหนดที่ตามหลังมา(โหนดที่มีค่า 5) ดังคำสั่งและรูปด้านล่างนี้


// 3.1.2 การลบโหนดออกจาก Circular Linked List
// 3.1.2.1 กรณีลบโหนดแรกสุด
// ถ้าต้องการลบโหนดแรกสุดออกจาก Circular Linked list ในที่นี้คือโหนดที่มีค่า 3

// เริ่มต้นให้ตัวชี้ cur1 และ cur2 ชี้ตามตัวชี้ last จากนั้น เลื่อนตัวชี้ cur1 และ cur2 ไปชี้ยังโหนดแรกซึ่งในที่นี้มีค่า 3  และโหนดสุดท้ายซึ่งในที่นี้มีค่า 7 ตามลำดับ ดัง 2 รูปข้างล่าง




// จากนั้นsetค่าส่วน next ของโหนดสุดท้าย(โหนดที่ขณะนี้มีตัวชี้ cur2 ชี้อยู่) ให้ชี้ไปยังโหนดที่ถัดจากโหนดแรก (โหนดที่มีค่า 2) ดังรูปข้างล่าง








// 3.1.2.2 กรณีลบโหนดท้ายสุด
// ถ้าต้องการลบโหนดท้ายสุดออกจาก Circular Linked List ในที่นี้คือโหนดที่มีค่า 7


// เริ่มต้นให้ตัวชี้ cur2 ชี้อยู่ที่เดียวกับตัวชี้ last แล้วเลื่อนตัวชี้ cur2 ไปยังโหนอก่อนหน้าโหนดสุดท้ายซึ่งก็คือโหนดที่มีค่า 9 ดัง 4 รูปข้างล่าง








// จากนั้นsetส่วน next ของโหนดที่ตัวชี้ cur2 ชี้อยู่ให้ไปชี้โหนดแรกสุดแทนโหนดสุดท้าย โดยใช้คำสั่ง
// 	cur2.setNext(last.getNext());
// จากนั้นเลื่อนตัวชี้ last ไปยังโหนดที่ตัวชี้ cur2 ชี้อยู่ โดยใช้คำสั่ง
//  		last = cur2;
// เพราะขณะนี้โหนดที่ตัวชี้ cur2 ชี้อยู่เป็นโหนดสุดท้ายของ Circular Linked List แทนโหนดที่ลบออกไป จึงได้ผลลัพธ์ดังรูปข้างล่างนี้

// 3.1.2.3 กรณีลบโหนดกลาง
// ถ้าต้องการลบโหนดที่อยู่กลางของ Circular Linked List ในที่นี้ก็มี โหนดที่มีค่า 2 และโหนดที่มีค่า 9 ที่เป็นโหนดกลาง ตัวอย่างข้างล่างจะแสดงการลบโหนดที่มีค่า 2

// เริ่มต้นให้ตัวชี้ cur1 และ cur2 ชี้ตามตัวชี้ last จากนั้น เลื่อนตัวชี้ cur1 และ cur2 ไปชี้โหนดที่อยากจะลบ(ในที่นี้มีค่า 2) และโหนดที่อยู่ก่อนหน้าโหนดที่ต้องการจะลบ (ในที่นี้มีค่า 3) ตามลำดับ  ดัง 4 รูปข้างล่าง






// จากนั้น set ส่วน next ของโหนดก่อนหน้าโหนดที่จะลบให้ข้ามโหนดที่จะลบ โดยชี้ไปยังโหนดข้างหลังโหนดที่ต้องการลบโดยใช้คำสั่งและรูปข้างล่างนี้




// 3.1.3 Collection implement โดย Circular Linked List
// ถึงเวลาที่จะสร้างโครงสร้างข้อมูลโดยใช้ Circular Linked List อันดับแรกต้องมี Abstract Data Type ของ Collection ก่อน ซึ่งก็คือส่วน interface Collection ซึ่งมีทั้งหมด 5 methods

// public interface Collection {
// public void add(Object e);
// public void remove(Object e);
// public boolean contains(Object e);
// public boolean isEmpty();
// public int size();
// }

// ก่อนที่จะสร้างโครงสร้างข้อมูลโดยใช้ Linked List ต้องมีคลาสโหนดเพื่อเอาไว้สร้างโหนดเพื่อเก็บข้อมูลแต่ละตัวเนื่องจาก ใช้ Circular Linked List สร้างโครงสร้างข้อมูล Collection จึงใช้คลาส MyNode ในการสร้างแต่ละโหนดเหมือนเดิม เพราะคุณสมบัติของโหนดของ Circular Linked List เหมือนกับของ Singly Linked List

// public class MyNode {
//    private Object data;
//    private MyNode next;

//    public  MyNode(Object obj, MyNode n) {
//       data =  obj;
//        next = n;
// }
//  public void SetNext(MyNode  n) {
//    next = n;
// }
// public void setData(Object  d) {
//    data = d;
// }
// public MyNode getNext() {
//    return next;
// }
// public Object getData()  {
//    return data;
// }
// }

// ต่อไปสร้างถังโดยใช้ Circular Linked List และจัดการข้อมูลในถังใบนี้โดยใช้คลาส CirLink ข้างล่างนี้ ซึ่งเป็นโครงสร้างข้อมูล Collection ซึ่งi mplement โดยใช้ Circular Linked List นั่นคือคลาสนี้จะมีการจัดการการ
//  	- สร้างถังเปล่า ตรง constructor ของคลาส  นั่นคือให้ last = null;
// - ใส่ข้อมูลเข้าไปใน Circular Linked List
// นำโหนดของข้อมูลมาเชื่อมต่อกันโดยใช้ method add (แทรกข้างหน้า)หรือ method addEnd (ใส่ต่อท้าย)
// จากนิยามของ Collection การเก็บหรือลบข้อมูลจะไม่มีลำดับ เพราะฉะนั้นเมื่อจะใส่ข้อมูลใหม่เข้าไปจะใส่เข้าด้านหน้า หรือต่อท้าย Linked List ก็สามารถทำได้ ดังนั้นคลาส CirLink ข้างล่างซึ่งเป็นโครงสร้างข้อมูล Collection  จึงมีแค่ method add (แทรกข้างหน้า) หรือ method addEnd (ใส่ต่อท้าย) สำหรับการใส่ข้อมูลใหม่
// - การลบข้อมูล ออกจากLinked List โดย method remove(Object o)
// อันดับแรกต้องค้นหาก่อนว่า ข้อมูล o อยู่โหนดไหนในlinked List นี้ โดยใช้ do_while loop เลื่อนตัวชี้ start ไปยังโหนดที่เก็บข้อมูลตัวที่ต้องการลบ และ ตัวชี้ pre (ในตัวอย่าง 3.1.2.1-3.1.2.3ใช้ตัวชี้ cur2) ไปชี้ที่โหนดก่อนหน้าตัวชี้ start (ในตัวอย่าง 3.1.2.1-3.1.2.3 ใช้ตัวชี้ cur1) จากนั้นเมื่ออกจาก loop ถ้าไม่เจอโหนดที่บรรจุ ข้อมูล o ให้ออกจาก method remove โดยการ return แต่ถ้าเจอโหนดที่บรรจุข้อมูลที่ต้องการลบ o ให้ตรวจสอบว่า เป็นโหนดตัวเดียว หรือ โหนด แรกของ Linked List หรือ เป็นโหนดตรงกลางของ Linked list หรือ เป็นโหนดท้ายสุดของ Linked List จากนั้นเมื่อรู้ว่าเป็นโหนดแรกหรือโหนดกลางหรือโหนดท้ายแล้วให้ทำตามการลบที่อธิบายไว้ใน 3.1.2.1 – 3.1.2.3  ข้างบน
// - ถามว่ามีข้อมูลที่ระบุอยู่ใน Linked List นี้หรือไม่ โดย method contains(Object O)
// ค้นหาก่อนว่า ข้อมูล o อยู่โหนดไหนใน Linked List นี้ โดยใช้ do_while loop เลื่อนตัวชี้ start ไปยังโหนดที่เก็บข้อมูลตัวที่ต้องการค้นหา คล้ายกับ do_while loop ของ method remove แต่การค้นหาไม่ต้องการตัวชี้ pre เมื่อจบ loop ตัวชี้ start จะไปชี้อยู่ที่โหนดที่บรรจุข้อมูล o คือโหนดที่กำลังค้นหา ถ้าตัวชี้ start เลื่อนไปยังโหนดสุดท้ายจะหลุด loop มาเช็คที่โหนดสุดท้ายว่าเก็บข้อมูล o ไหม ถ้าไม่ ก็แสดงว่าไม่พบ


// - ถามว่าถังข้อมูลนี้หรือ Linked List นี้ว่างหรือไม่ โดย method isEmpty()
// ถ้าตัวชี้ last ไม่ได้ชี้ไปแม้แต่โหนดเดียว แสดงว่าไม่มีข้อมูลในถังข้อมูลนี้ นั่นคือ last = null
// - ถามว่าถังใบนี้มีข้อมูลกี่ตัว หรือ Linked List นี้มีกี่โหนด โดย method size()
// นำตัวแปร size ออกมา นั่นคือ return ตัวแปร size
// - ส่วน method ที่เสริมขึ้นมาไม่อยู่ใน Collection ADT คือ method printlist() มีไว้เพื่อแสดงออกทางหน้าจอว่าขณะนี้ใน Linked List ว่ามีข้อมูลอะไรอยู่บ้างตั้งแต่โหนดแรกจนถึงโหนดสุดท้าย method นี้ทำงานโดยเลื่อนตัวชี้ start ไปทีละโหนดแล้ว print ค่าของโหนดนั้นออกมา ทำจนกระทั่งสิ้นสุด Linked List

// public class CirLink implements Collection{
//     private MyNode last;
//     private int size;

//    public  CirLink() { // constructor เมื่อเริ่มต้นถังว่างเปล่า last จึงไม่ชี้ไปยังโหนดใด ๆ
//       last = null;
//       size=0;
// }
//     public boolean isEmpty() {
//       return last == null;   //  size == 0;
//  }
//    public int size() {
//     return size;
// }
// public void  add(Object value) //การเพิ่ม node  เข้าทางด้านหน้า
//  {   MyNode tmp = new MyNode(value, null);
//      if(last == null) //ถ้าถังว่างเปล่า
//      {  last = tmp;
//         last.SetNext(last);
//        //ให้โหนดสุดท้ายชี้มายังโหนดแรกแต่ขณะนี้มีเพียงโหนดเดียว ส่วน next จึงวนกลับมาชี้ตัวมันเอง
//      }

//       else
//       {
//          tmp.SetNext(last.getNext()); //ให้โหนดใหม่ชี้ไปยังโหนดแรกสุด
//           last.SetNext(tmp); }  //ให้โหนดสุดท้ายชี้ไปยังโหนดใหม่เพราะฉะนั้นขณะนี้โหนดใหม่กลายเป็นโหนดแรกสุด
//       size++;
// }
//  public void printlist()   // การท่องเข้าไปใน list
// {   MyNode start;
//       if(last==null)
//       System.out.print(“Empty”);
//       else
//        { start = last;
//           do // print ตั้งแต่โหนดแรกไปยังโหนดสุดท้ายของ Linked List
//            {
//               System.out.println((start.getnext()).getData());
//               start = start.getNext();
//            }while(start!= last);
//          }
//  }

// public void addEnd(Object obj) //การนำ node ต่อเพิ่มเข้าทางด้านหลัง
//  {
//     MyNode tmp = new MyNode(value, null);
//      if(last == null)   //ถ้าถังว่างเปล่า
//      {  last = tmp;
//         last.SetNext(last);
//        //ให้โหนดสุดท้ายชี้มายังโหนดแรกแต่ขณะนี้มีเพียงโหนดเดียว ส่วน next ของโหนดจึงวนกลับมาชี้ตัวมันเอง
//      }


//      else
//       {
//       tmp.SetNext(last.getNext()); //ให้โหนดใหม่ชี้ไปยังโหนดแรก
//       last.SetNext(tmp);  //ให้โหนดสุดท้ายชี้ไปยังโหนดใหม่
//        last =last.getNext();  // ให้ตัวชี้ last ชี้ไปยังโหนดใหม่ซึ่งขณะนี้กลายเป็นโหนดสุดท้าย
//      }
//       size++;
// }

// public void remove(Object  o)
// {
//    if(isEmpty())// ถังว่างเปล่าแสดงว่าไม่ทำการ remove
//       return;
//   MyNode pre; //ในตัวอย่าง 3.1.2.1- 3.1.2.3 ใช้ตัวชี้ cur2
//   MyNode start = last; //ในตัวอย่าง 3.1.2.1- 3.1.2.3 ใช้ตัวชี้ cur1
//   do // หาโหนดที่บรรจุข้อมูล o
//    {      pre = start;
//          start = start.getNext();
//     } while (start != last && !(start.getData().equal(o)));
// if(!(start.getData().equal(o))   // กรณีไม่พบ
//    System.out.println(“Not Found”);
// else
//    {   if(pre==start) last = null;  // กรณีในถังมีโหนดเดียว เมื่อลบทิ้ง ตัวชี้ last จึงไม่เหลือโหนดให้ชี้
//         else {
//        pre.setNext(start.getNext()); // ถ้าตัวที่ต้องการลบเป็นตัวแรกหรือตัวกลางของ Linked List
//        if(start==last) // ถ้าตัวที่ต้องการลบเป็นตัวสุดท้ายของ Linked List
//          last = pre; }
//      size--;
//    }
//  } // จบ remove
//    public boolean contains(Object o)
//    {
//       MyNode start;
//       if(last==null) // ถังว่างเปล่าแสดงว่าไม่พบข้อมูล o จึง return false
//         return false;
//       else
//        { start = last;
//           do // หาโหนดที่บรรจุข้อมูล o
//            {
//                    start = start.getNext();
//            }while(start!= last && !(start.getData().equal(o)));
//           return start.getData().equal(o); // ถ้าพบโหนดที่มีข้อมูล o จะ return true มิฉะนั้นจะ return false
//          }
//    }
// } // จบ class

// 3.2 Doubly Linked List
// เป็น Linked List อีกประเภทที่มีเงื่อนไขดังนี้
//     1. ต้องมีตัวชี้ (pointer) ชี้ไปยังโหนดแรก ในที่นี้ชื่อ first
//     2. โหนดสุดท้ายตรงส่วนของ next ต้องเป็น null ซึ่งเป็นการแสดงว่าไม่มี address ของโหนดถัดไป
//     3. โหนดแรกสุดตรงส่วนของ previous ต้องเป็น null ซึ่งเป็นการแสดงว่าไม่มี address ของโหนดก่อนหน้า
//     4. โหนดตรงกลางส่วนของ next ต้องชี้ไปยังโหนดถัดไป ส่วนส่วนของ previous ต้องชี้ไปยังโหนดก่อนหน้า
//     5. ตัวชี้ first เลื่อนไม่ได้ ต้องชี้ที่โหนดแรกเท่านั้นเพื่อเป็นตัวชี้ที่ทำหน้าที่เข้าถึง Linked List เนื่องจากจะเข้าถึงโหนดไหนใน Linked List ก็ตามต้องเข้ามาทางโหนดแรกเท่านั้น
// ตัวอย่างของ Doubly Linked List


// 3.2.1 โหนดของ Doubly Linked List
// เนื่องจาก Doubly Linked List  ประกอบด้วยโหนดมาเชื่อมต่อกัน เพราะฉะนั้นก่อนจะสร้าง Doubly Linked List ต้องทำการรู้จักกับโหนดก่อน  โหนดของ Doubly Linked List  ประกอบด้วย 3 ส่วน

// ส่วนที่ 1 ช่องซ้ายสุดเรียกว่าส่วน previous มีหน้าที่เก็บ address ของโหนดก่อนหน้า
// ส่วนที่ 2 ช่องขวาสุดเรียกว่าส่วน next มีหน้าที่เก็บ address ของโหนดถัดไป
// ส่วนที่ 3 ช่องตรงกลางเรียกว่าส่วน data มีหน้าที่เก็บ ข้อมูลหนึ่งตัว
// จะสร้างโหนดได้ก็ต้องมีคลาสโหนด ในคลาสโหนดมี instance variable 3 ตัวคือ data และ previous และ next ไว้เก็บข้อมูลและ address ของโหนดก่อนหน้าและ address ของโหนดถัดไปตามลำดับ จึงมี instance methods อยู่ 6 methods สำหรับดึงข้อมูล (get) และ เปลี่ยนข้อมูลใหม่ (set) บน ข้อมูล data และ previous และ next
// public class DBLNode {
//    private Object data;
//    private DBLNode prev;
//    private DBLNode next;

//    public  DBLNode(Object obj) {
//       data =  obj;
//       prev = null;
//        next = null;
// }
// public void SetPrev(DBLNode  n) {
//    prev = n;
// }
//  public void SetNext(DBLNode  n) {
//    next = n;
// }
// public void SetData(Object  d)
//    data = d;
// }
// public DBLNode getPrev() {
//    return prev;
// }
// public DBLNode getNext() {
//    return next;
// }
// public Object getData()  {
//    return data;
// }
// }

// 3.2.2 การสร้าง Doubly Linked List
// 1. เริ่มต้นที่กรณีที่ถังข้อมูลว่างเปล่า แสดงว่าตัวชี้ first ไม่ได้ชี้ไปแม้แต่โหนดเดียว นั่นคือ first มีค่าเท่ากับ null

// 2. ใส่ข้อมูลตัวแรกเข้าไปใน Linked List เช่นต้องการใส่ข้อมูล 7 เข้าในถังว่าง ก่อนใส่ข้อมูล 7 เข้าไปใน Linked List ต้องสร้างโหนดเพื่อเก็บข้อมูล 7 ก่อน นั่นคือทางขวาของเครื่องหมายเท่ากับในคำสั่งข้างล่างนี้ หลังจากนั้นนำ first มาชี้ดังรูปข้างล่างนี้

// เนื่องจากขณะนี้ในถังข้อมูลมีเพียงโหนดเดียว ตามเงื่อนไขของ Doubly Linked List ส่วน previous ของโหนดแรกต้องเป็น null และส่วน next ของโหนดสุดท้ายต้องเป็น null จึงได้ตามรูปด้านบน

// 3. กรณีใส่โหนดใหม่เข้าไปต่อท้าย (addEnd) ของ Doubly Linked List
// ถ้าใน Linked List มีข้อมูล 4 6 8 12 อยู่แล้วจะใส่ข้อมูล 15 เข้าไปต่อท้าย

// เนื่องจากตัวชี้ first เลื่อนไม่ได้ ต้องชี้ที่โหนดแรกเท่านั้น จึงต้องสร้างตัวชี้อีกตัวหนึ่งมาเพื่อเลื่อนไปยังโหนดสุดท้ายในที่นี้ตัวชี้นั้นชื่อ start โดยคำสั่งข้างล่างนี้
//      while(start.getNext() != null)
//       start = start.getNext();
// เมื่อจบ while loop นี้ ตัวชี้ start จะไปหยุด ที่โหนดสุดท้าย ดัง 3 รูปข้างล่างนี้



// while loop รอบสุดท้าย
// เมื่อ start มาชี้ที่โหนดสุดท้ายแล้ว set ค่าส่วน next ของ start ให้เป็น address ของโหนดที่สร้างขึ้นมาใหม่ซึ่งมีค่า 15 และ set ค่าส่วน previous ของ โหนด 15 ให้เป็น address ของโหนดที่ตัวชี้ start ชี้อยู่ ดั่งรูปข้างล่างนี้


// 4. กรณีใส่โหนดใหม่เข้าไปแทรกหน้า (addFront)  ของ Doubly Linked List
// ถ้าใน Linked List มีข้อมูล 4 6 8 12 อยู่แล้วจะใส่ข้อมูล 2 เข้าไปแทรกข้างหน้า

// ตาม 3 คำสั่ง และรูปข้างล่างทำงานตามลำดับดังนี้
// อันดับแรกสร้างโหนดใหม่ซึ่งเก็บค่า 2 พร้อมกับ set ค่าให้ส่วน previous ของโหนดแรกของ Linked List ให้ เป็น address ของโหนดใหม่ซึ่งเก็บค่า 2
// ต่อมา set ส่วน next ของโหนดใหม่ ให้ชี้ไปยังโหนดแรก
// จากนั้นเปลี่ยนให้ first มาชี้ใหนดใหม่แทนเพราะขณะนี้โหนดใหม่เป็นโหนดแรกใน Linked List ตามคำสั่งและรูปข้างล่างนี้ นั่นคือให้ตัวแปร first เก็บ address ของโหนดใหม่ซึ่งเก็บค่า 2 อยู่



// 5. ใส่โหนดใหม่เข้าไปตรงกลางของ  Doubly Linked List (addMiddle)
// 	ถ้าต้องการใส่โหนดใหม่ซึ่งมีค่า 7 เข้าไปตรงกลางของ LinkedList คือให้อยู่ระหว่างโหนดที่มีค่า 6 กับโหนดที่มีค่า 8

// เลื่อนตัวชี้ start ไปยังโหนดคาดว่าจะอยู่ต่อจากโหนดที่จะใส่เข้าไปใหม่ ในที่นี้ให้ start ไปชี้ยังโหนดที่เก็บค่า 8 โดยเริ่มต้นให้ start เท่ากับ first




// เมื่อ start ชี้ไปยังโหนดที่เก็บค่า 8 แล้ว ให้ set ส่วน previous ของโหนดใหม่ซึ่งเก็บค่า 7 และมีตัวชี้ t ชี้อยู่ ให้ไปชี้ยังโหนดก่อนหน้าในที่นี้คือโหนดที่เก็บค่า 6 และ set ส่วน next ของโหนดใหม่ ให้ไปชี้โหนดที่ตามหลังในที่นี้คือโหนดที่เก็บค่า 8 ซึ่งตัวชี้ start ชี้อยู่ ตาม 3 คำสั่งข้างล่างนี้ตามลำดับ ซึ่งจะได้ดังรูปข้างล่างนี้









// จากนั้น ให้ set ส่วน next ของโหนดก่อนหน้าให้เป็นโหนดใหม่ และ set ส่วน previous ของโหนดที่ตามมาให้ชี้ไปยังโหนดใหม่ตาม 2 คำสั่งข้างล่างนี้ตามลำดับ ในที่สุดจะได้ผลลัพธ์ดังรูปข้างล่างนี้









// 3.2.3 การลบโหนดออกจาก Doubly Linked List (method remove)
// มีความเป็นไปได้ที่โหนดที่ต้องการลบจะเป็น โหนดแรก โหนดกลาง หรือโหนดท้าย
// 1. ลบโหนดแรก (removeFront)
// ถ้าต้องการลบโหนดที่มีค่า 4 ข้างล่างนี้ ซึ่งเป็นโหนดแรก

// ให้ย้าย first ไปชี้ที่โหนดที่สองแทนโหนดแรก และให้ set ส่วน previous ของโหนดที่สองซึ่งตอนนี้ first ชี้อยู่ ให้กลายเป็น null ดัง 2 คำสั่งข้างล่างนี้ เพราะฉะนั้นขณะนี้โหนดที่สองนี้ได้กลายเป็นโหนดแรกของ Linked List ดังรูปข้างล่าง


//           2. ลบโหนดกลาง (removeMiddle)
// ถ้าต้องการลบโหนดที่มีค่า 6 ข้างล่างนี้ ซึ่งเป็นโหนดกลาง

// 	เนื่องจากตัวชี้ first เลื่อนไม่ได้ จึงต้องสร้างตัวชี้อีกตัวหนึ่งมาเพื่อเลื่อนไปยังไหนดที่ต้องการลบ ในที่นี้ตัวชี้นั้นชื่อ start ก่อนที่จะเลื่อนตัวชี้ start กำหนดให้  start เท่ากับ first หมายความว่าให้  start เริ่มต้นชี้ที่โหนดแรก

// จากนั้นเลื่อนตัวชี้ start ไปยังโหนดที่ต้องการลบ

// จากนั้นกำหนดค่าในส่วน previous ของโหนดที่อยู่ถัดจากโหนดที่ต้องการลบ(โหนดที่มีค่า 8) ให้ให้เป็น address ของโหนดที่อยู่ก่อนหน้าโหนดที่ต้องการลบ(โหนดที่มีค่า 4)  ซึ่งโหนดที่ต้องการลบมี start ชี้อยู่ จากนั้นกำหนดค่าในส่วน next ของโหนดที่อยู่ก่อนหน้าตัวที่ต้องการลบ(โหนดที่มีค่า 4) ให้ให้เป็น address ของโหนดที่อยู่ถัดจากโหนดที่ต้องการลบ(โหนดที่มีค่า 8) ดัง 2 คำสั่ง ข้างล่างตามลำดับ ดังนั้นจะได้ผลลัพธ์ดังภาพข้างล่างนี้


// 3 ลบโหนดท้าย (removeEnd)
// ถ้าต้องการลบโหนดที่มีค่า 12 ข้างล่างนี้ ซึ่งเป็นโหนดท้ายสุด

// 	ก่อนที่จะเลื่อนตัวชี้  start กำหนดให้  start เท่ากับ first หมายความว่าให้ start เริ่มต้นชี้ที่โหนดแรก







// เลื่อนตัวชี้ start โดย start จะไปหยุดยังไหนดที่ต้องการลบซึ่งคือโหนดท้ายสุด ดังคำสั่งและรูป 3 รูปข้างล่างนี้





// 	ตัดโหนดท้ายสุดซึ่งคือโหนดที่เก็บค่า 12 ออกโดย กำหนดค่าของส่วน next ของโหนดก่อนหน้าโหนดที่ต้องการลบ(โหนดที่มีค่า 8) ให้กลายเป็น null นั่นคือไม่มี address ของโหนดถัดไป แสดงให้เห็นว่าขณะนี้โหนดที่เก็บค่า 8 กลายเป็นโหนดสุดท้ายแล้วดังคำสั่งและรูปข้างล่างนี้


// 3.2.4 Implement Sort โดยใช้ Doubly Linked List
// ถึงเวลาที่จะสร้างโครงสร้างข้อมูลโดยใช้ Doubly Linked List อันดับแรกต้องมี Abstract Data Type ของ Sort ก่อน ซึ่งก็คือส่วน interface Sort ซึ่งมีทั้งหมด 4 methods

// public interface Sort {

//   public void add(Object e);
//   public void remove(Object e);
//   public boolean contains(Object e);
//   public boolean isEmpty();
// }
// ก่อนที่จะสร้างโครงสร้างข้อมูลโดยใช้ Doubly Linked List ต้องมีคลาสโหนดเพื่อเอาไว้สร้างโหนดเพื่อเก็บข้อมูลแต่ละตัว ดังอธิบายไว้ในส่วน 3.2.1 ข้างบน
// public class DBLNode {
//    private Object data;
//    private DBLNode prev;
//    private DBLNode next;
//     public  DBLNode(Object obj) {
//       data =  obj;
//       prev = null;
//        next = null;
// }
// public void SetPrev(DBLNode  n) {
//    prev = n;
// }
//  public void SetNext(DBLNode  n) {
//    next = n;
// }
// public void SetData(Object  d)
//    data = d;
// }
// public DBLNode getPrev() {
//    return prev;
// }
// public DBLNode getNext() {
//    return next;
// }
// public Object getData()  {
//    return data;
// }
// }

// มาถึงการสร้างโครงสร้างข้อมูล Sort จากคลาส DoublySort ข้างล่างนี้ โดยใช้ Doubly Linked List ในการสร้างโครงสร้างข้อมูล
// - เริ่มจาก constructor ซึ่งแสดงถึงถังข้อมูลว่างเปล่า มีคำสั่ง คือ first = null;
// - method add ที่แตกต่างจาก Collection  เพราะว่า Collection จะใส่ข้อมูลข้างหน้า หรือต่อท้ายก็ได้เพราะแค่ต้องการใส่ข้อมูลเข้าไปในถังได้ก็พอ แต่ Sort เวลาใส่ข้อมูลใหม่เข้าไป ต้องตรวจสอบว่า ข้อมูลที่จะใส่เข้าไปควรต้องไปอยู่ที่ลำดับเท่าไหร่ เช่น เดิมมีข้อมูล   3, 8, 10, 35 อยู่ ถ้าจะใส่ 9 เข้าไป ต้องเอาเข้าไปไว้ระหว่าง โหนดที่เก็บข้อมูล 8 และ โหนดที่เก็บข้อมูล 10 จะแทรกหน้า หรือเอาไปต่อท้ายของ Linked List ไม่ได้ เพราะฉะนั้นข้อมูลที่จะใส่เข้าไปในถัง Sort มีโอกาสที่จะแทรกเข้าไปข้างหน้าสุดของ Linked List หรือ จะแทรกเข้าไปตรงกลางของ Linked List หรือ จะถูกนำไปต่อท้ายสุดของ Linked List โดยมีขั้นตอนการทำงานดังที่อธิบายไว้ข้างบนในหัวข้อ 3.2.2  addEnd , addFront และ addMiddle
// - method remove มีโอกาสที่จะลบได้อยู่ 3 แบบคือ ลบโหนดแรก ลบโหนดตรงกลาง หรือ ลบโหนดท้ายสุดของ Linked List   เนื่องจาก Sort มีการเรียงลำดับของค่าข้อมูลในLinked List อยู่แล้ว เพราะฉะนั้น เลื่อนตัวชี้ start ไปถึงแค่โหนดที่มีค่ามากกว่าตัวที่ต้องการลบ (ถ้าเรียงลำดับค่าข้อมูลจากน้อยไปหามาก) แต่ยังไม่พบตัวที่ต้องการค้นหา แสดงว่าจะไม่เจอตัวที่ต้องการลบ จึงหยุดเลื่อนตัวชี้ นั่นคือหยุดการค้นหาโดยไม่ต้องค้นหาไปยังโหนดสุดท้ายของ Linked List  จากนั้นตรวจสอบว่าตัวที่ต้องการลบเป็นโหนดแรก โหนดกลาง หรือโหนดท้ายของ Linked List จากนั้นทำตามขั้นตอนการทำงานดังที่อธิบายไว้ข้างบนในหัวข้อ 3.2.3
// - method contains โครงสร้างข้อมูล Sort จะมีส่วนต่างจาก method contains ของโครงสร้างข้อมูล Collection เฉพาะตรงที่จะเลื่อนตัวชี้ start ไปยังโหนดที่ต้องการค้นหา คือเมื่อเจอโหนดที่มีค่ามากกว่าตัวที่ต้องค้นหา (ถ้าเรียงลำดับค่าข้อมูลจากน้อยไปหามาก) แต่ยังไม่พบตัวที่ต้องการค้นหา แสดงว่าไม่เจอตัวที่ต้องการค้นหา จึงหยุดเการค้นหาได้เลย เหตุผลเดียวกับ method remove ข้างบนนี้
// -method isEmpty()  เหมือนกันทั้งใน Collection และ Sort คือแค่ตรวจสอบว่าถ้าตัวชี้ first ไม่มีแม้แต่โหนดเดียวให้ชี้ไป หรือ first = null แสดงว่าถังข้อมูลนี้ว่างเปล่า
// ส่วน method ที่เสริมขึ้นมาไม่อยู่ใน Sort  ADT คือ method printlist() มีไว้เพื่อแสดงออกทางหน้าจอว่าขณะนี้ใน Linked List ว่ามีข้อมูลอะไรอยู่บ้างตั้งแต่โหนดแรกจนถึงโหนดสุดท้าย method นี้ทำงานโดยทำการเลื่อนตัวชี้ start ไปทีละโหนดแล้ว print ค่าของโหนดนั้นออกมา ทำจนกระทั่งสิ้นสุด Linked List

// public class DoublySort implements Sort {
//     private MyNode first;
//     private int size;
//     public DoublySort()  {//เริ่มต้นถังข้อมูลว่างเปล่า
//         first = null;
//         size = 0;
//     }
//     public boolean isEmpty() //ถามว่าถังข้อมูลว่างหรือไม่ ถ้าว่าง first = null
//  {        return first == null;           //size == 0;
//     }
//     public int size(){ // แสดงว่าในถังมีข้อมูลอยู่กี่ตัว
//         return size;
//     }
//   public void printList(){// แสดงข้อมูลทุกตัวใน Linked List
//        DBLNode start = first;
//             while(start != null){
//             System.out.print(start.getData()+ "\t");
//             start = start.getNext();
//         }
//         System.out.println();
//         System.out.println("------------------------------------------------");
//     }
//     public boolean contains(Object o){
//         DBLNode start = first;
//         Integer value = (Integer) o;
//         while(start != null && !(start.getData().equals(o))){
//             Integer nodeData = (Integer)start.getData();
//             //ถ้าเจอโหนดทีมีค่าข้อมูลมากกว่าตัวที่ต้องการค้นหาให้หยุด แสดงว่าไม่เจอ
//             if(nodeData>value)
//                 return false;
//             start = start.getNext();
//         }
// // ถ้าหลุดจาก Loop โดย start ยังชี้ที่โหนดใดโหนดหนึ่งใน Linked List แสดงว่า พบตัวที่ต้องการ ค้นหา o
//         return start != null;
//     } // จบ method contains

//     public void add(Object value){
//             if(contains(value)){ // ถ้ามีข้อมูลที่จะใส่เข้าไปอยู่ใน Linked List อยู่แล้ว
//                 System.out.println(value + " has already existed in List"); // แจ้งว่ามีอยู่แล้ว
//                 return;         //ไม่ทำการ add ให้ออกจาก method
//             }
//             else
//                 System.out.println("Add Value: " + value);
//             if(isEmpty()){    //ถ้าข้อมูลที่จะใส่เข้าไปเป็นข้อมูลตัวแรกและตัวเดียวของ Linked List
//                   DBLNode tmp = new DBLNode(value);
//                   tmp.setNext(first);
//                    first.setPrev(tmp);
//                   first= tmp;
//                 size++;
//             }
//             else{
//                 DBLNode start = first;
//                 int nodeData = (Integer)start.getData();
//                 int intValue = (Integer)value;

//                 if(intValue < nodeData){   //แทรกข้อมูลตัวใหม่เข้าไปหน้าสุดของ linked List
//                     first = new MyNode(value);
//                      first.setNext(start);
//                     start.setPrev(first);
//                 }
//                 else{
//                     while (start != null && nodeData < intValue){

//                         start = start.getNext();
//                         if (start != null)
//                             nodeData = (Integer)start.getData();
//                     }
//                     if (start != null){       //แทรกข้อมูลตัวใหม่เข้าไปตรงกลางดของ Linked List
//                         DBLNode tmp = new DBLNode(value);
//                         tmp.setPrev(start.getPrev());
//                          tmp.setNext(start);
//                         start.getPrev().setNext(tmp);
//                         start.setPrev(tmp);
//                     }
//                     else{               //แทรกข้อมูลตัวใหม่เข้าไปท้ายสุดของ Linked List
//                         DBLNode tmp = new DBLNode(value);
//                         tmp.setPreve(start);
//                         start.getPreve().setNext(tmp);
//                     }
//                 }
//                 size++;
//            }
//     }

// public void remove(Object value){
//         if(isEmpty()) //กรณีถังว่าง จะไม่ทำการลบใด ๆ
//             return;  //ออกจาก method
//         else
//             System.out.println("Remove Value: " + value);

//         MyNode pre = null, start = first;
//         int nodeData = (Integer)start.getData();
//         int intValue = (Integer)value;
//           // ตรงที่เช็ค nodeData < intValue คือเช็คว่าถ้าเจอโหนดที่มากกว่าข้อมูลที่ต้องการลบแสดงว่าไม่เจอ ให้หยุดค้นหา
//           while(start.getNext() != null && !(start.getData().equals(value)) && (nodeData < intValue)){
//                         start = start.getNext();
//             nodeData = (Integer)start.getData();
//         }

//         if(!(start.getData().equals(value))) //กรณีไม่พบข้อมูลที่ต้องการลบในที่นี้คือ value
//             System.out.println("Object " + value + ": Not Found!");
//         else {
//             if(start == first){                         //กรณีลบโหนดแรกสุดของLinked List
//                 first = first.getNext();
//                 first.setPrev(null);
//             }



//             else {
//                 if(start.getNext() != null){            //กรณีลบโหนดตรงกลางของ Linked List

//                    start.getPreve() .setNext(start.getNext());
//                     start.getNext().setPrev(pre);
//                 }
//                 else
//                     start.getPreve().setNext(null);                  //กรณีลบโหนดท้ายสุดของ Linked List
//             }
//            size--;
//         }
//     }
// }


// แบบฝึกหัดท้ายบท
// 1. จงเขียนโปรแกรมสร้าง Data Structure Collection โดยใช้ Circular Linked list    ซึ่งมีรายละเอียดของโปรแกรม   ดังนี้
//     1. สร้าง Interface ชื่อ Collection เพื่อระบุรายการของ method ต่าง ๆ ที่จำเป็นในการสร้าง Data Structure Collection โดยใช้ Circular Linked list   ดังนี้
// - add   		สำหรับเพิ่มโหนดข้อมูลเข้าทางด้านหน้าของการโยง
// - remove 	สำหรับลบโหนดข้อมูลที่ต้องการ
// - contains 	สำหรับค้นหาโหนดข้อมูลที่ต้องการ
// - isEmpty	สำหรับตรวจสอบว่ามีโหนดข้อมูลภายในรายการโยงแบบวนนี้หรือไม่
// - size		สำหรับตรวจสอบขนาดของรายการโยงแบบวน

//     2. สร้างคลาสชื่อ MyNode เพื่อระบุ attribute และ method ของโหนดข้อมูล
//     3. สร้างคลาสชื่อ CirLink เพื่อสร้าง Data Structure Collection โดยใช้ Circular Linked list    โดย implement จาก Interface ชื่อ Collection และทำให้ abstract methods ใน Interface นี้เป็น method ที่สมบูรณ์     นอกจากนี้    สร้าง method printList เพื่อแสดงผลข้อมูลทั้งหมดในรายการโยงแบบวน  ออกมาทางจอภาพ
//     4. สร้างคลาสชื่อ Main เพื่อตรวจสอบการทำงานของ CirLink โดยแสดงผลลัพธ์ที่ได้ออกมาทางจอภาพด้วย method printList หลังจากที่ได้ดำเนินการต่าง ๆ  ดังนี้
//         4.1 เพิ่มข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 20  30  50  และ 80 ลงในรายการโยงแบบวน
//         4.2 แสดงผลขนาดของรายการโยงแบบวนออกมาทางจอภาพ
//         4.3 ลบข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 20  และ 50 ออกจากรายการโยงแบบวน
//         4.4 ลบข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 90 ออกจากรายการโยงแบบวน
//         4.5 ค้นหาข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 30 ในรายการโยงแบบวน
//         4.6 ค้นหาข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 100 ในรายการโยงแบบวน

// 2. จงเขียนโปรแกรมสร้าง Data Structure Doubly Sort Collection โดยใช้ Linked list   ซึ่งมีการเรียงลำดับค่าของข้อมูลภายใน Collection และไม่สามารถใช้ index ในการเข้าถึงข้อมูลต่าง ๆ ภายใน Collection นี้ได้โดยมีรายละเอียดของโปรแกรม ดังนี้
//     1. สร้าง interface ชื่อ Collection เพื่อระบุรายการของ method ต่าง ๆ ที่จำเป็นในโครงสร้างข้อมูลแบบ Collection ซึ่งมีการเรียงลำดับของข้อมูลภายใน Collection นั้นด้วย    ดังนี้
// - add   	เพิ่มโหนดข้อมูลเข้าไปใน Collection  โดยคำนึงถึงการเรียงลำดับค่าของข้อมูลภายใน Collection นี้ด้วย   เช่น ถ้าโหนดข้อมูลที่ต้องการจะเพิ่มเข้าไปใน Collection มีค่ามากกว่าค่าของข้อมูลในลำดับที่ 4   แต่น้อยกว่าค่าของข้อมูลในลำดับที่ 5    ให้เพิ่มโหนดข้อมูลนั้นเข้าไปเป็นลำดับที่ 5 ของ Collection และเลื่อนโหนดข้อมูลลำดับที่ 5 เดิมเป็นลำดับที่ 6 แทน   เป็นต้น
// - remove 	ลบโหนดข้อมูลที่ต้องการ   โดยเข้าถึงและเปรียบเทียบค่าของโหนดข้อมูลที่ต้องการลบกับค่าของข้อมูลที่ได้รับการเรียงลำดับแล้วภายใน Collection เพื่อดำเนินการลบโหนดข้อมูลที่ต้องการ
// - contains 	ค้นหาโหนดข้อมูลที่ต้องการ
// - isEmpty	ตรวจสอบว่ามีโหนดข้อมูลภายใน Collection นี้หรือไม่
// - size		ตรวจสอบขนาดของ Collection
//     2. สร้างคลาสชื่อ MyNode    เพื่อระบุ attribute และ method ของโหนดข้อมูล
//     3. สร้างคลาสชื่อ DoublySort เพื่อสร้าง Data Structure Doubly Sort Collection โดยใช้ Linked list ซึ่งมีการเรียงลำดับค่าของข้อมูลภายใน Collection และไม่สามารถใช้ index ในการเข้าถึงข้อมูลต่าง ๆ ภายใน Collection นี้ได้  โดย implement จาก Interface ชื่อ Collection และทำให้ abstract methods ใน Interface นี้เป็น method ที่สมบูรณ์     นอกจากนี้    สร้าง method printList เพื่อแสดงผลข้อมูลทั้งหมดใน Collection ออกมาทางจอภาพ
//     4. สร้างคลาสชื่อ Main เพื่อตรวจสอบการทำงานของ Doubly Sort Collection นี้  โดยแสดงผลลัพธ์ที่ได้ออกมาทางจอภาพด้วย method printList ทุกครั้ง   หลังจากที่ได้ดำเนินการต่าง ๆ  ดังนี้
//         4.1 เพิ่มข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 20 และ 30 ลงใน Collection
//         4.2 เพิ่มข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 10  25 และ 40 ลงใน Collection ตามลำดับ
//         4.3 แสดงผลขนาดของ Doubly Sort Collection นี้ออกมาทางจอภาพ
//         4.4 ลบข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 30  10 และ 40  ออกจาก Collection ตามลำดับ
//         4.5 ลบข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 45 ออกจาก Collection
//         4.6 ค้นหาข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 30 ใน Collection
//         4.7 ค้นหาข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 25 ใน Collection






// บทที่ 4 ต้นไม้
// ต้นไม้คือโครงสร้างข้อมูลที่ใช้เก็บข้อมูลแต่ละตัวในโหนด โดยโหนดจะเรียงเหมือนต้นไม้คว่ำนั่นคือ เริ่มต้นจากรากของต้นไม้ (root) และมีลูกลงมา (Child Node)  จนกระทั่งถึงโหนดล่างสุดที่ไม่มีลูก ซึ่งเรียกว่าใบ หรือ (Leaf Node)  ต้นไม้จะมี level โดยเริ่มจาก Level 0 ที่ root ดังรูปข้างล่างนี้

// ส่วนคำว่า sub tree หรือต้นไม้ย่อย มีทั้งต้นไม้ย่อยด้านซ้าย และ ต้นไม้ย่อยด้านขวา จากรูปข้างบน ต้นไม้ย่อยด้านซ้ายของโหนด 1 คือ

// จากรูปข้างบน ต้นไม้ย่อยด้านขวาของโหนด 1 คือ


// 4.1 Binary tree
// คือต้นไม้ที่มีลูกได้ไม่เกิน 2 นั่นคือมีโอกาสมีลูกได้ 0, 1 หรือ 2 โหนด
// 4.1.1 โหนดของต้นไม้
// โหนดจะประกอบด้วย 3 ส่วน คือ
//     • ส่วนที่เก็บข้อมูล คือส่วนบนสุดของรูปข้างล่างนี้
//     • ส่วนที่เก็บ address ของลูกทางด้านซ้าย หรือตัวชี้ทางซ้าย คือส่วนด้านล่างซ้ายของรูปข้างล่างนี้
//     • ส่วนที่เก็บ address ของลูกทางด้านขวา หรือตัวชี้ทางขวา คือส่วนด้านล่างขวาของรูปข้างล่างนี้

// ตัวอย่างของโหนดที่ไม่มีลูก นั่นคือลูก 0
// จะเห็นว่าส่วนที่เก็บ address ของลูกทางด้านซ้าย และทางขวา จะเป็นnull คือไม่มี โหนดให้ชี้ไปนั่นเอง ดังรูปข้างล่างนี้

// ตัวอย่างของโหนดที่มีลูก 1 ตัวอยู่ ทางด้านซ้าย
// จะเห็นว่าส่วนที่เก็บ address ของลูกทางด้านขวาจะเป็น null คือไม่มี โหนดให้ชี้ไปนั่นเอง แต่ทางด้านซ้ายจะเก็บ address ของโหนดลูกทางซ้าย นั่นคือมีตัวชี้ไปทางซ้าย ดังรูปข้างล่างนี้




// ตัวอย่างของโหนดที่มีลูก 1 ตัวทางด้านขวา
// จะเห็นว่าส่วนที่เก็บ address ของลูกทางด้านซ้ายจะเป็น null คือไม่มี โหนดให้ชี้ไปนั่นเอง แต่ทางด้านขวาจะเก็บ address ของโหนดลูกทางขวา นั่นคือมีตัวชี้ไปทางขวาดังรูปข้างล่างนี้

// จะสร้างโหนดของต้นไม้ได้ก็ต้องมีคลาสโหนด ในคลาสโหนดมี instance variable 3 ตัวคือ data , left และ right ไว้เก็บข้อมูล, เก็บ address ของโหนดลูกทางซ้าย และ เก็บaddress ของโหนดลูกทางขวาตามลำดับ จึงมี instance methods อยู่ 6 methods สำหรับดึงข้อมูล (get) และ เปลี่ยนข้อมูลใหม่ (set) บน ข้อมูล data, ตัวชี้ด้านซ้าย และตัวชี้ด้านขวา

// public class BTNode {
//         	private Object data;
//         	private BTNode left;
// 	private BTNode right;

// 	public BTNode(Object obj, BTNode l, BTNode r){
// 		data = obj;
//                 	left = l;
// 		right = r;
// 	}
//         	public void setLeft(BTNode l){
// 		left = l;
// 	}
// 	public void setRight(BTNode r){
// 		right = r;
// 	}
//         	public BTNode getLeft(){
// 		return left;
// 	}
// 	public BTNode getRight(){
// 		return right;
// 	}
// 	public Object getData(){
// 		return data;
// 	}
// }

// 4.2 Binary Search Tree
//  คือ binary tree ที่มีเงื่อนไขดังนี้
//     1. ลูกด้านซ้ายต้องมีค่าน้อยกว่าโหนดแม่
//     2. ลูกด้านขวาต้องมีค่ามากกว่าโหนดแม่

// ตัวอย่างของ binary search Tree







// ตัวอย่างข้างล่างนี้ ไม่ใช่ binary search Tree

// เพราะลูกด้านขวาไม่มากกว่าโหนดแม่
// 4.2.1 การสร้าง Binary Search Tree
// ขั้นตอนการสร้าง binary search tree
// ถ้ามีข้อมูลเข้าคือ: 8, 10, 1, 3, 9, 2, 4, 12


// จากรูปข้างบน เนื่องจาก 10 มีค่ามากกว่า 8 จึงนำไปเชื่อมต่อเป็นลูกด้านขวาของโหนดที่เก็บค่า 8


// จากรูปข้างบน เนื่องจาก 1 มีค่าน้อยกว่า 8 จึงนำไปเชื่อมต่อเป็นลูกด้านซ้ายของโหนดที่เก็บค่า 8


// จากรูปข้างบน เนื่องจาก 3 มีค่าน้อยกว่า 8 จึงท่องไปทางด้านซ้ายของโหนดที่เก็บค่า 8 เมื่อเจอโหนดที่เก็บค่า 1 ให้เปรียบเทียบว่า 3 มากกว่าหรือน้อยกว่า 1 ตามความจริง 3 มีค่ามากกว่า 1 จึงนำโหนด 3 ไปเชื่อมต่อเป็นลูกด้านขวาของโหนดที่เก็บค่า 1



// จากรูปข้างบน เนื่องจาก 9 มีค่ามากกว่า 8 จึงท่องไปทางด้านขวาของโหนดที่เก็บค่า 8 เมื่อเจอโหนดที่เก็บค่า 10 ให้เปรียบเทียบว่า 9 มากกว่าหรือน้อยกว่า 10 ตามความจริง 9 มีค่าน้อยกว่า 10 จึงนำโหนด 9 ไปเชื่อมต่อเป็นลูกด้านซ้ายของโหนดที่เก็บค่า 10

// จากรูปข้างบน เนื่องจาก 2 มีค่าน้อยกว่า 8 จึงท่องไปทางด้านซ้ายของโหนดที่เก็บค่า 8 เมื่อเจอโหนดที่เก็บค่า 1 ให้เปรียบเทียบว่า 2 มากกว่าหรือน้อยกว่า 1 ตามความจริง 2 มีค่ามากกว่า 1 จึงท่องไปทางด้านขวาของโหนด 1 ไปเจอโหนด 3 จึงทำการเปรียบเทียบอีก เนื่องจาก 2 มีค่าน้อยกว่า 3 จึงนำโหนด 2 ไปเชื่อมต่อเป็นลูกด้านซ้ายของโหนดที่เก็บค่า 3


// จากรูปข้างบน เนื่องจาก 4 มีค่าน้อยกว่า 8 จึงท่องไปทางด้านซ้ายของโหนดที่เก็บค่า 8 เมื่อเจอโหนดที่เก็บค่า 1 ให้เปรียบเทียบว่า 4 มากกว่าหรือน้อยกว่า 1 ตามความจริง 4 มีค่ามากกว่า 1 จึงท่องไปทางด้านขวาของโหนด 1 ไปเจอโหนด 3 จึงทำการเปรียบเทียบอีก เนื่องจาก 4 มีค่ามากกว่า 3 จึงนำโหนด 4 ไปเชื่อมต่อเป็นลูกด้านขวาของโหนดที่เก็บค่า 3


// จากรูปข้างบน เนื่องจาก 12 มีค่ามากกว่า 8 จึงท่องไปทางด้านขวาของโหนดที่เก็บค่า 8 เมื่อเจอโหนดที่เก็บค่า 10 ให้เปรียบเทียบว่า 12 มากกว่าหรือน้อยกว่า 10 ตามความจริง 12 มีค่ามากกว่า 10  จึงนำโหนด 12 ไปเชื่อมต่อเป็นลูกด้านขวาของโหนดที่เก็บค่า 10

// 4.2.2 การลบโหนดใน Binary Search Tree
// เนื่องจาก binary search tree มีลูกไม่เกิน 2 เพราะฉะนั้นโหนดที่จะลบ มีโอกาสที่ จะมี ลูก 0 หรือ ลูก 1 หรือ เป็นโหนดที่มีลูก 2
// กรณีลบโหนดที่มีลูก 0
//  - กรณีโหนดที่จะลบเป็น root

// เมื่อลบแล้ว root จะเท่ากับ null นั่นคือไม่มีโหนดเหลืออยู่บนต้นไม้ ดังคำสั่งและรูปข้างล่างนี้

// - กรณีที่โหนดที่จะลบเป็นลูกด้านซ้ายของแม่

// ลบโดยการ set ตัวชี้ด้านซ้ายของแม่ให้เป็น null นั่นคือแม่จะไม่มีลูกทางด้านซ้ายแล้ว ดังคำสั่งและรูปข้างล่างนี้







// - กรณีที่โหนดที่จะลบเป็นลูกด้านขวาของแม่

// ลบโดยการ set ตัวชี้ด้านขวาของแม่ให้เป็น null นั่นคือแม่จะไม่มีลูกทางด้านขวาแล้ว ดังคำสั่งและรูปข้างล่างนี้




// กรณีลบโหนดที่มีลูก 1
// กรณีโหนดที่จะลบเป็น root
// -กรณีโหนดที่จะลบเป็น root และมีลูก 1 ตัว ทางขวา

// ลบโดย set  root ให้กลายเป็นลูกด้านขวาของตัวที่ต้องการลบ ดังคำสั่งและรูปข้างล่างนี้


// - กรณีโหนดที่จะลบเป็น root และมีลูก 1 ตัว ทางซ้าย


// ลบโดย set  root ให้กลายเป็นลูกด้านซ้ายของตัวที่ต้องการลบ ดังคำสั่งและรูปข้างล่างนี้






// กรณีที่โหนดที่จะลบเป็นลูกด้านซ้ายของแม่
// กรณีที่โหนดที่จะลบเป็นลูกด้านซ้ายของแม่ แต่มีลูก 1 ตัวอยู่ด้านขวา ดังรูปข้างล่างนี้

// ลบโดย set ตัวชี้ด้านซ้ายของโหนดแม่ของโหนดที่ต้องการลบ ให้ชี้ไปยังลูกด้านขวาของโหนดที่ต้องการลบ ดังคำสั่งและรูปข้างล่างนี้

//     • กรณีที่โหนดที่จะลบเป็นลูกด้านซ้ายของแม่ แต่มีลูก 1 ตัวอยู่ด้านซ้าย

// ลบโดย set ตัวชี้ด้านซ้ายของโหนดแม่ของโหนดที่ต้องการลบ ให้ชี้ไปยังลูกด้านซ้ายของโหนดที่ต้องการลบ ดังคำสั่งและรูปข้างล่างนี้


// กรณีที่โหนดที่จะลบเป็นลูกด้านขวาของแม่
//     • กรณีที่โหนดที่จะลบเป็นลูกด้านขวาของแม่ แต่มีลูก 1 ตัวอยู่ด้านขวา

// ลบโดย set ตัวชี้ด้านขวาของโหนดแม่ของโหนดที่ต้องการลบ ให้ชี้ไปยังลูกด้านขวาของโหนดที่ต้องการลบ ดังคำสั่งและรูปข้างล่างนี้


//     •
//     • กรณีที่โหนดที่จะลบเป็นลูกด้านขวาของแม่ แต่มีลูก 1 ตัวอยู่ด้านซ้าย

// ลบโดย set ตัวชี้ด้านขวาของโหนดแม่ของโหนดที่ต้องการลบ ให้ชี้ไปยังลูกด้านซ้ายของโหนดที่ต้องการลบ ดังคำสั่งและรูปข้างล่างนี้



// กรณีโหนดที่จะลบมีลูก 2
//  ทำได้ 2 วิธีคือ
//     1. เลือกโหนดที่มีค่ามากที่สุดที่น้อยกว่าโหนดที่ต้องการลบ นั่นคือโหนดขวาล่างสุดของต้นไม้ย่อยทางด้ายซ้าย ( left sub tree) ของโหนดที่ต้องการลบ
//     2. เลือกโหนดที่มีค่าน้อยที่สุดที่มากกว่าโหนดที่ต้องการลบ นั่นคือโหนดซ้ายล่างสุดของต้นไม้ย่อยทางด้านขวา (right  sub tree) ของโหนดที่ต้องการลบ
// เมื่อได้โหนดจากข้อ1 หรือ ข้อ 2 แล้ว ให้นำค่าของหนึ่งในโหนดนี้ไปทับค่าของโหนดที่ต้องการลบ จากนั้น ทำการลบโหนด ที่ได้จากข้อ1 หรือ ข้อ 2 นั้นทิ้ง
// ข้างล่างนี้จะแสดงทำการลบเฉพาะวิธีที่ 1
// ถ้าจะลบโหนดที่เก็บค่า 31  ซึ่งมีลูก 2 จะมีขั้นตอนดังนี้
//     1.  เลือกโหนดที่มีค่ามากที่สุดที่น้อยกว่าโหนดที่ต้องการลบ นั่นคือโหนดขวาล่างสุดของต้นไม้ย่อยทางด้ายซ้าย ( left sub tree) ของโหนดที่ต้องการลบ นั่นคือโหนดที่เก็บค่า 30
//     2. เอาค่า 30 ไปทับค่า ในโหนด 31
//     3. ลบโหนดเดิมที่เก็บค่า 30 ทิ้ง
// ทำการเลื่อนตัวชี้ start ให้ไปชี้อยู่ที่โหนดที่ต้องการลบ ส่วนตัวชี้ pre ให้ไปชี้อยู่ที่โหนดแม่ของโหนดที่ต้องการลบ ดังรูปข้างล่างนี้


// กำหนดให้ตัวชี้ pre2 ชี้ที่เดียวกับตัวชี้ start และให้ตัวชี้ cur ชี้ที่ root ของ left sub tree  ดังคำสั่งและรูปข้างล่างนี้













// จากนั้นเลื่อนตัวชี้ cur ม่งหน้าไปยังโหนดขวาล่างสุดโดยมีตัวชี้ pre2 ขยับตามมา  ดังคำสั่งและรูปข้างล่างนี้

// จากนั้นเลื่อนตัวชี้ cur มุ่งหน้าไปยังโหนดขวาล่างสุดโดยมีตัวชี้ pre2 ขยับตามมา ดังคำสั่งและรูปข้างล่างนี้










// ขณะนี้ตัวชี้ cur มาถึงโหนดที่มากที่สุดที่น้อยกว่าโหนดที่ต้องการลบแล้ว นั่นคือ ตัวชี้ cur มาชี้โหนดที่เก็บค่า 30 แล้ว ดังคำสั่งและรูปข้างล่างนี้








// จากนั้นนำค่าในโหนดที่ cur ชี้อยู่ ไปทับค่าในโหนด start ซึ่งคือโหนดที่ตั้งใจจะลบ ดังคำสั่งและรูปข้างล่างนี้





// จากนั้นลบโหนดเดิมที่เก็บค่า 30 ทิ้ง โดยการ set ส่านตัวชี้ทางขวาของโหนดแม่ของโหนด 30 ซึ่งมีตัวชี้ pre2 ชี้อยู่ ไปเป็น address  ของโหนดลูกทางซ้ายของโหนด 30 ดังรูปข้างล่างนี้  เพราะว่าโหนด 30 เป็นโหนดขวาล่างสุดจึงไม่มีทางมีลูกด้านขวาได้อีก ดังคำสั่งและรูปข้างล่างนี้













// ตัวอย่างที่  2 กรณีที่ไม่มีโหนดขวาล่างสุดของ left sub tree


// กำหนดให้ตัวชี้ pre2 ชี้ที่เดียวกับตัวชี้ start และให้ตัวชี้ cur ชี้ที่ root ของ left sub tree  ดังรูปข้างล่างนี้

// เนื่องจากไม่มีโหนดด้านขวาของตัวชี้ cur จึงหมายความว่า ตัวชี้ cur เก็บค่าที่มีค่ามากสุดใน left sub tree ของ ตัวที่ต้องการลบซึ่งคือตัวที่ตัวชี้ start ชี้อยู่ จากนั้นนำค่าในโหนดที่ cur ชี้อยู่ ไปทับค่าในโหนด start ซึ่งคือโหนดที่ตั้งใจจะลบ ดังรูปข้างล่างนี้  นั่นคือโหนด 4 ถูกทับด้วยค่า 2  ดังรูปข้างล่างนี้





// จากนั้นลบโหนด 2 ที่ตัวชี้ cur ชี้อยู่ทิ้งโดยใช้คำสั่ง pre2.setLeft(cur.getLeft()); ได้ดังรูปข้างล่าง



// 4.3 การท่องเข้าไปในต้นไม้ (tree traversal)
// มีอยู่ 3 แบบ
//     1. Inorder คือการท่องไปที่ Left sub tree, Root, Right sub tree ตามลำดับ
//     2. Preorder คือการท่องไปที่ Root, Left sub tree, Right sub tree ตามลำดับ
//     3. Postorder คือการท่องไปที่ Left sub tree, Right sub tree, Root ตามลำดับ
// ตัวอย่างที่ 1

// ตัวอย่างที่ 2

// ตัวอย่างที่ 3

// 4.4 การสร้างโครงสร้างข้อมูลโดยใช้ Binary Search Tree
// ก่อนที่จะสร้างโครงสร้างข้อมูลโดยใช้ Binary Search Tree ต้องมีคลาสโหนดเพื่อเอาไว้สร้างโหนดเพื่อเก็บข้อมูลแต่ละตัว
// เนื่องจาก Binary Seach Tree เป็น Binary Tree จึงมีลักษณะของโหนด และ คลาสโหนดเหมือนที่อธิบายไว้ในส่วน 4.1.1

// public class BTNode {
//         	private Object data;
//         	private BTNode left;
// 	private BTNode right;

// 	public BTNode(Object obj, BTNode l, BTNode r){
// 		data = obj;
//                 	left = l;
// 		right = r;
// 	}
//         	public void setLeft(BTNode l){
// 		left = l;
// 	}
// 	public void setRight(BTNode r){
// 		right = r;
// 	}
//         	public BTNode getLeft(){
// 		return left;
// 	}
// 	public BTNode getRight(){
// 		return right;
// 	}
// 	public Object getData(){
// 		return data;
// 	}
// }

// มาถึงการสร้างโครงสร้างข้อมูล  จากคลาส  BinarySearchTree ข้างล่างนี้ โดยใช้ Binary Search Tree ในการสร้างโครงสร้างข้อมูล
// - เริ่มจาก constructor ซึ่งแสดงถึงถังข้อมูลว่างเปล่า มีคำสั่ง คือ root = null; นั่นคือไม่มีแม้แต่ root โหนด
// - method add(Object e) การที่จะเพิ่ม โหนดที่มีค่า e เข้าไปในต้นไม้ อันดับแรกต้องหาก่อนว่า ค่า e ควรไปอยู่ ณ ตำแหน่งไหนในต้นไม้ โดย while loop ใน method add ทำหน้าที่นี้ ซึ่งจะมีตัวชี้ start เริ่มต้นชี้ที่ root แล้วเลื่อนลงไปเรื่อย ๆจนกว่าจะเจอตำแหน่ง คือ ใน while loop จะคอยถามว่า ค่าที่ใส่เข้ามามีค่ามากกว่าหรือน้อยกว่าค่าของโหนดในต้นไม้ที่ตัวชี้ start ชี้อยู่ ถ้ามากกว่า ตัวชี้ start จะเลื่อนลงมาทางขวา  ถ้าน้อยกว่า ตัวชี้ start จะเลื่อนลงมาทางซ้าย และจะมีตัวชี้ pre เลื่อนตามตัวชี้ start มาติด ๆ ในที่สุดตัวชี้ pre จะมาชี้อยู่ที่ leaf node โหนดหนึ่งที่โหนดของค่าใหม่จะมาเชื่อมต่อเพื่อเป็นลูก  เมื่อออกจาก while loop จะได้แค่โหนดที่ pre ชี้อยู่คือโหนดที่โหนดใหม่จะมาเป็นลูก แต่ยังไม่รู้ว่าจะมาเป็นลูกด้านขวาหรือลูกด้านซ้าย จึงต้องถามโดยใช้ if ว่า ค่าของโหนดที่ pre ชี้อยู่มีค่ามากกว่าหรือน้อยกว่าค่าใหม่ที่จะใส่เข้าไป ถ้าค่าใหม่ที่ใส่เข้าไปมากกว่า โหนดที่ตัวชี้ pre ชี้อยู่  โหนดใหม่จะไปต่อเป็นลูกด้านขวาของโหนดที่ pre ชี้อยู่  แต่ถ้าค่าใหม่ที่ใส่เข้าไปน้อยกว่า โหนดที่ตัวชี้ pre ชี้อยู่  โหนดใหม่จะไปต่อเป็นลูกด้านซ้ายของโหนดที่ pre ชี้อยู่
// - method contains(Object e)  จะเลื่อนตัวชี้ start ไปยังโหนดที่ต้องการค้นหา จะคล้าย while loop ของ method add คือจะมีตัวชี้ start เริ่มต้นชี้ที่ root แล้วเลื่อนลงไปเรื่อย ๆจนกว่าจะเจอค่าที่ต้องการค้นหา คือ ใน while loop จะคอยถามว่า ค่า e มีค่ามากกว่าหรือน้อยกว่าค่าของโหนดในต้นไม้ที่ตัวชี้ start ชี้อยู่ ถ้ามากกว่า ตัวชี้ start จะเลื่อนลงมาทางขวา  ถ้าน้อยกว่า ตัวชี้ start จะเลื่อนลงมาทางซ้าย  ถ้าตัวชี้ start ไปหยุดที่ null แสดงว่าไม่พบค่าที่ต้องการค้นหา
// - method isEmpty()   คือตรวจสอบว่าถ้าตัวชี้ root ไม่มีแม้แต่โหนดเดียวให้ชี้ไป หรือ root = null แสดงว่าถังข้อมูลนี้ว่างเปล่า
// - method printTree() มีไว้เพื่อแสดงออกทางหน้าจอว่าขณะนี้ในต้นไม้ มีข้อมูลอะไรอยู่บ้างตั้งแต่โหนดแรกจนถึงโหนดสุดท้าย  ซึ่ง method นี้ทำงานโดย print ค่าของโหนดแต่ละโหนดออกมาซึ่งมีได้ 3 แบบ ตาม tree traversal คือ Preorder, InOrder หรือ PostOrder
// - method getMin() ทำหน้าที่ return ค่าที่มีค่าน้อยที่สุดในต้นไม้ออกมา โดยการให้ตัวชี้ start วิ่งไปหาโหนดซ้ายล่างสุดของต้นไม้ซึ่ง โหนดนั้นคือโหนดที่มีค่าน้อยสุด
// - method getMax() ทำหน้าที่ return ค่าที่มีค่ามากที่สุดในต้นไม้ออกมา โดยการให้ตัวชี้ start วิ่งไปหาโหนดขวาล่างสุดของต้นไม้ ซึ่งโหนดนั้นคือโหนดที่มีค่ามากสุด

// public class BinarySearchTree {

//     private BTNode root;
//     private int size;

//     public BinarySearchTree(){ //เริ่มต้นที่ถังข้อมูลว่างเปล่า
//         root = null;
//         size = 0;
//     }
//     public int size(){
//         return size;
//     }
//     public boolean isEmpty(){ //ถังข้อมูลนี้ว่างเปล่าหรือไม่
//         return root == null;    // โดยเช็คว่า root เท่ากับ null หรือไม่
//     }

//     public Object contains(Object e){ //ถังข้อมูลนี้บรรจุข้อมูล e หรือไม่
//         BTNode start;
//         start = root;
//         int value = (Integer) e;


//         while(start != null){
//             int BTNode = (Integer)start.getData();
//             if(BTNode == value)
//                 return true;
//             else{
//                 if(BTNode > value) //ถ้าค่าที่จะใส่เข้ามาน้อยกว่าโหนดปัจจุบันที่ start ชี้อยู่
//                     start = start.getLeft();  // เลื่อน start ลงทางซ้าย
//                 else //ถ้าค่าที่จะใส่เข้ามามากกว่าโหนดปัจจุบันที่ start ชี้อยู่

//                     start = start.getRight();// เลื่อน start ลงทางขวา

//             }
//         }
//         return false;    // ไม่พบข้อมูลที่ต้องการ
//     }

//     public void add (Object e){
//         if(e == null)
//             return;
//         BTNode start = root, pre = null;
//         BTNode tmp = new BTNode(e,null,null); // สร้างโหนดใหม่ที่เก็บค่า e
//         int value = (Integer) e;

//         if(root == null){ // ถ้าถังว่าง โหนดใหม่ที่เข้ามาจะเป็น root ของต้นไม้ทันที
//             root = tmp;
//             size++;
//         }



//         else{
//             while(start != null){
//                 pre = start;
//                 int BTNode = (Integer)start.getData();
//                 if(BTNode == value){
//                     System.out.println("Object: " + e +" has existed in the tree." );
//                     start = null;
//                     return;
//                 }
//                 else{
//                     if(BTNode > value)
//                         start = start.getLeft();
//                     else
//                         start = start.getRight();
//                 }
//             } // เมื่อจบ while loop จะได้โหนดแม่ของโหนดใหม่ ซึ่งโหนดแม่นี้จะมีตัวชี้ pre ชี้อยู่
//                 int curNode = (Integer)pre.getData();
//             if (curNode > value){ // ถ้าโหนดใหม่มีค่าน้อยกว่าโหนดที่ pre ชี้อยู่ให้โหนดใหม่ไปเป็นลูกด้านซ้าย
//                 pre.setLeft(tmp);
//                 size++;
//             }
//             else if(curNode < value){ // ถ้าโหนดใหม่มีค่ามากกว่าโหนดที่ pre ชี้อยู่ให้โหนดใหม่ไปเป็นลูกด้านขวา
//                 pre.setRight(tmp);
//                 size++;
//             }
//         }
//     }// end of Method ddd


//     public Object getMin(){
//         BTNode start = root;
//         if(start == null)
//             return null;
//         while(start.getLeft() != null){ // เลื่อนตัวชี้ start ไปที่โหนดซ้ายล่างสุดของต้นไม้
//             start = start.getLeft();
//         }
//         return start.getData(); // return ค่าของโหนดที่มีค่าน้อยสุดในต้นไม้
//     }

//     public Object getMax(){
//         BTNode start = root;
//         if(start == null)
//             return null;
//         while(start.getRight() != null){ // เลื่อนตัวชี้ start ไปที่โหนดขวาล่างสุดของต้นไม้
//             start = start.getRight();
//         }
//         return start.getData();// return ค่าของโหนดที่มีค่ามาก สุดในต้นไม้
//     }

//     public void printTree(){
//         BTNode r = root;
//         if(isEmpty()) //ถ้าถังว่างก็ print อะไรไม่ได้
//             System.out.println("Tree is empty.");

//         System.out.println("Preorder");
//         preOrder(r); // เรียก method การ print tree แบบ preOrder โดยใส่ root r ของต้นไม้เข้าไปใน method
//         System.out.println();


//         System.out.println("Inorder");
//         inOrder(r); // เรียก method การ print tree แบบ inOrder โดยใส่ root r ของต้นไม้เข้าไปใน method
//         System.out.println();
//         System.out.println("Postorder");
//         postOrder(r); // เรียก method การ print tree แบบ postOrder โดยใส่ root r ของต้นไม้เข้าไปใน method
//         System.out.println();
//     }
//      public void preOrder(BTNode r){ //การ print tree แบบ preOrder
//         if(r != null){
//             System.out.print(r.getData()+ "\t");
//             preOrder(r.getLeft());
//             preOrder(r.getRight());
//         }
//     }
//     public void inOrder(BTNode r){ //การ print tree แบบ inOrder
//         if(r != null){
//             inOrder(r.getLeft());
//             System.out.print(r.getData()+ "\t");
//             inOrder(r.getRight());
//         }
//     }
//     public void postOrder(BTNode r){ //การ print tree แบบ postOrder
//         if(r != null){
//             postOrder(r.getLeft());
//             postOrder(r.getRight());
//             System.out.print(r.getData() + "\t");
//         }
//     }
// } //จบคลาส BinarySearchTree
// Class Main ข้างล่างนี้เป็นคลาสที่ใช้ทดสอบคลาส BinarySearchTree โครงสร้างข้อมูลที่สร้างโดยใช้ Binary Search Tree ว่าใส่ข้อมูลเข้า ลบข้อมูลออก ถามว่ามีข้อมลที่ระบุหรือไม่ หรือถามว่าถังข้อมูลนี้ว่างเปล่าหรือไม่ ทั้งหมดนี้ทำงานได้อย่างถูกต้องหรือไม่

// public class Main {
//     public static void main(String[] args) {
//         BinarySearchTree BST = new BinarySearchTree();
//         Integer ob1 = new Integer(9);
//         Integer ob2 = new Integer(2);
//         Integer ob3 = new Integer(12);
//         Integer ob4 = new Integer(1);
//         Integer ob5 = new Integer(5);
//         Integer ob6 = new Integer(10);
//         Integer ob7 = new Integer(15);
//         Integer ob8 = new Integer(20);
//         BST.add(ob1);
//         BST.add(ob2);
//         BST.add(ob3);
//         BST.add(ob4);
//         BST.add(ob5);
//         BST.add(ob6);
//         BST.add(ob7);
//         BST.printTree();
//         System.out.println("Size: " + BST.size());
//         System.out.println("Min: " + BST.getMin());
//         System.out.println("Max: " + BST.getMax());
//         System.out.println("Is " + ob3 + " in the tree?" + "\t" + BST.contains(ob3));
//         System.out.println("Is " + ob8 + " in the tree?" + "\t" + BST.contains(ob8));
//     }
// }

// Output
// run:
// Preorder
// 9        2        1        5        12        10        15
// Inorder
// 1        2        5        9        10        12        15
// Postorder
// 1        5        2        10        15        12        9
// Size: 7
// Min: 1
// Max: 15
// Is 12 in the tree?        true
// Is 20 in the tree?        False
// แบบฝึกหัดท้ายบท
// จงเขียนโปรแกรมสร้างโครงสร้างข้อมูลแบบ Binary Search Tree	ซึ่งมีรายละเอียดของโปรแกรม   ดังนี้
//     1. สร้างคลาสชื่อ BTNode    เพื่อระบุ attribute และ method ของโหนดข้อมูลใน Binary Search Tree
//     2. สร้างคลาสชื่อ BinarySearchTree เพื่อสร้างโครงสร้างข้อมูลแบบ Binary Search Tree โดยมี root เป็น instant variable ของคลาสนี้เท่านั้นและมีรายละเอียดของ method ต่าง ๆ    ดังนี้
// - add		เพิ่มโหนดข้อมูลเข้าไปใน Binary Search Tree
// - contains	ค้นหาโหนดข้อมูลที่ต้องการใน Binary Search Tree
// - getMin		ขอข้อมูลที่มีค่าน้อยที่สุดใน Binary Search Tree
// - getMax	ขอข้อมูลที่มีค่ามากที่สุดใน Binary Search Tree
// - nnodes	หาจำนวนของ node ทั้งหมดใน Binary Search Tree
// - printTree	แสดงผลข้อมูลทั้งหมดใน Binary Search Tree ออกมาทางจอภาพด้วย tree traversal แบบ Inorder
//     3. สร้างคลาสชื่อ Main เพื่อตรวจสอบการทำงานของ BinarySearchTree โดยแสดงผลลัพธ์ที่ได้ออกมาทางจอภาพด้วย method printTree	    หลังจากที่ได้ดำเนินการต่าง ๆ  ดังนี้
//         3.1 เพิ่มข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า  9,  2,  12, 1,  5,  10, และ 15 ลงใน Binary Search Tree ตามลำดับ
//         3.2 แสดงผลจำนวนของ node ทั้งหมดใน Binary Search Tree ออกมาทางจอภาพ
//         3.3 แสดงผลข้อมูลที่มีค่าน้อยที่สุดใน Binary Search Tree นี้ออกมาทางจอภาพ
//         3.4 แสดงผลข้อมูลที่มีค่ามากที่สุดใน Binary Search Tree นี้ออกมาทางจอภาพ
//         3.5 ค้นหาข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 12 ใน Binary Search Tree
//         3.6 ค้นหาข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 20 ใน Binary Search Tree
















// บทที่ 5 Complete Tree or Nearly Complete Tree
// ต้นไม้สมบูรณ์หรือต้นไม้เกือบสมบูรณ์
// ต้นไม้สมบูรณ์คือต้นไม้เต็มต้น ที่มีโหนดครบทุกโหนดในแต่ละ level
// ต้นไม้เกือบสมบูรณ์คือต้นไม้ที่มีโหนดครบทุกโหนดในแต่ละ level โดย level ล่างสุดไม่จำเป็นต้องมีโหนดครบทุกโหนด แต่จำเป็นที่ห้ามมีโหนดหายไปเมื่อมองจากซ้ายไปขวา  เช่น ต้นไม้นี้ไม่ใช่ต้นไม้เกือบสมบูรณ์ เพราะ level สุดท้าย
// มีโหนดหายไปเมื่อมองจากซ้ายไปขวา นั่นคือโหนดลูกด้านขวาของโหนด 1 หายไป ดังูปข้างล่างนี้


// 5.1 ตัวอย่างต้นไม้ Complete Tree




// 5.2 ตัวอย่างต้นไม้ Nearly Complete Tree





// 5.3 วิธีแทน complete Tree หรือ Nearly Complete Tree ด้วย Array
// ถ้ามีต้นไม้ดังนี้

// 	ให้ใส่เลข 1 ที่ root ต่อมาใส่เลข 2 ที่ลูกด้านซ้ายของ root  เลข 3 ที่ลูกด้านขวาของ root ทำลงไปจนถึงใบของต้นไม้ โดยในระดับเดียวกันจะทำจากซ้ายไปขวา และทำจากบนลงล่าง ดังรูปข้างล่างนี้

// แล้วนำไปใส่ใน array โดยเริ่มที่ index ที่ 1 ดังรูปข้างล่างนี้





// 5.4 Heap
//  คือ ต้นไม้สมบูรณ์หรือต้นไม้เกือบสมบูรณ์ ที่โหนดแม่มีค่ามากกว่าโหนดลูกทั้งสอง  (max heap)
// ตัวอย่าง heap

// ตัวอย่างต้นไม้ที่ไม่ใช่ heap

// ไม่ใช่ heap เพราะต้นไม้นี้ไม่ใช่ทั้งต้นไม้สมบูรณ์ และต้นไม้เกือบสมบูรณ์

// ไม่ใช่ heap เพราะ มีลูกที่มีค่ามากกว่าโหนดแม่ นั่นคือโหนด 7 มีค่ากว่าโหนดแม่ซึ่งคือโหนด 4
// 5.4.1 การ build heap
// ต้นไม้ข้างล่างนี้เป็นต้นไม้สมบูรณ์หรือต้นไม้เกือบสมบูรณ์ แต่ยังไม่เป็น heap

//     1. ให้เริ่มหาโหนดแม่โหนดแรกเมื่อไล่มาจากด้านล่างของต้นไม้และจากขวามาซ้าย  ในที่นี้คือโหนดที่มีค่า 6 ต่อมาให้ดูต้นไม้ย่อยของแม่นี้ ว่าลูกทั้งสองมีค่าน้อยกว่าแม่หรือไม่  ถ้าใช่แสดงว่าต้นไม้ย่อยนั้นเป็น heap อยู่แล้ว


//     2. ต่อมาพิจารณาโหนดแม่โหนดถัดไปเมื่อไล่มาจากด้านล่างของต้นไม้และจากขวามาซ้าย ในที่นี้คือต้นไม้ย่อยที่มีแม่คือโหนด 5 ต่อมาให้ดูต้นไม้ย่อยของแม่นี้ ว่าลูกทั้งสองมีค่าน้อยกว่าแม่หรือไม่  ถ้าใช่แสดงว่าต้นไม้ย่อยนั้นเป็น heap อยู่แล้ว แต่ในที่นี้ลูกด้านซ้ายของโหนด 5 มีค่ามากกว่านั่นคือค่า 16 เพราะฉะนั้นต้นไม้ย่อยที่มีโหนด 5 เป็นโหนดแม่นี้ ไม่เป็น heap


// จึงต้องทำการ build heap ซึ่งมีขั้นตอนดังนี้
//     • หา max child คือ โหนดลูกที่มีค่ามากสุด ในที่นี้คือโหนดลูกด้านซ้ายซึ่งเก็บค่า 16
//     • เปรียบเทียบ max child ซึ่งคือโหนด 16 กับโหนดแม่ซึ่งคือโหนด 5 ถ้าโหนดแม่มีค่ามากกว่า max child แสดงว่าต้นไม้ย่อยนั้นเป็น heap อยู่แล้ว ก็ไม่ต้องทำอะไรสำหรับต้นไม้ย่อยนี้  และให้ไปพิจารณาโหนดแม่ถัดไป
//     • ถ้า max child มีค่ามากกว่า โหนดแม่ของต้นไม้ย่อยนี้ แสดงว่ายังไม่เป็น heap ให้ทำการสลับค่าระหว่าง max child กับ โหนดแม่ เพราะฉะนั้นต้นไม้ย่อยนี้จะมีโหนด 16 กลายเป็นโหนดแม่แทน ดังรูปข้างล่างนี้

//     3. ต่อมาพิจารณาโหนดแม่โหนดถัดไปเมื่อไล่มาจากด้านล่างของต้นไม้ขึ้นบนและจากขวามาซ้าย ในที่นี้คือต้นไม้ย่อยที่มีแม่คือโหนด 25 ดังรูปข้างล่างนี้ ต่อมาให้ดูต้นไม้ย่อยของแม่นั้นว่าลูกทั้งสองมีค่าน้อยกว่าแม่หรือไม่  ถ้าใช่แสดงว่าต้นไม้ย่อยนั้นเป็น heap อยู่แล้ว แต่ในที่นี้ลูกด้านซ้ายของโหนด 25 มีค่ามากกว่านั่นคือค่า 50 เพราะฉะนั้นต้นไม้ย่อยที่มีโหนด 25 เป็นโหนดแม่นี้ ไม่เป็น heap



// จึงต้องทำการ build heap ซึ่งมีขั้นตอนดังนี้
//     • หา max child คือ โหนดลูกที่มีค่ามากสุด ในที่นี้คือโหนดลูกด้านซ้ายซึ่งเก็บค่า 50
//     • เปรียบเทียบ max child โหนด 50 กับโหนดแม่ซึ่งคือโหนด 25  ถ้าโหนดแม่มีค่ามากกว่า max child แสดงว่าต้นไม้ย่อยนั้นเป็น heap อยู่แล้ว ก็ไม่ต้องทำอะไรสำหรับต้นไม้ย่อยนี้  และให้ไปพิจารณาโหนดแม่ถัดไป
//     • ถ้า max child มีค่ามากกว่า โหนดแม่ของต้นไม้ย่อยนี้ แสดงว่ายังไม่เป็น heap ให้ทำการสลับค่าระหว่าง max child กับ โหนดแม่ เพราะฉะนั้นต้นไม้ย่อยนี้จะมีโหนด 50 กลายเป็นโหนดแม่แทน ดังรูปข้างล่างนี้

//     4. ต่อมาพิจารณาโหนดแม่โหนดถัดไปเมื่อไล่มาจากด้านล่างของต้นไม้ขึ้นบนและจากขวามาซ้าย ในที่นี้คือต้นไม้ย่อยที่มีแม่คือโหนด 13  ดังรูปข้างล่างนี้ ต่อมาให้ดูต้นไม้ย่อยของแม่นั้นว่าลูกทั้งสองมีค่าน้อยกว่าแม่หรือไม่  ถ้าใช่แสดงว่าต้นไม้ย่อยนั้นเป็น heap อยู่แล้ว แต่ในที่นี้ลูกด้านซ้ายของโหนด 13 มีค่ามากกว่านั่นคือค่า 16 เพราะฉะนั้นต้นไม้ย่อยที่มีโหนด 13 เป็นโหนดแม่นี้ ไม่เป็น heap




// จึงต้องทำการ build heap ซึ่งมีขั้นตอนดังนี้
//     • หา max child คือ โหนดลูกที่มีค่ามากสุด ในที่นี้คือโหนดลูกด้านซ้ายซึ่งเก็บค่า 16
//     • เปรียบเทียบ max child โหนด16 กับโหนดแม่ซึ่งคือโหนด 13  ถ้าโหนดแม่มีค่ามากกว่า max child แสดงว่าต้นไม้ย่อยนั้นเป็น heap อยู่แล้ว ก็ไม่ต้องทำอะไรสำหรับต้นไม้ย่อยนี้  และให้ไปพิจารณาโหนดแม่ถัดไป
//     • ถ้า max child มีค่ามากกว่า โหนดแม่ของต้นไม้ย่อยนี้ แสดงว่ายังไม่เป็น heap ให้ทำการสลับค่าระหว่าง max child กับ โหนดแม่ เพราะฉะนั้นต้นไม้ย่อยนี้จะมีโหนด 16 กลายเป็นโหนดแม่แทน ดังรูปข้างล่างนี้

// 	เมื่อสลับโหนด 13 ลงมาโหนด 13 ก็จะกลายเป็นโหนดแม่ของต้นไม้ข้างล่างดังรูป จึงต้องการ re-build heap ของต้นไม้ย่อยนี้อีกทีว่า แม่มีค่ามากกว่า max child หรือไม่

// 	ในที่นี้โหนดแม่ของต้นไม้ย่อยนี้ซึ่งมีค่า 13 มีค่ามากกว่า max child ซึ่งคือโหนดลูกทางขวานั่นคือโหนดที่มีค่า 9 เพราะฉะนั้นต้นไม้ย่อยนี้เป็น heap อยู่แล้วจึงไม่ได้มีเปลี่ยนแปลงอะไรกับต้นไม้ย่อยนี้ดังรูปข้างล่างนี้

//     5. ต่อมาพิจารณาโหนดแม่โหนดถัดไปเมื่อไล่มาจากด้านล่างของต้นไม้ขึ้นบนและจากขวามาซ้าย ในที่นี้คือต้นไม้ย่อยที่มีแม่คือโหนด 20  ดังรูปข้างล่างนี้ ต่อมาให้ดูต้นไม้ย่อยของแม่นั้นว่าลูกทั้งสองมีค่าน้อยกว่าแม่หรือไม่  ถ้าใช่แสดงว่าต้นไม้ย่อยนั้นเป็น heap อยู่แล้ว แต่ในที่นี้ลูกด้านขวาของโหนด 20 มีค่ามากกว่านั่นคือค่า 50 เพราะฉะนั้นต้นไม้ย่อยที่มีโหนด 20 เป็นโหนดแม่นี้ ไม่เป็น heap




// จึงต้องทำการ build heap ซึ่งมีขั้นตอนดังนี้
//     • หา max child คือ โหนดลูกที่มีค่ามากสุด ในที่นี้คือโหนดลูกด้านขวาซึ่งเก็บค่า 50
//     • เปรียบเทียบ max child โหนด50 กับโหนดแม่ซึ่งคือโหนด 20  ถ้าโหนดแม่มีค่ามากกว่า max child แสดงว่าต้นไม้ย่อยนั้นเป็น heap อยู่แล้ว ก็ไม่ต้องทำอะไรสำหรับต้นไม้ย่อยนี้  และให้ไปพิจารณาโหนดแม่ถัดไป
//     • ถ้า max child มีค่ามากกว่า โหนดแม่ของต้นไม้ย่อยนี้ แสดงว่ายังไม่เป็น heap ให้ทำการสลับค่าระหว่าง max child กับ โหนดแม่ เพราะฉะนั้นต้นไม้ย่อยนี้จะมีโหนด 50 กลายเป็นโหนดแม่แทน ดังรูปข้างล่างนี้


// 	เมื่อสลับโหนด 20 ลงมาโหนด 20 ก็จะกลายเป็นโหนดแม่ของต้นไม้ข้างล่างดังรูป จึงต้องการ re-build heap ของต้นไม้ย่อยนี้อีกทีว่า แม่มีค่ามากกว่า max child หรือไม่




// ในที่นี้โหนดแม่ของต้นไม้ย่อยนี้ซึ่งมีค่า 20 มีค่าน้อยกว่า max child ซึ่งคือโหนดลูกทางซ้ายซึ่งคือโหนดที่มีค่า 25 เพราะฉะนั้นต้นไม้ย่อยนี้ไม่เป็น heap จึงทำการ re-build heap
//     • หา max child คือ โหนดลูกที่มีค่ามากสุด ในที่นี้คือโหนดลูกด้านซ้ายซึ่งเก็บค่า 25
//     • เปรียบเทียบ max child โหนด 25 กับโหนดแม่ซึ่งคือโหนด 20  ถ้าโหนดแม่มีค่ามากกว่า max child แสดงว่าต้นไม้ย่อยนั้นเป็น heap อยู่แล้ว ก็ไม่ต้องทำอะไรสำหรับต้นไม้ย่อยนี้
//     • ถ้า max child มีค่ามากกว่า โหนดแม่ของต้นไม้ย่อยนี้ แสดงว่ายังไม่เป็น heap ให้ทำการสลับค่าระหว่าง max child กับ โหนดแม่ เพราะฉะนั้นต้นไม้ย่อยนี้จะมีโหนด 25 กลายเป็นโหนดแม่แทน ดังรูปข้างล่างนี้


// เมื่อทำครบทุกต้นไม่ย่อยจนถึงโหนดแม่ที่เป็น root แล้ว ขณะนี้ต้นไม้นี้ก็กลายเป็น heap เรียบร้อยแล้ว ดังรูปข้างบนนี้

// มาถึงการสร้างโครงสร้างข้อมูล  จากคลาส  Heap ข้างล่างนี้ โดยใช้ Array ในการสร้างโครงสร้างข้อมูล

// public class Heap {

//     public void buildHeap(int[] heapArray, int numNode){
//         int i;
//         for (i=numNode/2; i>0; i--){
//             reHeap(heapArray,i,numNode);
//         }
//     }


//     public void reHeap(int[] heapArray, int root, int numNode){
//         int maxChild, tmp;
//         boolean isHeap = false;
//         while ((2*root <= numNode) && (!isHeap)){
//             if (2*root == numNode)
//                 maxChild = 2*root;
//             else
//                 if (heapArray[2*root] > heapArray[2*root+1])
//                     maxChild = 2*root;
//                 else
//                     maxChild = 2*root+1;
//             if (heapArray[root] < heapArray[maxChild]){
//                 tmp = heapArray[root];
//                 heapArray[root] = heapArray[maxChild];
//                 heapArray[maxChild] = tmp;
//                 root = maxChild;
//             }
//             else
//                 isHeap = true;
//         }
//     }

//     public void printHeap(int heapArray[], int numNode){
// // สำหรับ print ต้นไม้ออกมาตาม array  เริ่มจาก index 1 ซึ่งคือ root จนถึงโหนดสุดท้าย
//         for (int i=1; i<=numNode; i++){
//             System.out.print(heapArray[i] + " ");
//         }
//         System.out.println();
//     }
// }// จบคลาส Heap
// ทดสอบการทำงานของคลาส Heap
// public class Main {

//     public static void main(String[] args) {
//         int[] a = {0,20,13,25,5,6,50,2,16,9,1};
//         int numNode = a.length-1;
//         Heap h = new Heap();
//         System.out.print("Data Array: ");
//         h.printHeap(a, numNode);
//         h.buildHeap(a, numNode);
//         System.out.print("Heap Array: ");
//         h.printHeap(a, numNode);
//     }
// }

// Output
// run:
// Data Array: 20 9 32 6 15 25 50 5 8 13 18
// Heap Array: 50 18 32 8 15 25 20 5 6 13 9

// แบบฝึกหัดท้ายบท
// จงเขียนโปรแกรมสร้างโครงสร้างข้อมูลแบบ Heap Tree	 ซึ่งมีรายละเอียดของโปรแกรม   ดังนี้
//     1. สร้างคลาสชื่อ Heap เพื่อสร้างโครงสร้างข้อมูลแบบ Heap Tree   โดยรับ input เป็นอาร์เรย์ของ complete tree ใด ๆ แล้วแปลงเป็น Heap Tree      และมี method “printHeap” เพื่อแสดงผลข้อมูลใน Heap Tree ออกมาทางจอภาพ
//     2. สร้างคลาสชื่อ Main เพื่อตรวจสอบการทำงานของคลาส Heap  โดยแสดงผลลัพธ์ที่ได้ออกมาทางจอภาพ หลังจากรับ input ซึ่งเป็น array ของข้อมูลชนิดเลขจำนวนเต็ม    ดังนี้



// บทที่ 6 Stack และ Queue
// 6.1 Stack
// 6.1.1 Abstract Data Type (ADT) ของ Stack
// 1.เซตของข้อมูล เช่น {3, 1, 7, 15, 29}
// 2.ความสัมพันธ์ของข้อมูล: จัดเก็บข้อมูลโดยข้อมูลที่ใส่เข้ามาทีหลังจะถูกดึงออกไปใช้ก่อน First-In-Last-Out (FILO)
// 3.กลุ่มของตัวกระทำ
//   - Push : ใส่ข้อมูลเข้า
//  -   Pop :  ดึงข้อมูลออกมาใช้
// โดยจะมีตัวแปร top ไว้เก็บ index ของข้อมูลตัวบนสุด เนื่องจากใช้ array ในการ implement stack และ index ของ array เริ่มต้นที่ 0 เพราะฉะนั้น top ของ stack ที่ว่างเปล่าจึงมีค่าเท่ากับ -1 ดังรูปข้างล่างนี้  ในที่นี้ตัวแปร s แทน stack ซึ่ง คือ object ของ class Stack ในหน้า 125 ข้างล่าง

// 6.1.2 การเพิ่มข้อมูลลงใน stack
// 	 จะใช้ตัวกระทำ push จากรูปข้างล่างนี้ เติมข้อมูลที่มีค่า 2 ลงไปใน stack ที่ว่างเปล่า โดยใช้คำสั่ง s.push(2); เพราะฉะนั้นขณะนี้ stack จะมีข้อมูลอยู่หนึ่งตัว และตัวแปร top จะถูกบวกเพิ่มขึ้น 1  นั่นคือเพิ่มขึ้นจาก -1 เป็น 0  ซึ่งจะชี้อยู่ที่ข้อมูลตัวแรกนี้ ซึ่งมีindex เท่ากับ 0 เพราะ index ของ array เริ่มต้นที่ 0 ดังรูปข้างล่างนี้


// 	เมื่อต้องการเพิ่มข้อมูลตัวถัดไปที่มีค่า 6 ก็ใช้คำสั่ง s.push(6);  ขณะนี้ตัวแปร top จะถูกบวกเพิ่มขึ้น 1  นั่นคือเพิ่มขึ้นจาก 0 เป็น 1  และจะชี้อยู่ตัวบนสุดซึ่งคือตัวที่สอง โดยมี index คือ 1 ดังรูปข้างล่างนี้

// 	เมื่อต้องการเพิ่มข้อมูลตัวถัดไปที่มีค่า 7 ก็ใช้คำสั่ง s.push(7);  ขณะนี้ตัวแปร top จะชี้อยู่ตัวบนสุดซึ่งคือตัวที่สาม โดยมี index คือ 2 ดังรูปข้างล่างนี้






// 6.1.3 การลบข้อมูลออกจาก Stack
// 	จะใช้ตัวกระทำ pop จากรูปข้างบนล่าสุด ถ้าต้องการลบค่า 7 ออกจาก Stack ก็ใช้คำสั่ง s.pop(); ซึ่งจะทำการลบค่าตัวล่าสุดซึ่งคือตัวบนสุดออกจาก Stack ชื่อ s โดยค่าบนสุดคือค่าที่เพิ่งเข้ามาใน Stack หลังสุด เมื่อลบค่าออกจาก Stack หนึ่งค่า ตัวชี้ top ก็จะเลื่อนลงหนึ่งตำแหน่งโดยชี้ตัวบนสุดขณะนี้ซึ่งคือค่า 6 โดยตัวแปร top จะเลื่อนลงมาอยู่ที่ index 1 ดังรูปข้างล่าง

// 	เมื่อต้องการลบข้อมูลตัวถัดไปที่มีค่า 6 ก็ใช้คำสั่ง s.pop();  ขณะนี้ตัวแปร top จะชี้อยู่ตัวบนสุดซึ่งขณะนี้มีตัวเดียว โดยมี index คือ 0 ดังรูปข้างล่างนี้

// เมื่อต้องการลบข้อมูลตัวถัดไปที่มีค่า 2 ก็ใช้คำสั่ง s.pop();  ขณะนี้ตัวแปร top จะมี index คือ -1 แสดงให้รู้ว่าขณะนีไม่มีข้อมูลเหลืออยู่ใน Stack หรือ Stack ว่างเปล่า ดังรูปข้างล่างนี้

// 6.1.4 การสร้างโครงสร้งข้อมูล Stack โดยใช้ Array
// การสร้างโครงสร้างข้อมูล  จากคลาส  Stack ข้างล่างนี้ โดยใช้ Array ในการสร้างโครงสร้างข้อมูล
// - เริ่มจาก constructor ซึ่งแสดงถึง Stack ว่างเปล่า เนื่องจาก implement stack โดยใช้ array เพราะฉะนั้นตัวชี้ top จะมีค่าเท่ากับ -1 ซึ่งแปลว่ายังไม่มีข้อมูลตัวบนสุด ถ้ามีข้อมูลสัก 1 ตัว ตัวชี้ top จะชี้ที่ 0 เพราะ array เริ่มต้นที่ index 0
// - method size() จะ return จำนวนข้อมูลใน Stack นั่นคือ indexของตัวบนสุดบวกด้วย 1 (top+1) เพราะ array เริ่มต้นที่ index 0
// - method push(Object o) จะทำการใส่ข้อมูล o ลงใน Stack  นั่นคือข้อมูล  o กลายเป็นข้อมูลตัวบนสุดของ Stack
// - method pop() จะทำการดึงข้อมูลตัวบนสุดออกมา เพราะฉะนั้น ตัวชี้ top  ซึ่งทำการชี้ตัวบนสุดต้องถูกลดค่าไป 1
// - method isEmpty() จะ return ค่า true ถ้า Stack ว่าง และ return ค่า false ถ้า Stack มีข้อมูลอย่างน้อย 1 ตัว

// public class  Stack
//  {
//     private Object[] s;
//     private int top;




// public Stack() // เริ่มต้นที่ stack ว่างเปล่าซึ่ง implement โดยใช้ array ในที่นี้เริ่มต้นที่ 10 ช่อง
//      {
//            s= new Object[10];
//            top= -1;
//       }
//     public int size()
//      { return top+1; }

//     public void push(Object o)
//       {
//          if(top== s.length-1) // ถ้า array เต็ม
//            s = doubleSize(s); // ขยายความจุของ Stack
//            top++;       //เลื่อน top ขึ้นไป 1 ตำแหน่ง
//            s[top] = o;
//         }
//      private static Object[] doubleSize(Object[] origin)
//        {  //สร้าง array ตัวใหม่ที่มีขนาด 2 เท่าจากของเดิม และเอา ตัวแปรเดิมมาเก็บ address ของ array ใหม่นี้
//            Object[] temp = new Object[origin.length*2];
//            System.arraycopy(origin,0,temp,0,origin.length);
//            return temp;
//        }

//       public Object pop()
//        {
//            if(isEmpty())  return null; //ถ้า Stack ว่าง return ค่า null คือ ไม่มี object จะ return
//            Object  e = s[top]; //ถ้า Stack ไม่ว่าง ดึงข้อมูลตัวบนสุดออกจาก Stack และ return ข้อมูลตัวนั้น
//              top--;
//              return e;
//         }

//       public boolean isEmpty()
//        {
//              return top == -1; //ถ้าตัวชี้ top มีค่าเท่ากับ -1 แปลว่า Stack ว่างเปล่า
//          }
// }

// 6.1.5 การประยุกต์ใช้ Stack
// โปรแกรมข้างล่างนี้แสดงการใช้ Stack คำนวน expression แบบ Postfix

// import java.util.StringTokenizer;
// public class Postfix {
//     public String[] toPostfix(String infix){
//         Stack st = new Stack();
//         String[] arrayPostfix = new String[infix.length()];
//         String str;
//         int index = 0;
//         // แยก string ออกเป็นส่วน ๆ โดยใช้เครื่องหมาย + - * / ( ) เป็นตัวแบ่ง
//             String delim = "+-*/()";
//         //StringTokenizer infixToken = new StringTokenizer(input string, ตัวที่ใช้ในการตัดคำ, true_ถ้าต้องการเก็บตัว
// //ที่ใช้ตัดคำไว้ใน infixToken ส่วน false_ถ้าไม่ต้องการเก็บตัวที่ใช้หั่นไว้)
//             StringTokenizer infixToken = new StringTokenizer(infix,delim,true);
//         // เอาแต่ละส่วนของ string มาแปลงเป็น postfix expression
//         while (infixToken.hasMoreTokens()) {
//             str = infixToken.nextToken();
//             if(str.equals("("))
//                continue;
//             if (str.equals("+") || str.equals("-") || str.equals("*") || str.equals("/"))
//                 st.push(str);


//  else if(str.equals(")")){
//                  arrayPostfix[index] = (String) st.pop();
//                  index++;
//             }
//             else{
//                 arrayPostfix[index] = str;
//                 index++;
//             }
//         }
//         return arrayPostfix;
//     }

//     public void printArray(String[] arrayPostfix){
//         int i = 0;
//         while(arrayPostfix[i] != null){
//             System.out.print(arrayPostfix[i]);
//             i++;
//         }
//         System.out.println();
//     }

//     public int calPostfix(String[] postfix){
//         Stack st = new Stack();
//         int a, b, c;
//         int i = 0;
//               while(postfix[i] != null){
//             if (postfix[i].equals("+")){
//                 b = (Integer)st.pop();
//                 a = (Integer)st.pop();
//                 c = a+b;
//                 st.push(new Integer(c));  }
//             else if (postfix[i].equals("-")){
//                 b = (Integer)st.pop();
//                 a = (Integer)st.pop();
//                 c = a-b;
//                 st.push(new Integer(c));
//             }
//             else if (postfix[i].equals("*")){
//                 b = (Integer)st.pop();
//                 a = (Integer)st.pop();
//                 c = a*b;
//                 st.push(new Integer(c));
//             }
//             else if (postfix[i].equals("/")){
//                 b = (Integer)st.pop();
//                 a = (Integer)st.pop();
//                 c = a/b;
//                 st.push(new Integer(c));
//             }
//             else{
//                 st.push(new Integer(postfix[i]));
//             }
//             i++;
//         }
//         return (Integer)st.pop();
//     }
// }





// public class Main {
//     public static void main(String[] args) {
//         Postfix p = new Postfix();
//         String infix = "((5*3)-((2*3)/(1+1)))";
//         System.out.println("Infix Expression: " + infix);
//         System.out.print("Postfix Expression: ");
//         p.printArray(p.toPostfix(infix));
//         System.out.println("Calculation of Postfix: " + p.calPostfix(p.toPostfix(infix)));

//     }
// }
// Output

// Infix Expression: ((5*3)-((2*3)/(1+1)))
// Postfix Expression: 53*23*11+/-
// Calculation of Postfix: 12

// 6.2 Queue
// 6.2.1 Abstract Data Type (ADT) ของ Queue
// 1. เซตของข้อมูล เช่น {3, 1, 7, 15, 29}
// 2. ความสัมพันธ์ของข้อมูล : จัดเก็บข้อมูลโดยข้อมูลที่ใส่เข้ามาก่อนจะถูกดึงออกไปใช้ก่อน First-In-First-Out (FIFO)
// 3. กลุ่มของตัวกระทำ
//  - Enqueue : ใส่ข้อมูลเข้า
//  - Dequeue :  ดึงข้อมูลออก
// 	โดยจะมีตัวแปร front ไว้เก็บ index ของข้อมูลตัวแรกสุด และตัวแปร rear ไว้เก็บ index ของช่องว่างแรกหลังจากตัวท้ายสุด ถ้าใช้ array ในการ implement queue และ index ของ array เริ่มต้นที่ 0 เพราะฉะนั้น front ของ queue ที่ว่างเปล่าจึงมีค่าเท่ากับ -1 และ rear มีค่า เท่ากับ 0 ดังรูปข้างล่างนี้  ในที่นี้ตัวแปร q แทน queue นั่นคือ q คือ object ของ class Queue ในหน้า 135 ข้างล่าง

// 6.2.2 การเพิ่มข้อมูลลงใน Queue (Enqueue)
// จะใช้ตัวกระทำ enqueue จากรูปข้างล่างนี้ เติมข้อมูลที่มีค่า 7 ลงไปใน queue ที่ว่างเปล่า โดยใช้คำสั่ง q.enq(7); เพราะฉะนั้นขณะนี้ queue จะมีข้อมูลอยู่หนึ่งตัว และตัวแปร front จะชี้อยู่ที่ข้อมูลตัวแรกนี้จึงมีค่าเท่ากับ 0 เพราะ index ของ array เริ่มต้นที่ 0  ส่วนตัวแปร rear จะขยับไปหนึ่งตำแหน่ง เพื่อรอข้อมูลตัวถัดไปที่จะใส่เข้ามา คือ index 1 ดังรูปข้างล่างนี้

// 	เมื่อเพิ่มข้อมูลตัวถัดไปที่มีค่า 12 ก็ใช้คำสั่ง q.enq(12);  ข้อมูลค่า 12 จะเข้าไปที่ตำแหน่งที่ตัวแปร rear ชี้อยู่ ฃขณะนี้ ซึ่งคือที่ index  1  ส่วนตัวแปร front ยังคงอยู่ที่เดิมแต่ตัวแปร rear จะขยับถัดไปหนึ่งตำแหน่งเพื่อรอข้อมูลตัวถัดไปที่จะใส่เข้ามา โดยมี index คือ 2 ดังรูปข้างล่างนี้

// เมื่อเพิ่มข้อมูลตัวถัดไปที่มีค่า 9 ก็ใช้คำสั่ง q.enq(9);  ข้อมูลค่า 9 จะเข้าไปที่ตำแหน่งที่ตังแปร rear ชี้อยู่ขณะนี้ซึ่งคือที่ index  2  ส่วนตัวแปร front ยังคงอยู่ที่เดิมแต่ตัวแปร rear จะขยับถัดไปหนึ่งตำแหน่งเพื่อรอข้อมูลตัวถัดไปที่จะใส่เข้ามา โดยมี index คือ 3 ดังรูปข้างล่างนี้


// 6.2.3 การลบข้อมูลออกจาก Queue (Dequeue)
// จะใช้ตัวกระทำ dequeue จากรูปข้างบนล่าสุด ถ้าต้องการลบค่า 7 ออกจาก queue ก็ใช้คำสั่ง q.deq(); ซึ่งจะทำการลบค่าตัวแรกสุดออกจาก queue ชื่อ q โดยค่าแรกสุดคือค่าเข้ามาอยู่ใน queue นานสุด เมื่อลบค่าออกจาก queue หนึ่งค่า ตัวชี้ front ก็จะขยับถัดไปหนึ่งตำแหน่งโดยชี้ตัวแรกสุดขณะนี้กลายเป็นค่า 12 โดยตัวแปร front จะเลื่อนขยับไปอยู่ที่ index 1 ส่วนตัวแปร rear ยังคงอยู่ที่เดิมดังรูปข้างล่าง

// เมื่อลบข้อมูลตัวถัดไปที่มีค่า 12 ก็ใช้คำสั่ง q.deq();  ขณะนี้ตัวแปร front จะขยับไปชี้อยู่ตัวแรกสุดปัจจุบันซึ่งขณะนี้มีตัวเดียว โดยมี index คือ 2 ดังรูปข้างล่างนี้

// เมื่อลบข้อมูลตัวถัดไปที่มีค่า 9 ก็ใช้คำสั่ง q.deq();  ขณะนี้ตัวแปร front จะขยับไปจนไปชี้ที่เดียวกับตัวแปร rear แสดงให้รู้ว่าขณะนีไม่มีข้อมูลเหลืออยู่ใน queue หรือ queue ว่างเปล่า ดังรูปข้างล่างนี้

// 6.2.4 การสร้างโครงสร้างข้อมูล Queue โดยใช้ Array
// การสร้างโครงสร้างข้อมูล  จากคลาส  Queue ในหน้า 135 ข้างล่างนี้  โดยใช้ Array ในการสร้างโครงสร้างข้อมูล
// - เริ่มจาก constructor ซึ่งแสดงถึง queue ว่างเปล่า  ซึ่งimplement โดยใช้ array เพราะฉะนั้นตัวชี้ front = -1 ซึ่งแปลว่ายังไม่มีข้อมูล ถ้ามีข้อมูล 1 ตัว front จะชี้ที่ 0 เพราะ array เริ่มต้นที่ index 0
// - method size() จะ return จำนวนข้อมูลใน queue
// - method enq(Object o) จะทำการใส่ข้อมูล object o ลงใน queue เพราะฉะนั้น ตัวชี้ rear  ซึ่งทำการชี้ข่องว่างตัวถัดไป ต้องชี้ไปช่องถัดไป คือเพิ่มค่าไปอีก 1
// - method deq() จะทำการดึงข้อมูลตัวแรกสุดออกมา เพราะฉะนั้น ตัวชี้ front  ซึ่งทำการชี้ตัวแรกสุด ต้องชี้ไปช่องถัดไป คือเพิ่มค่าไปอีก1
// - method isEmpty() จะ return ค่า true ถ้า queue ว่าง และ return ค่า false ถ้า queue มีข้อมูลอย่างน้อย 1 ตัว

// 6.3 Circular Queue
// คือการนำ array ช่องสุดท้ายมาต่อกับ array ช่อง แรกสุด  เพื่อที่จะได้สามารถนำช่องข้อมูลช่องแรกของ array ที่ว่างจากการ dequeue ไปแล้ว นำกลับมาใช้

// เมื่อเพิ่มข้อมูลตัวถัดไปที่มีค่า 3 ก็ใช้คำ สั่ง q.enq(3);  ข้อมูลค่า 3 จะเข้าไปที่ตำแหน่งที่ตัวแปร rear ชี้อยู่ขณะนี้ ซึ่งคือที่ index  5  ส่วนตัวแปร front ยังคงอยู่ที่เดิมแต่ตัวแปร rear จะขยับถัดไปหนึ่งตำแหน่งเพื่อรอข้อมูลตัวถัดไปที่จะใส่เข้ามา โดยมี index คือ 0 ดังรูปข้างล่างนี้   โดย  index 0 มาจาก (5+1)%6  นั่นคือ ตำแหน่ง rear ก่อน
// เพิ่มข้อมูล ซึ่งคือ 5 ทำการถูกเพิ่มขึ้น 1 หลังจากเพิ่มข้อมูล และ mod ด้วยจำนวนช่องของ array ทั้งหมด เพื่อให้วนกลับมาใช้ array ช่องแรก

// 	เมื่อเพิ่มข้อมูลตัวถัดไปที่มีค่า 4 ก็ใช้คำ สั่ง q.enq(4);  ข้อมูลค่า 4 จะเข้าไปที่ตำแหน่งที่ตัวแปร rear ชี้อยู่ขณะนี้ ซึ่งคือที่ index  0  ส่วนตัวแปร front ยังคงอยู่ที่เดิมแต่ตัวแปร rear จะขยับถัดไปหนึ่งตำแหน่งเพื่อรอข้อมูลตัวถัดไปที่จะใส่เข้ามา โดยมี index คือ 1 ดังรูปข้างล่างนี้   โดย  index 1 มาจาก (0+1)%6  นั่นคือ ตำแหน่ง rear ก่อน เพิ่มข้อมูล ซึ่งคือ 0 ทำการถูกเพิ่มขึ้น 1 หลังจาก เพิ่มข้อมูล และ mod ด้วยจำนวนช่องของ array ทั้งหมด เพื่อให้วนกลับมาใช้ array ช่องแรก

// ถ้าขณะนี้มีข้อมูลอยู่ตัวเดียวใน circular queue ดังรูปข้างล่าง

// เมื่อลบข้อมูลตัวถัดไปที่มีค่า 2 ก็ใช้คำสั่ง q.deq();  ขณะนี้ตัวแปร front จะขยับไปจนไปชี้ที่เดียวกับตัวแปร rear แสดงให้รู้ว่าขณะนีไม่มีข้อมูลเหลืออยู่ใน queue หรือ queue ว่างเปล่า ดังรูปข้างล่างนี้

// ถ้าขณะนี้มีช่องว่างเหลืออยู่ช่องเดียวใน circular queue ดังรูปข้างล่าง

// เมื่อเพิ่มข้อมูลตัวถัดไปที่มีค่า 3 ก็ใช้คำสั่ง q.enq(3);  ขณะนี้ตัวแปร rear จะขยับไปจนไปชี้ที่เดียวกับตัวแปร front แสดงให้รู้ว่าขณะนีไม่มีช่องว่างเหลืออยู่ใน queue หรือ queue เต็ม ดังรูปข้างล่างนี้



// public class Queue
//   {
//      private Object[] q;
//      private int size;
//      private int max;
//      private int front, rear;



//   public Queue (int m) // เริ่มต้นที่ queue ว่างเปล่าโดย implement โดยใช้ array ในที่นี้เริ่มต้นที่ max ช่อง
//      {  max = m
//           q = new Object[max];
//           front = -1;
//            rear=0;
//           size = 0;
//       }
//     public void enq(Object o)
//     {
//           if(rear==front && size== max) // ถ้า queue เต็ม ก็จะไม่เติมข้อมูล
//               System.out.println(“Queue is full”);
//           else
//              { // ถ้า queue ยังไม่เต็ม
//                  q[rear] = o; // ใส่ข้อมูล o ลงใน queue ตรงตำแหน่งที่ rear ชี้อยู่
//                  rear = (rear+1)%max; // เลื่อนตัวแปร rear ไปตำแหน่งที่ว่างถัดไป
// // การ mod ด้วย max เพื่อให้วนกลับไปใช้ index แรก ๆ ของ array นั่นคือการทำงานของ circulary queue
//                  size++;
//               }
//        }
//      public Object deq()
//      {
//            if(isEmpty())  //ถ้า queue ว่าง return ค่า null คือ ไม่มี object จะ return

//             {       System.out.println(“Queue is Empty”);
//                       return null;
//              }
//            else
//               { //ถ้า queue ไม่ว่าง ดึงข้อมูลตัวแรกสุดออกจาก queue และ return ข้อมูลตัวนั้น


//                       Object  e = q[front];
//                       front = (front+1)%max ; // เลื่อน front ไปยังข้อมูลตัวแรกที่เหลืออยู่ใน queue
//                       size—;
//                       return e ;
//                }
//        }
//           public boolean isEmpty()
//        { //ถ้า ตัวแปร size= 0 แปลว่า queue ว่างเปล่า

//              return  size==0 ;
//          }
//       public int size()
//           { return size; // return จำนวนข้อมูลใน queue
//            }
//     }

// แบบฝึกหัดท้ายบท
// จงเขียนโปรแกรมเพื่อแปลงนิพจน์จากรูปแบบ Infix เป็นแบบ Postfix และเพื่อสร้างโครงสร้างข้อมูลแบบ Queue โดยใช้ Linked list ซึ่งมีรายละเอียดของโปรแกรม  ดังนี้
//     1. สร้างคลาสชื่อ Stack เพื่อระบุ attribute และ method ที่จำเป็นต้องใช้ในการสร้างโครงสร้างข้อมูลแบบ Stack
//     2. สร้างคลาสชื่อ Postfix เพื่อแปลงนิพจน์จากรูปแบบ Infix เป็นแบบ Postfix  และคำนวณค่าเพื่อหาผลลัพธ์ของนิพจน์ในรูปแบบ Postfix โดยมีรายละเอียดของ method ดังนี้
// 2.1) method ชื่อ toPostfix เพื่อแปลงนิพจน์จากรูปแบบ Infix เป็นแบบ Postfix และ return Array ของนิพจน์ในรูปแบบ Postfix ที่ได้ออกมา โดยใช้โครงสร้างข้อมูลแบบ Stack และ Array ในการแปลงนิพจน์ ยกตัวอย่างเช่น   นิพจน์รูปแบบ Infix คือ (5*3)
// 		- เจอ “(” 	ไม่ต้องดำเนินการใด ๆ
// 		- เจอ “5”	ให้นำตัวเลข 5 ไปใส่ใน array
// 		- เจอ “*”	ให้ push เครื่องหมาย * ลงใน stack
// 		- เจอ “3”	ให้นำตัวเลข 3 ไปใส่ใน array
// 		- เจอ “)”	ให้ pop เครื่องหมาย * ออกจาก stack มาใส่ใน array
// 	ได้ผลลัพธ์ที่มีโครงสร้างข้อมูลแบบ Array   คือ   53*
// 	       2.2) method ชื่อ calPostfix เพื่อคำนวณหาค่าผลลัพธ์ของนิพจน์ในรูปแบบ Postfix โดย input ของ method นี้คือ array ที่ return ออกมาจาก method toPostfix
//     3. สร้างคลาสชื่อ Queue    เพื่อสร้างโครงสร้างข้อมูลแบบ Queue โดยใช้ Linked list	ซึ่งมีรายละเอียดของ method ดังนี้
//       3.1) method ชื่อ enqueue   เพื่อเพิ่มข้อมูลลงไปใน queue
//       3.2) method ชื่อ dequeue   เพื่อนำข้อมูลออกจาก queue
//        3.3) method ชื่อ isEmpty   เพื่อตรวจสอบว่ามีข้อมูลอยู่ใน queue หรือไม่
//        3.4) method ชื่อ size    	เพื่อระบุขนาดของ queue
//        3.5) method ชื่อ printQueue   เพื่อแสดงผลข้อมูลทั้งหมดภายใน queue ออกมาทางจอภาพ
//     4. สร้างคลาสชื่อ Main เพื่อตรวจสอบการทำงานของคลาส Postfix  และคลาส Queue   ดังนี้
//       4.1) แปลงนิพจน์จากรูปแบบ Infix คือ ((5*3)-((2*3)/(1+1))) เป็นแบบ Postfix   และแสดงผล Array ของนิพจน์ดังกล่าวในรูปแบบ Postfix ที่ได้ ออกมาทางจอภาพ
//        4.2) แสดงค่าผลลัพธ์ของนิพจน์ในรูปแบบ Postfix ที่ได้ในข้อ 4.1) ออกมาทางจอภาพ
//        4.3) สร้าง queue ซึ่งสามารถรับข้อมูลได้จำนวนมากที่สุดคือ 4 ข้อมูล
//       4.4) เพิ่มข้อมูลชนิดเลขจำนวนเต็มคือ 5, 10, 15, 20 และ 25 เข้าไปใน queue และแสดงผลด้วย method printQueue
//       4.5) แสดงผลของการนำข้อมูลออกจาก queue ทีละตัว จนกระทั่งไม่มีข้อมูลใด ๆ เหลืออยู่ใน queue













// บทที่ 7 Hashing และ Searching
// 7.1 Hashing
// 	Hasing คือการ map ข้อมูลจากตำแหน่งในถังข้อมูลที่มีขนาดไม่เฉพาะเจาะจง  ให้ไปอยู่ในตำแหน่งของถังข้อมูลที่มีขนาดเฉพาะเจาะจง  หรือแปลงจาก ตำแหน่งในถังข้อมูลขนาดใหญ่ ไปยัง ตำแหน่งของถังข้อมูลที่มีขนาดเล็กลง  เพื่อให้การค้นหาข้อมูลได้ง่ายขึ้น โดยมีขั้นตอนดังนี้
//     1. กำหนด hash function
//     2. นำค่าตำแหน่งของข้อมูลในถังข้อมูลตั้งต้นซึ่งเรียกว่า key (k)  ไปเป็น  input ของ hash function
//     3. Output ของ hash function จะเป็นตำแหน่งของข้อมูลในถังข้อมูลปลายทาง ซึ่งคือ Hash table
// โดยทั่วไป hash function จะเป็น k mod N เมื่อ N เป็นขนาดของ hash table
// ประยุกต์ในปัญหาจริง
// 	นิสิตของจุฬามี 3 หมื่นคน  จะมีการเรียงตำแหน่ง 1-30,000 ใน database แต่ถ้าอยากจะพิจารณาแค่นิสิตในภาควิชาหนึ่งซึ้งมีนิสิต ประมาณ  500 คน จึงต้อง map จาก ตำแหน่งใน data base ที่มีขนาด 30,000 ช่อง มาเป็นตำแหน่งของ data base ที่มีขนาด 500 ช่อง เพื่อทำการค้นหาหรือเข้าถึง นิสิตในภาควิชานั้นได้ง่ายขึ้น
// ตัวอย่างต่อไปนี้จะ map ตำแหน่งข้อมูลจากถังข้อมูลที่มีขนาด 100 ช่องไปยังตำแหน่งของข้อมูลในถังที่มีขนาด 10 ช่อง มี hash function คือการ mod ด้วย จำนวนช่องของถังปลายทางในที่นี้ คือ mod ด้วย 10   อย่างที่กล่าวไปแล้วว่าถังปลายทางคือ hash table เพราะฉะนั้น array ในตัวอย่างข้างล่างนี้คือ hast table ที่มีขนาด 10 ช่อง จากตัวอย่างข้างล่าง ถ้ามีข้อมูล 9 ตัว และมีตำแหน่งของข้อมูลจากถังต้นทางซึ่งมีขนาด 100 ช่อง เป็นดังนี้  4, 7, 18, 36, 24, 72, 90, 83, 9

// 	ข้อมูลตัวแรกคือตำแหน่ง 4 จากถังต้นทาง  ให้นำ 4 เข้า hash function นั่นคือ 4 mod 10 ผลลัพธ์คือ 4 เพราะฉะนั้น map จากตำแหน่ง 4 ของถังต้นทางไปยังตำแหน่ง 4 ของ hash table ดังรูปข้างล่างนี้

// 	ข้อมูลถัดไปคือตำแหน่ง 7 จากถังต้นทาง ให้นำ 7 เข้า hash function นั่นคือ 7 mod 10 ผลลัพธ์คือ 7 เพราะฉะนั้น map จากตำแหน่ง 7 ของถังต้นทางไปยังตำแหน่ง 7 ของ hash table ดังรูปข้างล่างนี้

// 	ข้อมูลถัดไปคือตำแหน่ง 18 จากถังต้นทาง ให้นำ 18 เข้า hash function นั่นคือ 18 mod 10 ผลลัพธ์คือ 8 เพราะฉะนั้น map จากตำแหน่ง 18 ของถังต้นทางไปยังตำแหน่ง 8 ของ hash table ดังรูปข้างล่างนี้

// 	ข้อมูลถัดไปคือตำแหน่ง 36 จากถังต้นทาง  ให้นำ 36 เข้า hash function นั่นคือ 36 mod 10 ผลลัพธ์คือ 6 เพราะฉะนั้น map จากตำแหน่ง 36 ของถังต้นทางไปยังตำแหน่ง 6 ของ hash table ดังรูปข้างล่างนี้

// ข้อมูลถัดไปคือตำแหน่ง 24 จากถังต้นทาง ให้นำ 24 เข้า hash function นั่นคือ 24 mod 10 ผลลัพธ์คือ 4 เพราะฉะนั้น จะเห็นได้ว่า ที่ตำแหน้าง 4 นี้ มีข้อมูลอยู่แล้ว เหตุการนี้เรียกว่า การชนกันของข้อมูล หรือ collision การแก้ปัญหาการชนมีหลายแบบ เช่น Linear Probing, Chaining หรือ Double Hashing


// 7.1.1 Linear Probing
// การแก้ปัญหาการชนอย่างหนึ่ง เมื่อเกิดการชนขึ้นจะนำข้อมูลที่มาชนไปใส่ในช่องที่ว่างถัดไปจากผลลัพธ์ของ hash function จากตัวอย่างนี้ผลลัพธ์ของ hash function ของ key ที่มีค่า 24 คือ ตำแหน่ง 4 ซึ่งเกิดการชน  ดังนั้นจึง probe ไป ช่องว่างถัดไป นั่นคือช่องที่มี index 5 ดังรูปข้างล่างนี้

// 	หลังจากนั้นเติมข้อมูลต่อไปเข้าไปใน hast table โดบใช้ hash function เดิม คือ mod 10 จะได้ ข้อมูลใน hash table ดังรูปข้างล่าง 72 2, 900, 833 และ 9 9



// ถ้าสมมุติเรามีข้อมูลตัวที่ 10 เพิ่มเข้ามา ซึ่งตำแหน่งในถังตั้งต้นของมันคือ 5 จากนั้นนำ 5 เข้า hash function
// นั่นคือ 5 mod 10 ผลลัพธ์คือ 5 ซึ่งเกิดการชน จึงทำ Linear probing เพื่อหาช่องว่างถัดไป จะเห็นได้ว่าindex หลังจาก 5 ถูกใช้ไปหมด จึงย้อนกลับมาพิจารณาเริ่มที่ index 0 ใหม่ จะเห็นได้ว่า index 3 ว่าง จึงนำข้อมูลที่เข้ามาใหม่นี้ไปเก็บที่ตำแหน่ง 3 ดังรูปข้างล่างนี้

// 7.1.2 Chaining
// การแก้ปัญหาการชนอย่างหนึ่ง เมื่อเกิดการชนขึ้นจะนำข้อมูลที่มาชนไปใส่ใน Linked List ต่อท้ายของช่องที่ได้จากผลลัพธ์ของ hash function

// เริ่มจากข้อมูลตัวแรกคือตำแหน่ง 4 จากถังต้นทาง  ให้นำ 4 เข้า hash function นั่นคือ 4 mod 10 ผลลัพธ์คือ 4 เพราะฉะนั้น map จากตำแหน่ง 4 ของถังต้นทางไปยังตำแหน่ง 4 ของ hash table ดังรูปข้างล่างนี้

// ข้อมูลถัดไปคือตำแหน่ง 7 จากถังต้นทาง  ให้นำ 7 เข้า hash function นั่นคือ 7 mod 10 ผลลัพธ์คือ 7 เพราะฉะนั้น map จากตำแหน่ง 7 ของถังต้นทางไปยังตำแหน่ง 7 ของ hash table ดังรูปข้างล่างนี้

// 	ข้อมูลถัดไปคือตำแหน่ง 18 จากถังต้นทาง  ให้นำ 18 เข้า hash function นั่นคือ 18 mod 10 ผลลัพธ์คือ 8 เพราะฉะนั้น map จากตำแหน่ง 18 ของถังต้นทางไปยังตำแหน่ง 8 ของ hash table ดังรูปข้างล่างนี้

// ข้อมูลถัดไปคือตำแหน่ง 36 จากถังต้นทาง  ให้นำ 36 เข้า hash function นั่นคือ 36 mod 10 ผลลัพธ์คือ 6 เพราะฉะนั้น map จากตำแหน่ง 36 ของถังต้นทางไปยังตำแหน่ง 6 ของ hash table ดังรูปข้างล่างนี้

// 	ข้อมูลถัดไปคือตำแหน่ง 24 จากถังต้นทาง  ให้นำ 24 เข้า hash function นั่นคือ 24 mod 10 ผลลัพธ์คือ 4 จะเห็นได้ว่า ที่ตำแหน้าง 4 นี้ มีข้อมูลอยู่แล้ว นั่นคือเกิดการชนขึ้น จึงนำข้อมูลตัวใหม่นั่นคือ 24 ใส่ใน Linked List แล้วต่อไปที่ index ที่ 4








// ใช้ Chaining แก้ปัญหาการชนกันไปเรื่อย ๆจะได้ ผลลัพธ์ของ hash table ดัง 2 รูปข้างล่างตามลำดับ


// 7.1.3 Double Hashing
// การแก้ปัญหาการชนอย่างหนึ่ง เมื่อเกิดการชนขึ้น แสดงว่า hash function ตัวแรก ทำให้เกิดการชน จึงแก้ปัญหา โดยนำ key ตั้งต้นไปเป็น input ของ hash function อีกตัวนึง เพื่อ นำผลลัพธ์ตำแหน่งที่ได้จาก hash function ตัวแรก มา probe ด้วยจำนวนเท่ากับผลลัพธ์ของ hash function ตัวที่ 2  นั่นคือเมื่อเกิดการชนขึ้น ผลลัพธ์ของตำแหน่งใหม่คือ ผลลัพธ์ที่ได้จาก hash function ตัวแรก + ผลลัพธ์ได้จาก hash function ตัวที่ 2 ถ้าผลลัพธ์ล่าสุดยังเกิดการชนอีก ก็จะ probe ด้วยจำนวนเท่ากับผลลัพธ์ของ hash function ตัวที่ 2 ไปอีกจนกว่าจะเจอตำแหน่งที่จะไม่เกิดการชน นั่นคือ ผลลัพธ์ของตำแหน่งใหม่คือ ผลลัพธ์ที่ได้จาก hash function ตัวแรก + ผลลัพธ์ได้จาก hash function ตัวที่ 2+ ผลลัพธ์ได้จาก hash function ตัวที่ 2  จนกว่าจะเจอตำแหน่งที่จะไม่เกิดการชน
// โดยทั่วไป hash function ตัวแรก คือ นำตำแหน่งของข้อมูในถังข้อมูลตั้งต้นเรียกว่า key (k) ไป mod กับ ขนาดของ hash table  นั่นคือ hash functionตัวแรก จะเป็น h(k) = k mod N เมื่อ N เป็นขนาดของ hash table และ hash function ตัวที่ 2 โดยทั่วไป จะเป็น d(k) = a – (k mod a) เมื่อ a< N และ a ควรเป็นจำนวนเฉพาะ
// ตัวอย่าง
// ถ้าขนาดของ hash table คือ N = 13 เพราะฉะนั้น  hash function ตัวแรกคือ h(k) = k mod 13 ส่วน hash function ตัวที่ 2 คือ d(k)= 7 –k mod  7.  ตัวอย่างนี้เลือก a = 7 ซึ่งน้อยกว่า N ซึ่งมีค่า 13
// จากตัวอย่างข้างล่าง ถ้ามีข้อมูล 8 ตัว และมีตำแหน่งของข้อมูลจากถังต้นทางซึ่งมีขนาด 100 ช่อง เป็นดังนี้  18, 41, 22, 44, 59, 32, 31, 73

// 	เริ่มจากข้อมูลตัวแรกคือตำแหน่ง 18 จากถังต้นทาง  ให้นำ 18 เข้า hash functionตัวแรก นั่นคือ 18 mod 13 ผลลัพธ์คือ 5 เพราะฉะนั้น map จากตำแหน่ง 18 ของถังต้นทางไปยังตำแหน่ง 5 ของ hash table ดังรูปข้างล่างนี้


// 	ข้อมูลตัวถัดไปคือตำแหน่ง 41 จากถังต้นทาง  ให้นำ 41 เข้า hash functionตัวแรก นั่นคือ 41 mod 13 ผลลัพธ์คือ 2เพราะฉะนั้น map จากตำแหน่ง 41 ของถังต้นทางไปยังตำแหน่ง 2 ของ hash table ดังรูปข้างล่างนี้


// ข้อมูลตัวถัดไปคือตำแหน่ง 22 จากถังต้นทาง  ให้นำ 22 เข้า hash functionตัวแรก นั่นคือ 22 mod 13 ผลลัพธ์คือ 9เพราะฉะนั้น map จากตำแหน่ง 22 ของถังต้นทางไปยังตำแหน่ง 9 ของ hash table ดังรูปข้างล่างนี้






// ข้อมูลตัวถัดไปคือตำแหน่ง 44 จากถังต้นทาง  ให้นำ 44 เข้า hash functionตัวแรก นั่นคือ 44 mod 13 ผลลัพธ์คือ 5 จะเห็นได้ว่า ที่ตำแหน้าง 5 นี้ มีข้อมูลอยู่แล้ว นั่นคือเกิดการชนขึ้น จึงนำ 44 เข้า hash functionตัวที่ 2  นั่นคือ 7- (44 mod 7) ผลลัพธ์คือ 5  จากหลักการของ Double hashing ผลลัพธ์ของตำแหน่งใหม่คือ ผลลัพธ์ที่ได้จาก hash function ตัวแรก + ผลลัพธ์ได้จาก hash function ตัวที่ 2 เพราะฉะนั้น map จากตำแหน่ง 44ของถังต้นทางไปยังตำแหน่ง
// 5 +5 = 10 ของ hash table ดังรูปข้างล่างนี้

// ข้อมูลตัวถัดไปคือตำแหน่ง 59 จากถังต้นทาง  ให้นำ 59 เข้า hash functionตัวแรก นั่นคือ 59 mod 13 ผลลัพธ์คือ 7เพราะฉะนั้น map จากตำแหน่ง 59 ของถังต้นทางไปยังตำแหน่ง 7 ของ hash table ดังรูปข้างล่างนี้

// ข้อมูลตัวถัดไปคือตำแหน่ง 32 จากถังต้นทาง  ให้นำ 32 เข้า hash functionตัวแรก นั่นคือ 32 mod 13 ผลลัพธ์คือ 6เพราะฉะนั้น map จากตำแหน่ง 32 ของถังต้นทางไปยังตำแหน่ง 6 ของ hash table ดังรูปข้างล่างนี้

// 	ข้อมูลตัวถัดไปคือตำแหน่ง 31 จากถังต้นทาง  ให้นำ 31 เข้า hash functionตัวแรก นั่นคือ 31 mod 13 ผลลัพธ์คือ 5 จะเห็นได้ว่า ที่ตำแหน้าง 5 นี้ มีข้อมูลอยู่แล้ว นั่นคือเกิดการชนขึ้น จึงนำ 31 เข้า hash functionตัวที่ 2  นั่นคือ
// 7- (31 mod 7) ผลลัพธ์คือ 4 จากหลักการของ Double hashing ผลลัพธ์ของตำแหน่งใหม่คือ ผลลัพธ์ที่ได้จาก hash function ตัวแรก + ผลลัพธ์ได้จาก hash function ตัวที่ 2 นั่นคือ 5 +4 = 9
// 	จะเห็นได้ว่ายังเกิดการชนอยู่จึงต้อง probe ไปอีกครั้งด้วยจำนวนเท่ากับ ผลลัพธ์ที่ได้จาก hash function ตัวที่ 2 เพราะฉะนั้น map จากตำแหน่ง 31 ของถังต้นทางไปยังตำแหน่ง 5 +4 +4= 13 ของ hash table  แต่ 13 เกินจำนวน index จึงต้อง mod ด้วยจำนวนช่องของ hash table เพื่อวนกลับมาใช้ index แรก ๆ   นั่นคือ 13 mod 13 เท่ากับ 0 เพราะฉะนั้น map จากตำแหน่ง 31 ของถังต้นทางไปยังตำแหน่ง 0 ของ hash table ดังรูปข้างล่างนี้




// 	ข้อมูลตัวถัดไปคือตำแหน่ง 73 จากถังต้นทาง  ให้นำ 73 เข้า hash functionตัวแรก นั่นคือ 73 mod 13 ผลลัพธ์คือ 8เพราะฉะนั้น map จากตำแหน่ง 73 ของถังต้นทางไปยังตำแหน่ง 8 ของ hash table ดังรูปข้างล่างนี้

// จบการทำ hashing  สำหรับ list ของตำแหน่งตั้งต้น 18, 41, 22, 44, 59, 32, 31, 73  นี้

// 7.2 Searching
// การค้นหาข้อมูลใน List ของข้อมูล มีการค้นหา อยู่ 2 แบบ
// - Sequential Search หรือ Linear Search
// - Binary Search

// 7.2.1 Sequential Search
//              การค้นหาข้อมูลเป้าหมายในList นั่นคือต้องเริ่มตรวจสอบตั้งแต่ข้อมูลแรกใน List จนกว่าจะเจอข้อมูลที่ต้องการ นั่นคือเหมือนกับการค้นหาข้อมูลใน  Singly Linked List
// ตัวอย่าง ถ้าจะหาข้อมูลที่มีค่า 5 ใน Linked List ต้องทำการตรวจสอบตั้งแต่ข้อมูลตัวแรกที่ ตัวชี้ first ชี้อยู่ ว่าใช่ไหม ถ้าไม่ใช่จะค้นหาตัวถัดไปจนกว่าจะเจอข้อมูล 5

// 7.2.2 Binary Search
// คือการค้นหาข้อมูลเป้าหมายเหมือนกับการค้นหาข้อมูลใน Binary Search Tree นั่นคือค้นหาข้อมูลโดยการแบ่งทีละครึ่งแล้วดูว่าข้อมูลเป้าหมาย อยู่ทางครึ่งแรกหรือครึ่งหลัง ถ้าอยู่ทางครึ่งไหน ก็ให้พิจารณาค้นหาเฉพาะข้อมูลในครึ่งนั้น แล้วทำการแบ่งครึ่งต่อ
// ตัวอย่างถ้าต้องการหา ข้อมูล 5 ใน list ข้อมูลนี้  1, 2, 4, 5, 6,

// ทำการค้นหาข้อมูล 5 โดย การแบ่งครึ่งข้อมูลก่อน  เนื่องจากตำแหน่งเริ่มที่ 0 ส่วนตำแหน่งสุดท้ายของ List นี้คือ 4 เพราะฉะนั้นตำแหน่งกึ่งกล่งของ List นี้คือ  (0+4)/2 =2  นั้นคือข้อมูลที่มีค่า 4 เป็นข้อมูลกึ่งกลาง จากนั้นเปรียบเทียบค่ากึ่งกล่างกับข้อมูลเป้าหมาย นั่นคือ 5  > 4 เพราะฉะนั้น จะพิจารณา ข้อมูลครึ่ง หลัง  5, 6 ต่อจากนั้น ทำการแบ่งครึ่งข้อมูลต่อ เนื่องจากตำแหน่งเริ่มต้นของ List ครึ่งหลังคือตำแหน่งที่  ตำแหน่งกึ่งกลาง(2) + 1=3  ส่วนตำแหน่งสุดท้ายของ List ครึ่งหลังนี้เป็นตัวเดิม คือ 4 เพราะฉะนั้นตำแหน่งกึ่งกลางของ list นี้คือ  (3+4)/2 = 3  นั้นคือข้อมูลที่มีค่า 5 เป็นข้อมูลกึ่งกลาง เนื่องจากข้อมูลของค่ากึ่งกลางคือข้อมูล 5 นั่นคือพบข้อมูล 5 แล้ว

// 	ถ้ามีข้อมูลจำนวน n ข้อมูล  อยู่ใน array a แล้วจะทำการค้นหาข้อมูลเป้าหมาย t จะมีโปรแกรมการทำงานดังนี้
// public int binarysearch(int a[ ], int n, int t)
// {           int l, m, h;
//            l=0;  // array index เริ่มที่ 0 นั่นคือตำแหน่งแรกของ list ข้อมูล
//            h = n-1;  //array ช่องสุดท้ายคือ index = จำนวนช่องลบด้วย 1 นั่นคือตำแหน่งสุดท้ายของ list ข้อมูล
//            boolean found;  found = false;
//             while(( l <= h) && (!found))
//              {      m = (l + h) /2); // m คือตำแหน่ง กึ่งกลาง ของ list
//                    If(a[m] == t)  found = true;
//                    else if( a[m] < t )   l = m+1;  // ค้นหาข้อมูลเป้าหมายต่อในครึ่งแรก
//                    else h = m – 1; // ค้นหาข้อมูลเป้าหมายต่อในครึ่งหลัง
//            }
// }










// แบบฝึกหัดท้ายบท
// จงหาผลลัพธ์ของ hash table เมื่อมีตำแหน่งของข้อมูลตั้งต้นดังนี้

//     1. ใช้ Linear Probing ในการแก้ปัญหาการชน
//     2. ใช้ Double Hashing ในการแก้ปัญหาการชน โดยมี hash function แรก คือ key mod 10  ส่วน hash function ตัวที่ 2 คือ 7 – (key mod 7)


















// บทที่ 8 Sorting การเรียงลำดับข้อมูล
// 	คือการเรียงข้อมูลจากมากไปน้อยหรือจากน้อยไปมาก ในที่นี้จะแสดงการเรียงแต่จากน้อยไปมาก ในที่นี้จะอธิบายการเรียง 4 วิธี
//     • การเรียงแบบเลือก Selection Sort
//     • การเรียงแบบฟอง Bubble Sort
//     • Merge Sort
//     • Quick Sort

// 8.1 การเรียงแบบเลือก Selection Sort
// 	วิธีนี้ในแต่ละรอบ เริ่มต้นโดยหาค่าตัวที่น้อยที่สุดจากข้อมูลทั้งหมด แล้วเอาข้อมูลตัวที่น้อยที่สุดมาวางไว้บนสุด โดยการสลับค่าน้อยที่สุดกับค่าที่อยู่ที่ตำแหน่งบนสุด (ตำแหน่งที่มี index 0) เริ่มต้นจากข้อมูลดังใน array ข้างล่างนี้ แล้วจะแสดงขั้นตอนเของ Selection Sort เพื่อที่จะเรียงข้อมูลจากน้อยไปมาก

// รอบที่ 1
// 	หาตัวที่น้อยที่สุด ในที่นี้คือ ค่า 3 นำค่า 3 นี้มาวางไว้บนสุด โดยการสลับค่าน้อยที่สุด (3) กับค่าที่อยู่ที่ตำแหน่งบนสุด (9) นั่นคือจบ 1 รอบ หมายถึงเลข 3 ทำการเรียงลำดับเสร็จแล้ว(สีเทา) ดังรูปข้างล่างนี้

// รอบที่ 2
//            ตอนนี้เหลือข้อมูลที่ยังไม่เรียงอยู่ 4 ตัว ภายใน 4 ตัวนี้ ให้หาค่าที่น้อยที่สุด ซึ่งคือค่า 4 นำค่า 4 นี้มาวางไว้ข้างบนเป็นตัวถัดไป โดยการสลับค่าน้อยที่สุด (4) กับค่าที่อยู่ที่ตำแหน่งบนสุด (6) นั่นคือจบรอบที่ 2 หมายถึงเลข 4 ทำการเรียงลำดับเสร็จแล้ว(สีเทา) ดังรูปข้างล่างนี้

// รอบที่3
// 	ตอนนี้เหลือข้อมูลที่ยังไม่เรียงอยู่ 3 ตัว ภายใน 3 ตัวนี้ ให้หาค่าที่น้อยที่สุด ซึ่งคือค่า 5 นำค่า 5 นี้มาวางไว้ข้างบนเป็นตัวถัดไป แตต่ค่า 5 อยู่บนสุดอยู่แล้วจึงไม่ต้องทำการสลับค่า นั่นคือจบรอบที่ 3 หมายถึงเลข 5 ทำการเรียงลำดับเสร็จแล้ว(สีเทา) ดังรูปข้างล่างนี้

// รอบที่ 4
// 	ตอนนี้เหลือข้อมูลที่ยังไม่เรียงอยู่ 2 ตัว ภายใน 2ตัวนี้ ให้หาค่าที่น้อยที่สุด ซึ่งคือค่า 6 นำค่า 6 นี้มาวางไว้ข้างบนเป็นตัวถัดไป โดยการสลับค่าน้อยที่สุด (6) กับค่าที่อยู่ที่ตำแหน่งบนสุด (9) นั่นคือจบรอบที่ 4 หมายถึงเลข 6 ทำการเรียงลำดับเสร็จแล้ว(สีเทา)  ขณะนี้เหลือค่าตัวสุดท้ายคือค่า 9 เพราะฉะนั้นการเรียงจึงเสร็จสมบูรณ์ ดังรูปข้างล่างนี้

// โปรแกรมข้างล่างนี้คือขั้นตอนการทำ Selection Sort
// public void SelectionSort( int a[], int s)
// {  //ตัวแปร a คือ array ของข้อมูลเริ่มต้น ตัวแปร s คือจำนวนข้อมูลที่นำมาเรียง
//       int i, r, index_min, temp;
//       for(r=0; r<s-1; r++)
//         {
//            index_min = r;
//            for(i = r+1; I < s; i++)
//               {
//               if ( a[i]< a[index_min])
//                     Index_min= i;
//                } // end the second for
//            if(index_min != r)
//             {  temp = a[r];
//                 a[r] = a[index_min];
//                 a[index_min] = temp;
//              }
//          } // end the first for
// }   // end of method SelectionSort



// 8.2 การเรียงแบบฟอง Bubble Sort
// 	แต่ละรอบจะเริ่มที่ช่องล่างสุดและ ทำการเปรียบเทียบแต่ละคู่ข้อมูล ถ้าอันล่างมีค่าน้อยกว่าก็จะสลับขึ้นไป และเปรียบเทียบกับตัวถัดขึ้นไปทีละคู่จนถึงตำแหน่งบนสุดของกลุ่มข้อมูลที่ยังไม่ได้เรียงของแต่ละรอบ เริ่มต้นจากข้อมูลดังใน array ข้างล่างนี้ แล้วจะแสดงขั้นตอนเของ Bubble Sort เพื่อที่จะเรียงข้อมูลจากน้อยไปมาก

// รอบที่1
// พิจารณาข้อมูลตัวล่างสุดคือเลข 2 ให้เปรียบเทียบตัวที่อยู่ติดกันด้านบนคือ 4 แล้วดูว่าคู่นี้ เลข 2 น้อยกว่าเลข 4 หรือไม่ ในที่นี้คำตอบคือใช่ จึงทำการสลับที่กัน เพราะฉะนั้นเลข 2 จึงลอยขึ้นมา 1  ตำแหน่ง ดังรูปข้างล่างนี้

// ต่อมาเปรียบเทียบเลข 2 กับเลขที่อยู่ติดกันด้านบนนั่นคือเลข 9 ปรากฏว่า เลข 2 น้อยกว่าเลข 9 จึงทำการสลับที่กัน เพราะฉะนั้นเลข 2 จึงลอยขึ้นมา 1  ตำแหน่ง ดังรูปข้างล่างนี้

// 	ต่อมาเปรียบเทียบเลข 2 กับเลขที่อยู่ติดกันด้านบนนั่นคือเลข 8 ปรากฏว่า เลข 2 น้อยกว่าเลข 8 จึงทำการสลับที่กัน เพราะฉะนั้นเลข 2 จึงลอยขึ้นมา 1  ตำแหน่ง ดังรูปข้างล่างนี้


// 	ต่อมาเปรียบเทียบเลข 2 กับเลขที่อยู่ติดกันด้านบนนั่นคือเลข 6 ปรากฏว่า เลข 2 น้อยกว่าเลข 6 จึงทำการสลับที่กัน เพราะฉะนั้นเลข 2 จึงลอยขึ้นมา 1  ตำแหน่ง ดังรูปข้างล่างนี้


// 	ต่อมาเปรียบเทียบเลข 2 กับเลขที่อยู่ติดกันด้านบนนั่นคือเลข 20 ปรากฏว่า เลข 2 น้อยกว่าเลข 20 จึงทำการสลับที่กัน เพราะฉะนั้นเลข 2 จึงลอยขึ้นมา 1  ตำแหน่ง ขณะนี้เลข 2 ลอยมาถึงตำแหน่งบนสุด เพราะฉะนั้นคือจบ 1 รอบ หมายถึงเลข 2 ทำการเรียงลำดับเสร็จแล้ว (สีเทา) ดังรูปข้างล่างนี้


// รอบที่2
// พิจารณาข้อมูลตัวล่างสุดคือเลข 4 ให้เปรียบเทียบตัวที่อยู่ติดกันด้านบนนั่นคือ 9 แล้วดูว่าคู่นี้ เลข 4 น้อยกว่าเลข 9 หรือไม่ ในที่นี้คำตอบคือใช่ จึงทำการสลับที่กัน เพราะฉะนั้นเลข 4 จึงลอยขึ้นมา 1  ตำแหน่ง ดังรูปข้างล่างนี้

// 	ต่อมาเปรียบเทียบเลข 4 กับเลขที่อยู่ติดกันด้านบนนั่นคือเลข 8 ปรากฏว่า เลข 4 น้อยกว่าเลข 8 จึงทำการสลับที่กัน เพราะฉะนั้นเลข 4 จึงลอยขึ้นมา 1  ตำแหน่ง ดังรูปข้างล่างนี้

// 	ต่อมาเปรียบเทียบเลข 4 กับเลขที่อยู่ติดกันด้านบนนั่นคือเลข 6 ปรากฏว่า เลข 4 น้อยกว่าเลข 6 จึงทำการสลับที่กัน เพราะฉะนั้นเลข 4 จึงลอยขึ้นมา 1  ตำแหน่ง ดังรูปข้างล่างนี้


// ต่อมาเปรียบเทียบเลข 4 กับเลขที่อยู่ติดกันด้านบนนั่นคือเลข 20 ปรากฏว่า เลข4 น้อยกว่าเลข 20 จึงทำการสลับที่กัน เพราะฉะนั้นเลข 4 จึงลอยขึ้นมา 1  ตำแหน่ง ขณะนี้เลข 4 ลอยมาถึงตำแหน่งบนสุดของตัวที่ยังไม่ได้เรียง เพราะฉะนั้นคือจบรอบที่ 2 หมายถึงเลข 4 ทำการเรียงลำดับเสร็จแล้ว (สีเทา) ดังรูปข้างล่างนี้

// รอบที่3
// 	พิจารณาข้อมูลตัวล่างสุดคือเลข 9 ให้เปรียบเทียบตัวที่อยู่อยู่ติดกันด้านบนคือ 8 แล้วดูว่าคู่นี้ เลข 9 น้อยกว่าเลข 8 หรือไม่ ในที่นี้คำตอบคือไม่ จึงไม่ทำการสลับที่กัน นั่นคือสำหรับคู่นี้ 8 อยู่เหนือเลข 9 เป็นตำแหน่งที่ถูกแล้ว  ดังรูปข้างล่าง


// 	ต่อมาเปรียบเทียบเลข 8 กับเลขที่อยู่ติดกันด้านบนนั่นคือเลข 6 ปรากฏว่า เลข 8 ไม่น้อยกว่าเลข 6 จึงไม่ทำการสลับที่กัน นั่นคือสำหรับคู่นี้ 6 อยู่เหนือเลข 8 เป็นตำแหน่งที่ถูกแล้ว  ดังรูปข้างล่างนี้


// ต่อมาเปรียบเทียบเลข 6 กับเลขที่อยู่ติดกันด้านบนนั่นคือเลข 20 ปรากฏว่า เลข6 น้อยกว่าเลข 20 จึงทำการสลับที่กัน เพราะฉะนั้นเลข 6 จึงลอยขึ้นมา 1  ตำแหน่ง ขณะนี้เลข 6 ลอยมาถึงตำแหน่งบนสุดของตัวที่ยังไม่ได้เรียง เพราะฉะนั้นคือจบรอบที่ 3 หมายถึงเลข 6 ทำการเรียงลำดับเสร็จแล้ว (สีเทา) ดังรูปข้างล่างนี้


// รอบที่4
// 	พิจารณาข้อมูลตัวล่างสุดคือเลข 9 ให้เปรียบเทียบตัวที่อยู่ติดกันด้านบนคือ 8 แล้วดูว่าคู่นี้ เลข 9 น้อยกว่าเลข 8 หรือไม่ ในที่นี้คำตอบคือไม่ จึงไม่ทำการสลับที่กัน นั่นคือสำหรับคู่นี้ 8 อยู่เหนือเลข 9 เป็นตำแหน่งที่ถูกแล้ว  ดังรูปข้างล่าง


// ต่อมาเปรียบเทียบเลข 8 กับเลขที่อยู่ติดกันด้านบนนั่นคือเลข 20 ปรากฏว่า เลข 8 น้อยกว่าเลข 20 จึงทำการสลับที่กัน เพราะฉะนั้นเลข 8 จึงลอยขึ้นมา 1  ตำแหน่ง ขณะนี้เลข 8 ลอยมาถึงตำแหน่งบนสุดของตัวที่ยังไม่ได้เรียง เพราะฉะนั้นคือจบรอบที่ 4 หมายถึงเลข 8 ทำการเรียงลำดับเสร็จแล้ว (สีเทา) ดังรูปข้างล่างนี้

// รอบที่5
// พิจารณาข้อมูลตัวล่างสุดคือเลข 9 ให้เปรียบเทียบตัวที่อยู่ติดกันด้านบนคือ 20 แล้วดูว่าคู่นี้ เลข 9 น้อยกว่าเลข 20 หรือไม่ ในที่นี้คำตอบคือใช่ จึงทำการสลับที่กัน เพราะฉะนั้นเลข 9 จึงลอยขึ้นมา 1  ตำแหน่ง นั่นคือจบรอบ5 หมายถึงเลข 9 ทำการเรียงลำดับเสร็จแล้ว (สีเทา)  ขณะนี้เหลือค่าตัวสุดท้ายคือค่า 20 เพราะฉะนั้นการเรียงจึงเสร็จสมบูรณ์
// ดังรูปข้างล่างนี้

// โปรแกรมข้างล่างนี้คือขั้นตอนการทำ Bubble Sort
// public void BubbleSort( int a[], int s)
// { //ตัวแปร a คือ array ของข้อมูลเริ่มต้น ตัวแปร s คือจำนวนข้อมูลที่นำมาเรียง
//    int I, start, temp;
//   for(i=1; i<s; i++)
//     for(start = s-1; start>=I; start--)
//     if(a[start]< a[start-1])
//      { temp = a[start-1];
//         a[start-1] a[start];
//          a[start] =temp;
//       }
// }// end of BubbleSort method
// 8.3 Merge Sort
// วิธีนี้มีขั้นตอนดังนี้
//     • แบ่งข้อมูลเป็นกลุ่มย่อย
//     • จัดการเรียงข้อมูลในกลุ่มย่อย
//     • รวมข้อมูลกลุ่มย่อยเข้าด้วยกันเพื่อเรียงข้อมูลในกลุ่มใหญ่ขึ้น
// เริ่มต้นจากข้อมูลดังใน array a ข้างล่างนี้ แล้วจะแสดงขั้นตอนเของ Merge Sort เพื่อที่จะเรียงข้อมูลจากน้อยไปมาก

//     • Split แบ่งข้อมูลเป็นกลุ่มย่อย โดยแบ่งครึ่งไปเรื่อย ๆจนแบ่งไม่ได้



//     • จัดการเรียงข้อมูลในกลุ่มย่อย
//     • รวมข้อมูลกลุ่มย่อยเข้าด้วยกันเพื่อเรียงข้อมูลกันกลายเป็นกลุ่มใหญ่ขึ้น






// โปรแกรมข้างล่างนี้คือขั้นตอนการทำ Merge Sort
// public class MergeSort {
//     private int[] array;
//     private int index;

//     public MergeSort(int max) {
//         array = new int[max];
//         index = 0;
//     }

//     public void insert(int value) {
//         array[index] = value; // insert it
//         index++; // increment size
//     }

//     public void printArray() {
//         for (int i = 0; i < index; i++)
//             System.out.print(array[i] + "\t");
//         System.out.println();
//         System.out.println();
//     }

//     public void mergeSort() {
//         int[] workSpace = new int[index];
//         recMergeSort(workSpace, 0, index - 1);
//     }




//     private void recMergeSort(int[] workSpace, int lowerBound, int upperBound) {
//         if (lowerBound == upperBound) // if range is 1,
//             return; // no use sorting
//         else { // find midpoint
//             int mid = (lowerBound + upperBound) / 2;
//             recMergeSort(workSpace, lowerBound, mid);           // sort low half
//             recMergeSort(workSpace, mid + 1, upperBound);       // sort high half
//         // merge them
//             merge(workSpace, lowerBound, mid + 1, upperBound);
//         }
//     }

//     private void merge(int[] workSpace, int lowPtr, int highPtr, int upperBound) {
//         int j = 0; // workspace index
//         int lowerBound = lowPtr;
//         int mid = highPtr - 1;
//         int n = upperBound - lowerBound + 1; // # of items

//         while (lowPtr <= mid && highPtr <= upperBound)
//             if (array[lowPtr] < array[highPtr])
//                 workSpace[j++] = array[lowPtr++];
//             else
//                 workSpace[j++] = array[highPtr++];

//         while (lowPtr <= mid)
//             workSpace[j++] = array[lowPtr++];




//         while (highPtr <= upperBound)
//             workSpace[j++] = array[highPtr++];

//         for (j = 0; j < n; j++)
//             array[lowerBound + j] = workSpace[j];
//   }
// }

// 8.4 Quick Sort
// วิธีนี้แบ่งข้อมูลออกเป็นรอบละ 2 ส่วน จนกระทั่งเหลือตัวเดียว
// ถ้าต้องการเรียงจากน้อยไปหามาก วิธีนี้มีขั้นตอนดังนี้
//     • เลือกตัวแบ่งข้อมูล (pivot)
//     • ชุดข้อมูลด้านซ้ายต้องน้อยกว่าหรือเท่ากับ pivot
//     • ชุดข้อมูลด้านขวาต้องมากกว่า pivot

// เริ่มต้นจากข้อมูลดังใน array ข้างล่างนี้ แล้วจะแสดงขั้นตอนเของ Quick Sort เพื่อที่จะเรียงข้อมูลจากน้อยไปมาก

// รอบที่1
// กำหนดให้
// ตัวแปร pivot ชี้ ข้อมูลตัวแรก คือค่า 15
//  	ตัวแปร first ชี้ข้อมูลถัดจากตัว pivot คือค่า 9
// ตัวแปร last ชี้ข้อมูลตัวท้ายสุด คือค่า 12


//     • เลื่อน ตัวแปร first ไปทางขวาหนึ่งตำแหน่งก็ต่อเมื่อค่าของข้อมูลที่ first ชี้อยู่มีค่าน้อยกว่าค่าที่ pivot ชี้อยู่
//     • เลื่อน ตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งก็ต่อเมื่อค่าของข้อมูลที่ last ชี้อยู่มีค่ามากกว่าค่าที่ pivot ชี้อยู่

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 9 ซึ่งน้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นเลื่อนตัวแปร first ไปทางขวาหนึ่งตำแหน่งดังรูปข้างล่างนี้  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 12 ซึ่งไม่มากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร last ไปทางซ้ายดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 7 ซึ่งน้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นเลื่อนตัวแปร first ไปทางขวาหนึ่งตำแหน่งดังรูปข้างล่างนี้  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 12 ซึ่งไม่มากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร last ไปทางซ้ายดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 16 ซึ่งไม่น้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร first ไปทางขวา  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 12 ซึ่งไม่มากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร last ไปทางซ้าย
// เมื่อเกิดกรณีที่ไม่สามารถเลื่อนตัวแปร first และตัวแปร last ได้ทั้งคู่ ให้ทำการสลับค่าข้อมูลระหว่าง  ตัวแปร first และตัวแปร last จะได้ดังรูปข้างล่างนี้

// หลังจากนั้นทำการเลื่อนตัวแปร first และตัวแปร last ต่อ จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 12 ซึ่งน้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นเลื่อนตัวแปร first ไปทางขวาหนึ่งตำแหน่งดังรูปข้างล่างนี้

// ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 16 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 31 ซึ่งไม่น้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร first ไปทางขวา  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 17 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 31 ซึ่งไม่น้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร first ไปทางขวา  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 25 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 31 ซึ่งไม่น้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร first ไปทางขวา  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 20 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้


// เมื่อเกิดกรณีที่ไม่สามารถเลื่อนตัวแปร first และตัวแปร last ได้ทั้งคู่ ให้ทำการสลับค่าข้อมูลระหว่าง  ตัวแปร first และตัวแปร last จะได้ดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 2 ซึ่งน้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นเลื่อนตัวแปร first ไปทางขวาหนึ่งตำแหน่งดังรูปข้างล่างนี้

// ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 31 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงทำ
// การเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// เมื่อตำแหน่งของlast น้อยกว่า ตำแหน่งของfirst ให้หยุดเลื่อนตัวแปร first และตัวแปร last  จากนั้นแบ่งข้อมูลออกเป็น 2 ส่วน แล้วให้สลับค่า pivot ไปไว้ตัวท้ายสุดสำหรับข้อมูลกลุ่มทางซ้าย แล้ว pivot ซึ่งขณะนี้คือข้อมูล 15นั้นจะกลายเป็นตัวที่ทำการเรียงแล้ว ดัง 2 รูปข้างล่าง


// รอบที่2 พิจารณาข้อมูลกลุ่มทางซ้ายที่ได้มาจากรอบที่แล้ว
// กำหนดให้
// ตัวแปร pivot ชี้ ข้อมูลตัวแรก คือค่า 2
//  	ตัวแปร first ชี้ข้อมูลถัดจากตัว pivot คือค่า 9
// ตัวแปร last ชี้ข้อมูลตัวท้ายสุด คือค่า 12

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 9 ซึ่งไม่น้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 2 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร first ไปทางขวา  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 12 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 2 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 9 ซึ่งไม่น้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 2 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร first ไปทางขวา  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 7 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 2 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 9 ซึ่งไม่น้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 2 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร first ไปทางขวา  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 9 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 2 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนเมื่อตำแหน่งของlast น้อยกว่าตำแหน่งของfirst ให้หยุดเลื่อนตัวแปร first และตัวแปร last แล้วแบ่งข้อมูลออกเป็น 2 ส่วน แล้วให้สลับค่า pivot ไปไว้ตัวท้ายสุดสำหรับข้อมูลกลุ่มทางซ้าย แล้ว pivot ซึ่งขณะนี้คือข้อมูล 2 นั้นจะกลายเป็นตัวที่ทำการเรียงแล้ว ดังรูปข้างล่าง

// รอบที่3 พิจารณาข้อมูลกลุ่มทางขวาที่ได้มาจากรอบที่แล้ว
// กำหนดให้
// ตัวแปร pivot ชี้ ข้อมูลตัวแรก คือค่า 9
//  	ตัวแปร first ชี้ข้อมูลถัดจากตัว pivot คือค่า 7
// ตัวแปร last ชี้ข้อมูลตัวท้ายสุด คือค่า 12

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 7 ซึ่งน้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 9 เพราะฉะนั้นเลื่อนตัวแปร first ไปทางขวาหนึ่งตำแหน่งดังรูปข้างล่างนี้

// ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 12 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 15 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนเมื่อตำแหน่งของlast น้อยกว่า ตำแหน่งของfirst ให้หยุดเลื่อนตัวแปร first และตัวแปร last แล้วแบ่งข้อมูลออกเป็น 2 ส่วน แล้วให้สลับค่า pivot ไปไว้ตัวท้ายสุดสำหรับข้อมูลกลุ่มทางซ้าย แล้ว pivot ซึ่งขณะนี้คือข้อมูล 9 นั้นจะกลายเป็นตัวที่ทำการเรียงแล้ว ดัง 3 รูปข้างล่าง





// รอบที่4 พิจารณาข้อมูลกลุ่มที่ยังไม่เรียงจากรอบที่แล้ว
// กำหนดให้
// ตัวแปร pivot ชี้ ข้อมูลตัวแรก คือค่า 31
//  ตัวแปร first ชี้ข้อมูลถัดจากตัว pivot คือค่า 20
// ตัวแปร last ชี้ข้อมูลตัวท้ายสุด คือค่า 16

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 20 ซึ่งน้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 31 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร first ไปทางขวา ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 16 ซึ่งไม่มากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 31 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่ง ดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 25 ซึ่งน้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 31 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร first ไปทางขวา ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 16 ซึ่งไม่มากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 31 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่ง ดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 17  ซึ่งน้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 31 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร first ไปทางขวา ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 16 ซึ่งไม่มากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 31 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่ง ดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 16  ซึ่งน้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 31 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร first ไปทางขวา ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 16 ซึ่งไม่มากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 31 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่ง ดังรูปข้างล่างนี้

// จากรูปข้างบนเมื่อตำแหน่งของlast น้อยกว่า ตำแหน่งของfirst ให้หยุดเลื่อนตัวแปร first และตัวแปร last แล้วแบ่งข้อมูลออกเป็น 2 ส่วน แล้วให้สลับค่า pivot ไปไว้ตัวท้ายสุดสำหรับข้อมูลกลุ่มทางซ้าย แล้ว pivot ซึ่งขณะนี้คือข้อมูล 31 นั้นจะกลายเป็นตัวที่ทำการเรียงแล้ว ดังรูปข้างล่าง


// รอบที่5 พิจารณาข้อมูลกลุ่มที่ยังไม่เรียงจากรอบที่แล้ว
// กำหนดให้
// ตัวแปร pivot ชี้ ข้อมูลตัวแรก คือค่า 16
//  	ตัวแปร first ชี้ข้อมูลถัดจากตัว pivot คือค่า 20
// ตัวแปร last ชี้ข้อมูลตัวท้ายสุด คือค่า 17

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 20 ซึ่งไม่น้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 16 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร first ไปทางขวา  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 17 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 16 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 20 ซึ่งไม่น้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 16 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร first ไปทางขวา  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 25 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 16 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 20 ซึ่งไม่น้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 16 เพราะฉะนั้นจึงไม่ทำการเลื่อนตัวแปร first ไปทางขวา  ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 20 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 16 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนเมื่อตำแหน่งของlast น้อยกว่า ตำแหน่งของfirst ให้หยุดเลื่อนตัวแปร first และตัวแปร last แล้วแบ่งข้อมูลออกเป็น 2 ส่วน แล้วให้สลับค่า pivot ไปไว้ตัวท้ายสุดสำหรับข้อมูลกลุ่มทางซ้าย แล้ว pivot ซึ่งขณะนี้คือข้อมูล 2 นั้นจะกลายเป็นตัวที่ทำการเรียงแล้ว ดังรูปข้างล่าง

// รอบที่6 พิจารณาข้อมูลกลุ่มที่ยังไม่เรียงจากรอบที่แล้ว
// กำหนดให้
// ตัวแปร pivot ชี้ ข้อมูลตัวแรก คือค่า 20
//  	ตัวแปร first ชี้ข้อมูลถัดจากตัว pivot คือค่า 25
// ตัวแปร last ชี้ข้อมูลตัวท้ายสุด คือค่า 17

// จากรูปข้างบนเกิดเกิดกรณีที่ไม่สามารถเลื่อนตัวแปร first และตัวแปร last ได้ทั้งคู่ เพราะ  ค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 25 ไม่น้อยกว่า 20 (pivot) และ ค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ17 ไม่มากกว่า 20 (pivot)  จึงให้ทำการสลับค่าข้อมูลระหว่าง  ตัวแปร first และตัวแปร last จะได้ดังรูปข้างล่างนี้

// จากรูปข้างบนค่าข้อมูลที่ตัวแปร first ชี้อยู่คือ 17 ซึ่งน้อยกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 20 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร first ไปทางขวาหนึ่งตำแหน่ง ดังรูปข้างล่างนี้

// ส่วนค่าข้อมูลที่ตัวแปร last ชี้อยู่คือ 25 ซึ่งมากกว่า ค่าข้อมูลที่ตัวแปร pivot ชี้อยู่นั่นคือ 20 เพราะฉะนั้นจึงทำการเลื่อนตัวแปร last ไปทางซ้ายหนึ่งตำแหน่งดังรูปข้างล่างนี้

// จากรูปข้างบนเมื่อตำแหน่งของlast < ตำแหน่งของfirst ให้หยุดเลื่อนตัวแปร first และตัวแปร last แล้วแบ่งข้อมูลออกเป็น 2 ส่วน แล้วให้สลับค่า pivot ไปไว้ตัวท้ายสุดสำหรับข้อมูลกลุ่มทางซ้าย แล้ว pivot ซึ่งขณะนี้คือข้อมูล 20 นั้นจะกลายเป็นตัวที่ทำการเรียงแล้ว และขณะนี้ไม่เหลือตัวที่ไม่เรียงแล้ว จึงสิ้นสุดการเรียงลำดับของข้อมูลชุดนี้ ดัง 3 รูปข้างล่าง



// ขณะนี้นั่นคือเรียงหมดแล้ว
// โปรแกรมข้างล่างนี้คือขั้นตอนการทำ Quick Sort
// public class QuickSort {
//     int[] array;

//     public void quickSort(int[] a){
//         array = a;
//         QuickSort(array, 0, array.length-1);
//     }

//     public void QuickSort(int[] array, int first, int last){
//         int splitpoint;
//         if(first < last){
//             splitpoint = split(array,first,last);
//             QuickSort(array,first,splitpoint-1);
//             QuickSort(array,splitpoint+1,last);
//         }
//     }
//     public int split(int[] a,int first,int last){
//         int pivot,saveFirst,tmp;
//         boolean lessThanPivot,greaterPivot;
//         pivot = a[first];
//         saveFirst = first;
//         first++;
//         do{
//             lessThanPivot = true;
//             while((first<=last)&&(lessThanPivot)){
//                 if(a[first] > pivot)
//                     lessThanPivot = false;
//                 else
//                     first++;
//             }
//             greaterPivot = true;
//             while((first<=last)&&(greaterPivot)){
//                 if(pivot > a[last])
//                     greaterPivot = false;
//                 else
//                     last--;
//             }
//             if(first < last){
//                 tmp = a[first];
//                 a[first] = a[last];
//                 a[last] = tmp;
//                 first++;
//                 last--;
//             }
//         }while(first <= last);

//         tmp = a[saveFirst];
//         a[saveFirst] = a[last];
//         a[last] = tmp;

//         return last;
//     }

//   public void print(){
//         for(int i = 0; i < array.length; i++)
//             System.out.print(array[i] + "\t");
//         System.out.println();
//         System.out.println();
//     }
// }
















// แบบฝึกหัดท้ายบท
// จงเขียนโปรแกรมจัดเรียงข้อมูลด้วยวิธี Quick sort และ Merge sort     ซึ่งมีรายละเอียดของโปรแกรม   ดังนี้
//     1. สร้างคลาสชื่อ QuickSort    เพื่อเขียนโปรแกรมจัดเรียงข้อมูลที่ได้รับเข้ามาด้วยวิธี Quick sort   โดยรับ input คืออาร์เรย์ของข้อมูลชนิดเลขจำนวนเต็ม   และแสดงผลลัพธ์เป็นอาร์เรย์ของข้อมูลชนิดเลขจำนวนเต็มที่ได้รับการจัดเรียงข้อมูลเรียบร้อยแล้วออกมาทางจอภาพ

//     2. สร้างคลาสชื่อ MergeSort    เพื่อเขียนโปรแกรมจัดเรียงข้อมูลที่ได้รับเข้ามาด้วยวิธี Merge sort     โดยรับ input คืออาร์เรย์ของข้อมูลชนิดเลขจำนวนเต็ม   และแสดงผลลัพธ์เป็นอาร์เรย์ของข้อมูลชนิดเลขจำนวนเต็มที่ได้รับการจัดเรียงข้อมูลเรียบร้อยแล้วออกมาทางจอภาพ

//     3. สร้างคลาสชื่อ Main เพื่อตรวจสอบการทำงานของ QuickSort และ MergeSort
//         3.1 แสดงผลอาร์เรย์ของข้อมูลชนิดเลขจำนวนเต็มที่ได้รับการจัดเรียงข้อมูลเรียบร้อยแล้วด้วยวิธี Quick sort ออกมาทางจอภาพ   หลังจากรับ input คืออาร์เรย์ของข้อมูลชนิดเลขจำนวนเต็ม  ดังนี้
// 15	9	7	16	31	2	20	25	17	12

//         3.2 แสดงผลอาร์เรย์ของข้อมูลชนิดเลขจำนวนเต็มที่ได้รับการจัดเรียงข้อมูลเรียบร้อยแล้วด้วยวิธี Merge sort ออกมาทางจอภาพ   หลังจากรับ input คืออาร์เรย์ของข้อมูลชนิดเลขจำนวนเต็ม  ดังนี้
// 5	2	12	9	1	8	7	18










// บทที่ 9 ต้นไม้สมดุล
// ในบทนี้ จะพูดถึง ต้นไม้สมดุล 2 ตัว คือ AVL Tree และ Splay Tree
// 9.1 AVL Tree
// มีคุณสมบัติดังนี้
//     • ทุกโหนดมีน้ำหนักเป็น -1 0 หรือ 1
//     • น้ำหนัก คือ ความสูงของต้นไม้ย่อยด้านซ้าย ลบ ความสูงของต้นไม้ย่อยด้านขวา
// เพราะฉะนั้น ลีฟโหนดจะมีน้ำหนักเป็น 0
// ตัวอย่างที่1
// ต้นไม้ข้างล่างนี้ ไม่ใช่ AVL tree เพราะมี โหนดที่มีน้ำหนักเกิน  1 เช่น root node มี ความสูงของต้นไม้ย่อยด้านซ้ายเท่ากับ 4 ส่วนความสูงของต้นไม้ย่อยด้านขวาเท่ากับ 1 เพราะฉะนั้นน้ำหนักของ root node นี้จึงมีค่าเป็น 3

// ตัวอย่างที่2
// ต้นไม้ข้างล่างนี้ เป็น AVL tree เพราะทุกโหนดมีน้ำหนักเป็น  -1 0 หรือ  1

// ตัวอย่างที่3
// ต้นไม้ข้างล่างนี้ เป็น AVL tree เพราะทุกโหนดมีน้ำหนักเป็น -1 0 หรือ 1

// ตัวอย่างที่4
// ต้นไม้ข้างล่างนี้ ไม่ใช่ AVL tree เพราะมี โหนดที่มีน้ำหนักเกิน  1

// 9.1.1 การปรับต้นไม้ให้เป็น AVL tree มี 4 แบบ
//     1. Single left rotation การหมุนซ้าย 1 ครั้ง
//     2. Single right rotation การหมุนขวา 1 ครั้ง
//     3. Double left rotation การหมุนซ้าย 2 ครั้ง
//     4. Double right rotation การหมุนขวา 2 ครั้ง
// การที่จะดูว่าปรับด้วยแบบไหน
//     1. พิจารณาโหนดที่มีน้ำหนักไม่อยู่ในเกณฑ์
//     • เป็นบวกต้องหมุนขวา
//     • เป็นลบต้องหมุนซ้าย
//          2. น้ำหนักของโหนดลูกมีเครื่องหมายต่างจากโหนดในข้อ 1 หรือไม่
//             -  เครื่องหมายเหมือนกัน หมุน 1 ครั้ง
//            -  เครื่องหมายต่างกันหมุน 2 ครั้ง
// Single left rotation การหมุนซ้าย 1 ครั้ง


// Single right rotate การหมุนขวา 1 ครั้ง



// Double left rotation การหมุนซ้าย 2 ครั้ง




// Double right rotate การหมุนขวา 2 ครั้ง



// 9.1.2 การเพิ่มโหนดเข้าไปใน AVL Tree
// ขั้นตอนการเพิ่มโหนดเข้าไปใน AVL tree
//     1. หาจุดปลายที่ต้องการ add โดยใช้วิธีเดียวกับการ add โหนดใน Binary Search tree
//     2. หาน้ำหนักของแต่ละโหนดในต้นไม้
//     3. ทำการหมุนต้นไม้
//     4. ตรวจสอบว่าน้ำหนักของแต่ละโหนดของต้นไม้หลังจากหมุนเป็น AVL tree รึยัง
// จากต้นไม้ในรูปข้างล่างนี้ จะทำการเพิ่มโหนดที่มีค่า 5 เข้าไปในต้นไม้ AVL แล้วผลที่ได้ยังเป็น AVL tree


// เริ่มกำหนดตัวชี้ start ชี้ที่ root





// นำ 5 คือค่าที่จะใส่เพิ่มเข้ามาในต้นไม้ มาเปรียบเทียบกับค่าของ root นั่นคือ 6 เนื่องจากค่า 5 น้อยกว่าค่า 6 จึงเลื่อนตัวชี้ start จาก root ไปทางซ้าย แล้วเก็บ root ลงใน Stack ดังคำสั่งและรูปข้างล่าง

// นำค่า 5 มาเปรียบเทียบกับค่าของโหนดที่ตัวชี้ start กำลังชี้อยู่ นั่นคือ 2 เนื่องจากค่า 5 มากกว่าค่า 2 จึงเลื่อนตัวชี้ start ไปทางขวาซึ่งคือโหนด 3 แล้วเก็บ โหนดที่ผ่านมาซึ่งคือโหนด 2 ลงใน Stack ดังคำสั่งและรูปข้างล่าง

// นำ 5 มาเปรียบเทียบกับค่าของโหนดที่ตัวชี้ start กำลังชี้อยู่ นั่นคือ 3 เนื่องจากค่า 5 มากกว่าค่า 3 จึงเลื่อนตัวชี้ start ไปทางขวาซึ่งคือโหนด 4 แล้วเก็บ โหนดที่ผ่านมาซึ่งคือโหนด 3 ลงใน Stack ดังคำสั่งและรูปข้างล่าง

// นำ 5 มาเปรียบเทียบกับค่าของโหนดที่ตัวชี้ start กำลังชี้อยู่ นั่นคือ 4 เนื่องจากค่า 5 มากกว่าค่า 4 จึงเลื่อนตัวชี้ start ไปทางขวาซึ่งไม่มีโหนดแล้วนั่นคือ start มีค่าเท่ากับ null แล้วเก็บ โหนดที่ผ่านมาซึ่งคือโหนด 4 ลงใน Stack ดังคำสั่งและรูปข้างล่าง

// เนื่องจากค่า 5 มากกว่าค่า 4 จึงนำโหนดที่จะเพิ่มเข้าไปซึ่งคือโหนด 5 ไปต่อด้านขวาของโหนดสุดท้ายนั่นคือโหนด 4 ดังคำสั่งและรูปข้างล่างนี้


// ขณะนี้จบการ add แบบ Binary Search Tree ดังรูปข้างบนนี้

// หลังจาก add แล้ว ต้องปรับต้นไม้ให้เป็น AVL Tree
// โหนดที่เก็บใน Stack ทั้งหมดคือโหนดที่มีโอกาศที่น้ำหนักจะเปลี่ยนหลังจาก เพิ่มโหนดใหม่เข้าไป นั่นคือต้อง
// พิจารณาปรับน้ำหนักของโหนดเหล่านี้ทีละโหนด ให้อยู่ในช่วง -1 ถึง1 เพื่อให้ต้นไม้กลายเป็น AVL จากรูปข้างบน โหนดที่มีโอกาสเปลี่ยนน้ำหนัก แล้วไม่อยู่ในเกณฑ์  คือ โหนด  3 โหนด 2 และ โหนด 6 จึงเริ่มพิจารณาปรับโหนด 3 ดังรูปข้างล่าง


// 	การพิจารณาโหนด 3 จะเรียก method  adjustHeight ตามรูปข้างล่าง โดย method adjustHeight อยู่ในโปรแกรม คลาส AVLTree ด้านล่างหน้า 195 และมีการทำงานดังนี้
//     1. Update น้ำหนักปัจจุบันให้กับโหนดที่กำลังพิจารณาซึ่งมีตัวชี้ start ชี้อยู่ ในที่นี้คือโหนดที่มีค่า 3
// ผลจาการ update โหนด 3   จะได้ว่าโหนดนี้มีน้ำหนัก -2  ซึ่งต้องทำการหมุน
//     2. เช็คว่าต้องหมุนแบบไหน เนื่องจากน้ำหนักของโหนด 3 ติดลบจึงต้องหมุนซ้าย
//     3. เช็คว่าต้องหมุนกี่ครั้ง โดยดูจากโหนดลูกซึ่งมีตัวชี้ p ชี้อยู่ ว่าน้ำหนักมีเครื่องหมายเดียวกันหรือต่างกัน ในที่นี้โหนดลูกคือโหนดที่มีค่า 4 ซึ่งโหนดนี้มีน้ำหนัก -1 นั่นคือมีเครื่องหมายเดียวกันจึง หมุนครั้งเดียว
// นั่นคือทำ sigle left rotate ให้โหนด 3 แล้วจะได้ผล ดังรูปข้างล่างนี้






// 	จากนั้น pop โหนดถัดไปออกจาก Stack มาพิจารณา ในที่นี้โหนดที่จะถูกพิจารณาถัดไปคือ โหนดที่มีค่า 2

// การพิจารณาโหนด 2 จะเรียก method  adjustHeight โดยมีลำดับการทำงานเหมือนที่พิจารณาโหนด 3 ข้างบน
//     1. Update น้ำหนักปัจจุบันให้กับโหนดที่กำลังพิจารณาซึ่งมีตัวชี้ start ชี้อยู่ ในที่นี้คือโหนดที่มีค่า 2
// ผลจาการ update โหนด 2   จะได้ว่าโหนดนี้มีน้ำหนัก -1  ซึ่งอยู่ในเกณฑ์ของ AVL tree  จึงไม่ต้องทำการหมุนต้นไม้ดังรูปข้างล่าง






// จากนั้น pop โหนดถัดไปออกจาก Stack มาพิจารณา ในที่นี้โหนดที่จะถูกพิจารณาถัดไปคือ โหนดที่มีค่า 6

// การพิจารณาโหนด 6 จะเรียก method  adjustHeight โดยมีลำดับการทำงานเหมือนที่พิจารณาโหนด 3 ข้างบน
//     1. Update น้ำหนักปัจจุบันให้กับโหนดที่กำลังพิจารณาซึ่งมีตัวชี้ start ชี้ อยู่ ในที่นี้คือโหนดที่มีค่า 6
// ผลจาการ update โหนด 6   มีน้ำหนัก  1  ซึ่งอยู่ในเกณฑ์ของ AVL tree  จึงไม่ต้องทำการหมุนดังรูปข้างล่าง

// ขณะนี้ไม่มีโหนดที่ต้องสงสัยว่าจะมีน้ำหนักไม่อยู่ในเกณฑ์ เหลืออยู่ใน Stack แล้ว ดังนั้นขณะนี้ต้นไม้นี้เป็นต้นไม้ AVL แล้ว

// 9.1.3 การสร้างโครงสร้างข้อมูลต้นไม้ AVL
// จะสร้างต้นไม้ได้ ก่อนอื่นต้องสร้างโหนดของต้นไม้  จะสร้างโหนดของต้นไม้ได้ก็ต้องมีคลาสโหนด ในคลาสโหนดมี instance variable เพิ่มจาก คลาส Binary Tree Node(BTNode) 3 ตัวคือ  lefth  righth และ weight ดังนันคลาส AVLNode จึงทำการ extend มาจาก คลาส BTNode  สำหรับ instance variable ที่เพิ่มขึ้นมาไว้เก็บข้อมูลความสูงของsub tree ด้านซ้าย  ความสูงของsub tree ด้านขวา และ น้ำหนักของโหนด ตามลำดับ จึงมี instance methods เพิ่มอีก 6 methods สำหรับดึงข้อมูล (get) และ เปลี่ยนข้อมูลใหม่ (set)
// public class BTNode {
//         private Object data;
//         private BTNode left;
// 	private BTNode right;

// 	public BTNode(Object obj, BTNode l, BTNode r){
// 		data = obj;
//                 left = l;
// 		right = r;
// 	}
//        	public void setLeft(BTNode l){
// 		left = l;
// 	}

// 	public void setRight(BTNode r){
// 		right = r;
// 	}
//         public BTNode getLeft(){
// 		return left;
// 	}
// 	public BTNode getRight(){
// 		return right;
// 	}
// 	public Object getData(){
// 		return data;
// 	}
//         public void setData(Object e){
// 		data = e;
// 	}
// }
// public class AVLNode extends BTNode{
//     private int lefth, righth, weight;

//     public AVLNode(Object o, BTNode l, BTNode r, int lh, int rh, int w){
//         super(o,l,r);
//         lefth = lh;
//         righth = rh;
//         weight = w;
//     }
//     public int getLH(){
//         return lefth;
//     }
//     public int getRH(){
//         return righth;
//     }
//     public int getW(){
//         return weight;
//     }
//     public void setLH(int l){
//         lefth = l;
//     }
//     public void setRH(int r){
//         righth = r;
//     }
//     public void setW(int w){
//         weight = w;
//     }
// }

// เนื่องจากเวลา add หรือ remove โหนด ออกจาก AVL tree ต้องทำการ add หรือ remove ตาม ขั้นตอนของ Binary Search Tree ก่อน แล้วจึงทำการปรับ weight แต่ละโหนดให้ ไม่เกิน -1 ถึง 1ให้เป็น AVLTree  ดังนันจึงต้องมี คลาส BinarySearchTree ก่อน แล้วค่อย extend ไปเป็นคลาส AVLTree เพื่อทำการปรับ weight
// public class BinarySearchTree {

//     protected BTNode root;
//     //private int size;

//     public BinarySearchTree(){
//         root = null;
//         //size = 0;
//     }

//     /*public int size(){
//         return size;
//     }*/
//     public boolean isEmpty(){
//         return root == null;
//     }
//     public BTNode getRoot(){
//         return root;
//     }
//     public int nnodes(BTNode r){
//         if(r == null)
//             return 0;
//         else{
//             return 1+nnodes(r.getLeft())+nnodes(r.getRight());
//         }
//     }

//     public void numnodes(){
//         BTNode r = root;
//         System.out.println("numnodes: " + nnodes(r));
//     }

//     public Object contains(Object e){
//         BTNode start;
//         start = root;
//         int value = (Integer) e;
//         while(start != null){
//             int BTNode = (Integer)start.getData();
//             if(BTNode == value)
//                 return true;
//             else{
//                 if(BTNode > value)
//                     start = start.getLeft();
//                 else
//                     start = start.getRight();
//             }
//         }
//         return false;    //Object Not Found
//     }
//     public void add (Object e){
//         if(e == null)
//             return;
//         BTNode start = root, pre = null;
//         BTNode tmp = new BTNode(e,null,null);
//         int value = (Integer) e;


//         if(root == null){
//             root = tmp;
//             //size++;
//         }
//         else{
//             while(start != null){
//                 pre = start;
//                 int BTNode = (Integer)start.getData();
//                 if(BTNode == value){
//                     System.out.println("Object: " + e +" has existed in the tree." );
//                     start = null;
//                     return;
//                 }
//                 else{
//                     if(BTNode > value)
//                         start = start.getLeft();
//                     else
//                         start = start.getRight();
//                 }
//             } // end While
//             int curNode = (Integer)pre.getData();
//             if (curNode > value){
//                 pre.setLeft(tmp);
//                 //size++;
//             }
//             else if(curNode < value){
//                 pre.setRight(tmp);
//                 //size++;
//             }
//         }	}// end Method Add
//     public Object getMin(){
//         BTNode start = root;
//         if(start == null)
//             return null;

//         while(start.getLeft() != null){
//             start = start.getLeft();
//         }
//         return start.getData();
//     }

//     public Object getMax(){
//         BTNode start = root;
//         if(start == null)
//             return null;
//         while(start.getRight() != null){
//             start = start.getRight();
//         }
//         return start.getData();
//     }

//     public void printTree(){
//         BTNode r = root;
//         if(isEmpty())
//             System.out.println("Tree is empty.");

//         System.out.println("Preorder");
//         preOrder(r);
//         System.out.println();

//         System.out.println("Inorder");
//         inOrder(r);
//         System.out.println();

//         System.out.println("Postorder");
//         postOrder(r);
//         System.out.println();
//     }
//     public void preOrder(BTNode r){
//         if(r != null){
//             System.out.print(r.getData()+ "\t");
//             preOrder(r.getLeft());
//             preOrder(r.getRight());
//         }
//     }
//     public void inOrder(BTNode r){
//         if(r != null){
//             inOrder(r.getLeft());
//             System.out.print(r.getData()+ "\t");
//             inOrder(r.getRight());
//         }
//     }
//     public void postOrder(BTNode r){
//         if(r != null){
//             postOrder(r.getLeft());
//             postOrder(r.getRight());
//             System.out.print(r.getData() + "\t");
//         }
//     }
//    } // จบ คลาส Binary Search Tree
// public class AVLTree extends BinarySearchTree{

//     public AVLTree(){
//         super();
//     }

//     public int max(int a,int b){
//         if (a < b)
//             return b;
//         else
//             return a;
//     }
//     public void updateHeight(AVLNode r){
//         AVLNode pLeft, pRight;
//         pRight = (AVLNode) r.getRight();
//         pLeft = (AVLNode) r.getLeft();
//         if (pLeft != null)
//             r.setLH(max(pLeft.getLH(),pLeft.getRH())+1);
//         else
//             r.setLH(0);

//         if (pRight != null)
//             r.setRH(max(pRight.getLH(),pRight.getRH())+1);
//         else
//             r.setRH(0);

//         r.setW(r.getLH()-r.getRH());
//     }
// //method adjustHeight ใช้พิจารณาว่าโหนดมีน้ำหนักอยู่ในเกณฑ์ไหม ถ้าไม่ก็ทำการหมุนตามเงื่อนไขที่
// //อธิบายไว้ด้านบน
//     public AVLNode adjustHeight(AVLNode start, AVLNode p, Stack s){
//         updateHeight(start);
//         if (Math.abs(start.getW())>1){
//             if (start.getW() > 0)
//                 if (p.getW() >= 0)
//                     start = singleRightRotate(start,p);
//                 else
//                     start = doubleRightRotate(start,p);
//             else
//                 if (p.getW() <= 0)
//                     start = singleLeftRotate(start,p);
//                 else
//                     start = doubleLeftRotate(start,p);

//             updatePreNode(s,start);
//         }
//         return start;
//     }
//     public void updatePreNode(Stack s, AVLNode start){
//         AVLNode pre;
//         if (!s.isEmpty()){
//             pre = (AVLNode) s.peek();
//             if ((Integer) start.getData() < (Integer) pre.getData())
//                 pre.setLeft(start);
//             else
//                 pre.setRight(start);
//         }
//         else
//             root = start;
//     }
// //method singleRightRotate หมุนขวา 1ครั้ง
//     public AVLNode singleRightRotate(AVLNode start, AVLNode p){
//         start.setLeft(p.getRight());
//         p.setRight(start);
//         updateHeight(start);
//         updateHeight(p);
//         start = p;
//         return start;
//     }

// //method singleLeftRotate หมุนซ้าย 1ครั้ง
//     public AVLNode singleLeftRotate(AVLNode start, AVLNode p){
//         start.setRight(p.getLeft());
//         p.setLeft(start);
//         updateHeight(start);
//         updateHeight(p);
//         start = p;
//         return start;
//     }
// //method doubleRightRotate หมุนขวา 2 ครั้ง
//     public AVLNode doubleRightRotate(AVLNode start, AVLNode p){
//         AVLNode q;
//         q = (AVLNode) p.getRight();
//         p.setRight(q.getLeft());
//         start.setLeft(q.getRight());
//         q.setRight(start);
//         q.setLeft(p);
//         updateHeight(start);
//         updateHeight(p);
//         updateHeight(q);
//         start = q;
//         return start;
//     }

// //method doubleLeftRotat หมุนซ้าย 2 ครั้ง
//     public AVLNode doubleLeftRotate(AVLNode start, AVLNode p){
//         AVLNode q;
//         q = (AVLNode) p.getLeft();
//         p.setLeft(q.getRight());
//         start.setRight(q.getLeft());
//         q.setLeft(start);
//         q.setRight(p);
//         updateHeight(start);
//         updateHeight(p);
//         updateHeight(q);
//         start = q;
//         return start;
//     }
//     public void addAVL(Object e){//เพิ่มโหนดเข้าต้นไม้ AVL ตามขั้นตอนที่อธิบายไว้ในหัวข้อ 9.1.2
//         AVLNode start, t, p;
//         t = new AVLNode(e,null,null,0,0,0);
//         Stack s = new Stack();
//         if (root == null)
//             root = t;
//         else{
//             start = (AVLNode) root;
//             while (start != null){
//                 s.push(start);
//                 if ((Integer) t.getData() < (Integer) start.getData())
//                     start = (AVLNode) start.getLeft();
//                 else
//                     start = (AVLNode) start.getRight();
//             }
//             start = (AVLNode) s.pop();
//             if ((Integer) t.getData() < (Integer) start.getData())
//                 start.setLeft(t);
//             else
//                 start.setRight(t);

//             updateHeight(start);
//             p = start;
//             while (!s.isEmpty()){
//                 start = (AVLNode) s.pop();
//                 start = adjustHeight(start,p,s);
//                 p = start;
//             }
//         }
//     }

// /* ลบโหนดออกจากต้นไม้ AVL หลังจากลบโหนดโดยใช้ขั้นตอนของ Binary Search Tree ต้องเก็บโหนดที่ถูกผลกระทบหลังจากการลบโหนดออกไป 1 โหนด  นั่นคือเก็บโหนดที่น่าสงสัยว่าจะไม่เข้าเกณฑ์เข้าสู่ Stack แล้วพิจารณาปรับทีละโหนดว่าจะต้องหมุนหรือไม่ ถ้าต้องหมุนจะต้องหมุนด้วยวิธีใด เพื่อให้โหนดที่สงสัยว่าจะเกินเกณฑ์ ให้กลับเข้ามาอยู่ในเกณฑ์ คล้ายกับขบวนการของการ addAVL */
//     public void removeAVL(Object e){
//         AVLNode start, pre, cur;
//         start = (AVLNode) root;
//         Stack s = new Stack();
//         pre = start;
//         boolean d = false;

//         while((start != null) && (!d)){
//             s.push(start);
//             if (start.getData() == e)
//                 d = true;
//             else if((Integer) start.getData() > (Integer) e){
//                 pre = start;
//                 start = (AVLNode) start.getLeft();
//             }
//             else{
//                 pre = start;
//                 start = (AVLNode) start.getRight();
//             }
//         }
//         if(start == null) return;

//         if ((start.getLeft() == null) && (start.getRight() == null))
//             if(start == root)
//                 root = null;
//             else
//                 if(pre.getLeft() == start)
//                     pre.setLeft(null);
//                 else
//                     pre.setRight(null);
//         else if ((start.getLeft() != null) && (start.getRight() != null)){
//             pre = start;
//             cur = (AVLNode) start.getLeft();
//             s.push(cur);
//             while (cur.getRight() != null){
//                 pre = cur;
//                 s.push(cur);
//                 cur = (AVLNode) cur.getRight();
//             }
//             start.setData(cur.getData());
//             if (pre == start)
//                 pre.setLeft(cur.getLeft());
//             else
//                 pre.setRight(cur.getLeft());
//         }
//         else
//             if(start.getLeft() != null)
//                 if(start == root)
//                     root = start.getLeft();
//                 else
//                     if(pre.getLeft() == start)
//                         pre.setLeft(start.getLeft());
//                     else
//                         pre.setRight(start.getLeft());
//             else
//                 if(start == root)
//                     root = start.getRight();
//                 else
//                     if(pre.getRight() == start)
//                         pre.setRight(start.getRight());
//                     else
//                         pre.setLeft(start.getRight());
//         //size --;
//         s.pop();
//         AVLNode p;


//         while (!s.isEmpty()){
//             start = (AVLNode) s.pop();
//             updateHeight((AVLNode) start);
//             if (Math.abs(start.getW()) > 1){
//                 if (start.getLH() < start.getRH())
//                     p = (AVLNode) start.getRight();
//                 else
//                     p = (AVLNode) start.getLeft();
//                 adjustHeight(start,p,s);
//             }
//         }
//     }
// }
// //ทั้งการเพิ่มโหนดหรือลบโหนด ใน ต้นไม้ AVL ต้องใช้ Stack มาช่วย
// public class Stack {
//     private Object[] s;
//     private int top;
//     public  Stack(){
//         s = new Object[10];
//         top = -1;
//     }
//     public int size(){
//         return top+1;
//     }
//     public void push(Object o){
//         if(top == s.length-1)
//             s = doubleSize(s);
//         top++;
//         s[top] = o;
//     }
//     private static Object[] doubleSize(Object[] origin){
//         Object[] temp = new Object[origin.length*2];
//         System.arraycopy(origin,0,temp,0,origin.length);
//         return temp;
//     }

//     public Object pop(){
//         if(isEmpty())  return null;
//         Object e = s[top];
//         top--;
//         return e;
//     }

//     public boolean isEmpty(){
//         return top == -1;
//     }
//     public void printStack(){
//         while (!(isEmpty())){
//             System.out.println(pop());
//         }
//     }
//     public Object peek(){
//         Object e = s[top];
//         return e;
//     }
// }




// //ทดสอบการเพิ่มและลบโหนดในต้นไม้ AVL
// public class Main {

//     public static void main(String[] args) {
//         AVLTree AVL = new AVLTree();
//         Object ob1 = new Integer(5);
//         Object ob2 = new Integer(7);
//         Object ob3 = new Integer(10);
//         Object ob4 = new Integer(12);
//         Object ob5 = new Integer(13);
//         Object ob6 = new Integer(15);
//         Object ob7 = new Integer(25);
//         Object ob8 = new Integer(28);

//         AVL.addAVL(ob1);
//         //AVL.printTree();
//         AVL.addAVL(ob2);
//         //AVL.printTree();
//         AVL.addAVL(ob3);
//         //AVL.printTree();
//         AVL.addAVL(ob4);
//         //AVL.printTree();
//         AVL.addAVL(ob5);
//         //AVL.printTree();
//         AVL.addAVL(ob6);
//         AVL.addAVL(ob7);
//         AVL.addAVL(ob8);
//         AVL.printTree();
//          AVL.removeAVL(ob4);
//         AVL.printTree();
//          AVL.removeAVL(ob6);
//         AVL.printTree();
//     }
// }
// Output

// Preorder
// 12        7        5        10        15        13        25        28
// Inorder
// 5        7        10        12        13        15        25        28
// Postorder
// 5        10        7        13        28        25        15        12

// Preorder
// 10        7        5        15        13        25        28
// Inorder
// 5        7        10        13        15        25        28
// Postorder
// 5        7        13        28        25        15        10

// Preorder
// 10        7        5        25        13        28
// Inorder
// 5        7        10        13        25        28
// Postorder
// 5        7        13        28        25        10


// 9.2 Splay Tree
// เป็นต้นไม้ Binary Search tree ซึ่งปรับโหนดที่สนใจไปอยู่ตำแหน่ง root
// การ splay มี 6 แบบ
//     1. Zag
//     2. ZagZag
//     3. ZagZig
//     4. Zig
//     5. ZigZig
//     6. ZigZag

// สมมติโหนดที่สนใจคือโหนด X เพราะฉะนั้นจะปรับโหนดที่สนใจไปอยู่ตำแหน่ง root





// Zag กรณี X > Y ดังนั้น หมุนซ้าย 1 ครั้ง เพื่อให้ X มาเป็น root





// ZagZag กรณีX >Y >Z ดังนั้น หมุนซ้าย 2 ครั้ง เพื่อให้ X มาเป็น root







// ZagZig กรณี Z < X < Y ดังนั้น หมุนซ้าย 1 ครั้ง แล้วตามด้วยหมุนขวา 1 ครั้ง เพื่อให้ X มาเป็น root





// Zig   กรณี X < Y ดังนั้น หมุนขวา1 ครั้ง เพื่อให้ X มาเป็น root





// ZigZag  กรณีY < X < Z ดังนั้น หมุนขวา1 ครั้ง แล้วตามด้วย หมุนซ้าย 1 ครั้ง เพื่อให้ X มาเป็น root






// ZigZig กรณี X<Y<Z ดังนั้น หมุนขวา 2 ครั้ง เพื่อให้ X มาเป็น root








// 9.2.1 การเพิ่ม โหนด เข้าไปใน Splay Tree
// ตัวอย่าง ถ้าต้องการเติม โหนดที่มีค่า 23 เข้าไปใน ต้นไม้ข้างล่างนี้

// 	อันดับแรกคือพยายาม splay (23) จึงคล้ายกับว่าสนใจ จะ splay โหนด 24 ขึ้นมาเป็น root เพราะในต้นไม้ยังไม่มีโหนดที่จะเพิ่ม (23)  นั่นคือ จะ splay โหนดที่มีค่าใกล้กับโหนดที่จะเพิ่ม ขึ้นมาเป็น root



// จากรูปข้างบนพิจารณาจาก root มาที่สาย โหนด 24  คราวละ 3 โหนด ดังวงสีแดงข้างบน  จะเห็นได้ว่าต้องทำ zag คือหมุนซ้าย  1 ครั้ง แล้วได้ ต้นไม้ดังรูปข้างล่าง









// หลังจากหมุนซ้าย 1 ครั้ง ให้เอาส่วน y และ A นั่นคือเอาส่วนในวงสีแดงข้างล่างนี้ไปใส่ในต้นไม้ด้านซ้าย ดัง 2 รูปข้างล่าง



// 	จากรูปข้างบนพิจารณาต้นไม้ตรงกลาง จาก root มาที่สาย โหนด 24  คราวละ 3 โหนด ดังวงสีแดง  จะเห็นได้ว่า ต้องทำ  zigzig หมุนขวา 2 ครั้ง แล้วได้ ต้นไม้ดังรูปข้างล่าง



// หลังจากหมุนขวา 2 ครั้ง ให้เอาส่วน y  z และ C D  นั่นคือเอาส่วนในวงสีแดงข้างล่างนี้ไปใส่ในต้นไม้ด้านขวา ดัง 2 รูปข้างล่าง









// 	จากรูปข้างบนพิจารณาต้นไม้ตรงกลาง จาก root มาที่สาย โหนด 24  คราวละ 3 โหนด ตอนนี้เหลือ 2 โหนด
// ดังวงสีแดง  จะเห็นได้ว่า ต้องทำ zag คือหมุนซ้าย  1 ครั้ง แล้วได้ ต้นไม้ดังรูปข้างล่าง


// 	หลังจากหมุนซ้าย 1 ครั้ง ให้เอาส่วน y และ A นั่นคือเอาส่วนในวงสีแดงข้างล่างนี้ไปใส่ด้านขวาของในต้นไม้ด้านซ้าย ดัง 2 รูปข้างล่าง


// 	จากรูปข้างบนขณะนี้เหลือโหนดเดียวในต้นไม้ตรงกลาง นั่นคือโหนดที่สนใจ นั่นคือไม่ต้องหมุนแล้ว ให้รวมต้นไม้ ซ้าย ตรงกลาง และ ต้นไม้ด้านขวา  โดยให้เอาต้นไม้ทางซ้ายมาเชื่อมเป็นลูกด้านซ้ายของโหนดต้นไม้ตรงกลาง และ ให้เอาต้นไม้ทางขวามาเชื่อมเป็นลูกด้านขวาของโหนดต้นไม้ตรงกลาง ดังรูปข้างล่างนี้

// 	จากรูปข้างบนเมื่อ splay โหนด 24 ขึ้นมาเป็น root แล้ว ต่อมาเปรียบเทียบ ว่าโหนดที่เข้ามาใหม่ มีค่าน้อยกว่า หรือมากกว่า โหนดที่ splay ขึ้นมาเป็น root
// ถ้าโหนดที่เข้ามาใหม่ (23) มีค่าน้อยกว่า root (24)
//     •  ให้นำ root เดิมคือโหนด 24 และต้นไม้ย่อยด้านขวาของมัน มาต่อด้านขวาของโหนดใหม่ นั้นคือ 23 ซึ่งจะเพิ่มเข้ามาเป็น root ใหม่
//     • นำต้นไม้ย่อยด้านซ้ายของโหนด 24 ซึ่งมี root เป็น 18 มาต่อด้านซ้ายของโหนดใหม่ นั่นคือ 23 ดัง 3 รูปข้างล่าง



// ถ้าโหนดที่เข้ามาใหม่ (25)  มีค่ามากกว่า root (24)  ที่ splay ขึ้นมาเป็น root แล้ว ดังรูปข้างล่างนี้

// 	ต่อมาเปรียบเทียบ ว่า โหนดที่เข้ามาใหม่ มีค่าน้อยกว่า หรือมากกว่า โหนดที่ splay  ขึ้นมาเป็น root
// ถ้ามากกว่า คือ กรณีนี้ที่  25 > 24
//     • ให้นำ root เดิมคือโหนด 24 และต้นไม้ย่อยด้านซ้ายของมัน มาต่อด้านซ้ายของโหนดใหม่ นั้นคือ 25 ซึ่งจะเพิ่มเข้ามาเป็น root ใหม่
//     • นำต้นไม้ย่อยด้านขวาของโหนด 24 ซึ่งมี root เป็น 26 มาต่อด้านขวาของโหนดใหม่ นั่นคือ 25 ดัง 2 รูปข้างล่าง




// 9.2.2 ลบโหนดออกจาก Splay Tree
// 	คือการลบโหนดที่สนใจ นั่นคือ root โหนดในปัจจุบันที่เป็น splay tree อยู่  โดยการที่จะเลือกต้นไม้ย่อยฝั่งซ้ายหรือฝั่งขวาของ root ก็ได้ แบบ Max คือการเลือกต้นไม้ฝั่งซ้ายของ root ตัวอย่างต่อไปนี้ คือการที่จะลบ root  24 ออกจาก splay tree โดยการ  เลือกต้นไม้ฝั่งซ้าย

// 	นำเอาโหนดที่จะลบนั้นคือโหนด 24 ไป ใส่เข้าไปต้นไม้ฝั่งซ้าย แบบbinary serach tree ซึ่งโหนดนี้จะกลายเป็นโหนดที่มีค่ามากสุด (max) ของต้นไม้นี้ ดังรูปข้างล่าง

// จากนั้นเริ่ม ทำการ splay ต้นไม้ฝั่งซ้ายนี้


// 	หลังจากทำการ splay ต้นไม้ฝั่งซ้ายนี้เสร็จ โหนด 24 จะขึ้นไปอยู่เป็นโหนดบนสุดของต้นไม้ฝั่งซ้ายนี้ ดังรูปข้างบน
// จากนั้น ลบ โหนด 24 ออกจากต้นไม้ฝั่งซ้าย ดังนั้น โหนด 21 จะกลายเป็น root  ของต้นไม้ฝั่งซ้าย ดังรูปข้างล่าง

// จากนั้นนำต้นไม้ฝั่งขวามาเสียบเป็นลูกฝั่งขวาของต้นไม้ย่อยฝั่งซ้ายที่เหลือ ดังรูปข้างล่าง  ซึ่งเป็นการเสร็จสิ้นการลบโหนด 24 ออกจาก splay tree แบบ Max


// แบบ Min คือการเลือกต้นไม้ฝั่งขวาของ root
// ตัวอย่างต่อไปนี้ คือการที่จะลบ root  24 ออกจาก splay tree โดยการ  เลือกต้นไม้ฝั่งขวา

// นำเอาโหนดที่จะลบนั้นคือโหนด 24 ไป ใส่เข้าไปต้นไม้ฝั่งขวาแบบ binary search tree  ซึ่งโหนดนี้จะกลายเป็นโหนดที่มีค่าน้อยที่สุด (min) ของต้นไม้นี้ ดังรูปข้างล่าง

// จากนั้นเริ่ม ทำการ splay ต้นไม้ฝั่งขวานี้

// 	หลังจากทำการ splay ต้นไม้ฝั่งขวานี้เสร็จ โหนด 24 จะขึ้นไปอยู่เป็นโหนดบนสุดของต้นไม้ฝั่งขวานี้ ดังรูปข้างบน
// จากนั้น ลบ โหนด 24 ออกจากต้นไม้ฝั่งขวา ดังนั้น โหนด 26 จะกลายเป็น root  ของต้นไม้ฝั่งขวา ดังรูปข้างล่าง

// 	จากนั้นนำต้นไม้ฝั่งซ้ายมาเสียบเป็นลูกฝั่งซ้ายของต้นไม้ย่อยฝั่งขวาที่เหลือ ดังรูปข้างล่าง  ซึ่งเป็นการเสร็จสินการลบโหนด 24 ออกจาก splay tree แบบ Min

// 9.2.3 การสร้างโครงสร้างข้อมูล Splay Tree
// 	ก่อนที่จะสร้างต้นไม้ Splay  ต้องมีการสร้างโหนด   ในการสร้างโหนดแต่ละโหนดของ splay tree ต้องใช้ class SplayNode ซึ่ง ประกอบไปด้วย instance variable 3 ตัว คือ data, left และ right โดย  data เอาไว้เก็บข้อมูลของโหนด  left เอาไว้เก็บ address ของโหนดลูกฝั่งซ้าย ส่วน right เอาไว้เก็บ address ของโหนดลูกฝั่งขวา

// public class SplayNode {

//     private Object data;
//     private SplayNode left;
//     private SplayNode right;

//     public SplayNode (Object obj) {
//         data = obj;
//         left = right = null;
//     }

//     public void setLeft (SplayNode l) {
//         left = l;
//     }

//     public void setRight (SplayNode r) {
// 	right = r;
//     }

//     public SplayNode getLeft(){
// 	return left;
//     }

//     public SplayNode getRight(){
// 	return right;
//     }

//     public Object getData(){
// 	return data;
//     }
// }




// สร้างต้นไม้ splay โดยใช้ class SplayTree ข้างล่างนี้

// public class SplayTree {

//     private SplayNode root;
//     private static SplayNode header = new SplayNode(null);

//     public SplayTree() { //เริ่มต้นไม้ด้วย ต้นไว้ว่างเปล่านั่นคือ root = null
//         root = null;
//     }

//     //method add ทำการเพิ่มโหนด ที่มีค่า key เข้าไป แล้วผลลัพธ์ยังเป็น splay tree ตามขั้นตอนวิธีที่อธิบายไว้ด้านบน
//     public void add(Object key) {
// 	System.out.println("Add: " + key);
//         SplayNode splayNode;
// 	int c;
// 	if (root == null) {
// 	    root = new SplayNode(key);
// 	    return;
// 	}
// 	splay(key);
// 	if ((c = ((Integer) key).compareTo((Integer) root.getData())) == 0) {
// 	    //throw new DuplicateItemException(x.toString());
// 	    System.out.println("There is " + key + " in the Splay tree. No duplicate add!");
//             return;
// 	}
// 	splayNode = new SplayNode(key);
// 	if (c < 0) {
//             splayNode.setLeft(root.getLeft());
//             splayNode.setRight(root);
//             root.setLeft(null);
// 	} else {
//             splayNode.setRight(root.getRight());
//             splayNode.setLeft(root);
//             root.setRight(null);
// 	}
// 	root = splayNode;
//     }


// // method remove ลบโหนดที่มีค่า key ออกจาก splay tree แล้วผลลัธ์ยังคงเป็น splay tree ตามขั้นตอนที่อธิบายไว้
// //ด้านบน
//     public void remove(Object key) {
// 	System.out.println("Remove: " + key);
//         SplayNode x;
// 	splay(key);
// 	if (((Integer) key).compareTo((Integer) root.getData()) != 0) {
// 	    //throw new ItemNotFoundException(x.toString());
// 	    System.out.println("No " + key + " to remove!");
//             return;
// 	}
// 	// Now delete the root
// 	if (root.getLeft() == null) {
// 	    root = root.getRight();
// 	} else {
// 	    x = root.getRight();
// 	    root = root.getLeft();
// 	    splay(key);
//             root.setRight(x);
// 	}
//     }
// // method findMin ทำการ splayโหนดที่มีค่าน้อยสุดขึ้นมาเป็น root และ return ค่าโหนดนี้ออกมา
//     public Object findMin() {
//         System.out.println("Find Min");
//         SplayNode x = root;
//         if(root == null) return null;
//         while(x.getLeft() != null) x = x.getLeft();
//         splay(x.getData());
//         return x.getData();
//     }

// // method findMax ทำการ splay โหนดที่มีค่ามากสุดขึ้นมาเป็น root และ return ค่าโหนดนี้ออกมา
//     public Object findMax() {
//         System.out.println("Find Max");
//         SplayNode x = root;
//         if(root == null) return null;
//         while(x.getRight() != null) x = x.getRight();
//         splay(x.getData());
//         return x.getData();
//     }

// //method find ทำการ หาโหนด ที่มีค่า key โดยทำการ splay โหนดนี้มาเป็น root และ return ค่าของโหนดนี้ออกมา
//     public Object find(Object key) {
// 	System.out.println("Find " + key);
//         if (root == null) return null;
// 	splay(key);
//         if(((Integer) root.getData()).compareTo((Integer) key) != 0){
//             System.out.println(key + " not found!");
//             return null;
//         }
//         return root.getData();
//     }
//     // method isEmpty ถามว่าต้นไม้นี้ว่างเปล่าหรือไม่ (ว่างหมายความว่าไม่มีแม้แต่โหนดเดียว)
//     public boolean isEmpty() {
//         return root == null;
//     }

//     private void moveToRoot(Object key){
// 	SplayNode l, r, t, y;
// 	l = r = header;
// 	t = root;
//         header.setLeft(null);
//         header.setRight(null);
// 	for (;;) {
// 	    if (((Integer) key).compareTo((Integer) t.getData()) < 0) {
// 		if (t.getLeft() == null) break;
//                 r.setLeft(t);       /* link right */
// 		r = t;
// 		t = t.getLeft();
// 	    } else if (((Integer) key).compareTo((Integer) t.getData()) > 0) {
// 		if (t.getRight() == null) break;
//                 l.setRight(t);      /* link left */
// 		l = t;
// 		t = t.getRight();
// 	    } else {
// 		break;
// 	    }
// 	}
//         l.setRight(t.getLeft());    /* assemble */
// 	r.setLeft(t.getRight());
// 	t.setLeft(header.getRight());
// 	t.setRight(header.getLeft());
// 	root = t;
//     }

// // method splay ทำการ splay โหนดที่มีค่า key ขึ้นมาเป็น root
//     private void splay(Object key) {
// 	SplayNode l, r, t, y;
// 	l = r = header;
// 	t = root;
//         header.setLeft(null);
//         header.setRight(null);
// 	for (;;) {
// 	    if (((Integer) key).compareTo((Integer) t.getData()) < 0) {
// 		if (t.getLeft() == null) break;
// 		if (((Integer) key).compareTo((Integer) t.getLeft().getData()) < 0) {
// 		    y = t.getLeft();        /* rotate right */
// 		    t.setLeft(y.getRight());
// 		    y.setRight(t);
// 		    t = y;
// 		    if (t.getLeft() == null) break;
// 		}
// 		r.setLeft(t);               /* link right */
// 		r = t;
// 		t = t.getLeft();
// 	    } else if (((Integer) key).compareTo((Integer) t.getData()) > 0) {
// 		if (t.getRight() == null) break;
// 		if (((Integer) key).compareTo((Integer) t.getRight().getData()) > 0) {
// 		    y = t.getRight();       /* rotate left */
// 		    t.setRight(y.getLeft());
// 		    y.setLeft(t);
// 		    t = y;
// 		    if (t.getRight() == null) break;
// 		}
// 		l.setRight(t);              /* link left */
// 		l = t;
// 		t = t.getRight();
// 	    } else {
// 		break;
// 	    }
// 	}
// 	l.setRight(t.getLeft());            /* assemble */
// 	r.setLeft(t.getRight());
// 	t.setLeft(header.getRight());
// 	t.setRight(header.getLeft());
// 	root = t;
//     }

//     public void printRoot(){
//         System.out.println("Root: " + (Integer) root.getData());
//     }
//    // method printTree ทำการ print tree ออกมาแบบ preorder
//     public void printTree(){
//         SplayNode r = root;
//         if(isEmpty())
//             System.out.println("Tree is empty.");

//         System.out.println("Preorder");
//         preOrder(r);
//         System.out.println("\n");
//     }
//     public void preOrder(SplayNode r){
//         if(r != null){
//             System.out.print(r.getData()+ "\t");
//             preOrder(r.getLeft());
//             preOrder(r.getRight());
//         }
//     }

// }
// ทดสอบการเพิ่มและลบโหนดในต้นไม้ Splay
// public class Main {

//     public static void main(String[] args) {
//         SplayTree t = new SplayTree();

//         t.add(new Integer(2));
//         t.printTree();
//         t.add(new Integer(10));
//         t.printTree();
//         t.add(new Integer(1));
//         t.printTree();
//         t.add(new Integer(5));
//         t.printTree();
//         t.add(new Integer(7));
//         t.printTree();
//         t.add(new Integer(15));
//         t.printTree();


//         t.add(new Integer(10));
//         t.printTree();

//         t.find(new Integer(5));
//         t.printTree();
//         t.find(new Integer(8));
//         t.printTree();

//         /*t.findMin();
//         t.printTree();
//         t.findMax();
//         t.printTree();*/

//         t.remove(new Integer(15));
//         t.printTree();
//         t.remove(new Integer(20));
//         t.printTree();
//     }
// }

// Output

// Add: 2
// Preorder
// 2

// Add: 10
// Preorder
// 10        2
// Add: 1
// Preorder
// 1        2        10

// Add: 5
// Preorder
// 5        2        1        10

// Add: 7
// Preorder
// 7        5        2        1        10

// Add: 15
// Preorder
// 15        10        7        5        2        1

// Add: 10
// There is 10 in the Splay tree. No duplicate add!
// Preorder
// 10        7        5        2        1        15

// Find 5
// Preorder
// 5        2        1        7        10        15

// Find 8
// 8 not found!
// Preorder
// 10        7        5        2        1        15

// Remove: 15
// Preorder
// 10        7        5        2        1

// Remove: 20
// No 20 to remove!
// Preorder
// 10        7        5        2        1



// แบบฝึกหัดท้ายบท
// จงเขียนโปรแกรมสร้างโครงสร้างข้อมูลแบบ Splay Tree	ซึ่งมีรายละเอียดของโปรแกรม   ดังนี้
//     1. สร้างคลาสชื่อ SplayNode    เพื่อระบุ attribute และ method ของโหนดข้อมูลใน Splay Tree (เหมือน BTNode)
//     2. สร้างคลาสชื่อ SplayTree  เพื่อสร้างโครงสร้างข้อมูลแบบ Splay Tree  โดยมีรายละเอียดของ method ต่าง ๆ    ดังนี้
//     • splay    ปรับโครงสร้างของ Tree ทุกครั้งที่เรียกใช้บริการ ตั้งแต่การเพิ่ม การลบ หรือการ ค้นหา    โดยจะนำโหนดข้อมูลที่ถูกเรียกใช้บริการขึ้นมาเป็น root แทน
//     • add	           เพิ่มโหนดข้อมูลเข้าไปใน Splay Tree และในกรณีที่ Splay Tree มีโหนดข้อมูลที่มีค่าเดียวกันกับค่าของข้อมูลที่ต้องการเพิ่มแล้ว จะไม่มีการเพิ่มโหนดข้อมูล ๆ นั้นเข้าไปใน Splay Tree (ถ้าซ้ำ จะไม่ add)
//     • remove		ลบโหนดข้อมูลที่ต้องการออกจากSplay Tree
//     • find		           	ค้นหาโหนดข้อมูลที่ต้องการใน Splay Tree
//     • printTree		แสดงผล Splay Tree ออกมาทางจอภาพ ด้วย Tree Traversal แบบ
// Preorder

//     3. สร้างคลาสชื่อ Main เพื่อตรวจสอบการทำงานของ SplayTree โดยแสดงผลลัพธ์ที่ได้ออกมาทางจอภาพด้วย method printTree  ด้วย tree traversal แบบ Preorder	หลังจากที่ได้ดำเนินการต่าง ๆ  ดังนี้
//         a. เพิ่มข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 2, 10, 1, 5, 7, และ 15  ลงใน Splay Tree   ตามลำดับ
//         b. เพิ่มข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า 10 ลงใน Splay Tree   ตามลำดับ
//         c. ค้นหาโหนดข้อมูลซึ่งมีค่า 5 และ 8 ใน Splay Tree
//         d. ลบโหนดข้อมูลซึ่งมีค่า 15 และ 20 ออกจาก Splay Tree   ตามลำดับ

// 2.จงเขียนโปรแกรมสร้างโครงสร้างข้อมูลแบบ AVL Tree	ซึ่งมีรายละเอียดของโปรแกรม   ดังนี้
//     1. สร้างคลาสชื่อ AVLNode    เพื่อระบุ attribute และ method ของโหนดข้อมูลใน AVL Tree   โดย extends มาจากคลาส BTNode

//     2. สร้างคลาสชื่อ AVLTree  เพื่อสร้างโครงสร้างข้อมูลแบบ AVL Tree   โดย extends มาจากคลาสชื่อBinarySearchTree และมีรายละเอียดของ method ต่าง ๆ    ดังนี้
//     • updateHeight		คำนวณค่าความสูงล่าสุดของแต่ละโหนดข้อมูลใน AVL tree
//     • adjustHeight			ปรับสมดุลของ AVL tree โดยเรียกใช้ method ที่ใช้หมุน
//     • updatePreNode		หา PreNode และนำ PreNode ชี้ไปที่ root ของ subtree ที่ได้จากการหมุน
//     • singleRightRotate     		ปรับ tree ให้เป็น AVL Tree   โดยการหมุนขวา 1 ครั้ง
//     • singleLeftRotate		ปรับ tree ให้เป็น AVL Tree   โดยการหมุนซ้าย 1 ครั้ง
//     • doubleRightRotate	               ปรับ tree ให้เป็น AVL Tree   โดยการหมุนขวา 2 ครั้ง
//     • doubleLeftRotate		ปรับ tree ให้เป็น AVL Tree   โดยการหมุนซ้าย 2 ครั้ง
//     • addAVL			เพิ่มโหนดข้อมูลเข้าไปใน AVL Tree
//     • removeAVL			ลบโหนดข้อมูลที่ต้องการใน AVL Tree

//     3. สร้างคลาสชื่อ Main เพื่อตรวจสอบการทำงานของ AVLTree โดยแสดงผลลัพธ์ที่ได้ออกมาทางจอภาพด้วย method printTree  ด้วย tree traversal แบบ Preorder	หลังจากที่ได้ดำเนินการต่าง ๆ  ดังนี้
//         a. เพิ่มข้อมูลชนิดเลขจำนวนเต็มซึ่งมีค่า  5, 7, 10, 12, 13, 15, 25, และ28  ลงใน AVL Tree ตามลำดับ
//         b. ลบโหนดข้อมูลซึ่งมีค่า  12 และ 15  ออกจาก AVL Tree   ตามลำดับ











// บทที่ 10 Graph
// 10.1 นิยามของกราฟ
// กราฟประกอบไปด้วย set of vertex และ edge;  G= (V, E)
// V(G) = เซตชอง vertex ที่ไม่ใช่เซตว่างและมีจำนวนจำกัด
// E(G) = เซตของ Edge ซึ่งเขียนด้วยคู่ของ vertex
// Vertex ประกอบด้วย label และ status ว่าถูก visit แล้วหรือยัง

// จะสร้าง vertex ได้ก็ต้องมีคลาส Vertex ในคลาส Vertexมี instance variable 2 ตัวคือ isVisit กับ label ไว้เก็บสถานะการถูก visit และ ชื่อ ของ vertex ตามลำดับ จึงมี instance methods อยู่ 3 methods สำหรับดึงข้อมูล(get) และ เปลี่ยนข้อมูลใหม่(set) บน  isVisit กับ label

// public class Vertex {
//     private boolean isVisit;
//     private String label;

//     public Vertex(String lb){
//         isVisit = false;
//         label = lb;
//     }

//     public void setVisit(boolean visit){
//         isVisit = visit;
//     }
//     public boolean getVisit(){
//         return isVisit;
//     }
//     public String getLabel(){
//         return label;
//     }
// }

// Edge ใช้เชื่อมระหว่าง vertex

// 10.2 ชนิดของกราฟ
//     • กราฟแบบมีทิศทาง
//     • กราฟแบบไม่มีทิศทาง

// ตัวอย่างกราฟแบบไม่มีทิศทาง




// V(G) ={A, B, C, D}
// E(G) = { (A,C), (C,B), (B,D)}

// ตัวอย่างกราฟแบบมีทิศทาง





// V(G) ={A, B, C, D}
// E(G) = { (A,C), (C,A), (B,C),(D,A)}
// ดังนั้น
// กราฟแบบมีทิศทาง

// เท่ากับ

// กราฟแบบไม่มีทิศทาง


// 10.3 Adjacent vertex
// Adjacent คือ vertex  ข้างเคียง  หรือ  vertex ที่มี edgeเชื่อมกัน
// ตัวอย่างกราฟแบบไม่มีทิศทาง




// จากตัวอย่างข้างบนนี้  vertex A กับ vertex C อยู่ข้างเคียงกัน
// ส่วน  vertex A กับ vertex D       ไม่อยู่ข้างเคียงกัน

// 10.4 Indegrees and Outdegrees
//     • Indegrees คือจำนวน edge ที่เข้า vertex
//     • Outdegrees คือจำนวน edge ที่ออกจาก vertex

// ตัวอย่างกราฟแบบไม่มีทิศทาง







// Vertex                   Indegrees                            outdegrees
// A                                 1                                             1
// B                                 2                                             2
// C                                 2                                             2
// D                                1                                              1

// ตัวอย่างกราฟแบบมีทิศทาง




// Vertex                   Indegrees                            outdegrees
// A                                 2                                             1
// B                                 0                                             1
// C                                 2                                             1
// D                                0                                              1

// 10.5 Complete Graph กราฟสมบูรณ์
// คือกราฟที่ ทุก vertex มี edge เชื่อมโยงไปยัง vertex ที่เหลือทั้งหมด
// ตัวอย่างกราฟสมบูรณ์แบบไม่มีทิศทาง





// ตัวอย่างกราฟสมบูรณ์แบบมีทิศทาง




// กรณีกราฟแบบมีทิศทางแบบสมบูรณ์
//      จำนวน edge = N*(N-1)  ;  N = จำนวน vertex
// กรณีกราฟแบบไม่มีทิศทางแบบสมบูรณ์
//      จำนวน edge =( N*(N-1))/2    ;  N = จำนวน vertex

// 10.6 Path เส้นทาง
// ลำดับของ vertex ตั้งแต่ vertex เริ่มต้น ไล่เรียงไปจนถึง vertex  สิ้นสุด โดยที่มี edge เชื่อมโยง vertex เหล่านั้น
// ตัวอย่างเส้นทางกราฟแบบไม่มีทิศทาง




// เช่น path = {C, B, D}

// 10.7 กราฟมีน้ำหนัก weighted graph
// กราฟที่แต่ละ edge จะมีค่าบ่งบอกถึงความหมาย
// ตัวอย่างกราฟแบบมีน้ำหนัก จะเห็นได้ว่าที่ edge มีตัวเลขกำกับ ในที่นี้ความหมายของตัวเลขคือระยะทางจากเมือง (vertex) หนึ่งไปยังอีกเมือง (vertex) หนึ่ง







// 10.8 การ represent กราฟ
// กราฟแต่ละกราฟสามารถแสดงได้ด้วย list of vertex และ adjacency matrix
//     • list of vertex เป็น array 1 มิติใช้เก็บจำนวน vertex ทั้งหมดในกราฟ ดังรูปข้างล่างแสดงว่ากราฟนี้มีจำนวน vertex 4 vertex ได้แก่ A, B, C, D
//     • adjacency matrix เป็น array 2 มิติใช้เก็บ ค่าของ edge ระหว่าง vertex 2 vertex ถ้าไม่มี edge เชื่อมกันจะมีค่าเป็น 0 ส่วนถ้ามี edge เชื่อมกันจะมีค่าช่องนั้นเป็น 1 ส่วนในกรณีที่ edge ระหว่าง 2 vertex นั้นมีค่าน้ำหนัก (w) ในช่องนั้นใน array 2 มิติ ก็จะมีค่า w ดังรูปข้างล่างนี้


// ตัวอย่าง list of vertex และ adjacency matrix ของกราฟแบบไม่มีทิศทาง





// ตัวอย่าง list of vertex และ adjacency matrix ของกราฟแบบมีทิศทาง







// ตัวอย่าง list of vertex และ adjacency matrix ของกราฟแบบไม่มีทิศทางแต่มีน้ำหนัก






// 10.9 การลบโหนดในกราฟ Delete vertex
// ถ้าต้องการ ลบ vertex ออกจากกราฟ  ต้องมีการ ลบ vertex ออกจาก  list of vertex และ adjacency matrix
// ตัวอย่าง
// ทำการลบ vertex B ออกจากกราฟข้างล่างนี้





// พิจารณา การลบ vertex B ออกจาก array ของ vertex list
// ขั้นแรกเลื่อน C ขึ้น มาทับ B ดังรูปข้างล่าง



// จากนั้น เลื่อน D ขึ้นมาทับ C ดังรูปข้างล่าง


// ต่อจากนั้น พิจารณา การลบ vertex B ออกจาก array ของ adjacency matrix
// ขั้นแรกเลื่อนแถวที่มี index 2 ซึ่งแทน edge ที่เกี่ยวข้องกับ vertex C ขึ้นมาทับ แถวที่มี index 1 ซึ่งแทน edge ที่เกี่ยวข้องกับ vertex B ดังรูปข้างล่าง


// จากนั้น เลื่อนแถวที่มี index 3  ซึ่งแทน edge ที่เกี่ยวข้องกับ vertex D  ขึ้นมาทับ แถวที่มี index 2  ซึ่งแทน edge ที่เกี่ยวข้องกับ vertex C ดังรูปข้างล่าง


// ขั้นต่อไป เลื่อนคอลัมน์ที่มี index  2 ซึ่งแทน edge ที่เกี่ยวข้องกับ vertex C  มาทับ คอลัมน์ที่มี index 1 ซึ่งแทน edge ที่เกี่ยวข้องกับ vertex B ดังรูปข้างล่าง


// 	จากนั้น เลื่อนคอลัมน์ที่มี index 3  ซึ่งแทน edge ที่เกี่ยวข้องกับ vertex D  มาทับ คอลัมน์ที่มี index  2  ซึ่งแทน edge ที่เกี่ยวข้องกับ vertex C ดังรูปข้างล่าง



// ขั้นตอนสุดท้าย  ทำการลดจำนวน number of vertex (numV) ลงไป 1  โดยใช้คำสั่ง numV--;  ดังรูปข้างล่าง


// 10.10 การท่องเข้าไปในกราฟ (Graph Traversal)
// มีอยู่ 2  แบบ คือ
//     • Bread First search (BFS) คือแบบการค้นหาในแนวกว้าง
//     • Depth First search (DFS) คือแบบการค้นหาในแนวลึก

// 10.10.1 Bread First Search (BFS)
//         การค้นหา vertex ในแนวกว้างซึ่งมีตัวอย่างการทำงานดังนี้


// เริ่มจากโหนด A ใส่เข้าใน queue

// ดึงโหนดที่มีอยู่ออกมาจาก queue เพื่อพิจารณา

// โหนด A มี โหนด ข้างเคียงทั้งหมดที่ยังไม่ถูก visit คือ โหนด B, C, I ดังนั้นจึงนำโหนดทั้ง 3 ใส่เข้าไปใน queue ดังคำสั่งและรูปข้างล่างนี้

// ดึงโหนดถัดไปออกจาก queue มาพิจารณา นั่นคือโหนด B

// โหนด B มี โหนด ข้างเคียงทั้งหมดที่ยังไม่ถูก visit คือ โหนด F ดังนั้นจึงนำโหนดนี้ ใส่เข้าไปใน queue ดังคำสั่งและรูปข้างล่างนี้



// ดึงโหนดถัดไปออกจาก queue มาพิจารณา นั่นคือโหนด C

// โหนด C มี โหนด ข้างเคียงทั้งหมดที่ยังไม่ถูก visit คือ โหนด D, E  ดังนั้นจึงนำโหนดทั้งสองนี้ ใส่เข้าไปใน queue ดังคำสั่งและรูปข้างล่างนี้

// ดึงโหนดถัดไปออกจาก queue มาพิจารณา นั่นคือโหนด I

// โหนด I มี โหนด ข้างเคียงทั้งหมดที่ยังไม่ถูก visit คือ โหนด G  ดังนั้นจึงนำโหนดนี้ ใส่เข้าไปใน queue ดังคำสั่งและรูปข้างล่างนี้


// ดึงโหนดถัดไปออกจาก queue มาพิจารณา นั่นคือโหนด F



// โหนด F  มี โหนดข้างเคียงทั้งหมดที่ยังไม่ถูก visit คือ โหนด H  ดังนั้นจึงนำโหนดนี้ ใส่เข้าไปใน queue ดังคำสั่งและรูปข้างล่างนี้


// ดึงโหนดถัดไปออกจาก queue มาพิจารณา นั่นคือโหนด D

// 	เนื่องจากโหนด D  ไม่เหลือโหนด ข้างเคียงที่ยังไม่ถูก visit  จึงไม่ต้องใส่โหนดอะไรเข้าไปในqueue
// ดึงโหนดถัดไปออกจาก queue มาพิจารณา นั่นคือโหนด E
//               เนื่องจากโหนด E  ไม่เหลือโหนดข้างเคียงที่ยังไม่ถูก visit  จึงไม่ต้องใส่โหนดอะไรเข้าไปในqueue ดังรูปข้างล่างนี้


// ดึงโหนดถัดไปออกจาก queue มาพิจารณา นั่นคือโหนด G

// เนื่องจากโหนด G  ไม่เหลือโหนด ข้างเคียงที่ยังไม่ถูก visit  จึงไม่ต้องใส่โหนดอะไรเข้าไปในqueue
// 	ดึงโหนดถัดไปออกจาก queue มาพิจารณา นั่นคือโหนด H
// เนื่องจากโหนด H  ไม่เหลือโหนด ข้างเคียงที่ยังไม่ถูก visit  จึงไม่ต้องใส่โหนดอะไรเข้าไปในqueue
// 	ขณะนี้ queue empty แล้วถือว่าจบการทำงาน  ได้ผลลัพธ์ ได้ผลลัพธ์ของ Breadth First Search คือ A B C I F D E G H ดังรูปข้างล่าง



// 10.10.2 Depth First Search (DFS)
//          การค้นหา vertex ในแนวลึก ซึ่งมีตัวอย่างการทำงานดังนี้





// เริ่มใส่โหนดแรกซึ่งคือโหนด A เข้าไปใน Stack

// ดึงโหนดถัดไปออกจาก stack มาพิจารณา นั่นคือโหนด A


// โหนด A มี โหนด ข้างเคียงทั้งหมดที่ยังไม่ถูก visit คือ โหนด B, C,  I  ดังนั้นจึงนำโหนดทั้งสามนี้ ใส่เข้าไปใน stack ดังรูปข้างล่างนี้

// ดึงโหนดถัดไปออกจาก stack มาพิจารณา นั่นคือโหนด B

// โหนด B มี โหนด ข้างเคียงทั้งหมดที่ยังไม่ถูก visit คือ โหนด F  ดังนั้นจึงนำโหนดนี้ ใส่เข้าไปใน stack ดังรูปข้างล่างนี้

// ดึงโหนดถัดไปออกจาก stack มาพิจารณา นั่นคือโหนด F

// โหนด F มี โหนด ข้างเคียงทั้งหมดที่ยังไม่ถูก visit คือ โหนด D, H  ดังนั้นจึงนำโหนดทั้งสองนี้ ใส่เข้าไปใน stack ดังรูปข้างล่างนี้

// ดึงโหนดถัดไปออกจาก stack มาพิจารณา นั่นคือโหนด D

// โหนด D มี โหนด ข้างเคียงทั้งหมดที่ยังไม่ถูก visit คือ โหนด G  ดังนั้นจึงนำโหนดนี้ ใส่เข้าไปใน stack ดังรูปข้างล่างนี้

// ดึงโหนดถัดไปออกจาก stack มาพิจารณา นั่นคือโหนด G

// เนื่องจากโหนด G ไม่เหลือโหนด ข้างเคียงที่ยังไม่ถูก visit  จึงไม่ต้องใส่โหนดอะไรเข้าไปใน stack
// ดึงโหนดถัดไปออกจาก stack มาพิจารณา นั่นคือโหนด H

// เนื่องจากโหนด H ไม่เหลือโหนด ข้างเคียงที่ยังไม่ถูก visit  จึงไม่ต้องใส่โหนดอะไรเข้าไปใน stack
// ดึงโหนดถัดไปออกจาก stack มาพิจารณา นั่นคือโหนด C

// โหนด C มี โหนด ข้างเคียงทั้งหมดที่ยังไม่ถูก visit คือ โหนด E  ดังนั้นจึงนำโหนดนี้ ใส่เข้าไปใน stack ดังรูปข้างล่างนี้

// ดึงโหนดถัดไปออกจาก stack มาพิจารณา นั่นคือโหนด E
// เนื่องจากโหนด E ไม่เหลือโหนด ข้างเคียงที่ยังไม่ถูก visit  จึงไม่ต้องใส่โหนดอะไรเข้าไปใน stack

// ดึงโหนดถัดไปออกจาก stack มาพิจารณา นั่นคือโหนด I
// 	เนื่องจากโหนด I ไม่เหลือโหนด ข้างเคียงที่ยังไม่ถูก visit จึงไม่ต้องใส่โหนดอะไรเข้าไปใน stack
// ขณะนี้ stack empty แล้วถือว่าจบการทำงาน  ได้ผลลัพธ์ของ Depth First Search คือ  A B F D G H C E I ดังรูปข้างล่าง

// 10.11 การสร้างโครงสร้างข้อมูล Graph
// 	การสร้างโครงสร้างข้อมูล graph จากคลาส Graph  ข่างล่างนี้ เนื่องจาก กราฟ แต่ละ กราฟ สามารถแทนได้ด้วย ArrayList  ของ vertex list เพื่อแสดงว่าในกราฟนี้มี vertex อะไรบ้าง  และ แทนด้วย array ของ adjacency matrix ดังนั้นจึงควรมี 2 ตัวนี้เป็น instance variable ของ class Graph

// import java.util.ArrayList;
// public class Graph {
//     private ArrayList vertexList;
//     private int[][] adjMatrix;
//     private int  matrixSize;

//     public Graph(){
//         matrixSize = 2;
//         vertexList = new ArrayList(); // เริ่มต้นสร้าง array เพื่อเตรียมมาเก็บ vertex
//         initMatrix();
//     }

//     private void initMatrix(){ //เริ่มต้น กราฟยังไม่มี edge จึงเป็น 0 ทุกช่อง
//       adjMatrix = new int[matrixSize][matrixSize];
//       for(int i=0; i<matrixSize; i++)
//          for(int j=0; j<matrixSize; j++)
//             adjMatrix[i][j] = 0;
//     }
//     //เพิ่ม vertex ลงใน ArrayList ที่ชื่อ vertexList โดยใช้ method addVertex
//     public void addVertex(Vertex v){
//         vertexList.add(v);
//       // ถ้า adjacency matrix เต็ม จะทำการขยาย matrix เป็น 2 เท่า ใน if ข้างล่างนี้
//         if (matrixSize == vertexList.size()){
//             matrixSize = matrixSize*2;
//             int[][] tmpMatrix = adjMatrix;
//             initMatrix();
//             for (int i=0; i<vertexList.size(); i++)
//                 for (int j=0; j<vertexList.size(); j++)
//                     adjMatrix[i][j] = tmpMatrix[i][j];
//             tmpMatrix = null;
//         }
//     }
// // เพิ่ม edge ระหว่าง vertex 2 vertex สำหรับกราฟแบบ ไม่มีทิศทาง และไม่มีน้ำหนัก โดยใช้ method
// //addEdge โดยระบุ vertex เริ่มต้น และ vertex ปลายทาง
//     public void addEdge(Vertex start, Vertex end){
//         int v1 = vertexList.indexOf(start);
//         int v2 = vertexList.indexOf(end);
//         adjMatrix[v1][v2] = 1; // 1 แปลว่ามี edge จาก V1 ไป V2
//         adjMatrix[v2][v1] = 1; // 1 แปลว่ามี edge จาก V2 ไป V1

//     }
// // เพิ่ม edge ระหว่าง vertex 2 vertex สำหรับกราฟแบบ มีทิศทาง หรือแบบมีน้ำหนัก โดยใช้ method addEdge
// //โดยระบุ vertex เริ่มต้น และ vertex ปลายทาง

//     public void addEdge(Vertex start, Vertex end, int weight){
//         int v1 = vertexList.indexOf(start);
//         int v2 = vertexList.indexOf(end);
//         adjMatrix[v1][v2] = weight;
//         adjMatrix[v2][v1] = weight;
//     }
//     // ลบ edge ระหว่าง vertex 2 vertex โดย set ค่าระหว่าง vertexให้เป็น 0 ใช้ method deleteEdge




//     public void deleteEdge(Vertex start, Vertex end){
//         int v1 = vertexList.indexOf(start);
//         int v2 = vertexList.indexOf(end);
//         adjMatrix[v1][v2] = 0;
//         adjMatrix[v2][v1] = 0;
//     }
// //ลบ vertex ตามขั้นตอนวิธีที่อิ ที่อธิบายไว้ด้านบน
//     public void deleteVertex(Vertex vertex){
//         int ci = 0, cj = 0;
//         int v = vertexList.indexOf(vertex);
//         vertexList.remove(v);
//         int[][] tmpMatrix = adjMatrix;
//         initMatrix();

//         for (int i=0; i<=vertexList.size(); i++){
//             cj = 0;
//             if (i==v)
//                 continue;
//             for (int j=0; j<=vertexList.size(); j++){
//                 if (j==v)
//                     continue;
//                 adjMatrix[ci][cj] = tmpMatrix[i][j];
//                 cj++;
//             }
//             ci++;
//         }
//         tmpMatrix = null;
//     }


// // method showAdjacencyMatrix() แสดงค่าใน adjacency matrix
//     public void showAdjacencyMatrix(){
//         for (int i=0; i<vertexList.size(); i++){
//            for (int j=0; j<vertexList.size(); j++)
//                System.out.print(adjMatrix[i][j]+" ");
//            System.out.println();
//         }
//     }

// // method showVertices() แสดงค่าใน vertex list ว่าในกราฟมี vertex อะไรบ้าง

//     public void showVertices(){
//         for (int i=0; i<vertexList.size(); i++){
//             System.out.print(((Vertex) vertexList.get(i)).getLabel()+" ");
//         }
//         System.out.println();
//     }
// // method dfs ใช้ในการ ท่องกราฟ แบบ Depth First search ตามวิธีที่อธิบายไว้ข้างบน
//     public void dfs(Vertex target){
// 	Stack s = new Stack();
//         int index;
//         Vertex tmp;
//         boolean found = false;
//         ArrayList a;

//         Vertex startVertex = (Vertex) vertexList.get(0);
//         s.push(startVertex);



//         do {
//             tmp = (Vertex) s.pop();
//             if(tmp == target){
//                 found = true;
//                 System.out.print(tmp.getLabel());
//             } else if(!tmp.getVisit()){
//                 tmp.setVisit(true);
//                 System.out.print(tmp.getLabel()+" ");
//                 a = getAdjacencyVertrices(tmp);
//                 for (index=0; index<a.size(); index++)
//                     if(((Vertex) a.get(index)).getVisit() != true)
//                         s.push((Vertex) a.get(index));
//             }
//         }while((!s.isEmpty()) && (!found));
//         System.out.println();
//         if (found)
//             System.out.println("Found Vertex "+target.getLabel());
//         else
//             System.out.println("Not Found Vertex "+target.getLabel());
//         clearVisit();
//     }
// // method bfs ใช้ในการ ท่องกราฟ แบบ Bread First search ตามวิธีที่อธิบายไว้ข้างบน

//     public void bfs(Vertex target){
//         Queue q = new Queue(50);
//         int index;
//         Vertex tmp;
//         boolean found = false;
//         ArrayList a;

//         Vertex startVertex = (Vertex) vertexList.get(0);
//         q.enqueue(startVertex);

//         do {
//             tmp = (Vertex) q.dequeue();
//             if(tmp == target){
//                 found = true;
//                 System.out.print(tmp.getLabel());
//             }else if(!tmp.getVisit()){
//                 tmp.setVisit(true);
//                 System.out.print(tmp.getLabel()+" ");
//                 a = getAdjacencyVertrices(tmp);
//                 for (index=0; index<a.size(); index++)
//                     if(((Vertex) a.get(index)).getVisit()!=true)
//                         q.enqueue((Vertex) a.get(index));
//             }
//         }while((!q.isEmpty()) && (!found));
//         System.out.println();
//         if (found)
//             System.out.println("Found Vertex "+target.getLabel());
//         else
//             System.out.println("Not Found Vertex "+target.getLabel());
//         clearVisit();
//     }





//     public ArrayList getAdjacencyVertrices(Vertex v){
//         ArrayList a = new ArrayList();
//         int toIndex;
//         int fromIndex = vertexList.indexOf(v);
//         for(toIndex=0; toIndex<vertexList.size(); toIndex++){
//             if (adjMatrix[fromIndex][toIndex] != 0)
//                 a.add(vertexList.get(toIndex));
//         }
//         return a;
//     }

//     public void clearVisit(){
//         for(int i=0; i<vertexList.size(); i++)
//             ((Vertex) vertexList.get(i)).setVisit(false);
//     }
// }

// // เนื่องจาก ใช้ Linked List ในการ implement โครงสร้างข้อมูล Queue จึงต้องมี class MyNode
// public class MyNode {

// 	private Object data;
// 	private MyNode next;

// 	public MyNode(Object obj, MyNode n){
// 		data = obj;
// 		next = n;
// 	}
// 	public void setNext(MyNode n){
// 		next = n;
// 	}
// 	public void setData(Object d){
// 		data = d;
// 	}

// 	public MyNode getNext(){
// 		return next;
// 	}

// 	public Object getData(){
// 		return data;
// 	}
// }
// // เนื่องจากขั้นตอนวิธีการท่องไปในกราฟแบบ แบบ Bread First search ต้องใช้ Queue
// public class Queue {
//     private int size;
//     private int max;
//     private MyNode front,rear;

//     public Queue(int m){
//         max = m;
//         front = rear = null;
//         size = 0;
//     }

//     public int size(){
//         return size;
//     }
//     public boolean isEmpty() {
//         return size == 0;
//     }
//     public boolean isFull(){
//         return size == max;
//     }

//     public void enqueue(Object obj){
//         if(isFull()){
//             System.out.println("Queue is full. Can't Add " + obj + "!");
//             return;
//         }
//         else{
//             MyNode tmp = new MyNode(obj, null);
//             if(isEmpty()){                              //Add the first node
//                 front = rear = tmp;
//             }
//             else{                                       //Add another node
//                 rear.setNext(tmp);
//                 rear = tmp;
//             }
//             size++;
//         }
//     }

//     public Object dequeue(){
//         if(isEmpty()){
//             System.out.println("Queue is Empty.");
//             return null;
//         }
//         else{
//             Object obj = front.getData();
//             if(front == rear)                         //Remove last node
//                 front = rear = null;
//             else                                      //Remove another node
//                 front = front.getNext();
//             size--;
//             return obj;
//         }
//     }
//     public void printQueue(){
//         if(isEmpty()){
//             System.out.println("Nothing in queue");
//         }
//         else {
//             System.out.println("Print Queue:");
//             MyNode start = front;
//             while (start != null){
//                 System.out.println(start.getData());
//                 start = start.getNext();
//             }
//         }
//     }
// }
// // เนื่องจากขั้นตอนวิธีการท่องไปในกราฟแบบ แบบ Depth First search ต้องใช้ Stack
// public class Stack {
//     private Object[] s;
//     private int top;
//     public  Stack(){
//         s = new Object[10];
//         top = -1;
//     }

//     public int size(){
//         return top+1;
//     }

//     public void push(Object o){
//         if(top == s.length-1)
//             s = doubleSize(s);
//         top++;
//         s[top] = o;
//     }

//     private static Object[] doubleSize(Object[] origin){
//         Object[] temp = new Object[origin.length*2];
//         System.arraycopy(origin,0,temp,0,origin.length);
//         return temp;
//     }

//     public Object pop(){
//         if(isEmpty())  return null;
//         Object e = s[top];
//         top--;
//         return e;
//     }

//     public boolean isEmpty(){
//         return top == -1;
//     }



//     public void printStack(){
//         while (!(isEmpty())){
//             System.out.println(pop());
//         }
//     }

//     public Object peek(){
//         Object e = s[top];
//         return e;
//     }

// }
// //ทดสอบการทำงานของกราฟ
// public class Main {
//     public static void main(String[] args) {
//         Graph g = new Graph();
//         Vertex A = new Vertex("A");
//         Vertex B = new Vertex("B");
//         Vertex C = new Vertex("C");
//         Vertex D = new Vertex("D");
//         Vertex E = new Vertex("E");
//         Vertex F = new Vertex("F");

//         g.addVertex(A);
//         g.addVertex(B);
//         g.addVertex(C);
//         g.addVertex(D);
//         g.addVertex(E);
//         g.addVertex(F);

//         System.out.println("Vertrices:");
//         g.showVertices();

//         g.addEdge(A,B,5);
//         g.addEdge(A,C,5);
//         g.addEdge(A,D,8);
//         g.addEdge(B,C,6);
//         g.addEdge(B,E,5);
//         g.addEdge(C,D,6);
//         g.addEdge(C,E,5);
//         g.addEdge(C,F,5);
//         g.addEdge(F,D,5);
//         System.out.println("Adjacency Matrix:");
//         g.showAdjacencyMatrix();

//         g.deleteVertex(F);
//         System.out.println("Vertices:");
//         g.showVertices();
//         System.out.println("Adjacency Matrix:");
//         g.showAdjacencyMatrix();

//         System.out.println("Breadth First Search:");
//         g.bfs(E);

//         System.out.println("Depth First Search:");
//         g.dfs(B);
//     }
// }


// แบบฝึกหัดท้ายบท
// จงเขียนโปรแกรมสร้างโครงสร้างข้อมูลแบบ Graph    ซึ่งมีรายละเอียดของโปรแกรม  ดังนี้
//     1. สร้างคลาสชื่อ Vertex   เพื่อระบุ attribute และ method ของโหนดข้อมูลใน graph
//     2. สร้างคลาสชื่อ Graph เพื่อเขียนโปรแกรมสร้างโครงสร้างข้อมูลแบบ Graph โดยมีรายละเอียดของ method ต่าง ๆ   ดังนี้
//    - addVertex 	เพิ่มโหนดข้อมูลลงใน graph  โดยเก็บโหนดข้อมูลทั้งหมดของ graph ในรูปแบบ array ขนาด 1 มิติ
// - addEdge	เพิ่มเส้นโยงและระบุค่า weight ของเส้นโยงนั้น ๆ ลงใน graph   โดยเก็บค่า weight ของเส้นโยงระหว่าง source vertex และ destination vertex ในรูปแบบ array ขนาด 2 มิติ
// - deleteVertex 		ลบโหนดข้อมูลออกจาก graph
// - deleteEdge		ลบเส้นโยงและค่า weight ของเส้นโยงนั้น ๆ ออกจาก graph
// -  bfs(Vertex target)	traverse graph แบบ Breadth-First Search เพื่อค้นหาโหนดข้อมูล target ว่าอยู่ใน graph หรือไม่
// -  dfs(Vertex target)	traverse graph แบบ Depth-First Search เพื่อค้นหาโหนดข้อมูล target ว่าอยู่ใน graph หรือไม่  (แสดงผล output ในรูปแบบเดียวกับ method bfs(Vertex target)
//     3. สร้างคลาสชื่อ Main เพื่อตรวจสอบการทำงานของคลาส Graph
// 2.1) แสดงผลอาร์เรย์ของ Vertices และ Adjacency Matrix ออกมาทางจอภาพ หลังจากรับ
// input คือ










// 2.2) แสดงผลอาร์เรย์ของ Vertices และ Adjacency Matrix ออกมาทางจอภาพ   หลังจากลบ vertex “F” ออกจาก graph
// 2.3) แสดงผลลำดับของ vertices ใน graph ออกมาทางจอภาพ หลังจากการ traverse แบบ Breadth-First Search และแสดงผลเป็นข้อความออกมาทางจอภาพว่า พบโหนดข้อมูล E ใน graph หรือไม่
// ยกตัวอย่างเช่น


// 2.4) แสดงผลลำดับของ vertices ใน graph ออกมาทางจอภาพ หลังจากการ traverse แบบ Depth-First Search และแสดงผลเป็นข้อความออกมาทางจอภาพว่า พบโหนดข้อมูล B ใน g

// บทที่ ประโยชน์ของโครงสร้างข้อมูลและการนำไปใช้ประโยชน์
// การนำTree มาประยุกต์ใช้ได้หลายงาน
//     1. นำ Tree มา ใช้ในการเก็บข้อมูลที่มีลำดับขั้น เช่นการเก็บข้อมูลของระบบไฟล์บนคอมพิวเตอร์










//     2. ถ้าเก็บข้อมูลโดยใช้ Binary Search Tree จะสามารถหาข้อมูลได้เร็วกว่าการเก็บข้อมูลแบบเรียงทั่วไปเช่นการเก็บข้อมูลใน Linked List
// ตัวอย่าง ถ้าจะหาข้อมูลที่มีค่า 5 ใน Linked List ต้องทำการตรวจสอบตั้งแต่ข้อมูลแรกที่ ตัวชี้ first ชี้อยู่ ว่าใช่ไหม ถ้าไม่ใช่จะค้นหาตัวถัดไปจนกว่าจะเจอข้อมูล 5


// ถ้าต้องการหา ข้อมูล 5 ใน list ข้อมูลนี้  1, 2, 4, 5, 6, ที่ถูกเก็บแบบ Binary Search Tree

// ทำการค้นหาข้อมูล 5 โดย การแบ่งครึ่งข้อมูลก่อน  เนื่องจากตำแหน่งเริ่มที่ 0 ส่วนตำแหน่งสุดท้ายของ List นี้คือ 4 เพราะฉะนั้นตำแหน่งกึ่งกล่งของ List นี้คือ  (0+4)/2 =2  นั้นคือข้อมูลที่มีค่า 4 เป็นข้อมูลกึ่งกลาง จากนั้นเปรียบเทียบค่ากึ่งกล่างกับข้อมูลเป้าหมาย นั่นคือ 5  > 4 เพราะฉะนั้น จะพิจารณา ข้อมูลครึ่ง หลัง  5, 6 ต่อจากนั้น ทำการแบ่งครึ่งข้อมูลต่อ เนื่องจากตำแหน่งเริ่มต้นของ List ครึ่งหลังคือตำแหน่งที่  ตำแหน่งกึ่งกลาง(2) + 1=3  ส่วนตำแหน่งสุดท้ายของ List ครึ่งหลังนี้เป็นตัวเดิม คือ 4 เพราะฉะนั้นตำแหน่งกึ่งกลางของ list นี้คือ  (3+4)/2 = 3  นั้นคือข้อมูลที่มีค่า 5 เป็นข้อมูลกึ่งกลาง เนื่องจากข้อมูลของค่ากึ่งกลางคือข้อมูล 5 นั่นคือพบข้อมูล 5 แล้ว


// การนำGraph มาประยุกต์ใช้ได้หลายงาน
//     1. ใน social network การเชื่อมต่อระหว่างเครือข่ายเพื่อน โดย ให้แต่ละคนคือ vertex ส่วน Edge ไว้เชื่อมคนที่เป็นเพื่อนกัน
// ตัวอย่าง  มีผู้ใช้ใน Social network A B C D E F  graph สามารถ แทน Social Network นี้ได้ดังรูปข้างล่างนี้  โดยผู้ใช้คือvertex ส่วน edge แสดงการเป็นเพื่อน เช่นจากรูปข้างล่าง
// - C ขอเป็นเพื่อนกับ D แต่ D ยังไม่ยอมตอบรับเป็นเพื่อนกับ C
// - B กับ F เป็นเพื่อนซึ่งกันและกัน
// - B กับ C  ไม่เป็นเพื่อนซึ่งกันและกัน



//     2. Web page บน Internet มีการเชื่อมต่อกัน สามารถถูกสร้างด้วยกราฟ โดย vertex แทน แต่ละ web ส่วน edge แทน link จาก page นึง ไปยังอีก page
// ตัวอย่าง webภาค
// - หน้า home link ไป หน้า บุคลากรและหน้าหลักสูตร
// - หน้า บุคลากร link ไปหน้า อาจารย์ ก.
// - หน้าหลักสูตร link ไปหน้า หลักสูตรวิยาการคอมพิวเตอร์
// - จากหน้า หลักสูตรวิยาการคอมพิวเตอร์ หรือ หน้า อาจารย์ ก. Link กลับไปหน้า home










//     3. แผนที่รถไฟก็สามารถสร้างจากกราฟ เช่น แผนที่รถไฟใต้ดินในโตเกียว โดยแต่ละสถานีถูกแสดงด้วย vertex และสถานนีที่ติดต่อกันก็จะมี edge มาเชื่อมต่อดังรูป  จะเห็นได้ชัดว่าสถานี Ueno เชื่อมต่อกับสถานี Inaricho บนสายสีเหลือง
// ถ้าจะหาเส้นทางจากสถานีนึงไปยังอีกสถานีนึงก็ใช้หลักการของ Depth First  Search
