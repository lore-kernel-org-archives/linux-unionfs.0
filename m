Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1C44C9A;
	Mon, 18 Nov 2024 14:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731939430; cv=none; b=LpvXHFzDs6kYyLnF6/nMgbq/8U7J9gwaHm+Ql7QcScA86ee0de+RSkGYBHxf7MbXdPm7WMQn6eCcerJXwqcIaVoY0imKly3J4qtPBwH+C3ZQQr2ctvPewhClU40aN/JPZzjYFmuy5+fJ9zYjSfSilLTToHVrLaeFs0/U4q7Hdfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731939430; c=relaxed/simple;
	bh=tLPXuwrtHEr7Ap2XWyChz3+t0t0TRiE19UKcmBNrvYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iEN69tn7cQqS2PBCc+6KZxgzgsPe03StLef/wmhUr8c4Y6TgAhDmUZpt62O2PfkkyGl24tKXJsofXpxCzi6AXrByMPpJ/y8y49CdpL5/VIOFqfzGgwPyak1Q7UluxFFHEwrCuwjbyMkcS43XCAaJqe73wosdvqwAoE1xXdMfHbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.malta.altlinux.ru (obninsk.basealt.ru [217.15.195.17])
	by air.basealt.ru (Postfix) with ESMTPSA id A9C7F233CF;
	Mon, 18 Nov 2024 17:17:03 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kovalev@altlinux.org
Subject: [PATCH] ovl: Add check for missing lookup operation on inode
Date: Mon, 18 Nov 2024 17:17:03 +0300
Message-Id: <20241118141703.28510-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ensure that the lookup operation is present for the inode in the overlay
filesystem. If the operation is missing, log a warning and return an EIO
error to prevent further issues in the lookup process.

Reported-by: syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=a8c9d476508bd14a90e5
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 fs/overlayfs/namei.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 5764f91d283e7..a73f37e401cf0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1115,6 +1115,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	for (i = 0; !d.stop && i < ovl_numlower(poe); i++) {
 		struct ovl_path lower = ovl_lowerstack(poe)[i];
 
+		if (!lower.dentry->d_inode->i_op->lookup) {
+			err = -EIO;
+			pr_warn_ratelimited("missing lookup operation for inode %p\n",
+								lower.dentry->d_inode);
+			goto out_put;
+		}
+
 		if (!ovl_redirect_follow(ofs))
 			d.last = i == ovl_numlower(poe) - 1;
 		else if (d.is_dir || !ofs->numdatalayer)
-- 
2.33.8

