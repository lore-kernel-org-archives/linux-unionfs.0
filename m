Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817923;
	b=yvuov1hP/1ZrW2Rb1gKWrYZ0w3YAYVfW7QG5Z0iTjix035xBCKs+42db16kiUXFC3m2z
	 NcEeIZ+qyGhs3dOB+/HXVxSBCBUe/fqiG7Uyno/DI3gDj6efmTm9yLerUsLKPXe7uLDkI
	 mU/Tkn8GDF3b0/H2N98yXRwczXsFpcawgwtt7PZl0RUddQWh/DA8Rgq7shGhOB2n2pbVn
	 bmtqheC/h8PTBnNi0AErjlFMI+887BoMZBQ9iGZ4gzGw6ouAIsn1rtBoL5UeQby42Tg6C
	 oN+0EHTS0J5tmCzmBwZ7YyQb/N8NsSEnu+enl9xMnlJXjjbx+27VK018vOOp8TpH/Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817923;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7yYOLqYN6DkdjgfCk6HvsFoCg1+tvjoIOvaqudKYChY=;
	b=almOm9Rh7oKq+F00pmTA6AEaVpyhH0zznmgUZek3N0iKt1FTGv42ptdCKce+nLq2QQef
	 UgcKn+xuH3q4TfuBxNaxopf36iRcJaEBG88gsxbeCwwHPzk5q9JMI3U15F2/Jf7PuHl0x
	 bL7IHOqUvPEUEovbLI1mZfX+0F8IvbqPdxjMMRdHi3MYEbRXgdv43FzjHQ9bfWA6tv0iL
	 HC2etYdCISgHEGaenK/VvuvGcARciFhbqRHb7YrwcQbF6vjkY3VjiXsZwXksFHtw86/cs
	 z3juY8yR4oVOcF0cIjtzY79/GV7PdMg/AyoZTGUHD7g980KzZJltMg9BtqGGBLf+ROA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VE2aSb3W;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B027F606A32E
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:45:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B027F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VE2aSb3W
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so6862935e9.3
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817921; x=1794422721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7yYOLqYN6DkdjgfCk6HvsFoCg1+tvjoIOvaqudKYChY=;
        b=VE2aSb3Ws1kRKaJMzMPJLgGS906H4ucRvf4ajxmcusUuZsY7eupgwLOdwmxjAq78uL
         WFPRY/65Vdkp2iKhkwg76Ddtu+qlnm0LGVamsO2yrLGlSXO8ruoVY+tYj+eFeJmgMNVR
         sWTcoOXYX3m1CXAtMki928x0Eu9KY6e1ZHgQ7bJ/XQfcImPawkDrIITIji9GLQoLRpY7
         QUKLEUhI+L9ziFJgHrFsZnkzIZq7tqvBJQ62aNojNHHl+G9KXLUEq7L+1tfdSUzmWGTz
         j6zNHoOUA70gZZfp4tDK+62cw0yWiAtkmxHHw7Yhr80AsAO570fh7yOxeguWdOGce2AS
         3YoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817921; x=1794422721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7yYOLqYN6DkdjgfCk6HvsFoCg1+tvjoIOvaqudKYChY=;
        b=CzgZTPBJYf7fscs+dDWqaw8eMzCpX4GbtzHS+XBpj3e2EGzcFs9mIX/h5ltsjllVff
         l7nQrXmMwAFpzgIcknX/kSoQCNTSf8CD9ibaR/6CJT+FugXJDQit66XM2DdRoesYs7ak
         c+Eki7/3QTX7lxvmRUBqjkau5yXMsMqhAARsevbKq6WxXa3XtC8d/iXxB/k4yrqfy2lq
         CCk2H3iUt/M90eX+FPF4CZ+YwwvUhb7n9YPEb5DMeQFUCol8w2ti1102RL4T3NM7IPu1
         KffRDJ0L0cLwgM8/2g3FSvnq8jA+iqUXWBQ4E/vSMIsFxSadjdxglA8Sz4LMT5ZwJrD+
         LDAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzTThe6KUi7Uhkk0N54y/5VtGLYD/QRD3xNuhJ+TZGiTmEp9pnClfOn4tzJE1PHHtkecvAGSoqsfvlj3++v@vger.kernel.org
X-Gm-Message-State: APuU4Z/zaRBs34DV08PGgJB/YuW3eGSDGY2rjcGV2MCDGZuyUa+hauQ8
	ozIx9hhZsYWOv9+6JT+JAhAdfOyCvekV4rZ7PgVEi496evMaezQ4EWaF
X-Gm-Gg: AYBFou04bIdXZ5w+ucbbB54sz3omTbEf4dpAwXzzJ+tTE2Frrw83aoR+T37xfxqsAtG
	caWyTMQvAyojBxMTHfuB5AjpcKogVmYt+Z9pkgqN8VY86ezKXV+tCAdyq/TFijQzZM4ZlC46ezf
	99/i1XPv8LC4/aMjjGx/cMRvBISIzrJ4WLFjFh41uTdnGE11DUVAhbpGOQBg94wUy1VsMs6z8Xx
	zCZCQtF1rkPQvQ1sEFwBCtsfmt2Uj+X1Ic8uKbKpy2JZaBgzehEI2pnX/fS0h5Br3ynNe+8HNSh
	3TibYuJom9oMq5teNxtSOH7RdyOSKaflcskr46xMnclVMi9XGM8A4ooAEBmNk2oH4vljDvxCaeV
	FroJcqu1EjwYYJ7uVhyQUyrMILPXmrCdGI5TYMlaclG6kMNzPA+r+UIyxHevwQAu3tSwrxBLDkE
	w4T6ajJmIo0J+dkovkNJmF/G6GVM71g0pPFhF9rr10gisLb+7tFFJddnpWDpQos2Ll9NJvi+PJN
	TkLkWCq20I9Zme4OKsi+Jn6MHlqqSTxVit7G+S2DiqpMo5DO4PsCfExYImCfNVYVkAEb/ciepbn
	eJcP+C1w97UNxz9kek6wf9G2cpv3ZUf+LV92g7IHhXP96TcG/0/0ZzB2DPN0h5bJWo8F+w/bWfu
	IYsCROXbGhFM=
X-Received: by 2002:a05:600c:46c8:b0:4a2:1a:a120 with SMTP id 5b1f17b1804b1-4ac16acfde1mr398229935e9.6.1793817920931;
        Wed, 04 Nov 2026 10:45:20 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56e2ae762sm3927915e9.2.2026.11.04.10.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:45:20 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 1/3] ovl: check that the parents of volatile/dirty are dirs
Date: Wed,  4 Nov 2026 19:45:14 +0100
Message-ID: <20261104184517.3630089-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261104184517.3630089-1-amir73il@gmail.com>
References: <20261104184517.3630089-1-amir73il@gmail.com>
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
 fs/overlayfs/super.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -636,17 +636,25 @@ static int ovl_check_rename_whiteout(struct ovl_fs *ofs)
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
-		child = ovl_create_real(ofs, parent, child, OVL_CATTR(mode));
+	if (!IS_ERR(child)) {
+		if (!child->d_inode) {
+			child = ovl_create_real(ofs, parent, child,
+						OVL_CATTR(is_dir ? S_IFDIR :
+								   S_IFREG));
+		} else if (is_dir && !d_can_lookup(child)) {
+			dput(child);
+			child = ERR_PTR(-ENOTDIR);
+		}
+	}
 	inode_unlock(parent->d_inode);
 	dput(parent);
 
@@ -667,7 +675,7 @@ static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}
-- 
backport

