Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EE247F774
	for <linux-unionfs@vger.kernel.org>; Thu, 20 Aug 2026 17:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248724; cv=none; b=l3BLCu/EgPKQZH4Lmx7fodkTqZnb6MI9dNKDibJYASZrMk4BLiSDyiKpaBNzyJ2H2Q+DUm3gJQ4kjll0FS2CkxtNpP0e1nfNnQ9UnAVCkSHknmEjvRbemvsehiWGUsmCm17w1HJ1pg2SbJeOFj7JYmm5OfbESi1x1qkgYxk9HRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248724; c=relaxed/simple;
	bh=rRQ+k45Rzu1T02qBpX5CzRl8hfRPtWG1qRV4GQ3dh8A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=srnoHRUFGz/0Q4tYWJbtlvXEB7MOoZSQtw/YXD+Uszdnt6nFHXnJorkJC+6vjLFHsib7ZokLOTvUvES8D15oPY9cRvSowwao0HF739XGl33ZoCW27gmk5us5/B8rTUg6zafUQfx54Q8jhp37qXoPVcwcTUGNMCwQN9p89jaeKiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EXIMHYXK; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXIMHYXK"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-499ae1c6471so867405e9.3
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Aug 2026 10:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787248721; x=1787853521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YYEsMKlE1hunKYKu1jEmmpknYRhAQx1ch1/5OXya0mo=;
        b=EXIMHYXKtcMYV7Ri4p2slns48PJSlkPt9sYp06GVbIEv7XQEADPtUj/3XddT1RbmVP
         Bw3kLCkgze5ufVH0tLZm80uCPnNO7zIQw0BjT6QdI8qiGG8oPIBhyeynfgqepXYk0rpi
         AJvu1g+pWxEI1fEE3kuXrWeOBAmSV/S1cs/phtJ1QBAwq12wGg//H3ndYR8pUq8kjo8k
         4dpAV8VvCuiaJYfAw/Ge/XENRiax6OTv5iw/zda7TQ8owXkRmwQbdlSFJzPWmp5jCAUu
         E3P87CFlAZvhB6HOTgOQipXvkXIlJ9vW9UosPLufYlPePe87NoQu9EjkruR3RzuFc/AM
         nVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787248721; x=1787853521;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YYEsMKlE1hunKYKu1jEmmpknYRhAQx1ch1/5OXya0mo=;
        b=quBoV39NTv+JMOcQi+vj8E2tBQXJWDF2sfd0dv7QM53rtbuGrGSEr/ozPsTH79Xmko
         u+53tazw/ULoVWGlvtnjglMAIoSJOMHdSpY5N7dyoKeWWKXh9a8jvsIk8taDeBcrCbEj
         O39rOtY1IDaI0QZ5wZ3+55Vb4GCdygT79bIbJUesROM4W+Hm+ggKkC8/yPNogWYO9OIV
         bgaken9aIUaweRg4JIlY47JPTWqItddj/cEhbvAe+cgISe1Z/j8gZ7NgziT88Ebeqtj5
         IMe9pl+DxOSiLRZJ6PHSsYTJ2WQuUOJIrLR66Ywds0brdSfpH0C1i/1K1NYXR9e3HDGe
         JDug==
X-Forwarded-Encrypted: i=1; AHgh+RrwYJmojaPGRfIrI1uq4Bf+kTf2/VRsdo4CbzfWjeGSHg3iWFAy9i6gArPYte+hXmpyJNAex0ahwBqXEKYD@vger.kernel.org
X-Gm-Message-State: AOJu0YzDUM+r5gTRCMKVYEVdCPyBOtFjG0atfhqKvdJNnF74XGv1Hno0
	u5nUk2lxWm8IOf2y0HFQhChc95Rr0rQClbTJq6jX0Ex5coEF2xJT/jFm
X-Gm-Gg: AR+sD11Cej5CFf/cX01seVYcTWAWay8T/hhCH9nJyaYKOG6TM6iAi+Fq8VvMHBoYrHO
	deZUnkkfl2aQCITYNNKL/ksZL98A9pbZ0CuW1w5efxYsXECV/AzUlYFUGTYQSXolAKysNHP+R2v
	4kOrCliRrpD2h1zfXUTBM38bgMjNyXUxZ5+4CPeNFldL61TyOAMm/TC1hBEurTKkMEa6CNnEwSw
	CVgqOmmexfRMh+wX2g/QXQGugYcotZiD7lHpFGpRXjfSq8ArIOKkpgZ0jvjQVy9blb0IK4RM5v4
	hKFF9ykv/O0mwJopV7WHltkS32AjMe3qyO2A5OVmVnut+56XxhT+HTz7WaqHwbWbC9zILLxD4Il
	V7CsvCq+uQZ3fVpUM+Gi+UK5+mp4dSXkWxesPeyEDUSBpn8s+eaB81UrksnyaO7vOG7NGIpNQEN
	lSThYE/3Ui1kiDnqxwZiOAYJ/RlHCqJwag89TCuDSnqPZ6wCOoSrETCxp5TC8HyCc3FJ3PJ/m8O
	kHZ8Cj+L+VPX7LUGRTteFbbAGy0PQy1+AjK+ckP8eXmMOajzmE7TiN6/Z/A7aU+ZT6BMBeZ3vra
	BCkZn01yFtaliYs8QL/rKYj33RzshrwC2EHpWPGWrTQNfDd1KlajBTSSs1cahlUJZ+bet5+jsA=
	=
X-Received: by 2002:a05:600c:c494:b0:499:a5c8:c6f3 with SMTP id 5b1f17b1804b1-499b82f4d3bmr10160435e9.3.1787248720981;
        Thu, 20 Aug 2026 10:58:40 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a476-1a01-141e-2b69-987c-d72d.310.pool.telefonica.de. [2a02:3100:a476:1a01:141e:2b69:987c:d72d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa11f832sm152118355e9.7.2026.08.20.10.58.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 20 Aug 2026 10:58:40 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: selinux@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] selinux: preserve user SID across nested backing files
Date: Thu, 20 Aug 2026 19:58:32 +0200
Message-Id: <20260820175832.44512-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
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

Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() access checks")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Changes in v2:
- Add selinux_file_user_sid() helper instead of open-coding the lookup
  (Amir).

Tested on arm64 QEMU at fd6e2388a3ea with SELinux enforcing and two
nested overlayfs mounts. The policy omitted only
base_t -> mounter_t:fd { use } among the relevant cross-domain allows:

  baseline: mprotect(PROT_READ) returned EACCES with that denial
  patched:  mprotect(PROT_READ) succeeded; test exited 0

This patch fixes SID propagation only. backing_file_user_path() still
resolves to the middle layer for a nested mapping, so the audit path and
inode do not correspond to uf_sid, and that layer's mounter is not
re-checked. Preserving the full user path likely needs a VFS-side change,
such as having backing_file_open() store file_user_path(user_file).

 security/selinux/hooks.c          | 9 ++++++++-
 security/selinux/include/objsec.h | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1ead2eee1944..171b90412ff1 100644
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
index 3c0a16ec978b..853f7266ed18 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -87,7 +87,7 @@ struct file_security_struct {
 };
 
 struct backing_file_security_struct {
-	u32 uf_sid; /* associated user file fsec->sid */
+	u32 uf_sid; /* top-level user file fsec->sid */
 };
 
 struct superblock_security_struct {

base-commit: fd6e2388a3ea55e58cbbbef840c1d8aa2067dbb3
-- 
2.39.5 (Apple Git-154)

