Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793289321;
	b=iDqWGL4ORBEQy8f7Qo0BS3q4W8wxkf/Lld8dnA5QBYSdsqe6XMzV3lnWTziRzjtrQzvU
	 S9sx2Q3oK8kfQap7Tm6jYxgafri/5EikikD/HNw/aCL171hxuzFFnFQ8efCPeoh8VWhB2
	 OFrbIrbT8xeFNxjUohs38LkQEPvyVQTxfGb76VP/s/wFdDV1U3Yj0ePpnWPdXjeVaGSD4
	 PJ0vfJj5HNwABIGgFRKy5EFyCltkN6J27WajtJsK9ZiaWPoGzj/UZNlWucr7tZdEp9eVr
	 hp6Z0acbtQIieNyC1/NZf+tY7puhDIzMUT/ScnfxlR0EZ/d4p0COFTzE3pKyhnO3Gfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793289321;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-RootMTR:X-EPHeader:X-CMS-RootMailID:References;
	bh=ou5xTWnBV4IN8d+IMd9GAiVukG3GtoBdPbXbect3Eic=;
	b=qUgKNAiMaypAoMcQsxWwQBvX07AbWN5XFLcR8+6MkFIi5KtirIhKbZ5Ju5HJ/ZL0K9XH
	 7sdsZdgJKSsbySlkRBsiD67jTOmILLxzlKJEReYC0amkABfW9nTG3TML07158OR9kTSU8
	 jr3HV/wFvwY7VI+1bksFvIYJRS0sRG1dv1yd97JwjonynJfq21mRaN2wSLCrTmUleX4Y4
	 i2N1FSmN/rxQGf4FE4jyXsVMaEuHVWr93efZQUFjNNa5qlDIOGdjpFQeGKaM2NlF/up27
	 hUU6yTHBKPQWNgW677LGmyc35BF+pJmFhHvDjTgNQ+JTYfgTqZ99GcItXXV+VPkPWvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nL4x2PA8;
	arc=none smtp.remote-ip=210.118.77.11
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B5E606A31C
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 15:55:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68B5E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nL4x2PA8
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261029155517euoutp01328dd1afb6a42e2993a226b4988c6ff6~jCyIRDJKl3227832278euoutp01L
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 15:55:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261029155517euoutp01328dd1afb6a42e2993a226b4988c6ff6~jCyIRDJKl3227832278euoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793289317;
	bh=ou5xTWnBV4IN8d+IMd9GAiVukG3GtoBdPbXbect3Eic=;
	h=From:To:Cc:Subject:Date:References:From;
	b=nL4x2PA8l2G1PO47jroQ4w1feEx3uKYifRJ0PABquDh6ARmN+BcH5zbxZSMUTduvi
	 R1n9+CxS+v0PWMkqPW2G3vqlH17SKqV/c0+wX7Ua+9PEPxiZ1jXyMB5Hqe0s8TM2iT
	 CCQsv4P2hlNcQig261CMa7lrrZo53dtwQZBVoPrk=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261029155517eucas1p25b05b501c3f6a8c9b58c145898f6e76e~jCyH7dGSK3165531655eucas1p2J;
	Thu, 29 Oct 2026 15:55:17 +0000 (GMT)
Received: from AMDC4817.eu.corp.samsungelectronics.net (unknown
	[106.120.51.132]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261029155516eusmtip174458744fa8f16b95384d9440e432d5d~jCyHUDtKN0633306333eusmtip1S;
	Thu, 29 Oct 2026 15:55:16 +0000 (GMT)
From: Mateusz Moscicki <m.moscicki2@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Mateusz Moscicki <m.moscicki2@samsung.com>, Paul Moore
	<paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn"
	<serge@hallyn.com>, Roberto Sassu <roberto.sassu@huawei.com>, Miklos Szeredi
	<miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
	Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH] smack: do not override the subject label in overlayfs hooks
Date: Thu, 29 Oct 2026 16:54:22 +0100
Message-Id: <20261029155422.578322-1-m.moscicki2@samsung.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261029155517eucas1p25b05b501c3f6a8c9b58c145898f6e76e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261029155517eucas1p25b05b501c3f6a8c9b58c145898f6e76e
X-EPHeader: CA
X-CMS-RootMailID: 20261029155517eucas1p25b05b501c3f6a8c9b58c145898f6e76e
References: <CGME20261029155517eucas1p25b05b501c3f6a8c9b58c145898f6e76e@eucas1p2.samsung.com>

Overlayfs performs operations on the upper, lower and work directories
with the credentials of the mounter and uses the inode_copy_up() and
dentry_create_files_as() hooks only to let the LSM choose the label of
the inode it is about to create. Smack implemented both hooks by
replacing smk_task in the override credentials, so the label of the
copied file, or of the transmuting directory, became the subject of all
access checks done in the underlying filesystems on behalf of overlayfs:
the lookup and creation of the temporary inode in the workdir, the
rename into the upper directory, setting the overlay xattrs.

Unless that label happens to have access to the workdir and upper
directories, or is allowed to use CAP_MAC_OVERRIDE, these operations
fail with EACCES:

  lsm=SMACK fn=smack_inode_permission action=denied subject="somelabel"
    object="<mounter label>" requested=x ... name="work"

With onlycap configured this makes copy-up and creation in transmuting
directories fail for every label not listed there, and a file labeled
"*" can never be copied up at all, as a "*" subject is not granted
access to anything.

Keep smk_task untouched and store the label the new inode should get in
a new task_smack field, smk_create, consumed by
smack_inode_alloc_security() and smack_inode_init_security(). This is
the same split SELinux uses with create_sid. Labels assigned to new and
copied up inodes do not change; only the subject of the access checks
done on behalf of overlayfs does, and it is now the mounter, as it is
for DAC. The transmute handling added in commit 2c085f3a8f23 ("smack:
Record transmuting in smk_transmuted") is preserved: smk_transmuted is
compared against smk_create.

Outside overlayfs smk_create is never set, so there is no behaviour
change there.

Fixes: d6d80cb57be4 ("Smack: Base support for overlayfs")
Signed-off-by: Mateusz Moscicki <m.moscicki2@samsung.com>
---
The analysis, the patch and the reproducer below were drafted with the
help of Claude Code (Claude Opus 5.5 / Fable 5.1) and then reviewed,
adjusted and tested by me. Tested before and after the change on a
6.12-based kernel on Raspberry Pi 4 and on linux-next (next-20261028).

Reproducer (needs root and setfattr/getfattr). The bug only shows when
the override credentials cannot use CAP_MAC_OVERRIDE, so the script
sets onlycap to the mounter's label for its duration if it is empty.
Before the fix both checks print FAIL with EACCES and Smack reports
"subject=somelabel object=<mounter label> requested=x" on the workdir;
after the fix both print SUCCESS:

  #!/bin/sh
  # overlayfs + Smack: copy-up and create run with the label of the copied file
  # or of the transmuting directory instead of the mounter's label.
  # Run as root. onlycap must be set, otherwise CAP_MAC_OVERRIDE of the
  # mounter hides the bug; if it is empty, it is set for the duration of
  # the test and cleared afterwards.
  ME=$(cat /proc/self/attr/current)
  OC=$(cat /sys/fs/smackfs/onlycap)
  [ -z "$OC" ] && echo "$ME" > /sys/fs/smackfs/onlycap
  D=/tmp/ovltest
  rm -rf $D; mkdir -p $D/lower/dir $D/upper $D/work $D/merged
  echo x > $D/lower/file
  setfattr -n security.SMACK64 -v somelabel $D/lower/file
  setfattr -n security.SMACK64 -v somelabel $D/lower/dir
  setfattr -n security.SMACK64TRANSMUTE -v TRUE $D/lower/dir
  echo "$ME somelabel rwxat" > /sys/fs/smackfs/load2
  mount -t overlay overlay \
  	-o lowerdir=$D/lower,upperdir=$D/upper,workdir=$D/work $D/merged
  
  if echo y >> $D/merged/file; then
  	echo "copy-up of 'somelabel' file: SUCCESS"
  else
  	echo "copy-up of 'somelabel' file: FAIL"
  fi
  if touch $D/merged/dir/new; then
  	l=$(getfattr -n security.SMACK64 --only-values --absolute-names \
  		$D/merged/dir/new)
  	echo "create in transmuting dir:   SUCCESS (new file labeled '$l')"
  else
  	echo "create in transmuting dir:   FAIL"
  fi
  
  umount $D/merged; rm -rf $D
  echo "$ME somelabel -" > /sys/fs/smackfs/load2
  [ -z "$OC" ] && echo - > /sys/fs/smackfs/onlycap

 security/smack/smack.h     |  1 +
 security/smack/smack_lsm.c | 42 +++++++++++++++++++++++++++-----------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index deb2ef31b63a4..456f282acc251 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -121,6 +121,7 @@ struct task_smack {
 	struct smack_known	*smk_task;	/* label for access control */
 	struct smack_known	*smk_forked;	/* label when forked */
 	struct smack_known	*smk_transmuted;/* label when transmuted */
+	struct smack_known	*smk_create;	/* label for new inodes */
 	struct list_head	smk_rules;	/* per task access rules */
 	struct mutex		smk_rules_lock;	/* lock for the rules */
 	struct list_head	smk_relabel;	/* transit allowed labels */
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index c243adb137402..7bd63005e9631 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -965,6 +965,19 @@ static int smack_bprm_creds_for_exec(struct linux_binprm *bprm)
  * Inode hooks
  */
 
+/**
+ * smk_of_create - the label new inodes get
+ * @tsp: the task security blob
+ *
+ * Overlayfs sets smk_create in smack_inode_copy_up() and
+ * smack_dentry_create_files_as(), while smk_task stays
+ * the mounter's label used for access control.
+ */
+static struct smack_known *smk_of_create(const struct task_smack *tsp)
+{
+	return tsp->smk_create ? tsp->smk_create : tsp->smk_task;
+}
+
 /**
  * smack_inode_alloc_security - allocate an inode blob
  * @inode: the inode in need of a blob
@@ -973,7 +986,7 @@ static int smack_bprm_creds_for_exec(struct linux_binprm *bprm)
  */
 static int smack_inode_alloc_security(struct inode *inode)
 {
-	struct smack_known *skp = smk_of_current();
+	struct smack_known *skp = smk_of_create(smack_cred(current_cred()));
 
 	init_inode_smack(inode, skp);
 	return 0;
@@ -1030,6 +1043,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 				     struct xattr *xattrs, int *xattr_count)
 {
 	struct task_smack *tsp = smack_cred(current_cred());
+	struct smack_known *skp = smk_of_create(tsp);
 	struct inode_smack * const issp = smack_inode(inode);
 	struct smack_known *dsp = smk_of_inode(dir);
 	int rc = 0;
@@ -1051,12 +1065,12 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	 * If equal, transmuting already occurred in
 	 * smack_dentry_create_files_as(). No need to check again.
 	 */
-	trans_cred = (tsp->smk_task == tsp->smk_transmuted);
+	trans_cred = (skp == tsp->smk_transmuted);
 	if (!trans_cred)
-		trans_rule = smk_rule_transmutes(smk_of_task(tsp), dsp);
+		trans_rule = smk_rule_transmutes(skp, dsp);
 
 	/*
-	 * In addition to having smk_task equal to smk_transmuted,
+	 * In addition to having smk_create equal to smk_transmuted,
 	 * if the access rule allows transmutation and the directory
 	 * requests transmutation then by all means transmute.
 	 * Mark the inode as changed.
@@ -4974,11 +4988,13 @@ static int smack_inode_copy_up(struct dentry *dentry, struct cred **new)
 	tsp = smack_cred(new_creds);
 
 	/*
-	 * Get label from overlay inode and set it in create_sid
+	 * Get label from overlay inode and set it in smk_create.
+	 * Keep smk_task, overlayfs accesses the underlying
+	 * filesystems with the mounter's credentials.
 	 */
 	isp = smack_inode(d_inode(dentry));
 	skp = isp->smk_inode;
-	tsp->smk_task = skp;
+	tsp->smk_create = skp;
 	*new = new_creds;
 	return 0;
 }
@@ -5004,10 +5020,12 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
 	struct inode_smack *isp;
 
 	/*
-	 * Use the process credential unless all of
-	 * the transmuting criteria are met
+	 * Label the new inode with the process label unless all of
+	 * the transmuting criteria are met. Keep smk_task, overlayfs
+	 * accesses the underlying filesystems with the mounter's
+	 * credentials.
 	 */
-	ntsp->smk_task = otsp->smk_task;
+	ntsp->smk_create = smk_of_create(otsp);
 
 	/*
 	 * the attribute of the containing directory
@@ -5020,9 +5038,9 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
 		 * providing access is transmuting use the containing
 		 * directory label instead of the process label.
 		 */
-		if (smk_rule_transmutes(otsp->smk_task, isp->smk_inode)) {
-			ntsp->smk_task = isp->smk_inode;
-			ntsp->smk_transmuted = ntsp->smk_task;
+		if (smk_rule_transmutes(ntsp->smk_create, isp->smk_inode)) {
+			ntsp->smk_create = isp->smk_inode;
+			ntsp->smk_transmuted = isp->smk_inode;
 		}
 	}
 	return 0;
-- 
2.34.1

