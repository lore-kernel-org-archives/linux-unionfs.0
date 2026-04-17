Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B181347520
	for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2026 08:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776415092; cv=none; b=CBiI3xnbIzWx8Aif4cVyYqxXmubqtM53n17ONyQe27/R4u9LfUGUld4MBbEZKd1Hi0B6BwPRNAkBzhX0yWG0YWkBH7Gd7efXBUCsbklFeqsDUZFRoiFUxUVdbeW1ruyRC/wc/194u+4qEYQmPAwCGeZVULB6GLjneJpzoa2e72o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776415092; c=relaxed/simple;
	bh=xvhZVhoX6KIDvZU6Mrny3lXApf4u6vNLedbRcTOP/J0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p3e6Y9X1o+2itTATs+akulw6WY8xYLrvHfWeghRUwjzIFMM8oDdlMWEjbfvkAHzZDKI4Y5STITHRYPRM6YlJm6fFwfXaCD5X/oxTDOy/8APqdwrLJU2dvCECmUQKvsx6CAQ5GHvORz1OKZuCArr+G6KKkbmwG0yDvAcyiWLEpeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c047b2623a3811f1aa26b74ffac11d73-20260417
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:71a07ffe-bb2b-426a-9372-011c7d7a4b4e,IP:20,
	URL:0,TC:0,Content:0,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-10
X-CID-INFO: VERSION:1.3.12,REQID:71a07ffe-bb2b-426a-9372-011c7d7a4b4e,IP:20,UR
	L:0,TC:0,Content:0,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-10
X-CID-META: VersionHash:e7bac3a,CLOUDID:66d95dbbd9a1ef649fd87880fe00ccd7,BulkI
	D:260417163805SN32CEZA,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	898,TC:nil,Content:0|15|50,EDM:2,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c047b2623a3811f1aa26b74ffac11d73-20260417
X-User: cuitao@kylinos.cn
Received: from ctao-book.. [(183.242.174.21)] by mailgw.kylinos.cn
	(envelope-from <cuitao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2033254324; Fri, 17 Apr 2026 16:38:04 +0800
From: cuitao <cuitao@kylinos.cn>
To: miklos@szeredi.hu,
	amir73il@gmail.com,
	linux-unionfs@vger.kernel.org
Cc: cuitao <cuitao@kylinos.cn>
Subject: [PATCH] ovl: skip ovl_file_modified() for dedupe operations
Date: Fri, 17 Apr 2026 16:37:36 +0800
Message-ID: <20260417083736.95117-1-cuitao@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DEDUPE only compares data blocks between two files without modifying
file_out, so there is no need to call ovl_file_modified() to sync
attributes from the real inode. This aligns with the existing
guard at the top of ovl_copyfile() which already skips copyattr
and file_remove_privs for OVL_DEDUPE.

Signed-off-by: cuitao <cuitao@kylinos.cn>
---
 fs/overlayfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 27cc07738f33..f1829f425f45 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -572,7 +572,8 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	}
 
 	/* Update size */
-	ovl_file_modified(file_out);
+	if (op != OVL_DEDUPE)
+		ovl_file_modified(file_out);
 
 out_unlock:
 	inode_unlock(inode_out);
-- 
2.43.0

