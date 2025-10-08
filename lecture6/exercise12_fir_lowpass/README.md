jiancai hou 

Increasing the filter order M (so the number of taps is M+1) makes the impulse response longer and the truncation of the ideal sinc less severe. A longer time window gives a narrower transition band in frequency, so the cutoff is sharper—that’s why M=64 looks steeper than M=20. The longer filter also spreads energy more smoothly, so passband and stopband ripples are smaller; adding a window reduces them further. Because the coefficients are symmetric about the center sample, the filter has linear phase (constant group delay), so increasing M sharpens magnitude without distorting phase. In the direct, unwindowed design with cutoff set to 1 rad/s, the passband peak is about 0.318; with a window and DC normalization, the passband tops near 1.0 while keeping a narrower transition for larger M.


<img width="863" height="666" alt="image" src="https://github.com/user-attachments/assets/383e365c-d4c0-4eb0-a410-dea432d00b18" />

<img width="844" height="657" alt="image" src="https://github.com/user-attachments/assets/bbb0f75a-ac60-4047-b5af-52fdb7acb2e6" />

<img width="871" height="676" alt="image" src="https://github.com/user-attachments/assets/f00177c7-e519-4ced-a43f-8ee3cece1962" />

<img width="849" height="680" alt="image" src="https://github.com/user-attachments/assets/3e2bd4b5-feb4-45f0-b053-4e3e84c58b64" />

