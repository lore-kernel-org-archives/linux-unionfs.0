Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432EE13B593
	for <linux-unionfs@vger.kernel.org>; Fri, 16 Aug 2024 06:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723790041; cv=none; b=lv31wEZxvrXb2V427ItrnHiIW9SUdgsqQeCT06ZWrUS46VOHCn9Cdf5KsKPxd69tIlTAAI2RaUQ2gdWsT1C/tJsSUiRK6OlJ+uhxkf7VmeSiqB06zgldfoD4j6Z8HMrk9JSkxqgheLou5PvLoiyS4w+DqiqK/VU06BV0UgLLXCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723790041; c=relaxed/simple;
	bh=Kr+jm4mN/Vr7IFiZT+edpsmEiHcead1/YTvqlgVdMGc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RqtNLMxZugzOFsAC/s9qZZXGMTttv3xqiKmsCX7e3M7d7q0nnGiizVJq1MKQQ7o1rkTowJXp7+mQfbcdh0Pe5otpHOjQFuvaFIIbzJ/fkDRvAFase9dYyjho8GUZxFWiohrcJ/OM6D5+m9OhMgaU//oGZtVOt9c6eNSfgodBX8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WlXBj1Fn7z2CmNC
	for <linux-unionfs@vger.kernel.org>; Fri, 16 Aug 2024 14:29:01 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 841D1180019
	for <linux-unionfs@vger.kernel.org>; Fri, 16 Aug 2024 14:33:55 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 16 Aug
 2024 14:33:55 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next] ovl: Use in_group_or_capable() helper to simplify the code
Date: Fri, 16 Aug 2024 14:41:00 +0800
Message-ID: <20240816064100.1993219-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Since in_group_or_capable has been exported, we can use
it to simplify the code when check group and capable.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/overlayfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 35fd3e3e1778..a0692595a5d6 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -554,8 +554,8 @@ int ovl_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	 * be done with mounter's capabilities and so that won't do it for us).
 	 */
 	if (unlikely(inode->i_mode & S_ISGID) && type == ACL_TYPE_ACCESS &&
-	    !in_group_p(inode->i_gid) &&
-	    !capable_wrt_inode_uidgid(&nop_mnt_idmap, inode, CAP_FSETID)) {
+	    !in_group_or_capable(&nop_mnt_idmap, inode,
+				 i_gid_into_vfsgid(&nop_mnt_idmap, inode))) {
 		struct iattr iattr = { .ia_valid = ATTR_KILL_SGID };
 
 		err = ovl_setattr(&nop_mnt_idmap, dentry, &iattr);
-- 
2.34.1

