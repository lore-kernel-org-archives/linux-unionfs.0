Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4CF3FC5BE;
	Wed,  8 Jul 2026 08:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783499068; cv=none; b=kZITGBWjT24uQzaRWc/TB/43MHWGBhMq/14hdjQY6eWyq6OcNltJ4ulNTSmgiK4r5CcZggY8sQ9bvpJPbpPrNmrTmBO35brkhjkF5AKdAdYIDQLnbaxSSVML/n1j92Y05k4CsK5O9xX/xJNS2RrdYe4skUnZ/Ka/PcBvuKb76gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783499068; c=relaxed/simple;
	bh=8tNShngHUbiS4xF2c1PpBwvsmOYW/i3XIsEhgkyDzso=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uGBsZXi4YFqqlXzK+JY/ic4L0TRkocLbNP0iXsCW8L+pLm9EvxUUBiaq/vR627ItedJ/3rxpejco1NHURfihprjZbxORwNWlDc/1ZM/2YqKsF7OlYJWH/xdlUb0PLUOI4S/mwFxmBZwzqAYKuhX0MuAAuwpLqDhhKjYiLmM0H/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=gCDDJ3qu; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="gCDDJ3qu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783498961;
	bh=gS4JYEjxhIaJ8ssv3//iDNdLA5aSMv7l+AwfK/Xz/Eg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=gCDDJ3qufSxf6j39i8mEG3AVMjUpn06CxyyiJHC0CfFjsF6VzwofuwQQIWG6GBFWm
	 RtC4dHAMC7faXvIHoY05/204IWRmq0Xg07cyTaIWLRoWyJtMK8iMcBxypT6AWgA63s
	 a1ErfWIbqB/dTc3tRCs2WUDLSLwocyp9ajQ5FKPQ=
X-QQ-mid: esmtpsz11t1783498946tb3fca6e6
X-QQ-Originating-IP: lEZxs7S+Pr6ZYmdeDbLU9Z6JL3UcsXi+UokUM3Sb9uA=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 08 Jul 2026 16:22:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2992820863266456770
EX-QQ-RecipientCnt: 6
From: Yichong Chen <chenyichong@uniontech.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] ovl: fix trusted xattr escape prefix matching
Date: Wed,  8 Jul 2026 16:22:21 +0800
Message-Id: <20260708082221.633602-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NIaGbSI1IL4ZxOp6IX1cOS9JyksiQ/gPnJAP+tBih+hu2FeVyr0wE/Oo
	O6MfAAHjOOvHVUswv2oY5YfKWREqQgsdL+xuDKVH4GOgi31aKtRgi7P1x2snfxh+qIMRU/q
	wEiiYTsRNty74UFp07LhYgNao7ZEDfA4UO8CLJlz3vFZxWErs2iy+HbTZ/OzWB5ivRKgZIo
	BQiahHLpL6Dw0W/Hm6wc/httbuRZ6vmNVPtIIax1cMAiUwmoupdR0ewIKBaR59E+3BM5Nm6
	hWO8O40XnwB+W4RxDvgknUDLY7k4YEvZOhLxOWWb5wHiktHD9awOYrvos9xgCuTNzeE4U2n
	vDoofreZpBKVm+3f9WunTmhULV+56P7B66don8u2fBJ1L/4KK917jROm+Ry5RIY/H60VpmZ
	gRzW62vMO95ImQqbWag5DDiKA6q8KtNruEnvyDsbcFsUQ+35cxchlfzU6m0BQCng5ybqDly
	UhubYDyfOBbaROluKVbe53B8LAUr/HsSAs03L+waIFE2OnnsSGT4l+CW2T9fS2AbzBuzSEy
	7eOFw3GfL4j2c+aFI2div0ByJWnHv+9uDY/b3tic10EL5nJ492Cd1XCSy3e/QW/f/g1nGNd
	2b3DgX4sdDRFmJSKAfXxhU9cJtBK74lpkmffrLVImepmwHKZmvsaoxLZO86h3hCKTQ5+vyI
	896dtIkrlObLppDarotSDcvUjAH/vjZG2pIh4fs9M7ipNk/+SUH5vfhb8DhA2nngP/V+0lZ
	olSjp5b4/0YJzQzHkZG5yJoCSF3W+ee98LtKCjrQZA5nVypEAIsDq+YXYzFSGUCu8KOvzPr
	49W8BfdtfftW/Ew4EOsXUJfTfKADNTKETRDwsqoYfJLvOO1thfg4ap58dvmz2AphJl77BE/
	pTfPs+72KrBcE3lLJUIJPI3PmFP4E9djIgQhQPxXPAKoqLkEUh7TKHs4RzhPFrWcY5T/tE4
	Rk8f4TzrEmTAcJW+F4kXOMyib1MgrgdXTKEvFTlAKWmV8jaQ/qgBX7n0RDOPKZZuTd3t/0u
	EEt8t72N7kxymei6be
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

In the trusted.* xattr namespace, ovl_is_escaped_xattr() compares
one byte less than the escaped overlay xattr prefix length. This makes
it match "trusted.overlay.overlay" without requiring the trailing dot.

As a result, an xattr such as "trusted.overlay.overlayfoo" is
incorrectly treated as an escaped overlay xattr. This can be reproduced
by setting "trusted.overlay.overlayfoo" on a lower file and listing xattrs
through an overlay mount. listxattr() then exposes it as
"trusted.overlay.oo", and a following getxattr() on that listed name fails
with ENODATA.

Compare the full escaped prefix, including the trailing dot, so
similarly-prefixed private xattrs are not misclassified.

Fixes: dad02fad84cbc ("ovl: Support escaped overlay.* xattrs")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/overlayfs/xattrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
index aa95855c7023..859e80ae6f40 100644
--- a/fs/overlayfs/xattrs.c
+++ b/fs/overlayfs/xattrs.c
@@ -13,7 +13,7 @@ static bool ovl_is_escaped_xattr(struct super_block *sb, const char *name)
 			       OVL_XATTR_ESCAPE_USER_PREFIX_LEN) == 0;
 	else
 		return strncmp(name, OVL_XATTR_ESCAPE_TRUSTED_PREFIX,
-			       OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN - 1) == 0;
+			       OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN) == 0;
 }
 
 static bool ovl_is_own_xattr(struct super_block *sb, const char *name)
-- 
2.51.0

