Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B833BD22C;
	Thu, 28 May 2026 10:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779964982; cv=none; b=Rkj1MWPg9qXGlZPFb+JDy9+7ao9M1kvY52uR/09XPWKiFZppm1NlHXJ2JFKJ61D1meSmVZ9dfvaN+WXbMfr9aMGyXhYd5+ibUC/sL3sl8Yl1a4V5Ezyv2EFjjfHOM8UXMWDUv0zPtNx1+lK8tU4K85wpSY2Ca9eJVns6qowWU/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779964982; c=relaxed/simple;
	bh=tcZXhy2Pk08not35yEB5KZPgtgO9Lo4MHOuRJ4uiRAc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RcJ1S5082/EFPjRDp7ONgSZJCOpIDd+Bg8S9IeP3EdH2U6eJOYPnTSt8qVHnFL9NNgiOYXadG7BhBsBOnSeocg9s/whZnMJIqYQyHeAZbf5rVoqrZzoUL7EXdSay5EuL8F0lgV1DcwxZ+uZ/aDkUeBM9kych1wqdFTx2YTCBf94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: f3f856165a8111f1aa26b74ffac11d73-20260528
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:874fc547-e7f4-41a7-9b9e-eaba7b9ec53e,IP:10,
	URL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-10
X-CID-INFO: VERSION:1.3.12,REQID:874fc547-e7f4-41a7-9b9e-eaba7b9ec53e,IP:10,UR
	L:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:-10
X-CID-META: VersionHash:e7bac3a,CLOUDID:272b8f2804d092ffd81c63030757381c,BulkI
	D:2605281842435D4L3CGM,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|865|898,TC:nil,Content:0|15|50,EDM:1|19,IP:-2,URL:0,File:nil,RT:nil,
	Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f3f856165a8111f1aa26b74ffac11d73-20260528
X-User: liwang@kylinos.cn
Received: from computer.. [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <liwang@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1361279345; Thu, 28 May 2026 18:42:41 +0800
From: Li Wang <liwang@kylinos.cn>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li Wang <liwang@kylinos.cn>
Subject: [PATCH v2] backing-file: fix backing_file_open() kerneldoc parameter
Date: Thu, 28 May 2026 18:42:08 +0800
Message-Id: <20260528104208.395757-1-liwang@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526085801.81187-1-liwang@kylinos.cn>
References: <20260526085801.81187-1-liwang@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kerneldoc for backing_file_open() documented a @user_path argument,
but the function takes const struct file *user_file. The user
path is derived as &user_file->f_path.

Update the @-tag to @user_file and adjust the description accordingly.
Also fix the "reuqested" typo to 'requested' in the old comment.

Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/backing-file.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 1f3bbfc75882..080c99696cd0 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -18,17 +18,18 @@
 
 /**
  * backing_file_open - open a backing file for kernel internal use
- * @user_path:	path that the user reuqested to open
+ * @user_file:  file the user requested to open
  * @flags:	open flags
  * @real_path:	path of the backing file
  * @cred:	credentials for open
  *
  * Open a backing file for a stackable filesystem (e.g., overlayfs).
- * @user_path may be on the stackable filesystem and @real_path on the
- * underlying filesystem.  In this case, we want to be able to return the
- * @user_path of the stackable filesystem. This is done by embedding the
- * returned file into a container structure that also stores the stacked
- * file's path, which can be retrieved using backing_file_user_path().
+ * @user_file->f_path may be on the stackable filesystem and @real_path
+ * on the underlying filesystem. In this case, we want to be able to
+ * return the path of the stackable filesystem. This is done by
+ * embedding the returned file into a container structure that also
+ * stores the stacked file's path, which can be retrieved using
+ * backing_file_user_path().
  */
 struct file *backing_file_open(const struct file *user_file, int flags,
 			       const struct path *real_path,
-- 
2.34.1

