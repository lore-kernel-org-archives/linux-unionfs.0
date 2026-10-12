Received: from out28-75.mail.aliyun.com (out28-75.mail.aliyun.com [115.124.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C9E46EF6A;
	Mon, 12 Oct 2026 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791798951; cv=none; b=aZlBtBuIhl6g7rNCZetqBnx5VsBWWNxwjvk6abel9sKBVefoCPSpJ5uFBgxiEwtCmBGjzTJxd9z49NDEHWX4Z0xY++W6HvC7Rb91FGyDjNWIjbV9Au7+zcrOzoRaCItR6aKcyat/+Fxwu69t2lKlii+lJosDAQyiEOJEl0GeUzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791798951; c=relaxed/simple;
	bh=8jjDp0mopqfEmT+20j7XuRc4b3Ao6eGqw7y9kS17+SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jestaz/dtd3nI2nQh+V8XMIYlmdI/5UEyC+BACrzTPKblJ7GJuqUiP0iM6CGw/pNL7buknlmmABk4PlCXhHAjS0POAzgs3XB3UZqjJZBNmurdL78zPJh2IluFBZOZzWWPQZbn/08VMnhkZv9kbuw8N8znzjfkyH2ItJ169Dgacw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=gtfARsuR; arc=none smtp.client-ip=115.124.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="gtfARsuR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791798939; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=hNUvCs+g+oZlxncGUXpqX0VwM9glkZ9wzt09M376ej4=;
	b=gtfARsuRfg7SAYPT5vKWx8oErz7e34D6iiPUjk+6bpRj6+aEVmb7pnBxujVmoQ/kzIKlk9GqTG6uaqlJ+jonjNPAuzfuwkEuKZtFFfhKNLKDY71fwWAC/BwAj+xe9aSzdXGRDGvJDDHalJnTnONMFu5JkJTcDLrq8CSPT8EiZaQ=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.2191282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00150799-1.82752e-05-0.998474;FP=3025519633931349018|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033045220102;MF=zhugl3@xiaopeng.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.jZwq6ZF_1791798938;
Received: from DESKTOP-UL5U09E.xiaopeng.local(mailfrom:zhugl3@xiaopeng.com fp:SMTPD_---.jZwq6ZF_1791798938 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 17:55:39 +0800
From: Guanglei Zhu <zhugl3@xiaopeng.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuwb@xiaopeng.com
Subject: [PATCH v2] ovl: reject lowerdir ending with unescaped backslash
Date: Mon, 12 Oct 2026 17:55:38 +0800
Message-ID: <20261012095538.938789-1-zhugl3@xiaopeng.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012060847.836027-1-zhugl3@xiaopeng.com>
References: <20261012060847.836027-1-zhugl3@xiaopeng.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ovl_parse_param_split_lowerdirs() a backslash consumes the
character that follows it.  When the backslash is the last character
of the lowerdir value, it consumes the NUL terminator: the loop exits
normally and the backslash is kept in the output, so the lowerdir is
passed downstream with a trailing backslash and the mount fails later
with a confusing ENOENT from path lookup.

A trailing unescaped backslash escapes nothing, so reject it with
EINVAL.

Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
---
v2: fix the commit message.  v1 wrongly claimed that the loop
scans heap memory past the allocation; there is no out-of-bounds
access, the backslash merely consumes the NUL terminator.  Thanks
to Amir Goldstein and Sashiko for catching this.

Verified with an ASAN build of a user-space replica of the loop:
no out-of-bounds access, the output retains the trailing backslash.
With this patch fsconfig(lowerdir="...\") returns -EINVAL instead
of -ENOENT.

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

