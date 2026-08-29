Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CC9435514
	for <linux-unionfs@vger.kernel.org>; Sat, 29 Aug 2026 21:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788039191; cv=none; b=aIX0QvXrzksdl8pWdDPCEaOaPpTGjBa+oUg04vN5OaHl75ID7HHmEvaKART3ZoI7F3OUfrgUvIm6ruJvEuiHJAJdOw/whtS98z7eyen2Awnr8EkhG6PHzUb477kCHwgAU/CG7rCmBWbswvpmmmeRbc500TECcyoRQf3cTxBZdNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788039191; c=relaxed/simple;
	bh=LO1QiG+tuqYXw1xkU6kH+n25tHtzPNegmiTgVWdxIs0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N8MJxKIy7XgaX5KWB53I1ZnwchmSstW/9XRCkQo27WSVZeh7ZWro1r5BpM7kO3h8BltTX3WA5zwMEYt+eWUPgp2b81ceFj5LlRLHKHNxtEYgVuPDLNfWN8H/0DEAV98sl4imfI6Eq9pEzX2zkd3t2GC+oVJf6NDp5RtpstEAaoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l5pzNf96; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l5pzNf96"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47fecbb7000so789350f8f.2
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Aug 2026 14:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788039186; x=1788643986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XPdTmo/psYzNVIunLzBuzuNQ62GIR7HvuoO8VwCkzsQ=;
        b=l5pzNf96MTYV8/moSN0WI9ZuXaKDZa5UHbuy16V1DyGljLFlTwV1CHBrDnvAO8Qoc6
         e+C1W9+hDhu6kCQH3ubu3UbQZt451RX8Ep+8ULGqms3kUVVwTBHdILpGtJiHJGnZ8pwA
         35c/HQWRfteLGTcX9XtWAkMXAJeeDsJf4Y+UrLVhUm0chhLm/uLoeHpesdV8dIhJj8QB
         c9vj+O7T8JjfDTo050/B90yPDpAuhcXoSR1NbwafUI+pCQDpkYTqCc3vbnMuGgeJ4X7T
         Meekeo+ASAzUBPAG4ShXUu7sVEjvZ50qmnrspoQHEWXGwh07mTlzE68n0o0+atq/FLIK
         oAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788039186; x=1788643986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XPdTmo/psYzNVIunLzBuzuNQ62GIR7HvuoO8VwCkzsQ=;
        b=JvBVFHCtLEDucJgQxDU5arqCMq6nOafHznEo1CrYjkvEI17GvO0Q6j1eMr4rChTEfp
         /9tDIu3nRtO1mP+QFp8/Qy+ltgn5i/lPCsrX2fP8CR0lRo9KiFVryoQWPElwNq3uLqng
         p2/VLJ8QaG6ydSV3W6u+ojUpZKYpbBvtiV4U6uBJ7eapGfLEX/wyQyLzdZ3d+YsJ+Gzg
         eVu1OxtPcsP6LlTW3SN16qhrUoIOOugrg7hFH7upEYviiZX7/+WDSkgG38JeOUtG9Ohg
         q1eTQuEvhrHnf7YbXlViP/8hX/BS4cz3FZC9WfyrmDs/mPUJPbjZBZLnJk0VCnnBcr6R
         Aozw==
X-Forwarded-Encrypted: i=1; AKwUvBwo9Wj+ejO331r2wkWWhTzizcr6ei33jUg9vF/GHtr0SOa7OsuOTFiRx34bOlhzdGqElZMqDVW2cuAzD4aP@vger.kernel.org
X-Gm-Message-State: AFuF++nt3/f7EeGmNlgsaKv3WrULbnj8B58OP0RdZfxxX39LI7XkVj+o
	gL1hl9yHKLNwoN4hlJw8OcVj72Cq5aJfcI8eVSwIlQ9Gxw71Q3VIeuiF
X-Gm-Gg: AYBFou3/DtXM/3XmriSjGeodbp4qfscN6bkZmKc+3GP83MKJzuM7+UWHqVhggPJG+M9
	/qdc7+AL5TlvSvcL7IJvJZ/VotD5NdbTmvck4iU94sD0z4CUk6H2/zlFyTc065mKLAKz3kRvaZk
	k+3umNi1CwFcyksdjLC7IWi67fqiLHo1W8X8Ty0YgB3KS6IpYbeAlwEREqU3MkkJjIboIk8wIVO
	mfvai5lgVhcPGOXIVl0X4QYVN/E+eDrWDvMjInmMA0lE9sIobwS0DY+3C5JhP5A9cLHoJ2pMCg1
	hPSlMEUfO8RgeFEFw81zOtbEkwKKX1H3LiTbZxzDgIUboFmMJnqBWQFXBlR0B2j84iK8m71+03u
	V5iGDZL8GrZoHHp2wa+CSYgg2w/FtpIZBeTZUsDL7Sf67iupZtID89Ei9W4aS4f+YpL15ib+CVj
	hHZtN2rETh3k186p4tDc4VOOLomXWCiTYc8bDWRAkYd0rQfP62AEw20dP2B9mSyCup5iOeXR7HI
	8hWsjuG2rGoVqrE2KsQE5zU9pQJEonCHAbWZLZLehKB9nDN+xWL9gBQpb/XMyRjvLpdl5eI0XP5
	pw3GQZmK0QKi7E0HNUNLYjl8kaCIKoqFeiGW+UuYPOZ5nsMGmvsYfYjfMFTTf7GwjpU=
X-Received: by 2002:a05:6000:41e9:b0:484:3621:6340 with SMTP id ffacd0b85a97d-48436216a9bmr3184979f8f.16.1788039186041;
        Sat, 29 Aug 2026 14:33:06 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ae86-1b01-80e2-8851-4221-68d8.310.pool.telefonica.de. [2a02:3100:ae86:1b01:80e2:8851:4221:68d8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbb33070sm12540616f8f.36.2026.08.29.14.33.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 14:33:05 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: selinux@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] selinux: preserve user SID across nested backing files
Date: Sat, 29 Aug 2026 23:32:55 +0200
Message-Id: <20260829213256.51527-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260829213256.51527-1-kmehltretter@gmail.com>
References: <20260829213256.51527-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SELinux saves the user file SID in a backing-file security blob so it
remains available after mmap() replaces vma->vm_file with a backing file.

For nested backing files (overlayfs over overlayfs, or FUSE passthrough
backed by overlayfs), user_file may itself be a backing file.  Its
fsec->sid is the SID of the mounter that opened it, rather than the user
that opened the top-level file.  mprotect() then checks fd { use } against
the mounter SID.  This can incorrectly deny access without a domain
transition, or check the wrong target SID after one.

Copy the saved user SID when user_file is a backing file.  Keep using the
regular file SID for the first backing layer.

With two nested overlayfs mounts and SELinux enforcing,
mprotect(PROT_READ) returns EACCES with an fd { use } denial against the
mounter SID.  With this change, mprotect() succeeds.

Tested on arm64 QEMU with a small BusyBox initramfs and a purpose-built
SELinux policy.  The original test was also repeated with Fedora Cloud
Base 44 userspace and gave the same result.

Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() access checks")
Cc: <stable@vger.kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 security/selinux/hooks.c          | 9 ++++++++-
 security/selinux/include/objsec.h | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 035aaf113d1da..232b7e7bfcafd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3843,13 +3843,20 @@ static int selinux_file_alloc_security(struct file *file)
 	return 0;
 }
 
+static inline u32 selinux_file_user_sid(const struct file *file)
+{
+	if (unlikely(file->f_mode & FMODE_BACKING))
+		return selinux_backing_file(file)->uf_sid;
+	return selinux_file(file)->sid;
+}
+
 static int selinux_backing_file_alloc(struct file *backing_file,
 				      const struct file *user_file)
 {
 	struct backing_file_security_struct *bfsec;
 
 	bfsec = selinux_backing_file(backing_file);
-	bfsec->uf_sid = selinux_file(user_file)->sid;
+	bfsec->uf_sid = selinux_file_user_sid(user_file);
 
 	return 0;
 }
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 3c0a16ec978b0..853f7266ed189 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -87,7 +87,7 @@ struct file_security_struct {
 };
 
 struct backing_file_security_struct {
-	u32 uf_sid; /* associated user file fsec->sid */
+	u32 uf_sid; /* top-level user file fsec->sid */
 };
 
 struct superblock_security_struct {
-- 
2.53.0

