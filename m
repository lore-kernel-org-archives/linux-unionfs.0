Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938295;
	b=oYB3aup8NPpXllBXSuzNW3HsyOk2E1RChMqd0pQUYMrrbJlcrZLi+XM7M+EvlAs3eEmy
	 4E+OLv2kcoU6C4whi8skTAGrNxQ0FX/+sOe84iiN2nUDBizmI/qpgZ1KF6CYQK4l9RlDP
	 UP4KI+DyqmBFperzaHyKp+bwLGb1JSIIXKZ0AKd4udPOL0G3s1EXXDJIi5wLYeHvHY8nm
	 quRe9zYbPfwitl+rbp6PhLvBxFsiFfWzcY+EKu0lMib7ZIhFijJwSZf+0tFzDNxvn76gG
	 zwUFdE9Sfh19msGXck6nCySGT6xWF4rlTjsnj8AlDHQn7hdOpaMm9kMZk6PU5t4qBbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938295;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hSfKSUTEhkehT1w6qMT0dqkDpoRv4wdMYRmkyLePlrQ=;
	b=wiWhWBb9+spMrBawiHRDMidKMV6BsFqyRDqpMZEEtXzXAut7xhHOQ3TpMBMf77F4IGv1
	 Rvrelq40RAC9IDCzCr/X+bV4qLrsTAmrJp5Wi8lgiFExFtSX7WXWlQEe/cwMbKHnTSMP6
	 LF6CuiYYzrl03QOYqlA9DR0lYqfUGrS4XcSQN3IS3rGBcIVCfNQgq9WiIQ8B7USW2gyJk
	 nyt81GTd73aOgPRqpK2oSZiDiETKdn4Y5QhEh9VMPk0VF4Or+UflEb4XZ3J7D5UZwIcf+
	 rbOLn52kZ3G3E1yHCc7lpTBL4nc9uTjPx0JVMqQ2FAX7N/FLFq1Qhchh5a00EBS02ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y8MMJ9A+;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0018F606A335
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 04:11:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0018F606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y8MMJ9A+
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b56221d361so220120a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 20:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793938293; x=1794543093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hSfKSUTEhkehT1w6qMT0dqkDpoRv4wdMYRmkyLePlrQ=;
        b=Y8MMJ9A+mSZAq21XHxB/XgLVQCPFbdDn8x16YpklAzHAYcqbEju+AN9eamYtrL3d+Z
         9/1yYRBC3oz+qOk/VPVjZa0q62Zd2rk75ARXiDOsYmpTGyCDWuNM6RvC4ta7z17IuX7g
         4AgwVysEzgMJ9z+htEv30bB8H0XwAspMN298VTol8Vjh4O4Wf5393bSyu31lQhpEk8qx
         8LlnEUnbWvi/Tyz4A98A1vpRrEk9c/gotWVwoemfEYZaxspikg6oy4jHRgRIwxKf6WTT
         gdJCXQZaKnIqLDaapHa9m0OMAC+huzakn8Mj5ePpzFhYJ2XC/bBPktlAtbF7rJR4mRhL
         HJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793938293; x=1794543093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hSfKSUTEhkehT1w6qMT0dqkDpoRv4wdMYRmkyLePlrQ=;
        b=wIj5OIuZZJJxNmaqGtfgMTQeryk+CQK5gztvJ295fbxhs4S8/KBYzEb51LTcpkOOjX
         pGvJYbGJ3L+qn1j7l0sbT6U1fWmp47EINcrUVrdcFnlYD9ygCbBOSALsiuznwJ3i3GgZ
         f0KyEB8cq23G9Ssa3RGedpZLJyz8sJ4pSNPE48xTVE4YgnJj/fCCxz33WEVX7tFXO9yf
         AV/ZzS4PhbbkE/tHmwsc1ykUtmhaTHeu3vIelEHizgeT5aeaB8sHeBe91fM4/vi3QviP
         2oyx6jL0FQ4ZHpLoSzKE3VGVJvWnNucEOV7/C2O6xSS1rojxNRR/aP9/kb2oFXAwLMaY
         Q12g==
X-Forwarded-Encrypted: i=1; AKwUvBziMyAKGN3jWH4nrKBbeHJ9TiwyLb3vvx4QzYdUxZLQ/2Z05YJXU8WQNooInfSrk5Rv9AWD1RAKVCpJZPtZ@vger.kernel.org
X-Gm-Message-State: APuU4Z+yFYNc+7YmVou2to+MZI5PcF/s4ISF0V1pA+bghyQ7T/qMcQUD
	VToQ7P/nY8ctj9owbQoY9kSd91DHCy8oKb1p5BmINvXIx2+PBjn+WoUt
X-Gm-Gg: AYBFou0ueOaSeUE8XyJIdveJrZzuHaXtLGmP5PxlNP1BCE3/m4lBPJZmIIBfu5uc2+y
	bXNF1DXIyDZUimbSgwvDklHq9eTWVC9bCub9Lz/1xP7pl2o+kbPI0gThJWGWY0fo0Mm97dFfSSN
	OBLUFCLr3Ac0NUPSIZBsohrD/BwZMkArh7yUdJzS5ITEO0MhzI62RnVagZWon80Z0jG/ty8E7eM
	Md35emsc9MepEmm/kSQnZ2V0i9BCfvKwqU2z9Fyjxk7C/xh72q2WXciGtfasg3PL/K9Y1C4GI2D
	T6HxequHKSOmm7O4ME46F9ZoN0T5NDqzk1k9T0Lg7eE8590nObIYRSmMkdJhohnLTA1BMI7jbBh
	q/FQJzab7CZyk22NbmI2I870gifOByNbgj8u6Lf8/OK+HjOAHinWPTbbSXQaq2NmR2fa2If4RQ6
	9z7goHyCCI2/SLcMrzMs0OV5f3RLzMEP6NhmAnKfaZEMqPv0S9E0mkcavWcQHGg3+0A4gpgddvt
	FEqwD3e6/rIAOvt7AjQcZpM/5ON9bA+m8pwPZXzlKXYt5jTM6OPMqewVGbbAJZTQhmWIFW7Tkpf
	QhVtEGtfAHnVBw6fal7cqi8rrFqVLKjbqMU4ytmTcju8JN2FfZqqYddCYgyIFWIDyEOL3Atq1n8
	c5bAMJ9usrCHH
X-Received: by 2002:a05:6402:2b93:b0:6b2:2331:3ea9 with SMTP id 4fb4d7f45d1cf-6b5977d09ccmr876675a12.17.1793938293380;
        Thu, 05 Nov 2026 20:11:33 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b669c4c08csm223808a12.37.2026.11.05.20.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:11:32 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 1/3] ovl: check that the parents of volatile/dirty are dirs
Date: Fri,  6 Nov 2026 05:11:23 +0100
Message-ID: <20261106041128.3797453-4-amir73il@gmail.com>
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
@@ -592,18 +592,25 @@
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
 
@@ -624,7 +631,7 @@
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}
-- 
backport

