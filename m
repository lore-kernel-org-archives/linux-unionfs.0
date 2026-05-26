Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5512D351C3B;
	Tue, 26 May 2026 08:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779785927; cv=none; b=fZQOWFtvvf84KllDGlWmDZ3tXN0M6g/1LSX2RwneVH/HLo52tSo3QKlEJB6nDzh3cJ841GEcq2ifV1jh/avLXaay+BY7NNkUiYbGfV4FWsSeDVjsMBl/bcVJlMZeP77YuO+07S5vWS9cyENwI9mpurlx6Yhgqik22kJ+f0KdyRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779785927; c=relaxed/simple;
	bh=od5dhZSUsua+wQE38Q2bCQ8eWHM+Q5TcYMMD2DW6rmk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EB06S/xtXDgU4oHbxk9TOvf4b8oUo6emalVJmxKbX4yAOq7G7mx3xVM2aDhPHbfnqTfrDTadfR3ZB6XTgDvliJkT6vTPrppjw/a3M5NpRnwSGq/3CFX0Dp3hS1J9dz47UDuj+U4IP6UaJXlWwubXTvJCAMwUzfQFfeSs3UzCUbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1149883658e111f1aa26b74ffac11d73-20260526
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5fce18ef-c972-40f3-8e8b-6cd024542147,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:5fce18ef-c972-40f3-8e8b-6cd024542147,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:b24d57ed498504768261efb10e71d5ed,BulkI
	D:260526165832GZCGH9DJ,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1149883658e111f1aa26b74ffac11d73-20260526
X-User: liwang@kylinos.cn
Received: from computer.. [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <liwang@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 791235121; Tue, 26 May 2026 16:58:30 +0800
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
Subject: [PATCH] backing-file: fix backing_file_open() kerneldoc parameter
Date: Tue, 26 May 2026 16:58:01 +0800
Message-Id: <20260526085801.81187-1-liwang@kylinos.cn>
X-Mailer: git-send-email 2.34.1
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
Also fix the "reuqested" typo in the old comment.

Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/backing-file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 1f3bbfc75882..a530c2d19d20 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -18,13 +18,14 @@
 
 /**
  * backing_file_open - open a backing file for kernel internal use
- * @user_path:	path that the user reuqested to open
+ * @user_file:	file the user opened on the stackable filesystem
  * @flags:	open flags
  * @real_path:	path of the backing file
  * @cred:	credentials for open
  *
  * Open a backing file for a stackable filesystem (e.g., overlayfs).
- * @user_path may be on the stackable filesystem and @real_path on the
+ * The user_path (taken from @user_file->f_path) may be
+ * on the stackable filesystem and @real_path on the
  * underlying filesystem.  In this case, we want to be able to return the
  * @user_path of the stackable filesystem. This is done by embedding the
  * returned file into a container structure that also stores the stacked
-- 
2.34.1

