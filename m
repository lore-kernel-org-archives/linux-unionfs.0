Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF62980C2;
	Thu, 12 Jun 2025 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741016; cv=none; b=G4eYhyWftRccEUIz9bWqRFELu8botGdBwasg3fGIM4VPGyOo32RM9aqzAGpesY57DTreD3rlD2yZP1o5sbtW9e5TmKO+no32JlZMBoF9A8+XiXsFJfg7muqvwoITPgvlwcftUz5DhvnJUbnWXX0gFvVyPoGtslm9wKD0fbo0LdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741016; c=relaxed/simple;
	bh=K3LQUnBtS+2Tcv7ACqZKHRdhKQxw+Yd7TehlFf8X0ic=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=BFxir8OJ+2ZDOLnKSNWlXqh+jfts+IUA/g306AVdcO1ClKC8Jd5DXrQsxcSQk8H32txEYENYoXUoWtancqecIjbhdJyDloRliA+XUC+mP/jgn5yZM9uHQJUn16BJblzaoZxZM1p7qlW0Rw47C1OFHUZLl6wpwLv/Zm8ITFe0XqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=MbpyrVkD; arc=none smtp.client-ip=203.205.221.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="MbpyrVkD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1749741010; bh=nTF5MUYaWmJcKbJXFqj0S8VvY7BZpo8uiL6sIulYVEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbpyrVkDR0BgDFzBBUrK2qpuqlxL+25wQSA6ekkMdpiXSXT5gZNQvTiOGi0HGKBSP
	 wzieVbcsNWeAN/zLGUrz7YiMLMHHx8rw03/jsO6eZTxTH1H9BQPa/uMV3kXEdIA9Nf
	 HR5lHCtC8BBLUFV/qP/6bLAIoivqYLM7tZbk5BvA=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.228.63])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id 5E14AFF; Thu, 12 Jun 2025 23:01:30 +0800
X-QQ-mid: xmsmtpt1749740490t2u8huf6d
Message-ID: <tencent_AB76B566A43C5B37A4961637CC4ABC745909@qq.com>
X-QQ-XMAILINFO: OKKHiI6c9SH3MjZSMJ8ZzVg3A4yKuY+Fh0bXnnd9SnitM3VSEBpNHHzd1H5K9j
	 vRcsWRVbaxJ84ASFm4kgxjW15FDt9e5J19/Mqgfr7+Vyt7WzCnjOIbCmCpH/p5fOhCT9ctoxSX/s
	 y4szANZJtd73MLGRTa5K7WMYSoNmjhLJ5Ng6DeMWk8eUorb76c5R3lQFERe7Xi9sBvHnvMsJ0t3G
	 uP86NTNSHl2fGValG2kP3cUbsOyh75qll5s2FPyip//UGttNmDENUW7jhjw7zbPRfDMmq4Cn8RRV
	 uAHw5+X1Ku8etZNPAhAVUIHX2EmdwlhGxe86boPauRqLqmKmMfkoi3974Z1U3P66qdw9ykROHGtD
	 Di5/bdIeJfwnB4IwKkrDef7F8PxK8J5z1CizDtWjfyajAhLfSkQxxLmgRqh52mhviuHKVmbMPbZA
	 GKQ2D1Z9esBpsB5DkRBTLUMNxJGcf2Y3FPNAQ20ADqxw97w1vMn69HSqx9FB567DJasxFN3Iben5
	 HVSYMrUO2JNGQKcH0lW2/1rNOjiUag807L7eTEGGxoX3XOvfJvS7Slw76RNvEfnGIMUu9IZw1jL6
	 rO7B01KwANuEUx/4dsPVb2TN47535fvK5pNI3+5rhom8TY261IEaeOFHeVeCMnJdMiLInpiDK58A
	 IBrM7CSi23JDWdjT09nITFaSkCgNBQJmLnXwkR8lMtz6fFO9ymzIee24gUhZXTf7RFTkVEuA1cnX
	 Z6uHjpS+KHTyk/VM8B+X+M4kuUjbnRPYsYwKpzL/kFSyPr8qPHYShTp1L9D7bDCLh2hQwG++CHM0
	 3fc+BeJ80F7141KqxziU8wDTTcs3FeyB+e47nQtCZ9UkueTkFhUOMcYSWY4VrAPXbQ9hqWHInECK
	 lAbPjRa9hASP7JLjUSobVKr4p5iLMJHtSUwofwjvzhaB64k/Tf+/i1QWtdK3mC3Sk6d3T9ib533N
	 EqJY4mfsGPplLA4SKaZ/EmDuA5157y
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+4125590f2a9f5b3cdf43@syzkaller.appspotmail.com
Cc: amir73il@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	stephen.smalley.work@gmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] fs/xattr: reset err to 0 after get security.* xattrs
Date: Thu, 12 Jun 2025 23:01:30 +0800
X-OQ-MSGID: <20250612150129.2783900-2-eadavis@qq.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <6828591c.a00a0220.398d88.0248.GAE@google.com>
References: <6828591c.a00a0220.398d88.0248.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After successfully getting "security.SMACK64", err is not reset to 0, which
causes simple_xattr_list() to return 17, which is much smaller than the
actual buffer size..

After updating err to remaining_size, reset err to 0 to avoid returning an
inappropriate buffer size.

Fixes: 8b0ba61df5a1 ("fs/xattr.c: fix simple_xattr_list to always include security.* xattrs")
Reported-by: syzbot+4125590f2a9f5b3cdf43@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4125590f2a9f5b3cdf43
Tested-by: syzbot+4125590f2a9f5b3cdf43@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xattr.c b/fs/xattr.c
index 8ec5b0204bfd..600ae97969cf 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1479,6 +1479,7 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 		buffer += err;
 	}
 	remaining_size -= err;
+	err = 0;
 
 	read_lock(&xattrs->lock);
 	for (rbp = rb_first(&xattrs->rb_root); rbp; rbp = rb_next(rbp)) {
-- 
2.43.0

