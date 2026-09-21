Received: from mail-ej2-f38.google.com (mail-ej2-f38.google.com [74.125.228.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A7147A876
	for <linux-unionfs@vger.kernel.org>; Mon, 21 Sep 2026 10:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789987218; cv=none; b=Pi6/hdgLUAmah8iE4JTPt0Azta5iBKX0dPLHMDrJuRF/Qdw9wf6Y3hTddUioR4H3FNOmSJv6WHD1kZI1N8rqHeM8GJVhnVxja1e2DpUa+2PtwGXpRFz8NUIjX4kszWcaf5tuIbmN7hwIlgONZEO4DnJYDOR4ohrMHwmgJ5GJTNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789987218; c=relaxed/simple;
	bh=dDPQGMPxWDL5Md4UKKAaE12b5eDFg7IKombAhZ8/EIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rvXf9JST0oat+2b8MVJ2NsBOa3TbSnFbAWTQ2uY1Ygsy9GwAp7OTVDCebB3aYNjsQtctbBLJpylPAfe1Mh/H1tCZoMDlAenqzI72UUBzLQBsSMknPVHH0SVHhsZqXQxH+BeA1zgLTgAU9GnT7nwXAjNPTiuY4dCip2JqZ0hq8Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C+zC8Rjg; arc=none smtp.client-ip=74.125.228.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+zC8Rjg"
Received: by mail-ej2-f38.google.com with SMTP id a640c23a62f3a-c254f560398so421386966b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Sep 2026 03:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789987215; x=1790592015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IbEEZ7owdYJHLjt2CUeGmUfepiIuH0Jeo8fewfZ4bvY=;
        b=C+zC8RjgB5aCJHwSCOmI6rs0LhflVG+NLp432F4hQbPsNm0w0Cv6nxfJn4b4sWI9Bg
         6AoUamME659LVBOX0KNfVgDxlQ6Sr0/Y7jCAzFDeSvLGXe+hPcIpkoO3YaeUDhlp3FNm
         wN1JLjTfju4Yrpa+XK+7WboxETZ26qdow6qd2+YG1RPpmW1c6Pf572vmC9nDJHHKoDLt
         r+2yEEyl3BiaEjN9r0OocvwJ/VdzLkN8+IbW6rbY1FLQKg8xB0Xzx76jiePiUEfaFl/h
         2wR/zlMD5QVmM2QfQaqsd6nWYhs/xQ1pOTrfEORlXTOTPZyrvk+FJHd4SzrEyTTbOmcY
         ljUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789987215; x=1790592015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IbEEZ7owdYJHLjt2CUeGmUfepiIuH0Jeo8fewfZ4bvY=;
        b=IMur2dfb+FCN3M+73p9CprcWyg+SdfD6QOYTr7Y65tGc6Px2FIIyzgSiqeiOoN7Hxl
         e52G8UFwsX1hPgXjKyMUce2vOQWp25ug354gbmISUUlOBzFWXJMh8picxYo+RlQMefNg
         bsNPkZJgYiQBQJjA6lN//o5BWpkMaxsO5NLfFuXU2jsyjyQMPDDuXz0eM6ElvdRaDxxx
         EKbWYmC986ew2TFzfxD/GnCqtXp0ilh7ML3e6smIQbzqPMZV+ou1jKcqhEwHfMmNrQRz
         rz6+MML9Lj7MWhXbx0sl/2cA7fixSLLJpRzlnTMedAYGB4e2n9CZANN2or7rGlalcVx9
         8DlQ==
X-Forwarded-Encrypted: i=1; AKwUvBz4PBow0mfPa9yHQ0gt/W6pfXMO2qw/a0o1/zDvEnStdZi1eW9PkIS7ew/cjo/uFZkuJAtK67jMoHxNZxYi@vger.kernel.org
X-Gm-Message-State: AFuF++nhrtKE8gWF2wPLCC7hXdqw9mvkESaPZZyUBIJFMrvt9s6HlVJy
	ZvBB+21gSuimiwJn+VdBe/FFJK3JaF/w74fVUrNrgoZWJWwFdpNpKExm
X-Gm-Gg: AYBFou0bHhrnd0UvXg6fcaotIIp2Zr15Rir46X7EqmxGHYiHeQIGHe6LFiPPzYRlDUZ
	A+/wFrm0DjYzgvcsvSPkdkc8gwT13p3/OFhAjt1lhC4sH7M188rq/z7Gf01tvBCEofVkG8z9jH2
	841m2FYlXNXq7oG/qrqWB1XuGiA9bMKRABYiCTYPwcKmwsIpcSptAjs6Eb4XD5vf/4QyzUnUKft
	nA5yWytj/EZjCRO60A43kNYtKUhfLMimOKWQd7jLNtHiqFTFkJmDe9FZyetfTm/CaKR6lUdo2Tr
	C8sm0K1JmJKoCQ7ZnseGcTyxw6nFyrGT6cVcLZ4EggOyUw6o/Q+o2R3AD3yrjg7g9+QTB27ai0M
	b4NOZOof6TJdrsU3OBM65QE6z0d1byZY3AuCwBo+fRabUJEilxwxIB8IBD2ERJkNZgmdB7A4MUb
	+tl5BC22vJwgjJw3HgrTYTFYwB434f82ayesYHeK1DZMf1jvnqkzRWx0K39cslq7sDSYzmAFc1e
	R1KpeoKw5o2q6NvT7RHtlYQzg==
X-Received: by 2002:a17:907:7213:b0:c25:cb9c:2e3 with SMTP id a640c23a62f3a-c2a157c014bmr881902366b.4.1789987214613;
        Mon, 21 Sep 2026 03:40:14 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a46a8ce50sm257548766b.4.2026.09.21.03.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 03:40:14 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Neil Brown <neil@brown.name>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	syzbot+ced26b784bf977d223dd@syzkaller.appspotmail.com
Subject: [PATCH] ovl: fix UAF in ovl_do_mkdir() debug print
Date: Mon, 21 Sep 2026 12:40:13 +0200
Message-ID: <20260921104013.40475-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ovl_do_mkdir() prints the input dentry with %pd after vfs_mkdir().
Since commit fe497f0759e0 ("VFS: change vfs_mkdir() to unlock on
failure."), vfs_mkdir() calls end_creating() on the input dentry on
failure and may replace it on success, so the post-call %pd can
use-after-free the dentry when CONFIG_OVERLAY_FS_DEBUG is enabled.

Print the dentry before the call and only the result afterward.

Reported-by: syzbot+ced26b784bf977d223dd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ced26b784bf977d223dd
Fixes: fe497f0759e0 ("VFS: change vfs_mkdir() to unlock on failure.")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christian,

One more fallout from directory locking prep series reported by syzbot.
I have asked LLM to audit the kernel for other similar uses of %pd
post end_creating() and it did not find any.

Could you take this via vfs.fixes?

Thanks,
Amir.

 fs/overlayfs/overlayfs.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e0d8c6152e9fc..7f3558372c599 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -254,8 +254,10 @@ static inline struct dentry *ovl_do_mkdir(struct ovl_fs *ofs,
 {
 	struct dentry *ret;
 
+	/* vfs_mkdir() drops @dentry on failure and may replace it on success */
+	pr_debug("mkdir(%pd2, 0%o)\n", dentry, mode);
 	ret = vfs_mkdir(ovl_upper_mnt_idmap(ofs), dir, dentry, mode, NULL);
-	pr_debug("mkdir(%pd2, 0%o) = %i\n", dentry, mode, PTR_ERR_OR_ZERO(ret));
+	pr_debug("...mkdir = %i\n", PTR_ERR_OR_ZERO(ret));
 	return ret;
 }
 
-- 
2.55.0

