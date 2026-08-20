Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B9D38DC70
	for <linux-unionfs@vger.kernel.org>; Thu, 20 Aug 2026 06:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787206442; cv=none; b=I02gw5BCZCCuTQNMr6FwAP19D8e/WZ8O2Vfc+bkiGmE4zzTSLfqYD2UpmGDB0DrMDK6lJUcwvM5afavP3vqUDkwqDzTCinNQLZX2/G0+Xh00pnW6YDskvsXCheX/GyZiQmzllk+1XSMioGCpk29rDErIgQdd/cmzQpCQ8EC7GuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787206442; c=relaxed/simple;
	bh=5idfiA36NczW41si+OWGL51HGRsYJBjnWxO7ogXCc8M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bVjQSahS71mKv+V1oEpDuxUESmz8OeD3/fNjJDT3fRXQD2HvKlU8jUMe1XcN5H8CxFj7hql5l9TS+WbLzCSWJiFUy1pWJ53Emgd6ZcadlSSEoFGCXUULdoIi6E+nexCfdlBxmrnk51T3f7IWc5H85oBwOeqQaclGiDPyDVQ5yMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E7AH9DAi; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E7AH9DAi"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-499b2981a7bso3419785e9.3
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Aug 2026 23:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787206439; x=1787811239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+0zPOZ4cy1qU8zrYNcuVxcq7JUklUQqhNtrlV/MxG9w=;
        b=E7AH9DAi27mvWHXeWQF4pPTG34CIkQVMlXTwEpX059psgy3AeLgF1rtszHwT8LM6gF
         JpYRVv2kojq75qlK/voPyek23nZVE/GLYkm7tO567/s1a89KdohpXrWmqCfvkfQTnsjW
         P16plr8nwlfRaJL1wfxodV8RuiadRWSTqAkksPw8ENdlslmJmyAFiFXnEsh9Z+xDT9dJ
         dfUtl7khszq/iwm1UAqg5AgNa9vq82UWZ+me20UU41gotRzJ0TbvBrq249i62SFdzQ29
         Svvjs9lgODDmcYo9I0H/GcMrAG9QaX9ZrFJCzxPp3BeYGAXseJyDW/j1nts5ck6IVJ65
         cAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787206439; x=1787811239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+0zPOZ4cy1qU8zrYNcuVxcq7JUklUQqhNtrlV/MxG9w=;
        b=mZ6KiCHt0Mpg3jcUrGEClcq+1npVoS1zVSzY9kK7TaOAoSXF7OdO9rf7r5ySlhCM78
         xcAYdsg/8FYij5prqTDVtVoePtAz0sjrZikVcBu2tPxRHLaH9BAng8GvbDscKQNrd26s
         /ODWUcQ1COv5oSyZ0Ep6B2QDvvTKbi8pqfPq9azeP+BqBkDuzGOLrscKKpU5sVtavLOB
         nWAWrNOpTl1QLNv+agMy7wSnbX/ziGW418qOormqCbj2WCYrIhb+rxAdG2IcF0C296L9
         C1LuyPmMTG3l3a3XJnEfN/SwkKUJlAwDxqbGUl9QQ/obAI3+GKfRf8ba0pNvCxl+QpLV
         8n7Q==
X-Forwarded-Encrypted: i=1; AHgh+Rrm6paw1WO0PAYDQHqKeH+KGO7Ms54IkVXrcNf7UAdf/pgUJCvAC60eDJkphJ6rhHwf+8w1Rm91j2ndiU/F@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0Y/EMHI227gIrUVjWMj8Kc0sRCrjxoRaNnAZin13baYEP6X3I
	/1atC/UZnNMJwO5LBb9HfKBZtJu/YBoDNZhjzHx0KAjR2iBVw/qSfnfx
X-Gm-Gg: AR+sD11eUQUMGW7Tva5bdFDL3QsJKftTEYRmHggumj9cTiFM9xVrvE8b3z0K9FxshXr
	fq2vtNB8+lTShGSEUalV3HDRI0V8z5w5VRQZKXzBetuVLN//lv0tL/N8/21bP696yeOIBKEWsoA
	TxZermBt3WwMLDzqsvzXQqVIYwLpD2wDnJaKJCvKNzyRg1b3PNlP94UqVenonL4S90DyaiTTf0k
	C+4qaXTCXNFajUQ9TjB26hz4GDvYbjHLhxVlvWTp0peKqFxdDJhAixY148g+XGAVqhHIDBX1aHH
	n8XP5ine0RWp0nK+K9qoXXZCp2MJf3p7jkYmj/FhlEBwlfac7qbIOCTjCHEgi07CLSAS3m6eL5R
	OE+ddW0p3pa8vJZYJMzBQM76vGhg7XFyirJOowGx+Whrw6iSUGoU5C2Gxh/rCywCfY6ZplNhztl
	eXZcnlzYD+9U5O2C5wYS39xaROyOdh3WRPtWb9UrfipQIVLurLPrw3BQ4MMyVs+75r8uq+g1Lak
	jQkmEw9APBneheWQhi0n7PJDzwkuG0QtS9K65+ewoDM/mfTH0vPQpIPbYS4mpc8/4WrthekeE3J
	gzAy3efxdaEmNwdoPwGxxRWv4+3tfhN7jGBUJyZXON0hKNmtRqsPBNxKnOaPi29Yl4c4OSVX5mY
	ov6Y=
X-Received: by 2002:a05:600c:c493:b0:499:7aa7:eaa7 with SMTP id 5b1f17b1804b1-499aa20c7b1mr165566735e9.15.1787206438796;
        Wed, 19 Aug 2026 23:13:58 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a476-1a01-141e-2b69-987c-d72d.310.pool.telefonica.de. [2a02:3100:a476:1a01:141e:2b69:987c:d72d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa17fc80sm129661355e9.14.2026.08.19.23.13.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 23:13:57 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: selinux@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] selinux: preserve user SID across nested backing files
Date: Thu, 20 Aug 2026 08:13:49 +0200
Message-Id: <20260820061349.10542-1-kmehltretter@gmail.com>
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

 security/selinux/hooks.c          | 4 +++-
 security/selinux/include/objsec.h | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1ead2eee1944..8b96934e9992 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3849,7 +3849,9 @@ static int selinux_backing_file_alloc(struct file *backing_file,
 	struct backing_file_security_struct *bfsec;
 
 	bfsec = selinux_backing_file(backing_file);
-	bfsec->uf_sid = selinux_file(user_file)->sid;
+	bfsec->uf_sid = (user_file->f_mode & FMODE_BACKING) ?
+				selinux_backing_file(user_file)->uf_sid :
+				selinux_file(user_file)->sid;
 
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

