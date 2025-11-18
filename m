Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D152122422A;
	Tue, 18 Nov 2025 02:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763434125; cv=none; b=BOrwEnS03EhZUancdgIakYRs0c05ODcPK8ckl/rK5OVZMTG/XcqQFvmvRnKOHm8OzEp6HIN0Ok6McnAVyMnjkYgs0yA6ehPiPaMcDON8lPwAsfT75ua7K+FJLxuiewiBeZg/CJOWW9vfG4R5Dx2kGBMgw/ooXAACxfZ17a+pdtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763434125; c=relaxed/simple;
	bh=IF7tXxjfJnJ7UP8snUq6Fu9sE62VSH0RBbQy7nJpU/E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cA07+6U/0jUZ+GBWcHuTvTBLQpDiizCMP+aEXjTAvOXgH8ipdzed9aZKh3faHa389wfdTLBQqmusAlnqFpzKUU7K+d+Xi5O47XEc+yVgTVY23T0FkrNNTAxbyVNX+igbrZp1awnMtcQMSu4guXoUKYBsTDb0WPZg5La25pSf8f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-01 (Coremail) with SMTP id qwCowABH3MuF3htpXYcdAQ--.19816S2;
	Tue, 18 Nov 2025 10:48:37 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] ovl: remove unneeded semicolon
Date: Tue, 18 Nov 2025 10:48:00 +0800
Message-Id: <20251118024800.701780-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABH3MuF3htpXYcdAQ--.19816S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZFWDuF4rXw43GFyUtF45Awb_yoW3JFc_Cr
	1vy3yvkFZ8JFs8Kr13AFsYvrnak348CF4S9w4xta1UA390g345Z3WvvFsxXr9FvryFqF9x
	u3s7Kry2934YgjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbsAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1lc2xSY4AK67AK6r4UMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
	UI43ZEXa7VUjAwIDUUUUU==
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Remove unnecessary semicolons reported by Coccinelle/coccicheck and the
semantic patch at scripts/coccinelle/misc/semicolon.cocci.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/overlayfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index d21f81a524f6..7c2407b8c3a4 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -105,7 +105,7 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 			whiteout = dget(link);
 		end_creating(link);
 		if (!err)
-			return whiteout;;
+			return whiteout;
 
 		if (err != -EMLINK) {
 			pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%u)\n",
-- 
2.25.1

