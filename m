Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795453091;
	b=t7wkhrJx8P386nO6J9g+vRxd303eVEbXvPSEUlEzvOs3XA3FzJyKeSNZ/ftlya8uCMkr
	 3wBRjkIpIgwjDfiOY/lsgxxHijKhHLrg4L5XE4dhx4DTLUpJi6gWUWzAA+sHJAlp0iK1E
	 zI99bP80iWtRR7v3v/CI1bB+9iM+tIah6OD5YxJ7NlCqTjo36zdAUu1sOJUKs5GzTvcuC
	 MC02R4+uYIejmO5/OuNDOOJQPqxXAalHWnSxHDvy01hw/FhQ/y1f97bE15D15ojuOwzmc
	 KHOgNwBtan8lNU5UzLvMFQLvqat0A5GYdxWg68VH0f52dXkFmLQgA8FjYlgrKQgOCug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795453091;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ET5i7Z4z+p1A+lXOmLQS8UTZbl0dmHPPBOT7XFIXf1c=;
	b=HoCSiXKRRtdY8JSVYxrFdLsmdLhvT6DZdS1zaQuVX86FvgBmfBlnGHrwV4hsYa4SvA7R
	 PRoqFyaa84pNf5wKtp+klkuhYYDcM0ETw4Y5s4hRRivl1SPSxcZjM+/IdG1o3Zf7RHgr1
	 obtZPFeMb2cFkuaiUkoBhvgb+xxJZa0ozLb51MpC5j8ig3+LkgHBRoEVP4pW3CWI/XSuH
	 U204Xepag49C/BKNmJe2sQDSRgY8O0apPMhYvLvNFQ4THbcRkniIkirHMwSZAG1BIEfCr
	 POTfNHHcfwok4szCw97n336oOM0mbucNkssL+gNKy/RqpjsE6tqIYqYB+8HyhUnw4Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ghM5RF2F;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A98606A31E
	for <linux-unionfs@vger.kernel.org>; Mon, 23 Nov 2026 16:58:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8A98606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ghM5RF2F
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb5b8ef642so29849715e9.1
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Nov 2026 08:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795453089; x=1796057889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ET5i7Z4z+p1A+lXOmLQS8UTZbl0dmHPPBOT7XFIXf1c=;
        b=ghM5RF2FQl80hQKyHvN2jllTrtM1CJh/o7VdiRneRI+3bez8N5CpLxGZnZQnz7WkIj
         tbMOThvQa6A+CELTNOQ4z+JHx1EiPb1nkXzpSXtg2HFCbKqUJpEdk+O3JTaAylWitP09
         UuBWje5M6fjoi/DpfxMR6zbQl2hPRB4bJ4EoZi2PZg2GKAX2+uFbPUJdArtt0ehuUenD
         P2ab0kEvFhUQdLsAwU0DNhp6n9Sk9TaFCTEqo2UEgERZ7JCNNQ1BpIu/Kx++sAISi1+j
         ej+Ph8fSV2xIk1Qt3ICeViLbIWNt3GfWdvvOW2CN/ejzoPTh0KzAifKoE+c4MSrU6CqH
         QRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795453089; x=1796057889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ET5i7Z4z+p1A+lXOmLQS8UTZbl0dmHPPBOT7XFIXf1c=;
        b=u2OgZ30yH1Bht/YFOwnYcPTDydSztkTPuVOWIVLe76zJbi2ogELz6n8/TZTw2qk6wz
         p0EC8hk79vvr2e03Iv9BxAmVx9Ad6Sy91UO2FatEHNXmQVB6GgFoX4A5Qvjs2T2uI+Hi
         rl/8WebiRFw+CMOHmjo9H+uGTefWot7V1NIoOfBUWngABTx7qAHdS+go+Lvh3v/6Cvsb
         wM22gj1JYtEmY5nBdfGd9lvy+Fq6AsVYc+vc6oI8vj3UT2hKYN6B2Q2nnRtIQSwiCfqN
         rK9lT0EvufKQdwCZOMOABUpwdUtG6XIugR72fm2BVt8ESSayL/RjIgXiGsc5nMlxyopA
         JFmg==
X-Forwarded-Encrypted: i=1; AL+hErFjZHJhEF0171BsNg8hzR4HVZ5zQ+r1cEJzr7R0eidUtTUjXFLd0l/HVSq8xWCmwcvv3na2WcE9tsq+F8AL@vger.kernel.org
X-Gm-Message-State: APuU4Z98CxQoCECdJ8V0TeLYDUAbiElioCLClBGrFl3C3nufwPXa9ULl
	01Y/EazrokSRXPHa+HAJJlyagRWpIqPtvilUDqgC810gQRqSGZEtrhYQ
X-Gm-Gg: AZFdTZcyD5Jd4rQrCh8czt9AcBRriuzBR4OlGFVrJ9iz4XqD5zFFkLC/I9AWL6/Sh9q
	K+Dz32qZzzcVQp4hYB41/QzNFlcE1+WnA0+h0w1nmjr9Ny2dEkI5Jj8muw4o6ekO1rs+RQpbWXp
	Eo/LReezNHlSCw67bk0D+rbdgJ6drVT+kViDUZdOXZSL9B4KvcLAVbD1F5PHdUvyOQuMnH/T0IV
	as4Vpwc79WvUzwl+G3RT5YLxKheWIutT4s48odsNYwGyBcIFbnUHkpgyweoNu5T3IyuJ1xtoFO/
	kvg4os95Cqm8g9J3cyI8ne8KlUx1oZOPqtWIAXqPPs0UaRn+UvME13myRsMzSsNyF47GMR/8ACK
	4r8C0VPn+1mcVYx/GHUJXGxfd9gMfvuJo/hK+K35jtkeat0NrjO+BwmJkEHUwBMJhME4AnwPthG
	KICnnH/JQ1FDePQfVmOD6mKFQgC0RChK3a7Sy6Gy2SV+uWpqzK1bnfzlWbEbDhUsvtYOJCwy2Iu
	UO5mXuDqjaUWaL/YhZ+A2I0KOoKhQ1wwgffu5y5yCP4bu4XIYWkxI3pETHn61+0cXyj3NzV/fRM
	4hPNRh4EIO/0pYoF3GW2kF78CFH9KTQzINIJr+LJ+00XHyWzvg42UoGpbUuKNRjlfST+W24nrNf
	IgLYjjkFHW8pZtm1SVFF6r0LdcgSJMwWL
X-Received: by 2002:a05:600c:1d8c:b0:4bb:5345:606b with SMTP id 5b1f17b1804b1-4bb8882358dmr243856655e9.31.1795453088912;
        Mon, 23 Nov 2026 08:58:08 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906817ccsm179329005e9.5.2026.11.23.08.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 08:58:08 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <mason@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] xattr: enforce the name and size limits for in-kernel callers
Date: Mon, 23 Nov 2026 17:58:07 +0100
Message-ID: <20261123165807.1939942-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261123113513.1910906-1-amir73il@gmail.com>
References: <20261123113513.1910906-1-amir73il@gmail.com>
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

The xattr system calls refuse a name longer than XATTR_NAME_MAX and a
value larger than XATTR_SIZE_MAX, but the VFS helpers do not. An
in-kernel caller may pass a name or a size that it got from another
filesystem, such as overlayfs copy up from a lower layer.

Check both limits before calling the xattr handler of the filesystem,
and fail with the errors that the system calls return for them.

Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Changes since v1:
- Check the name in vfs_getxattr_alloc() too (Alex)

v1: https://lore.kernel.org/r/20261123113513.1910906-1-amir73il@gmail.com/

 fs/xattr.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 0705801a62cc5..fb5e43d4ff356 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -178,6 +178,18 @@ xattr_permission(const struct mnt_idmap *idmap, struct inode *inode,
 	return inode_permission(idmap, inode, mask);
 }
 
+/*
+ * The xattr system calls refuse a name above XATTR_NAME_MAX and a value above
+ * XATTR_SIZE_MAX, but an in-kernel caller may pass a name or a size that it
+ * got from another filesystem, such as the lower layer of overlayfs.
+ */
+static int xattr_check_name(const char *name)
+{
+	if (strnlen(name, XATTR_NAME_MAX + 1) > XATTR_NAME_MAX)
+		return -ERANGE;
+	return 0;
+}
+
 /*
  * Look for any handler that deals with the specified namespace.
  */
@@ -209,10 +221,17 @@ __vfs_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	       size_t size, int flags)
 {
 	const struct xattr_handler *handler;
+	int error;
 
 	if (is_posix_acl_xattr(name))
 		return -EOPNOTSUPP;
 
+	error = xattr_check_name(name);
+	if (error)
+		return error;
+	if (size > XATTR_SIZE_MAX)
+		return -E2BIG;
+
 	handler = xattr_resolve_name(inode, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
@@ -408,6 +427,10 @@ vfs_getxattr_alloc(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (error)
 		return error;
 
+	error = xattr_check_name(name);
+	if (error)
+		return error;
+
 	handler = xattr_resolve_name(inode, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
@@ -416,6 +439,8 @@ vfs_getxattr_alloc(const struct mnt_idmap *idmap, struct dentry *dentry,
 	error = handler->get(handler, dentry, inode, name, NULL, 0);
 	if (error < 0)
 		return error;
+	if (error > XATTR_SIZE_MAX)
+		return -E2BIG;
 
 	if (!value || (error > xattr_size)) {
 		value = krealloc(*xattr_value, error + 1, flags);
@@ -434,16 +459,24 @@ __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
 	       void *value, size_t size)
 {
 	const struct xattr_handler *handler;
+	ssize_t ret;
 
 	if (is_posix_acl_xattr(name))
 		return -EOPNOTSUPP;
 
+	ret = xattr_check_name(name);
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

