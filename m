From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/4] fs/namei.c: factor out helper full_name_long_hash()
Date: Tue,  6 Feb 2018 14:21:38 +0200
Message-ID: <1517919700-29182-4-git-send-email-amir73il@gmail.com>
References: <1517919700-29182-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:37258 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752922AbeBFMUr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Feb 2018 07:20:47 -0500
Received: by mail-wr0-f193.google.com with SMTP id a43so1699288wrc.4
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Feb 2018 04:20:47 -0800 (PST)
In-Reply-To: <1517919700-29182-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

This is a flavor of full_name_hash() which does not truncate the long
hash value to 32-bit in case long is 64-bit.

A helper __hash_64() is introduced to multiply with GOLDEN_RATIO_64,
just as the the helper __hash_32() multiples with GOLDEN_RATIO_32.
This makes the 32 and 64 bit variants of fold_long_hash() look similar.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/namei.c                 | 41 ++++++++++++++++++++++++++++++-----------
 include/linux/hash.h       | 10 +++++++++-
 include/linux/stringhash.h |  6 +++++-
 3 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 921ae32dbc80..afe2a8af9ce4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1804,7 +1804,7 @@ static int walk_component(struct nameidata *nd, int flags)
 
 #ifdef HASH_MIX
 
-/* Architecture provides HASH_MIX and fold_hash() in <asm/hash.h> */
+/* Architecture provides HASH_MIX and fold_long_hash() in <asm/hash.h> */
 
 #elif defined(CONFIG_64BIT)
 /*
@@ -1843,15 +1843,13 @@ static int walk_component(struct nameidata *nd, int flags)
 	y *= 9			)
 
 /*
- * Fold two longs into one 32-bit hash value.  This must be fast, but
+ * Fold two longs into one long hash value.  This must be fast, but
  * latency isn't quite as critical, as there is a fair bit of additional
  * work done before the hash value is used.
  */
-static inline unsigned int fold_hash(unsigned long x, unsigned long y)
+static inline unsigned long fold_long_hash(unsigned long x, unsigned long y)
 {
-	y ^= x * GOLDEN_RATIO_64;
-	y *= GOLDEN_RATIO_64;
-	return y >> 32;
+	return __hash_64(y ^ __hash_64(x));
 }
 
 #else	/* 32-bit case */
@@ -1872,7 +1870,7 @@ static inline unsigned int fold_hash(unsigned long x, unsigned long y)
 	x += y,	y = rol32(y,20),\
 	y *= 9			)
 
-static inline unsigned int fold_hash(unsigned long x, unsigned long y)
+static inline unsigned long fold_long_hash(unsigned long x, unsigned long y)
 {
 	/* Use arch-optimized multiply if one exists */
 	return __hash_32(y ^ __hash_32(x));
@@ -1880,6 +1878,11 @@ static inline unsigned int fold_hash(unsigned long x, unsigned long y)
 
 #endif
 
+static inline unsigned int fold_hash(unsigned long x, unsigned long y)
+{
+	return fold_long_hash(x, y) >> (BITS_PER_LONG - 32);
+}
+
 /*
  * Return the hash of a string of known length.  This is carfully
  * designed to match hash_name(), which is the more critical function.
@@ -1887,7 +1890,8 @@ static inline unsigned int fold_hash(unsigned long x, unsigned long y)
  * payload bytes, to match the way that hash_name() iterates until it
  * finds the delimiter after the name.
  */
-unsigned int full_name_hash(const void *salt, const char *name, unsigned int len)
+unsigned long full_name_long_hash(const void *salt, const char *name,
+				  unsigned int len)
 {
 	unsigned long a, x = 0, y = (unsigned long)salt;
 
@@ -1903,7 +1907,14 @@ unsigned int full_name_hash(const void *salt, const char *name, unsigned int len
 	}
 	x ^= a & bytemask_from_count(len);
 done:
-	return fold_hash(x, y);
+	return fold_long_hash(x, y);
+}
+EXPORT_SYMBOL(full_name_long_hash);
+
+unsigned int full_name_hash(const void *salt, const char *name,
+			    unsigned int len)
+{
+	return full_name_long_hash(salt, name, len) >> (BITS_PER_LONG - 32);
 }
 EXPORT_SYMBOL(full_name_hash);
 
@@ -1964,12 +1975,20 @@ static inline u64 hash_name(const void *salt, const char *name)
 #else	/* !CONFIG_DCACHE_WORD_ACCESS: Slow, byte-at-a-time version */
 
 /* Return the hash of a string of known length */
-unsigned int full_name_hash(const void *salt, const char *name, unsigned int len)
+unsigned long full_name_long_hash(const void *salt, const char *name,
+				  unsigned int len)
 {
 	unsigned long hash = init_name_hash(salt);
 	while (len--)
 		hash = partial_name_hash((unsigned char)*name++, hash);
-	return end_name_hash(hash);
+	return hash;
+}
+EXPORT_SYMBOL(full_name_long_hash);
+
+unsigned int full_name_hash(const void *salt, const char *name,
+			    unsigned int len)
+{
+	return end_name_hash(full_name_long_hash(salt, name, len));
 }
 EXPORT_SYMBOL(full_name_hash);
 
diff --git a/include/linux/hash.h b/include/linux/hash.h
index ad6fa21d977b..fb2324f20c22 100644
--- a/include/linux/hash.h
+++ b/include/linux/hash.h
@@ -71,6 +71,14 @@ static inline u32 hash_32_generic(u32 val, unsigned int bits)
 	return __hash_32(val) >> (32 - bits);
 }
 
+#ifndef HAVE_ARCH__HASH_64
+#define __hash_64 __hash_64_generic
+#endif
+static inline u64 __hash_64_generic(u64 val)
+{
+	return val * GOLDEN_RATIO_64;
+}
+
 #ifndef HAVE_ARCH_HASH_64
 #define hash_64 hash_64_generic
 #endif
@@ -78,7 +86,7 @@ static __always_inline u32 hash_64_generic(u64 val, unsigned int bits)
 {
 #if BITS_PER_LONG == 64
 	/* 64x64-bit multiply is efficient on all 64-bit processors */
-	return val * GOLDEN_RATIO_64 >> (64 - bits);
+	return __hash_64(val) >> (64 - bits);
 #else
 	/* Hash 64 bits using only 32x32-bit multiply. */
 	return hash_32((u32)val ^ __hash_32(val >> 32), bits);
diff --git a/include/linux/stringhash.h b/include/linux/stringhash.h
index e8f0f852968f..80bdf4bd9c8b 100644
--- a/include/linux/stringhash.h
+++ b/include/linux/stringhash.h
@@ -63,7 +63,11 @@ static inline unsigned long end_name_hash(unsigned long hash)
  *
  * If not set, this falls back to a wrapper around the preceding.
  */
-extern unsigned int __pure full_name_hash(const void *salt, const char *, unsigned int);
+extern unsigned int __pure full_name_hash(const void *salt, const char *name,
+					  unsigned int len);
+extern unsigned long __pure full_name_long_hash(const void *salt,
+						const char *name,
+						unsigned int len);
 
 /*
  * A hash_len is a u64 with the hash of a string in the low
-- 
2.7.4
