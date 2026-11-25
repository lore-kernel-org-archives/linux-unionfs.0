Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586343;
	b=EI3TQl1n3yOVXWqu+6qa7cWJamZNeKHG5KuqsjoinYxjtQua5ltKIOBYV/alutb1RJZg
	 41bOe9DXrfvlJe8Tzuz44DsFG6UU0bkzY+jDYmc67AizGZDyX3sOlNXq1gGFLTDTEpZEl
	 i/sVc8cunEoFkIrsFHFpx0ziginCiNHiPLAJTsgsSAvqIlbAJPNb8gkVL0mKD/YOYTJ24
	 JEg9OjE9VKXwMaQ7+tNB5AGo2y9RpkMBJfBpHfozc7p9AcURM4AwHilHaKz8LWJ6X6a10
	 Can++JGmXALJ4R+zmwZNLqCkgKR+NumnEZtUL83M/k//bfw/U4uJaABriZcgl1IR5aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586343;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kLO4bvaNtN2k734CUnroIhM2LaGQVLf7dwNtjbQDkFI=;
	b=G/sWbKMbvtIo7MkrFh7jfAXIELMnsue28czFwGNkMKpGoDtOJQhjaVvFL0REjixqDOEe
	 ZOWkFjQDGBjks6xLN+dXMclkxrj61S8PyvMlaa9udw5dDYzSA4bJL/0Tal4At+8eS1/JX
	 FtnbnA8R31LKxjw2fzckYRyO8VPLT0/h/XNS57V3lHiLQalV7iMjuXXfV1UdYVtDrSZ4Z
	 4rYEAen+cCddaWxzVcry6aQ/25BMx6YkIw9g6saCJ4SvDrE6vmjzqsfzzSfQc2pkNf6UT
	 Xs9dkGyUGKTxslnB1nUIai3uVvyQ5EIfiQJklY0kZlF96dAMYVSugUMkgu2wTC5AQkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="KNFf/AWj";
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E17606A321
	for <linux-unionfs@vger.kernel.org>; Wed, 25 Nov 2026 05:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79E17606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KNFf/AWj
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c515319dd89so11534366b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Nov 2026 21:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795586342; x=1796191142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kLO4bvaNtN2k734CUnroIhM2LaGQVLf7dwNtjbQDkFI=;
        b=KNFf/AWjp7WY6ZuWUqCXKj371sD9eX7Tq701WLajCU+17vXhs0tsQTj9QpMEh9CBZd
         LeMT5ydltu7YVOz4lRQch9ajDJT03i9RWQRyWAPqp/BHigbAO2oPLIac5GHZ78OUpUCW
         RAbzSsrcz7s8AUjqfIwW0BBo38FRzkHV2ceL/TfDrn7AlWFwb93dL100/48lPYwkv3qo
         eSN9Cc63VX851v6BHYHUb5T+OaIDy7+BdlWdHC7O13S7R1qd8KA4J6xDrKoSBQ4XZTao
         rPLi1oTRi1hpyuV8yc7luJZS0f8omHZ5LRs3cG3In0K7bxBHU3EaB20PlFy8j1M1g3YK
         LH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795586342; x=1796191142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kLO4bvaNtN2k734CUnroIhM2LaGQVLf7dwNtjbQDkFI=;
        b=uFyZBWHmuT4j16eVfCjv0IL4sRZVGNlkez5gNf6/jVasWXNCr2vdKqGn5Bd/pFs3bP
         h6rm4udzuvoKs8eCbZeU2wJI7ahw4d/A4CpCvy+4zRKFf/hI8j9MmpYWqo1WxKDrIbdE
         +T0bnNP/hfLV1mhXiCoquA9VfEZ0hoZoO55qUdSkV+0MmUtLgySIPf4w/uWpElTli/9m
         2SX3K+fSNRwgz/3wuFLXNj3bqIIjjzFQBm3a+/EpXWE1W/2FuRJA0J9tP2Vj97pJ0NUd
         fzJi5IYO6iz0akJJUaQyv0m7Typa3FH0HNIoGBBPhlTgmUF+2P/qooudduUsY35YfLtj
         otMA==
X-Forwarded-Encrypted: i=1; AL+hErFtnBQNO5c3ghDRTULeHl7ZXmz2IeSAHQlPXbGYcAo/I34ab98HgnWNKvTyDF2QxpAf4XBlsRwh2pYK5guj@vger.kernel.org
X-Gm-Message-State: APuU4Z/USzeHWi+HDcBLsR2C/wmN97bdfK7ElhzdZvLMKnIibyKlPm17
	j/2pEIeF2G6N1aMwi1rH6HjJZdqwgG5BofB8XWuV/vsipQ4Mub8zFJlB
X-Gm-Gg: AZFdTZfyDl6+7WTMR+dyZGiiGVf7SdmJZW/C/rwN6TC0aNkAyKg0PACj/JfLc2zXHEV
	c3ffXk4r3OHZb+uyLayIfsBmBMixgrK+JfTIKa89nboLvpLTOuERKcKXlKH2W3ojIOVt3t2V+A4
	aah/Zbm+k81MJznzebW4jHY8i9GxaCw4fu2Fmu1SHZnZ4Yyc45G5avr76Zx+Z55nVa1HYU2Lor1
	YfSa7nCPcS55FB5gf+A+TRADGPzBQ6SgY56OZDpCJ8p185+ItnHIrHXjjekeQFAPC51EindaT5x
	J6m+1DkT61UAOdkOuqeaBSvSsVnb6w7sJQjxetA7mozrHMWR6JRUf5Kz6tB8x4p0cmxpX+6c6Yl
	WkuWuKv6uZyxT+gz7IEBLZ3bpg8WqbPmsJEv+7m3UNDox2WPfNhf+eS1hhhkYBAJ+EuKCUG8hTu
	IVaGXslCmTo/UPOoSeTkgVb2Nc7BLFvpIc8VaXxAN0Lwhdwe3Pe2AEguDNdHgx4F6EYpPCYugkN
	COf0P6bDiWRhUV7X6UUK3/QoCfBfeV9OJm7TPpeO+Kq+D0j3yaWVSDw4KFIfkZGn2/hcSEmaHkx
	QTBphT/j1DWmqXOqTYUsxE8JHRpwahw34D/eVuxct/WRpvlpbGxLIuVBkRd0U89nNdEanxrb7u9
	Hg6igXIwkFaDi
X-Received: by 2002:a17:906:1c11:b0:c50:8d2b:4392 with SMTP id a640c23a62f3a-c513ab38967mr1036690966b.49.1795586341572;
        Tue, 24 Nov 2026 21:59:01 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba36e355easm7533212a12.3.2026.11.24.21.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 21:59:01 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <mason@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Carlos Maiolino <cem@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: [PATCH v3] xattr: enforce the name and size limits for in-kernel callers
Date: Wed, 25 Nov 2026 06:59:00 +0100
Message-ID: <20261125055900.2077059-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261123165807.1939942-1-amir73il@gmail.com>
References: <20261123165807.1939942-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The xattr system calls refuse an empty name, a name longer than
XATTR_NAME_MAX and a value larger than XATTR_SIZE_MAX, but the VFS
helpers do not. An in-kernel caller may pass a name or a size that it
got from another filesystem, such as overlayfs copy up from a lower
layer.

Check these limits before calling the xattr handler of the filesystem,
and fail with the errors that the system calls return for them.

Cc: stable@vger.kernel.org
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Changes since v2:
- Rename the helper to xattr_check_name_len() (Carlos)
- Also refuse an empty name (Carlos)
- Add Reviewed-by tags

Changes since v1:
- Check the name in vfs_getxattr_alloc() too (Alex)

v2: https://lore.kernel.org/r/20261123165807.1939942-1-amir73il@gmail.com/
v1: https://lore.kernel.org/r/20261123113513.1910906-1-amir73il@gmail.com/

 fs/xattr.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 0705801a62cc5..64df10ed498c3 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -178,6 +178,21 @@ xattr_permission(const struct mnt_idmap *idmap, struct inode *inode,
 	return inode_permission(idmap, inode, mask);
 }
 
+/*
+ * The xattr system calls refuse an empty name, a name above XATTR_NAME_MAX
+ * and a value above XATTR_SIZE_MAX, but an in-kernel caller may pass a name or
+ * a size that it got from another filesystem, such as the lower layer of
+ * overlayfs.
+ */
+static int xattr_check_name_len(const char *name)
+{
+	size_t len = strnlen(name, XATTR_NAME_MAX + 1);
+
+	if (!len || len > XATTR_NAME_MAX)
+		return -ERANGE;
+	return 0;
+}
+
 /*
  * Look for any handler that deals with the specified namespace.
  */
@@ -209,10 +224,17 @@ __vfs_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	       size_t size, int flags)
 {
 	const struct xattr_handler *handler;
+	int error;
 
 	if (is_posix_acl_xattr(name))
 		return -EOPNOTSUPP;
 
+	error = xattr_check_name_len(name);
+	if (error)
+		return error;
+	if (size > XATTR_SIZE_MAX)
+		return -E2BIG;
+
 	handler = xattr_resolve_name(inode, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
@@ -408,6 +430,10 @@ vfs_getxattr_alloc(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (error)
 		return error;
 
+	error = xattr_check_name_len(name);
+	if (error)
+		return error;
+
 	handler = xattr_resolve_name(inode, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
@@ -416,6 +442,8 @@ vfs_getxattr_alloc(const struct mnt_idmap *idmap, struct dentry *dentry,
 	error = handler->get(handler, dentry, inode, name, NULL, 0);
 	if (error < 0)
 		return error;
+	if (error > XATTR_SIZE_MAX)
+		return -E2BIG;
 
 	if (!value || (error > xattr_size)) {
 		value = krealloc(*xattr_value, error + 1, flags);
@@ -434,16 +462,24 @@ __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
 	       void *value, size_t size)
 {
 	const struct xattr_handler *handler;
+	ssize_t ret;
 
 	if (is_posix_acl_xattr(name))
 		return -EOPNOTSUPP;
 
+	ret = xattr_check_name_len(name);
+	if (ret)
+		return ret;
+
 	handler = xattr_resolve_name(inode, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
 	if (!handler->get)
 		return -EOPNOTSUPP;
-	return handler->get(handler, dentry, inode, name, value, size);
+	ret = handler->get(handler, dentry, inode, name, value, size);
+	if (ret > XATTR_SIZE_MAX)
+		return -E2BIG;
+	return ret;
 }
 EXPORT_SYMBOL(__vfs_getxattr);
 
-- 
2.56.1

