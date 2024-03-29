Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF1B8562E
	for <linux-unionfs@vger.kernel.org>; Fri, 29 Mar 2024 01:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677305; cv=none; b=ABG2aJgSJSd0IFxSoRT0uQKkcdvCJIqe6tlOuhu3b4U86VBu9E/zQfZTosDxj4lhSlpNu+DxhfqqaaOKZ+tl/+Ke/aq3S5eEgbTDt+P53788yHT7KmeIUS9Mgwj+ey5bk295ArH3c9aZRBt6dBigenBix2k5iCylYxcoLBTRfyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677305; c=relaxed/simple;
	bh=fRKdI3QiwIiUODgq+UYwDm6APftE3YO7UTQiQdpsLQk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lg5F1Dc7gVZnAxoj5Hc6F8Pe7HudeL4xwUn8ztAbYZBtfwVE/ht2yxufOqZySo9Hmt433Q0psfLsL2MmdHJ/vvCC5/AQbiaUAgPLMWDeivoxKRLzuNKCU/9Sd6x6CjO+02gFXgH3QWYEqwT9k/aDGr3GGMkG2TNgU1nPVz1bkSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qPLeyrQ5; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qPLeyrQ5"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso2326117276.0
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2024 18:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711677303; x=1712282103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zEN/hYQfa73u/9gIRdrmlwDPst/lwM0QAOXzH39EmOE=;
        b=qPLeyrQ5TH2DAWgV8I4AWYGcmgKMHTjMKC076tbFiK7GjGM9ftByjuMhqgyn3rmnQG
         DIbIRf08mveERGW5T+C8jOy7SRdJYgi018cEABgOnQldlk55sZ8YoWpr8yjMg6aCZXSo
         gK/Z1qcWud+JvCpPrf0B+6RSXx0792sRyHVfFUZ2q4ZqfVJ4KZaDgc6Fr7d8NNUPfAof
         iByM1i2xzaY2k/sDeZKOPJoKcPF71FHXoFgZT8T1u/7Tds1vfLBRV8v8FH0km54S2t9m
         0nY+Ne/84wuU5tKpqLGygFLazM5UD8kZPj5Jfzj5CVz79OhlDhUYi+C01KEoV433bMEi
         Ni8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711677303; x=1712282103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zEN/hYQfa73u/9gIRdrmlwDPst/lwM0QAOXzH39EmOE=;
        b=AdKvxNbgTKMWcatQAIeL1LPe8vGV7yA19XGvD+sdtLZ4FqrwyNMv3e6kyz7ETHcl1G
         N7jrdrC05YZoUF4WpLQDKXqldGHzRXwDycHsjgDq2KojxjiFhQ0NPrAHku/Vc1sXhRVw
         nhk2GfQrBL7+lbal2LzMSKAqgH0kGZpu5BPQxlUfzn3Xpo4zSN8JlKfHpk39KI58izln
         gPTthdEQLdmS8JWKRkELAKl+Un4xd+BbY8G7kLtUgNiwGPfke9lMUuVvGW9l8zjOPjLI
         w2YetQcgRpaZHl0c3ATpr8d0i/AkTbIfk4x7/P5ZU3Iu2cpCRNQT96gs0zzvorvDk2ds
         2kiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRhPgzUMxP42DkfKEQZ6RHY6hhnTeXfYPOEc57yBDfHAp+OdSu/caKohyV2KyigV77QFilXKIiB1M/Y4+dtJP+iVxxmHHFvcWCAfC1Tw==
X-Gm-Message-State: AOJu0YyqBk+PnFmsc0VfJ2TGWLJdaO2KTUFknwgWxGAve+PBP0ufoj5m
	LdMoyXeMUiIfCRbQpKV5ZlGu5ubTuFMO4HVVwruetUejsR66nvTVjAtWTrjdib0bZ3dK1JHT5cB
	e5w==
X-Google-Smtp-Source: AGHT+IGJkcoNjDwu0yATYCHjKDKZoR5yIciZSAATbPvRVnUKhEVFpM8/s5FsZmz4KVaPxicOk3AftJZTH7I=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:fcce:d6ab:804c:b94b])
 (user=drosen job=sendgmr) by 2002:a05:6902:2481:b0:dd9:2a64:e98a with SMTP id
 ds1-20020a056902248100b00dd92a64e98amr86515ybb.9.1711677302942; Thu, 28 Mar
 2024 18:55:02 -0700 (PDT)
Date: Thu, 28 Mar 2024 18:53:43 -0700
In-Reply-To: <20240329015351.624249-1-drosen@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240329015351.624249-1-drosen@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240329015351.624249-29-drosen@google.com>
Subject: [RFC PATCH v4 28/36] fuse: Provide registration functions for fuse-bpf
From: Daniel Rosenberg <drosen@google.com>
To: Miklos Szeredi <miklos@szeredi.hu>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Yonghong Song <yonghong.song@linux.dev>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Joanne Koong <joannelkoong@gmail.com>, Mykola Lysenko <mykolal@fb.com>, 
	Christian Brauner <brauner@kernel.org>, kernel-team@android.com, 
	Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"

Fuse may be built as a module, but verifier components are not. This
provides a means for fuse-bpf to handle struct op programs once the
module is loaded.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 fs/fuse/Makefile         |   2 +-
 fs/fuse/backing.c        |   2 +
 fs/fuse/bpf_register.c   | 207 +++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h         |  26 +++++
 include/linux/bpf_fuse.h |   8 ++
 5 files changed, 244 insertions(+), 1 deletion(-)
 create mode 100644 fs/fuse/bpf_register.c

diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index a0853c439db2..903253db7285 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -9,6 +9,6 @@ obj-$(CONFIG_VIRTIO_FS) += virtiofs.o
 
 fuse-y := dev.o dir.o file.o inode.o control.o xattr.o acl.o readdir.o ioctl.o
 fuse-$(CONFIG_FUSE_DAX) += dax.o
-fuse-$(CONFIG_FUSE_BPF) += backing.o
+fuse-$(CONFIG_FUSE_BPF) += backing.o bpf_register.o
 
 virtiofs-y := virtio_fs.o
diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 884c690becd5..d5fcaef8e6b5 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -3392,6 +3392,7 @@ int fuse_bpf_access(int *out, struct inode *inode, int mask)
 
 int __init fuse_bpf_init(void)
 {
+	init_fuse_bpf();
 	fuse_bpf_aio_request_cachep = kmem_cache_create("fuse_bpf_aio_req",
 						   sizeof(struct fuse_bpf_aio_req),
 						   0, SLAB_HWCACHE_ALIGN, NULL);
@@ -3403,5 +3404,6 @@ int __init fuse_bpf_init(void)
 
 void __exit fuse_bpf_cleanup(void)
 {
+	uninit_fuse_bpf();
 	kmem_cache_destroy(fuse_bpf_aio_request_cachep);
 }
diff --git a/fs/fuse/bpf_register.c b/fs/fuse/bpf_register.c
new file mode 100644
index 000000000000..32f96004b161
--- /dev/null
+++ b/fs/fuse/bpf_register.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * FUSE-BPF: Filesystem in Userspace with BPF
+ * Copyright (c) 2021 Google LLC
+ */
+
+#include <linux/bpf_verifier.h>
+#include <linux/bpf_fuse.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/hashtable.h>
+
+#include "fuse_i.h"
+
+struct fuse_ops tmp_f_op_empty = { 0 };
+struct fuse_ops *tmp_f_op = &tmp_f_op_empty;
+
+struct hashtable_entry {
+	struct hlist_node hlist;
+	struct hlist_node dlist; /* for deletion cleanup */
+	struct qstr key;
+	struct fuse_ops *ops;
+};
+
+static DEFINE_HASHTABLE(name_to_ops, 8);
+
+static unsigned int full_name_case_hash(const void *salt, const unsigned char *name, unsigned int len)
+{
+	unsigned long hash = init_name_hash(salt);
+
+	while (len--)
+		hash = partial_name_hash(tolower(*name++), hash);
+	return end_name_hash(hash);
+}
+
+static inline void qstr_init(struct qstr *q, const char *name)
+{
+	q->name = name;
+	q->len = strlen(q->name);
+	q->hash = full_name_case_hash(0, q->name, q->len);
+}
+
+static inline int qstr_copy(const struct qstr *src, struct qstr *dest)
+{
+	dest->name = kstrdup(src->name, GFP_KERNEL);
+	dest->hash_len = src->hash_len;
+	return !!dest->name;
+}
+
+static inline int qstr_eq(const struct qstr *s1, const struct qstr *s2)
+{
+	int res, r1, r2, r3;
+
+	r1 = s1->len == s2->len;
+	r2 = s1->hash == s2->hash;
+	r3 = memcmp(s1->name, s2->name, s1->len);
+	res = (s1->len == s2->len && s1->hash == s2->hash && !memcmp(s1->name, s2->name, s1->len));
+	return res;
+}
+
+static struct fuse_ops *__find_fuse_ops(const struct qstr *key)
+{
+	struct hashtable_entry *hash_cur;
+	unsigned int hash = key->hash;
+	struct fuse_ops *ret_ops;
+
+	rcu_read_lock();
+	hash_for_each_possible_rcu(name_to_ops, hash_cur, hlist, hash) {
+		if (qstr_eq(key, &hash_cur->key)) {
+			ret_ops = hash_cur->ops;
+			ret_ops = get_fuse_ops(ret_ops);
+			rcu_read_unlock();
+			return ret_ops;
+		}
+	}
+	rcu_read_unlock();
+	return NULL;
+}
+
+struct fuse_ops *get_fuse_ops(struct fuse_ops *ops)
+{
+	if (bpf_try_module_get(ops, BPF_MODULE_OWNER))
+		return ops;
+	else
+		return NULL;
+}
+
+void put_fuse_ops(struct fuse_ops *ops)
+{
+	if (ops)
+		bpf_module_put(ops, BPF_MODULE_OWNER);
+}
+
+struct fuse_ops *find_fuse_ops(const char *key)
+{
+	struct qstr q;
+
+	qstr_init(&q, key);
+	return __find_fuse_ops(&q);
+}
+
+static struct hashtable_entry *alloc_hashtable_entry(const struct qstr *key,
+		struct fuse_ops *value)
+{
+	struct hashtable_entry *ret = kzalloc(sizeof(*ret), GFP_KERNEL);
+	if (!ret)
+		return NULL;
+	INIT_HLIST_NODE(&ret->dlist);
+	INIT_HLIST_NODE(&ret->hlist);
+
+	if (!qstr_copy(key, &ret->key)) {
+		kfree(ret);
+		return NULL;
+	}
+
+	ret->ops = value;
+	return ret;
+}
+
+static int __register_fuse_op(struct fuse_ops *value)
+{
+	struct hashtable_entry *hash_cur;
+	struct hashtable_entry *new_entry;
+	struct qstr key;
+	unsigned int hash;
+
+	qstr_init(&key, value->name);
+	hash = key.hash;
+	hash_for_each_possible_rcu(name_to_ops, hash_cur, hlist, hash) {
+		if (qstr_eq(&key, &hash_cur->key)) {
+			return -EEXIST;
+		}
+	}
+	new_entry = alloc_hashtable_entry(&key, value);
+	if (!new_entry)
+		return -ENOMEM;
+	hash_add_rcu(name_to_ops, &new_entry->hlist, hash);
+	return 0;
+}
+
+static int register_fuse_op(struct fuse_ops *value)
+{
+	int err;
+
+	if (bpf_try_module_get(value, BPF_MODULE_OWNER))
+		err = __register_fuse_op(value);
+	else
+		return -EBUSY;
+
+	return err;
+}
+
+static void unregister_fuse_op(struct fuse_ops *value)
+{
+	struct hashtable_entry *hash_cur;
+	struct qstr key;
+	unsigned int hash;
+	struct hlist_node *h_t;
+	HLIST_HEAD(free_list);
+
+	qstr_init(&key, value->name);
+	hash = key.hash;
+
+	hash_for_each_possible_rcu(name_to_ops, hash_cur, hlist, hash) {
+		if (qstr_eq(&key, &hash_cur->key)) {
+			hash_del_rcu(&hash_cur->hlist);
+			hlist_add_head(&hash_cur->dlist, &free_list);
+		}
+	}
+	synchronize_rcu();
+	bpf_module_put(value, BPF_MODULE_OWNER);
+	hlist_for_each_entry_safe(hash_cur, h_t, &free_list, dlist)
+		kfree(hash_cur);
+}
+
+static void fuse_op_list_destroy(void)
+{
+	struct hashtable_entry *hash_cur;
+	struct hlist_node *h_t;
+	HLIST_HEAD(free_list);
+	int i;
+
+	hash_for_each_rcu(name_to_ops, i, hash_cur, hlist) {
+		hash_del_rcu(&hash_cur->hlist);
+		hlist_add_head(&hash_cur->dlist, &free_list);
+	}
+	synchronize_rcu();
+	hlist_for_each_entry_safe(hash_cur, h_t, &free_list, dlist)
+		kfree(hash_cur);
+	pr_info("fuse: destroyed fuse_op list\n");
+}
+
+static struct bpf_fuse_ops_attach bpf_fuse_ops_connect = {
+	.fuse_register_bpf = &register_fuse_op,
+	.fuse_unregister_bpf = &unregister_fuse_op,
+};
+
+int init_fuse_bpf(void)
+{
+	return register_fuse_bpf(&bpf_fuse_ops_connect);
+}
+
+void uninit_fuse_bpf(void)
+{
+	unregister_fuse_bpf(&bpf_fuse_ops_connect);
+	fuse_op_list_destroy();
+}
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f1a8f8a97f1f..082cfd14de53 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1423,6 +1423,32 @@ void fuse_file_release(struct inode *inode, struct fuse_file *ff,
 		       unsigned int open_flags, fl_owner_t id, bool isdir);
 
 /* backing.c */
+#ifdef CONFIG_FUSE_BPF
+struct fuse_ops *find_fuse_ops(const char *key);
+struct fuse_ops *get_fuse_ops(struct fuse_ops *ops);
+void put_fuse_ops(struct fuse_ops *ops);
+int init_fuse_bpf(void);
+void uninit_fuse_bpf(void);
+#else
+int init_fuse_bpf(void)
+{
+	return -EOPNOTSUPP;
+}
+void uninit_fuse_bpf(void)
+{
+}
+struct fuse_ops *find_fuse_ops(const char *key)
+{
+	return NULL;
+}
+struct fuse_ops *get_fuse_ops(struct fuse_ops *ops)
+{
+	return NULL;
+}
+void put_fuse_ops(struct fuse_ops *ops)
+{
+}
+#endif
 
 enum fuse_bpf_set {
 	FUSE_BPF_UNCHANGED = 0,
diff --git a/include/linux/bpf_fuse.h b/include/linux/bpf_fuse.h
index 780a7889aea2..2183a7a45c92 100644
--- a/include/linux/bpf_fuse.h
+++ b/include/linux/bpf_fuse.h
@@ -270,4 +270,12 @@ struct fuse_ops {
 	char name[BPF_FUSE_NAME_MAX];
 };
 
+struct bpf_fuse_ops_attach {
+	int (*fuse_register_bpf)(struct fuse_ops *f_ops);
+	void (*fuse_unregister_bpf)(struct fuse_ops *f_ops);
+};
+
+int register_fuse_bpf(struct bpf_fuse_ops_attach *reg_ops);
+void unregister_fuse_bpf(struct bpf_fuse_ops_attach *reg_ops);
+
 #endif /* _BPF_FUSE_H */
-- 
2.44.0.478.gd926399ef9-goog

