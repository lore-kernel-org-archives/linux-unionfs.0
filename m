From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 04/18] fsck.overlay: add path package and split helper
Date: Thu, 14 Dec 2017 14:47:33 +0800
Message-ID: <20171214064747.20999-5-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11982 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdLNGmB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:01 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Add path helpers to handle redundant or missing '/' when package and
split path.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 lib.c | 36 ++++++++++++++++++++++++++++++++++++
 lib.h |  3 +++
 2 files changed, 39 insertions(+)

diff --git a/lib.c b/lib.c
index 7607517..ecc5d27 100644
--- a/lib.c
+++ b/lib.c
@@ -126,6 +126,42 @@ int remove_xattr(const char *pathname, const char *xattrname)
 	return ret;
 }
 
+char *path_pack(char *out, int len, const char *base, const char *append)
+{
+	int baselen = strlen(base);
+
+	if (base[baselen-1] == '/' && append[0] == '/')
+		snprintf(out, len, "%s%s", base, append+1);
+	else if (base[baselen-1] != '/' && append[0] != '/')
+		snprintf(out, len, "%s/%s", base, append);
+	else
+		snprintf(out, len, "%s%s", base, append);
+
+	return out;
+}
+
+char *path_truncate(char *out, int len, const char *path, const char *filename)
+{
+	int filelen = strlen(filename);
+	int pathlen = strlen(path);
+	int cplen;
+
+	cplen = (filename[0] == '/') ? pathlen-filelen : pathlen-filelen-1;
+	cplen = cplen < len ? cplen : len-1;
+
+	memcpy(out, path, cplen);
+	out[cplen] = '\0';
+
+	return out;
+}
+
+const char *path_pick(const char *path, int baselen)
+{
+	const char *p = path + baselen;
+
+	return (*p == '/') ? p+1 : p;
+}
+
 static inline int __check_entry(struct scan_ctx *sctx,
 				  int (*do_check)(struct scan_ctx *))
 {
diff --git a/lib.h b/lib.h
index 2956235..618791c 100644
--- a/lib.h
+++ b/lib.h
@@ -73,5 +73,8 @@ ssize_t get_xattr(const char *pathname, const char *xattrname,
 int set_xattr(const char *pathname, const char *xattrname,
 	      void *value, size_t size);
 int remove_xattr(const char *pathname, const char *xattrname);
+char *path_pack(char *out, int len, const char *base, const char *append);
+char *path_truncate(char *out, int len, const char *path, const char *filename);
+const char *path_pick(const char *path, int baselen);
 
 #endif /* OVL_LIB_H */
-- 
2.9.5
