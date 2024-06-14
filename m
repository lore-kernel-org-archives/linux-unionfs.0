Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC83163;
	Fri, 14 Jun 2024 01:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718327132; cv=none; b=EClCJiut20856YccMVDaWtmL5rwKWpNFA0FlOiquQLmSw+ZsAFGvgO9Bu89zqLHhlaFiPH3WDRWYjukYJhH7DMBWfrvy1VQS6jXadgIamJJTUOgF9RoATTmn9iLulxMvGDd/jn9gN1IVTpJbEqU2JsUCw7OPJcJEt5uOYvw8Ldw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718327132; c=relaxed/simple;
	bh=PekTB8wWNvrnCvP2P/JIrxw9nxaknXwMDBljbAjXfyE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GBaCqrRobnuU852VaNknIuGiqvpvvwKRqoTmOrDcFxij5HAPpm/ZgXe79SHlC1Y17vDNBvBVcuWWyw5L7B/raF4RzqYIbzmN8JInvQHWH3Ebvgwjyvx+NnE9cj+2LLq3Ac8H65jHRKyz6Q8FHJSAEPGZma7VvXYDVB4gBjVSr8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E0Ujcl028810;
	Fri, 14 Jun 2024 01:05:26 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yme965jrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 14 Jun 2024 01:05:25 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 18:05:24 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Thu, 13 Jun 2024 18:05:22 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+b778ac10fe2a0cd72517@syzkaller.appspotmail.com>
CC: <amir73il@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-unionfs@vger.kernel.org>, <miklos@szeredi.hu>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH] ovl: avoid deadlock in ovl_create_tmpfile
Date: Fri, 14 Jun 2024 09:05:22 +0800
Message-ID: <20240614010522.2261016-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <000000000000871190061acd8fed@google.com>
References: <000000000000871190061acd8fed@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: BhpMO5as8WEAVXN-nnT_laXPQq3yOLaw
X-Proofpoint-ORIG-GUID: BhpMO5as8WEAVXN-nnT_laXPQq3yOLaw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 adultscore=0 spamscore=0 suspectscore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=679 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2405170001 definitions=main-2406140003

ovl_copy_up() will retrieve sb_writers, and ovl_want_write will also retrieve
sb_writers, adjusting the order of their execution to avoid deadlocks.

Reported-by: syzbot+b778ac10fe2a0cd72517@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/overlayfs/dir.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 116f542442dd..ab65e98a1def 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1314,10 +1314,6 @@ static int ovl_create_tmpfile(struct file *file, struct dentry *dentry,
 	int flags = file->f_flags | OVL_OPEN_FLAGS;
 	int err;
 
-	err = ovl_copy_up(dentry->d_parent);
-	if (err)
-		return err;
-
 	old_cred = ovl_override_creds(dentry->d_sb);
 	err = ovl_setup_cred_for_create(dentry, inode, mode, old_cred);
 	if (err)
@@ -1360,6 +1356,10 @@ static int ovl_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 	if (!OVL_FS(dentry->d_sb)->tmpfile)
 		return -EOPNOTSUPP;
 
+	err = ovl_copy_up(dentry->d_parent);
+	if (err)
+		return err;
+
 	err = ovl_want_write(dentry);
 	if (err)
 		return err;
-- 
2.43.0

