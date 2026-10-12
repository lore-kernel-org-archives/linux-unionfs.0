Received: from out28-76.mail.aliyun.com (out28-76.mail.aliyun.com [115.124.28.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46193644C4;
	Mon, 12 Oct 2026 06:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791785342; cv=none; b=E04dvsinZwyaHOrCjUsmsAmmwptCqtJRHqevBeJOCE8msYeGIJF5t7tQ1D+iv++w0qvBNTgMdM8UjT39Bqt7cBy0U9DOLF41JBMdxDb8U5UDmxj2EA2RPdjeBd1SJPicvbujKioHz2HSw9ndJ7NNeEF2OXzXQjjw2pmjTgrRbAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791785342; c=relaxed/simple;
	bh=+bGqkuIu9xVO1ARt89speEmuhwk0ce5zLJouJ1r5i90=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IQnk4SaZU8+b/bPplU7GeElaFzr2uUel0yegTHGA/Z+nrdif2q7gJWB8JsuvynJktucv/6gThAm7IgOktSZC2efMgthcRFHo/RDR1lZUSJxzY/qd6KqBpMmMyx59/AgpvbahM+BTRycS1GJPs5UzFlm2jkkPmkl/qq4Au1EOsY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=OjoVBeYV; arc=none smtp.client-ip=115.124.28.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="OjoVBeYV"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791785330; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=rNLMCwNA6MCSj46Zwd+BPEPlQGaV6ZyfWmirxtwHQ0I=;
	b=OjoVBeYVPOIrYevDw7veY8Xe2PWijKWNVDVOf71eZuZwffZ1gvg5PA4VaHpRz9hHCKIqaPgRnrNf3HWijnl7XFB9qCal67wl8Nk47A2y2rvWXFVklQgcvGoRca4wVmZAumS6yGLtK3dk4DUH51/VrGYd59qhBbxeJ+yPJh3YJdA=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.4095172|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00284634-3.1537e-05-0.997122;FP=5043158655540792362|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037022039;MF=zhugl3@xiaopeng.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.jZruTWl_1791785327;
Received: from DESKTOP-UL5U09E.xiaopeng.local(mailfrom:zhugl3@xiaopeng.com fp:SMTPD_---.jZruTWl_1791785327 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 14:08:49 +0800
From: Guanglei Zhu <zhugl3@xiaopeng.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuc63@xiaopeng.com
Subject: [PATCH] ovl: reject lowerdir ending with unescaped backslash
Date: Mon, 12 Oct 2026 14:08:47 +0800
Message-ID: <20261012060847.836027-1-zhugl3@xiaopeng.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ovl_parse_param_split_lowerdirs() the escape handling consumes
the backslash and the character after it.  When the backslash is the
last character of the lowerdir value, the loop increment moves the
cursor past the NUL terminator, so the loop scans heap memory beyond
the kstrdup'd string until it happens to hit a zero byte; a colon
found there is written over as well.

A trailing unescaped backslash escapes nothing, so reject it with
EINVAL.

Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
---
Found by code inspection.  Behavior check in a QEMU guest:
fsconfig(lowerdir="...\") on an unpatched kernel returns -ENOENT
after the loop scanned past the allocation; with this patch it
returns -EINVAL.

 fs/overlayfs/params.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index c93fcaa45..5a15e5478 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -216,6 +216,9 @@ static ssize_t ovl_parse_param_split_lowerdirs(char *str)
 		if (*s == '\\') {
 			/* keep esc chars in split lowerdir */
 			*d++ = *s++;
+			/* A trailing backslash escapes nothing. */
+			if (!*s)
+				return -EINVAL;
 		} else if (*s == ':') {
 			bool next_colon = (*(s + 1) == ':');
 
-- 
2.43.0

