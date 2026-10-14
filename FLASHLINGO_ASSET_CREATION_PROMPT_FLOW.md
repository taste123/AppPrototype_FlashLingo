# 🎨 FlashLingo Asset Generation Prompt Framework (Google Flow)
> **Master Guide & Prompt Catalog untuk Pembuatan Asset FlashLingo yang Bebas "AI Slop"**  
> Didesain khusus untuk audiens **Anak Sekolah Dasar (SD / Usia 6–12 Tahun)** dengan estetika kartun kontemporer, ekspresif, berkarakter unik, dan tidak pasaran.

---

## 📌 1. Filosofi Gaya Visual: "Anti-AI-Slop" Manifesto

Sebagian besar image generator (Midjourney, DALL-E 3, Imagen/Google Flow) memiliki bias bawaan (default bias) yang menghasilkan:
1. **3D Glossy Clay/Pixar Knockoff** (terlihat seperti lilin plastik berminyak, mata boneka mengkilat).
2. **Corporate Flat Vector / "Memphis Style"** (terlalu kaku, steril, membosankan bagi anak SD).
3. **Hyper-rendered Airbrushed Clipart** (terlalu banyak gradasi lembut, tidak memiliki jiwa seni tradisonal).

### 🎯 Pilar Estetika Visual FlashLingo:
* **Style:** *Contemporary Indie Storybook Animation & Editorial Cartoon* (Campuran gaya *Hilda*, *Bluey*, Oliver Jeffers, dan kartun *Cartoon Network* modern era).
* **Line Art:** Garis kontur tebal, organik, sedikit *jittery* (seperti goresan pena tinta tebal atau pensil *crayon wax*), tidak simetris secara kaku.
* **Warna & Shading:** Warna datar berani (*flat gouache & screenprint*), *matte finish*, sedikit sentuhan tekstur *risograph/halftone grain*. **Haram menggunakan gradasi plastik 3D.**
* **Bentuk & Siluet (Shape Language):** Proporsi unik, *exaggerated & playful* (misal: kaki mungil dengan badan gemuk, mata besar ekspresif, ekspresi konyol tapi menggemaskan). Bukan kartun balita (*cocomelon*), melainkan kartun cerdas yang disukai anak SD.
* **Latar:** *Clean isolated asset* di atas latar belakang putih bersih / netral agar mudah di-*cutout* (PNG transparan) untuk Flutter.

---

## 🛡️ 2. Global Negative Prompt (Anti-Slop Guardrails)

Selalu sertakan parameter negatif ini ke dalam setiap node prompt di Google Flow / Imagen untuk memblokir estetika AI murahan:

```text
--no 3d render, cgi, blender render, octane render, unreal engine, claymation, plastic, glossy surfaces, airbrushed, hyperrealistic, photorealistic, shiny gradients, smooth airbrush shading, corporate memphis, generic vector clipart, sterile stock art, soulless flat vector, anime tropes, shiny porcelain skin, symmetrical uncanny eyes, extra limbs, mutated anatomy, blur, noisy background, photographic lighting
```

---

## 🧱 3. Formula Master Prompt (Template Google Flow)

Gunakan struktur formula berikut di setiap card/node Google Flow:

```text
[Subjek Spesifik & Pose Ekspresif Unik], [Bahasa Bentuk / Siluet Eksentrik], indie picture book illustration style, chunky textured ink outlines, flat matte gouache colors, subtle risograph paper texture, playful asymmetrical shapes, vibrant limited color palette: [pilihan warna kunci], whimsical and fun character design for elementary school kids, isolated on pure white background, zero glossy reflections, 2D vector-feel hand-drawn craft --no [Global Negative Prompt]
```

---

## 🧩 4. Katalog Prompt Kategori & Aset FlashLingo

Di bawah ini adalah prompt terstruktur siap pakai yang disesuaikan dengan file `lib/data/content.dart`:

---

### A. Ikon Kategori & Badge Menu (Home Screen)

#### 1. Level 1: Greetings (`assets/greetings.png`)
* **Prompt:**
  ```text
  Whimsical quirky cartoon illustration of two diverse friendly elementary kids exchanging a high-five mid-air with joyful energetic expressions, chunky imperfect ink outlines, flat gouache warm earthy tones (#8B5A2B accent, mustard yellow, coral), charming storybook style, dynamic pose, isolated on white background, no text, 2d indie animation --no 3d, glossy, plastic, corporate vector
  ```

#### 2. Level 2: Colours (`assets/colors.png`)
* **Prompt:**
  ```text
  Funny cartoon chameleon holding an oversized messy paintbrush, with colorful paint splatters around its feet, wearing round glasses, quirky handmade indie art style, thick crayon outlines, vivid lavender (#B088CA), mint green and tangerine, matte paper finish, isolated on solid white background --no 3d, realistic lizard, shiny gradients
  ```

#### 3. Level 3: Numbers (`assets/numbers.svg` / PNG)
* **Prompt:**
  ```text
  Quirky anthropomorphic numbers 1, 2, 3 playing leapfrog together, goofy googly eyes, skinny wobbly cartoon legs, playful children book illustration, warm ochre orange (#F4A261) and teal tones, screenprinted texture, isolated on pure white background --no 3d render, glossy balloons, clipart
  ```

#### 4. Level 4: The Body and The Face (`assets/body.png`)
* **Prompt:**
  ```text
  Playful indie cartoon character making a goofy silly face, touching nose with one hand and winking, expressive big animated features, chunky uneven ink brush line, soft sage green (#A9D39E) and peach palette, matte gouache texture, isolated on pure white background --no uncanny realistic face, 3d render, creepy smile
  ```

#### 5. Level 5: School (`assets/school.svg` / PNG)
* **Prompt:**
  ```text
  An oversized friendly backpack creature packed with quirky pens, ruler, and a book peeking out with wide cartoon eyes, indie cartoon style, thick pencil lineart, sky blue (#7FB6D8) and mustard yellow accents, retro storybook feel, isolated on pure white background --no corporate flat design, 3d render, shiny bag
  ```

#### 6. Level 6: Clothes (`assets/clothes.png`)
* **Prompt:**
  ```text
  A stack of quirky mismatched clothing items animated with personality: a bright funny beanie hat on top, sneakers with goofy laces, hand-drawn editorial cartoon illustration, retro primary colors and denim blue, chunky brush lines, risograph texture, white background --no realistic fabric, 3d clothes, plastic
  ```

#### 7. Level 7: The Home (`assets/home.svg` / PNG)
* **Prompt:**
  ```text
  A charming slightly crooked cartoon cottage house with a cheerful chimney puffing curly smoke shaped like a heart, warm friendly face on the front door, storybook illustration, terracotta orange (#E76F51) and olive tones, hand-stamped block print texture, isolated on white background --no 3d architectural render, glossy surfaces
  ```

#### 8. Level 8: Animals (`assets/animal.png`)
* **Prompt:**
  ```text
  A funny stack of three quirky cartoon animals balancing together: a tiny bird on a sleepy dog, on top of an easygoing round elephant, indie editorial style, chunky crayon contours, turquoise (#73C2C8) and terracotta palette, matte gouache, pure white background --no 3d disney clone, realistic fur, glossy eyes
  ```

#### 9. Level 9: Family & Friends (`assets/familyFriends.png`)
* **Prompt:**
  ```text
  Quirky cartoon group portrait of a cheerful family: tall mom, round dad, energetic kids and a goofy pet, hugging inside a playful wobbly frame, indie graphic novel style, coral pink (#EB8B71) and warm yellow accents, grainy matte texture, isolated on white background --no uncanny photorealism, glossy 3d puppets
  ```

#### 10. Level 10: Time (`assets/time.svg` / PNG)
* **Prompt:**
  ```text
  A quirky vintage alarm clock running on energetic cartoon sneaker legs, clock hands pointing to a fun hour, motion lines, expressive cartoon face on the dial, deep teal (#2A9D8F) and lemon yellow, hand-drawn screenprint illustration, isolated on pure white background --no 3d metallic render, shiny glass reflection
  ```

---

### B. Flashcard Vocabularies: Item Cards

#### Kategori: Animals (`B8`)
* **Cat (Kucing):**
  ```text
  Quirky lazy ginger cat curled into a soft square shape, sleepy satisfied smile, tiny whiskers, chunky textured contour lines, warm terracotta and cream matte flat gouache, indie storybook character, white background --no realistic fur, 3d cat, shiny eyes
  ```
* **Dog (Anjing):**
  ```text
  Scruffy floppy-eared puppy running excitedly with a stick in its mouth, dynamic goofy posture, hand-drawn comic style, warm chocolate and mustard tones, risograph speckle, white background --no photorealistic dog, 3d render, airbrush
  ```
* **Elephant (Gajah):**
  ```text
  Chunky friendly elephant with disproportionately tiny round ears and funny sneakers, spraying water droplets playfully, chalky charcoal outlines, slate blue-gray with dusty rose accents, isolated on white background --no realistic elephant skin, 3d clay
  ```
* **Monkey (Monyet):**
  ```text
  Quirky lanky monkey hanging upside down by its spiral tail eating a banana with wide humorous eyes, thick uneven ink lines, warm golden brown and bright yellow, indie animation cel look, white background --no 3d furry monkey, realistic ape
  ```
* **Bird (Burung):**
  ```text
  Chubby little round songbird with oversized feet and comical expressive eyebrows, singing musical notes, turquoise and bright orange flat color blocks, woodblock print aesthetic, white background --no angry birds clone, 3d feathers
  ```
* **Fish (Ikan):**
  ```text
  Round quirky puffer-style goldfish with huge circular glasses and tiny flipper fins, blowing comic-style bubbles, coral orange and mint green, matte gouache illustration, white background --no nemo clone, shiny scales, 3d
  ```

---

#### Kategori: The Body and Face (`B4`)
* **Head & Hair:**
  ```text
  Fun cartoon child head with messy curly unruly hair bursting in all directions, big excited round eyes, simple nose dot, bold textured brush strokes, warm peach and charcoal, isolated on white background --no creepy doll face, 3d anime
  ```
* **Eye:**
  ```text
  Pair of expressive cartoon eyes with playful thick eyebrows looking up curiously, retro comic book print aesthetic, clean hand-inked line, risograph dot effect, white background --no realistic human eyeball, 3d render
  ```
* **Nose:**
  ```text
  Cute stylized cartoon button nose on a smiling character profile, funny freckles, soft crayon texture, warm pastel peach tones, indie picture book style, white background --no realistic plastic surgery nose, 3d clay
  ```
* **Mouth:**
  ```text
  Big happy cartoon open mouth laughing showing two playful front teeth, clean comic ink contour, bright watermelon red, matte paper grain, isolated on white background --no realistic teeth, uncanny lips, glossy saliva
  ```
* **Hand:**
  ```text
  Chunky cartoon four-fingered hand waving enthusiastically, thick wobbly ink outline, dynamic gesture, warm flesh tone with playful orange outline, white background --no six fingers, mutated AI hand, 3d realistic anatomy
  ```
* **Leg & Feet:**
  ```text
  Pair of funny cartoon legs mid-stride wearing bright yellow retro sneakers and striped socks, motion dust puffs, comic strip style, white background --no realistic human feet, bare toes, 3d render
  ```

---

#### Kategori: School (`B5`)
* **Book:**
  ```text
  A thick open storybook with colorful magical doodles and stars popping out from its pages, hand-carved lino-print style, bold indigo, gold, and ruby red, matte texture, white background --no 3d render, realistic glossy book
  ```
* **Pen / Pencil:**
  ```text
  A determined cartoon wooden pencil character with a funny eraser hat writing a curly line, expressive pencil lead tip, vintage children's book aesthetic, canary yellow and graphite gray, white background --no sleek corporate ballpoint, 3d render
  ```
* **Table & Chair:**
  ```text
  A charming wooden school desk and chair with slightly wonky hand-made perspective, a carved smiley on the wood grain, Scandinavian picture book style, muted oak wood and teal metal frame, white background --no 3d architectural furniture, sterile cad
  ```
* **Teacher:**
  ```text
  A warm cheerful cartoon teacher with colorful funky glasses and patterned cardigan, holding a pointer stick enthusiastically, friendly quirky expression, indie storybook vector art, white background --no uncanny face, anime girl, corporate illustration
  ```

---

#### Kategori: Clothes (`B6`)
* **Hat:**
  ```text
  A cozy knitted winter beanie with a giant quirky oversized pom-pom and playful zig-zag patterns, chunky wool texture illustrated in 2D gouache, mustard yellow and royal blue, white background --no realistic photo, 3d knit mesh
  ```
* **Shirt:**
  ```text
  A bright striped t-shirt with a funny little dinosaur patch pocket, hand-drawn ink contours, playful loose fold lines, coral red and off-white stripes, white background --no realistic cotton mockup, glossy 3d
  ```
* **Shoes:**
  ```text
  A pair of chunky funky high-top sneakers with mismatched shoelaces, side profile, indie comic book style, bold cobalt blue and cherry red, halftone screenprint dots, white background --no realistic nike photo, 3d model
  ```

---

#### Kategori: The Home (`B7`)
* **Living Room:**
  ```text
  A cozy whimsical living room vignette: a chubby comfy armchair with a sleeping cat and a quirky floor lamp, warm storybook illustration, olive green, mustard and burnt orange, clean cutout on white background --no sterile interior 3d render, hyperrealism
  ```
* **Kitchen:**
  ```text
  A playful kitchen counter with a bubbling tea kettle whistling cheerful musical notes, a quirky polka-dot mug, retro mid-century cartoon art style, turquoise and lemon yellow, white background --no realistic modern kitchen, stainless steel reflections
  ```
* **Garden:**
  ```text
  Quirky cartoon garden patch with giant smiling sunflower, a funny snail on a leaf, and a watering can, hand-stamped folk-art inspired cartoon, vibrant botanical greens and sunshine yellow, white background --no 3d realistic grass, photorealism
  ```

---

### C. Maskot FlashLingo: "Lingo the Gecko/Chameleon" (Opsional Ekosistem Brand)

Jika ingin membuat maskot pemandu game yang konsisten di semua layar:

```text
Character sheet of "Lingo": a quirky, lovable small cartoon chameleon with oversized expressive round eyes, wearing a little teal messenger satchel, goofy curved tail, vibrant lime green and tangerine spots, hand-drawn indie animation style (inspired by Cartoon Saloon and Adventure Time), flat matte gouache, bold contour ink lines, isolated on white background, 4 different poses: (1) Celebrating with confetti, (2) Thinking with hand on chin, (3) Encouraging thumbs up, (4) Goofy confusion with dizzy spiral eyes --no 3d, glossy, plastic, pixar clone
```

---

## ⚙️ 5. Panduan Teknis Integrasi ke Flutter (`AppPrototype_FlashLingo`)

Agar gambar hasil generate langsung optimal saat dimasukkan ke dalam project Flutter:

1. **Resolusi Output:**
   * Generate di rasio **1:1 (Square)** dengan ukuran minimal **1024x1024 px**.
2. **Format File & Transparansi:**
   * Simpan dalam format **PNG-24 dengan latar transparan** (atau hapus latar putih menggunakan tool cutout seperti Photoroom / remove.bg / script Python).
   * Format target aset: WebP atau PNG teroptimasi (lossless/compressed).
3. **Penyelarasan Cache di Codebase:**
   * Codebase FlashLingo saat ini menggunakan optimasi memori:
     * `flashcard_screen.dart`: `cacheWidth: 800`
     * `quiz_screen.dart`: `cacheWidth: 500`
   * Menjaga outline tebal dan flat color memastikan aset tetap tajam dan tajam (*crisp*) saat di-*downsample* otomatis oleh Flutter engine tanpa blur.

---

## 💡 6. Checklist Verifikasi "Anti-AI-Slop" Sebelum Finalisasi

Tanyakan 5 hal ini sebelum memutuskan sebuah aset layak dipakai di FlashLingo:
- [ ] **Apakah ada efek plastik mengkilap?** (Jika ada highlight putih licin seperti lilin 3D, **reject**).
- [ ] **Apakah proporsinya berani dan unik?** (Jika tampak seperti gambar stok clip-art standar Canva atau clip-art umum, minta variasi pose yang lebih *quirky*).
- [ ] **Apakah garis luarnya punya karakter?** (Harus terlihat sentuhan tangan / *hand-drawn ink/crayon*, bukan garis vektor komputer yang steril).
- [ ] **Apakah anatominya aman?** (Pastikan jari tangan anak/hewan berjumlah pas atau stylized 4 jari kartun yang rapi).
- [ ] **Apakah cocok untuk anak SD?** (Keren, lucu, imajinatif, tidak kekanak-kanakan seperti kartun bayi 2 tahun).
