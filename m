Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938299;
	b=5qAxHS5VQLG7ik6Q0y4VErYQTDX6rYk2088kNqdcAZuX/IyrCl5hkpLcUQzuVFFhNSR3
	 ELBIeEwtQxWgCNXY9cReAdDU3lKSQT5qOSoiGUqK/Y9juHa6IIWd3e7KRLuO74RhC6vxb
	 q5isqvSj7IEGwg+9m8rSFKyduuEttV0o5yMK07mrRBdjlV3HrGHlXRiNUbhJtSA9Zt0Bg
	 oUSS3z2Hg27SlWvOKIAgZCOMf+olhsJN1Op08pF/S387DDFVx1IJRL8KZiV+9osqu24xu
	 RJHTHf+GoPwGPy6r9ITvV4Sh/syJvo6KHtaw87DvN3skZRNwpg6lDR4aJmk63TKB3ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938299;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yw3Hukdm9hjkYi3v+QZBT936SHqKGZI3cszKFBhuw/o=;
	b=0faxcnWLHzXP96tJ9JzB/nbKP2cwFaljx+WMGGuoVUrEReiJKAhizXwR1mpV2PWBgFiF
	 oBe9Zcgmr73jG5wgmHH9pLSNVxzY7BbanA61wemxKwOAe8FnFMTGE+85kF+VKOfUgk9dj
	 O5gaxhJJOjH/8iVnXWMqhbyKpQmqoLIsgSyG/ve9/tucSQ5jAo+VihzuMNxngygde9nVQ
	 tzQSsutzK+oN44SPRTKWr8Mx/ydztPZj1VxgSmRHPVszaqy6ft3L/4bfMTltajGttZNeY
	 9oGapYboQGDGN4J77ci0lJ/QUD03X9Lddjwp/Kuw13iTldjUnYc3hS7qAalQSpOma9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ljxHZEbB;
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF66606A32F
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 04:11:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFF66606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ljxHZEbB
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b65d69f5c2so204883a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 20:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793938297; x=1794543097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yw3Hukdm9hjkYi3v+QZBT936SHqKGZI3cszKFBhuw/o=;
        b=ljxHZEbB5osOm2+Iafsv165D7BwMXlp7taAlA72CLAeACG8r/UlqUc5pbBT0uvXgFb
         ddMPAaL4QJLo1YXxVhSh7vq3GYZCmSXZD7aGiDPKqHMW1tO1RU4TDzeTxXBU0qm9ZKQM
         shfDVWjXD57qYluwqL4TkMgj5dSnVuodPJX0yesOkv6TszwKKJAavJJ1gcJnWKXXD86B
         aiCoSahWSjxroOSDvoDc3i0lYfJMwNq3AqOJoiRv80Cdxh257GGGVWwimgYMwz0qf9Gt
         YwvfPqbbhr+cKiKPDeve0mqULxKA/lJUNdYSpI7g4bTTearpdkLhDrdAqNr1QulDgGfc
         ERGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793938297; x=1794543097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yw3Hukdm9hjkYi3v+QZBT936SHqKGZI3cszKFBhuw/o=;
        b=Sl/Na/fxvj/Y+u87Adm83FyDBgEz72ldbO7qBFdlPDL4kMGvz8pCvucxebTGwkVLcN
         vHjjCiNd4w55d8J3tkNIUeTji2QA03wxhmt5pMQjCM/Lkc2/oNHTKzwbAfhIy1Bk8oCc
         yMkKeOYmDwQzAKkY9ljU89JgZblzGxJGpX8U84F0VW1Korr4V0CV6KcSbVecHV9cPu0Q
         lmGh4mQERMWBxJ5uuiHIH8tII+zj+Br46OkKwWAZ4pgqMBi89syAJ+SVB3n5NcMTP58A
         EFf3adns+R0X8cjhB2AiTU7QbxHpBMBJDK1elwUPSgRZkSCrAPGMWITTpCUwXIZ46H6O
         6G1Q==
X-Forwarded-Encrypted: i=1; AKwUvBwUJ6Gxu+1GzrvKJ5F+LaiQW4ZdXXdNnfv7LyEYMl4BCmRBcVMXB0x1TY0yUaJ5Nv6J+tZVbGfBLO1LhsAS@vger.kernel.org
X-Gm-Message-State: APuU4Z/jftPemrmt7Uw5GZ/WZNHOCjSGEpT2soZlGMqVtmKHaxdatMx2
	g986vSRUKsJ+6yTmWf3aRRVj0geewEPeH1E08R2ZSVFkoT9w9MCyAOxN
X-Gm-Gg: AYBFou0gW0j5OQjUXme1MZf7y8K/xUwr+zv47xnKZdxs//Frw7Lb/MnCLM4c02PFg7m
	IYY07yzHYKUm4P1BkTeiaKw4+hwFVc6lTZcO3lIOzLzAl0KmofIBMQIMLNxUfobqYpZrrsROzJg
	qblouAh51YyrNOn8kz0mfd6dWogeaPH1OUZoq7N6VQmk3GkC/jxbWJgiP3DohBeMSjSZsg4cUFF
	pU8j46EWWMHmD1487igb6kA39ZGRnaC74LBygXxilDZQGLJdJ4qRHkGAh7KVBnox43yx43EDjZM
	YyXhU+Jf74+/12+UE4fPZ1d6Xb9d+cuD8Xx11jsk5BqJrbhadJkZBN4kPCRagSSEGm0iTNcatIu
	K6BC1wG7Yjyy3a0cGl3HtKIRAAhZQcxJDLbUtWOhF1HgeaNpcsaf2tgKb70QmUGFIQZ1GLdj23F
	vzEudhsTmhz9513kWf5xLkjH3MlpSxiJWuapDLFEyHhxIditUlTdjIlPUp0h/CdcObeTNLM+Kj9
	tw7f6VUPOQcUVJy6uD9fcisaSm6L6LsXTkX8t41ZAxkBkq10z2k6TVy6pWt9OTcydqC2dfMRV0f
	xiJrLHJV6BGphRCQ1p77gUhbgm2QKIA5bCLUSpBhQZksXbTaa/1bEVnjFh1X/0Kb4JVv3Upkp+1
	4iYXE4sEXOy7K
X-Received: by 2002:a05:6402:210c:b0:6ac:9a44:d3ed with SMTP id 4fb4d7f45d1cf-6b5975249c5mr890967a12.5.1793938297099;
        Thu, 05 Nov 2026 20:11:37 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b65d6b3847sm236655a12.1.2026.11.05.20.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:11:36 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.6 1/3] ovl: check that the parents of volatile/dirty are dirs
Date: Fri,  6 Nov 2026 05:11:26 +0100
Message-ID: <20261106041128.3797453-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261106041128.3797453-1-amir73il@gmail.com>
References: <20261106041128.3797453-1-amir73il@gmail.com>
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

From: Chris Mason <mason@kernel.org>

commit e34d2ef818e4c7676d8d8e1bf43e6a1ed39efb2a upstream.

An unprivileged user crashes the kernel by mounting overlayfs with the
volatile option.

A dentry that serves as the parent of a lookup must be a directory.
ovl_create_volatile_dirty() walks work/incompat/volatile/dirty by name,
and ovl_lookup_or_create() returns an existing entry whatever its type.
A file or a symlink that another task creates during the mount becomes
the parent of the next lookup, which calls a NULL ->lookup.

An unprivileged user mounted overlayfs with "volatile" in a user
namespace while a second process created a symlink named work/incompat,
and the mount task oopsed on a NULL ->lookup call.

Fix this by returning -ENOTDIR from ovl_lookup_or_create() when the
caller asked for a directory and the existing entry is a non-dir.

Fixes: c86243b090bc ("ovl: provide a mount option "volatile"")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no ovl_start_creating_upper(), check the child of
 ovl_lookup_upper() in ovl_lookup_or_create() instead]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -658,18 +658,25 @@
 	return err;
 }
 
 static struct dentry *ovl_lookup_or_create(struct ovl_fs *ofs,
 					   struct dentry *parent,
-					   const char *name, umode_t mode)
+					   const char *name, bool is_dir)
 {
 	size_t len = strlen(name);
 	struct dentry *child;
 
 	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
 	child = ovl_lookup_upper(ofs, name, parent, len);
-	if (!IS_ERR(child) && !child->d_inode)
-		child = ovl_create_real(ofs, parent->d_inode, child,
-					OVL_CATTR(mode));
+	if (!IS_ERR(child)) {
+		if (!child->d_inode) {
+			child = ovl_create_real(ofs, parent->d_inode, child,
+						OVL_CATTR(is_dir ? S_IFDIR :
+								   S_IFREG));
+		} else if (is_dir && !d_can_lookup(child)) {
+			dput(child);
+			child = ERR_PTR(-ENOTDIR);
+		}
+	}
 	inode_unlock(parent->d_inode);
 	dput(parent);
 
@@ -690,7 +697,7 @@
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}
-- 
backport

