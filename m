Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF19F396D28
	for <linux-unionfs@vger.kernel.org>; Sat, 17 Oct 2026 16:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255891; cv=none; b=igryyTXyyO9ec2sYOCscYjznxavNsDDGroWliEHi1TSkiFXR9gJqUBTqO/0JEwLj6CMsD4XpIseQDq+3+ljfKd69GC7FfLLL8/pMgTOY3OLqOEoHL5sdhACenImsaAPmm+h7RhpgVMVKmvgqL3SazBtdHyEpltkHlvH8sxZ8oHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255891; c=relaxed/simple;
	bh=pPWBmM/X+uYky/gKQ+5EBYcMPQ+iL6bPJtE8VbYUpwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YmWs68a99DAhl84Epwys3Kj/KPcgtR6NEgjQKu3HYeTsPfOIm+DPP4vMr29i1wC45wVCHXXRz70UtYLy1b3VHAnL1awK/wNfp1kZp59qK/ugdH3U6DIVps8LRFsYklVdEDBgBneCBbvqdZtNTd2lMeOuWWgSoHIIcIaq+n+0e7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SQMdXipJ; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SQMdXipJ"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2afa22e1dcso134548266b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Oct 2026 09:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792255887; x=1792860687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zPmxIE9jKtEtBa3fhEQJEoH+3Pe3VBtJ1OEhScFLQkg=;
        b=SQMdXipJcTnSkdIGdtzCdDzGcYwxa1YpZNAwlZt/b8fc/uLY/fjBHjIf+NNoV59nqc
         cflleyxC6nZbEptKnxtwTMz8Fg6Ix/yMFWn4B1aPei/RTNA/8RnAKDlXMUMFu2blNVL2
         VN/7dfqPVGoLXQ7sfyHe72buVr5GZ7NYbOjvDaXyoOSSYUHZDT8IMUSnkWTcG3Hhas8Z
         3355SIJyPa7mA98qj5KaBHv6qsY2B1noPccuoFkI54T159/Dan91qbYaXmefQ47bp3FF
         q2yWdQn47KNDjOctg5tWVgzzpEswxbjkKD8s91cvp7U4lOIsgfOd2wfiH7Bh+TQmo8Xf
         vBjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792255887; x=1792860687;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zPmxIE9jKtEtBa3fhEQJEoH+3Pe3VBtJ1OEhScFLQkg=;
        b=d0W0WKfboitiZyrwmXO96eCK6Z62UK3AQq3mlGOVpX7onBhXb+xJBQk7NEqA0CY9lB
         gpvTbU5RPgliBWFyfIFzrocYV33X9sxIGHGD9h9IXO6GXOif4gRimyVKgJWfFyEY5C8P
         N/fk7rAJQCMpN1BxnzGu7SsbIKEL3fiSoZ5qvLJcXYWhw80mSNvwT6IO5kYtJ7HpUWlX
         YKPJHl+SomAcpkxPW0uPrOaJJqtSqmxjl7HGfQI9fMmszovu1j8EpbpIBnHGWoQy4A3T
         xhvXCjXbdfzRSeIkHY4V2TH66Lq1sJPzF7RjCOeL2lbPNdYu6VFgotsNAs3SzIoO/tn0
         sYvw==
X-Forwarded-Encrypted: i=1; AKwUvByB6g9USEFR5oXtniXrdrNdYvzHXjsXM72+Xa5MbBaw6jQ82Np7Rj3LJri1CICclGLrRioLXks2zlv7Gazh@vger.kernel.org
X-Gm-Message-State: AFq9FYKIxj0E+D9RERz2eiLG5xmDmjkiIRLmy7u68A5+cbfLD/MIDSPT
	gS8de+ySNefLugyeNo3DUwRfVAO/4SsyyyjeaAe2dQ7xQ+eIfQonTR35
X-Gm-Gg: AYBFou0sJmKjtxBz0LJAv4igYAxWEgz8B57vntkSl/VBCps4D5DIMt6JUT+t3hseKB8
	tzreI3n294dctb3vRjd2KwI/2M3iv8EX8jfqX6DkstUgft8edrkzSH+fl1VfS8taJf8sMYprneP
	8FS4pET6tWW5hk+kS2lsA9Md3VqlYrmY1BEdi6M5e7QTyppqRqX1SzJ1yldl2Wx03GUw58mmWoK
	nr/YKy/59Bbqr7UigGDPWfo/Tn68s85H2y5ikppqBH6HMGyOt2O0dh49BofPVzg5+ZWunLflTuk
	HXeCevmava/dGbHg1gdC6vO0wIDh1sAEpw2nc0sCkpxYFMHC06EzKp60vVKQjb+2S8iq0I3hcYT
	7xSAjpDipMiuMhRs+EkxqMXzfLVDJPwabw+J6Vj8GkqC3gSAvsMSUG9mDYpvxhxZ6ocRVP0dKn9
	Dhwman9BOtgaUOXexaE9gUcRTHOSAMmU4fUBEKeJ9Hz2YXFFDQZZs4AHaiUMffktvyDKHeMbfs3
	9z4jMcxl5hy0A9NtjJskUYvcg==
X-Received: by 2002:a17:907:a892:b0:c3f:c10c:2178 with SMTP id a640c23a62f3a-c419eb337bbmr218862466b.28.1792255886777;
        Sat, 17 Oct 2026 09:51:26 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4090dd3190sm196301866b.23.2026.10.17.09.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 09:51:26 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH] ovl: fix mount setup failing when override_creds drops CAP_SYS_ADMIN
Date: Sat, 17 Oct 2026 18:51:25 +0200
Message-ID: <20261017165125.2450059-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a process drops CAP_SYS_ADMIN and calls fsconfig(FSCONFIG_SET_FLAG,
"override_creds"), overlayfs saves those restricted credentials in
ofs->creator_cred. ovl_fill_super() then wraps the entire mount setup in
with_ovl_creds(), switching to those restricted credentials for the
duration.

Mount setup calls clone_private_mount(), which checks CAP_SYS_ADMIN
against current credentials. With restricted credentials active, this
check fails with -EPERM even though the task issuing
FSCONFIG_CMD_CREATE is fully privileged.

Use the mounter's real credentials only for cloning the private layer
mounts. Keep all other backing filesystem operations during mount setup
under the stashed credentials.

Reported-by: Disha Goel <disgoel@linux.ibm.com>
Closes: https://lore.kernel.org/linux-unionfs/20260924112858.51392-1-disgoel@linux.ibm.com
Fixes: c28f922c9dcee ("clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bd0a3f9039d25..c8145b62ea99d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -497,6 +497,20 @@ static int ovl_report_in_use(struct ovl_fs *ofs, const char *name)
 	}
 }
 
+/*
+ * clone_private_mount() checks CAP_SYS_ADMIN in current->cred.
+ * ovl_fill_super_creds() runs under the stashed creator cred, which
+ * override_creds may have dropped.
+ * The task that issued FSCONFIG_CMD_CREATE is still current->real_cred, so
+ * use that only for the clone. creator_cred stays in effect for every other
+ * backing-fs operation.
+ */
+static struct vfsmount *ovl_clone_private_mount(const struct path *path)
+{
+	scoped_with_creds(current_real_cred())
+		return clone_private_mount(path);
+}
+
 static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 			 struct ovl_layer *upper_layer,
 			 const struct path *upperpath)
@@ -520,7 +534,7 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 	if (err)
 		goto out;
 
-	upper_mnt = clone_private_mount(upperpath);
+	upper_mnt = ovl_clone_private_mount(upperpath);
 	err = PTR_ERR(upper_mnt);
 	if (IS_ERR(upper_mnt)) {
 		pr_err("failed to clone upperpath\n");
@@ -1093,7 +1107,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 			}
 		}
 
-		mnt = clone_private_mount(&l->path);
+		mnt = ovl_clone_private_mount(&l->path);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
 			pr_err("failed to clone lowerpath\n");
-- 
2.55.0

