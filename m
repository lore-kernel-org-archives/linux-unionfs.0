Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488DC36683B
	for <linux-unionfs@vger.kernel.org>; Thu, 27 Aug 2026 17:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787850445; cv=none; b=P+hTSpDLUUIRgopXSIC0YeZdJPf7Bjd7QfuSyKjQf/aqUPo7hs6azAOoxW4xf4sLJq/1PHYqpeNWJ3Jj7IxqnW7Rx6Jzz2AGyfNsjIsgrWM1VB8iNSOOpmHEAVd8oMeWuC5f9apT3BrMS8GowuPXHl4PYgg9hmcMgjw2RowhQi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787850445; c=relaxed/simple;
	bh=2SFNXBxgdI0HCVXFzGJAFG6tOT9qdrVngpU9Gwe0KHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GopLreYsmcrXEJ0NOrrwXJylO5XMvUnUuL5cPQ579If90lV+wVMDDPsJ00nYE+3l8mrm86DyvsTwBVFF5D2xWyNB67OgUYoyzDModWABOr9vn5I14mg+9oZZARUSJOhX7W5MWT+ncp+K9I0PWjCWrTHAqBOdlIy5qJZPF55sknU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PUhq3qtS; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUhq3qtS"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-39675172593so237606a91.2
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Aug 2026 10:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787850443; x=1788455243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gi6YEr+DF1axBW1gXA4gs50+nTUaB9ghIFL8GIX9VQU=;
        b=PUhq3qtSGzfTiI+W/6GQtOzgY6s0ItbAYjJ+f8M7BfVwG5OJCsCUTklHGx4IDLzg+t
         p8RmH1CBuIq7DfeyT02KnLx/tXw8l8lN1B65pwGs04oDnszptMseMdR/PWS6KBlgE6MR
         ml86aQ5jlZi8LjTquEmvL2YihcvFAp5C3ZNboqkbWcacmSm+MZhtK4/2HaKOQcbDrV1F
         xTt7ZYL0eI8E/lY+ZnUy+Bl+4m8tvHv1c64eJiatsVK0nFiA8tjCHI5R1WPdqc3NAGJm
         tmzoGPeg846rrujaeubPhBSmCo38gW/SA0tKjrsWXqpA54ZkvMOcOXJ9GR1Jfk5i3pxc
         4PHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787850443; x=1788455243;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gi6YEr+DF1axBW1gXA4gs50+nTUaB9ghIFL8GIX9VQU=;
        b=ITenpRUMl+31Wn3RJlEY+rGP3MPTAniN5ijR+say4Eo/n7yK7QuClbLlG3nijOYywu
         GnBsIFEgrKeU95EcbRKHM7Nykv2NtT6aLFEdDptHhMUhAkxr5tc5bv6XWKC3PdOE2v9D
         3rbWeOsYQxe3rVj7gUZzQ5p3p04WEBx5QlOcnLTdBkF0naFmaiHxBwD33AW4attHhQC4
         iIY4+azzbZSoFOyRSqTPXE1TRiWbh9WtC0oiJxlyTXx6RFgSlS2fyKeFZU4KomQZVjCl
         yLQFuKE6x3g+JkdKzoyEGPrgUd7aqhISJr5bu3NxVitCffzCHOKtkLlPIf22GofFFSuq
         sxPA==
X-Gm-Message-State: AFuF++k4T+o7th5tx5unvLLRxmSf45W63knyY0asHlvBrR5plXFCgQyq
	EybgxYAJf2cgEtEeF3eH/+t60AkUyUnxOAr2ldo+QF3ga/SgqOAK4ohN
X-Gm-Gg: AR+sD100uU79soLjbDFTNvoGpkwJeYIQVr7fVvWPGfVwWbqWSxTJ+jUSBs3yelc28Or
	rRImQVf82ZMcebZ0qwWwr53G3gGvCc9f2mngDwN1cutQOx3jAdyNNumcDC6JuLQuxaz8StmGeEu
	GfWs45VXIOZvoXHpd51WmfXNk1UA/PF9ejVFlAAlK3Y9ZDpuwFgIXQSH2xHLCTqEZcmMIyVKppL
	0YiyhkLY/4PsO3bfHU5F6EhZvObaHdsH8vACvcRRlJGiCrstqB4Guhf9dZQapZqwlBYFE947mhJ
	dI7mtUkmTFO0K44l5RNRLAc57U6tbg0NHgkJEX4WpsvHj+X+dds5Ic014TufUVLH9tKCUUjQuCO
	O+s1IFavfQfmwPX/bVgle3n1DRY3tcHs3yO7rytr4Hs4hx0VW5bEuF/tzpCPOjqxRxKjMRliTG0
	0RipNg581qCzxOmTFJH43g0yI+zROAZBv0ypsJLZRbGP2by+h4lc7wasC9PVJRQZ/vYUhLBtbvU
	KFZn5Q8pGFeA7bWr9mz2Vf/WHjGkFmaHDBHmiMVHB2YAhMfMbbH5JuUX/OBVOldFtKFhBLwdwrb
	LEV63kk=
X-Received: by 2002:a17:90b:3a45:b0:396:5785:843 with SMTP id 98e67ed59e1d1-396d0f09a46mr1214506a91.8.1787850443311;
        Thu, 27 Aug 2026 10:07:23 -0700 (PDT)
Received: from DESKTOP-TJS95SS.localdomain (36-232-192-191.dynamic-ip.hinet.net. [36.232.192.191])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39675922253sm2628890a91.4.2026.08.27.10.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 10:07:22 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: [PATCH] ovl: implement ->get_unmapped_area()
Date: Fri, 28 Aug 2026 01:07:18 +0800
Message-ID: <20260827170718.497-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ovl_mmap() passes realfile to the underlying filesystem, so the VMA it
returns is backed by realfile, not by the overlayfs file.

Address selection is not delegated.  __get_unmapped_area() looks at the
overlayfs file's f_op, ovl_file_operations does not implement
->get_unmapped_area(), and the mapping lands wherever
mm_get_unmapped_area() puts it.  ext4, xfs and btrfs all point
->get_unmapped_area() at thp_get_unmapped_area(); none of that is reached.

vaddr - file_offset is then not a multiple of PMD_SIZE,
thp_vma_suitable_order() rejects the VMA, and the PMD-sized folios the
underlying filesystem already has in the page cache are never mapped by
a PMD.

Delegate to the file ovl_mmap() will use.  Calling thp_get_unmapped_area()
here instead would force alignment on filesystems that deliberately do
not implement ->get_unmapped_area(), which commit 34d7cf637c43 ("mm:
don't try THP alignment for FS without get_unmapped_area") avoided.
fs/proc delegates the same way in pde_get_unmapped_area().

Reading a 1025M ext4 file through mmap(NULL, ...), 97% of its page cache
in PMD-sized folios, 15 runs:

                     PMD congruent  minor faults  page tables
  ext4, directly             15/15           764          68K
  overlayfs, before            0/5         16186        2056K
  overlayfs, after           15/15           764          68K

Fault counts had 0 stddev.  Median read time 17.4ms -> 4.80ms, against
4.92ms for the same file on ext4.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>

---
 fs/overlayfs/file.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index f3d97eb146e8..0d985025f4c8 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/fs.h>
 #include <linux/backing-file.h>
+#include <linux/sched/mm.h>
 #include "overlayfs.h"
 
 static char ovl_whatisit(struct inode *inode, struct inode *realinode)
@@ -465,6 +466,30 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		return vfs_fsync_range(upperfile, start, end, datasync);
 }
 
+static unsigned long ovl_get_unmapped_area(struct file *file,
+					   unsigned long addr, unsigned long len,
+					   unsigned long pgoff, unsigned long flags)
+{
+	struct ovl_file *of = file->private_data;
+	struct file *realfile = of->realfile;
+
+	/*
+	 * ovl_mmap() hands realfile to the underlying filesystem, so the vma
+	 * ends up backed by realfile.  Let that filesystem pick the address
+	 * too, or one that needs a specific alignment - to allow PMD mappings,
+	 * for example - never gets asked for one.
+	 */
+	if (realfile->f_op->get_unmapped_area)
+		return realfile->f_op->get_unmapped_area(realfile, addr, len,
+							 pgoff, flags);
+
+#ifdef CONFIG_MMU
+	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
+#endif
+
+	return addr;
+}
+
 static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct ovl_file *of = file->private_data;
@@ -654,6 +679,7 @@ const struct file_operations ovl_file_operations = {
 	.write_iter	= ovl_write_iter,
 	.fsync		= ovl_fsync,
 	.mmap		= ovl_mmap,
+	.get_unmapped_area = ovl_get_unmapped_area,
 	.fallocate	= ovl_fallocate,
 	.fadvise	= ovl_fadvise,
 	.flush		= ovl_flush,

base-commit: 26260251022fbc2f248a3d747a9b2b961b18d2d8
