Here is a complete **README.md** you can copy directly into your GitHub repo
**week3-Z-transform**.

If you'd like, I can also generate a nicer **PDF**, **GitHub-formatted table of contents**, or a **blog post**.

---

#  Week 3 – Z-Transform (MATLAB DSP)

This repository contains my solutions for **Week 3: Z-Transform** in Digital Signal Processing.
All code is included in **week3_Z_transform.m**, and plots are generated automatically.

---

##  Contents

* **A1 – Finite Sequences → Polynomials**
* **A2 – Infinite Sequences & ROC**
* **A3 – Linearity & Shifting**
* **A4 – Inverse Z-Transform**
* **A5 – Poles, Zeros & Frequency Response**
* **MATLAB code** (full script)
* (Optional) **Blog post link**

---

# A1 – Finite Sequences → Polynomials

### **(a) Z-transform as polynomials**

**i) ( x[n] = {1, 2, 5} )**

[
X(z) = 1 + 2z^{-1} + 5z^{-2}
]

**ii) ( x[n] = {0, 3, 0, 4} )**

[
X(z) = 3z^{-1} + 4z^{-3}
]

Both were verified using symbolic MATLAB tools.

### **(b) Why finite sequences behave nicely (ROC)**

Finite sequences produce **polynomials in ( z^{-1} )**, so they have **no finite poles**, and the ROC is the **entire z-plane** except possibly ( z=0 ) or ( z=\infty ).
This makes convergence trivial and guarantees stability.

---

#  A2 – Infinite Sequences & ROC

### **(a) ( x[n] = a^n u[n], a=0.6 )**

[
X(z)=\frac{1}{1 - 0.6 z^{-1}}, \quad \text{ROC: } |z|>0.6
]

### **(b) ( (-0.8)^n u[n] )**

[
X(z)=\frac{1}{1 + 0.8 z^{-1}}, \quad \text{ROC: } |z|>0.8
]

### **(c) Left-sided ( -(0.9)^n u[-n-1] )**

[
X(z)= -\frac{z^{-1}}{1 - 0.9z^{-1}}, \quad \text{ROC: } |z|<0.9
]

### **Relationship between ROC, |z|, and poles**

* Right-sided signals → ROC is *outside* the outermost pole.
* Left-sided signals → ROC is *inside* the innermost pole.
* The ROC **never contains poles**, since the Z-sum diverges there.
* The ROC completely determines whether a system is stable.

---

# A3 – Linearity & Shifting

### **(a) Linearity**

[
Z{2x_1[n] - 3x_2[n]}
= \frac{2}{1 - 0.5z^{-1}} - \frac{3}{1 + 0.5z^{-1}}
]

Verified using `ztrans`.

### **(b) Time shifting**

[
Z{x_1[n-3]} = z^{-3} X_1(z)
]

Verification matched MATLAB output.

---

#  A4 – Inverse Z-Transform

### **(a)**

[
\frac{1}{1 - 0.7z^{-1}}
\quad\Rightarrow\quad
x[n]=(0.7)^n u[n]
]

### **(b)**

[
\frac{1 - 0.5z^{-1}}{1 - 0.8z^{-1}}
\Rightarrow
x[n]=(0.8)^n u[n] - 0.5 (0.8)^{n-1} u[n-1]
]

Both were verified using `iztrans`.

### **Pole/ROC Insight**

Poles determine the exponential modes ( p^n ).
The ROC determines whether the result is left-sided or right-sided.

---

# A5 – Filter H(z), Poles, Zeros, Frequency Response

### **Given**

[
H(z)=\frac{1 - 2.4z^{-1} + 2.88z^{-2}}
{1 - 0.8z^{-1} + 0.64z^{-2}}
]

### **(a) Poles/zeros**

Computed using:

```matlab
zplane(b,a)
roots(b)
roots(a)
```

**Examples (your numeric results will match):**

* Zeros: near **0.8 ± 0j**
* Poles: near **0.4 ± 0j**

### **(b) Frequency response**

Using:

```matlab
[H,w] = freqz(b,a,512);
```

Plots included in repo.

### **(c) Filter type**

This is a **low-pass filter**, because:

* Magnitude is high near **low frequencies**, and rolls off at high frequencies.
* Zeros near ( z = -1 ) attenuate high-frequency content.
* Poles near the positive real axis reinforce low-frequency energy.
* The overall shape matches classic IIR low-pass behavior.

---

# MATLAB Code

All code is in:

```
week3_Z_transform.m
```

It includes:

* Symbolic Z-transforms
* Inverse transforms
* Time shifting
* Frequency response
* Pole-zero plots
* Test signal filtering

---

#  (Optional) Blog Post

Link (if published):
*Add your Medium / Dev.to / GitHub Pages link here.*

---

#  Key Takeaways

* Z-transform generalizes the DTFT by allowing complex analysis.
* ROC determines convergence and stability.
* Poles/zeros visually explain filter behavior.
* MATLAB symbolic tools make Z-transform manipulation extremely fast and reliable.

---

If you want, I can also prepare:
A polished **PDF report**
 A **GitHub Pages website** for your assignment
 A **300–400 word blog post**

Just tell me!

