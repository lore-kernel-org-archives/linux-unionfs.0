Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C34478841;
	Thu, 24 Sep 2026 11:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249379; cv=none; b=pnFK4LQBPXNOeMCg+OptLJP34BUIU93NbfIz0tYafPgUhi8jvfiKezjn659LPu0IhOl+PkZUl6qOrUd3YLGThhSnaijRPuu7YRNHYTHzg00czQy3G+qOvoXVCKRSf/Gb2l9lju8E+5NrPYGItGdW9lsfbjCOY8S2i8XQwzUWEpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249379; c=relaxed/simple;
	bh=cTQ/2eZjIQwqjadvItCkwF2c8q3BkQ/WyvLBXCtwGeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sx2E3TBalyQYsghFI1yTbDAAtwx3eFJUcdcQozMUddBd02nZKTYMMof+JLUOrkNxm4BN4fHAz3DByEBaCamQL4dyeP9NOUoiR/ry3+nkqNSVyFRbEDKpkpVxWvYRSruPRw6i4VyAQrXtBa/BTNTWBkbzTqeLJmrEOs2vgDFEpkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gieXQlXC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gieXQlXC"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5bSj41372161;
	Thu, 24 Sep 2026 11:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=sct5go4yjxa4anaqa
	XcfQq/nsAbN5Wkf2EPye1AsD4k=; b=gieXQlXCEtx59XvCNg+ET0MFxLpGogH+E
	WwTWbF7/x04irvk3FPsYg7Mi/zRCV6yKYijpkpFtpvUbSWUQGhCxMx/N1obQLrwQ
	Kq7NvNr3IlhDmAN+yFZnmjapouCNs5igKDIA3+8SYVPL38lQvZMh5nROW9S2A6SU
	7mr/eLbt5hfFTE5tWQQnezyHRoMxAVn6ROUmzCpJoY6f/QTvuqacLdrjfObMOHNz
	qLr8bm8htR/MZ/hscKbGXgML+wnOJhvyXZEENgfKOOcgyeDlssbdfQLxWuCm6J32
	aSJRPLRyUEC0ifrB7Xqisvz5YLXikf/JeB5o+vypfWs5FaZgEjtbQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskdvfxyw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 11:29:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68OAGC6V212340;
	Thu, 24 Sep 2026 11:29:13 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvu7e9n1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 11:29:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68OBTB5v52297992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Sep 2026 11:29:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 713292004B;
	Thu, 24 Sep 2026 11:29:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47C0920040;
	Thu, 24 Sep 2026 11:29:09 +0000 (GMT)
Received: from macbookpro.bl1-in.ibm.com (unknown [9.123.4.160])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 24 Sep 2026 11:29:09 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        shuah@kernel.org, linux-unionfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Disha Goel <disgoel@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ovl: fix wrong layer paths in mountinfo for detached mount FDs
Date: Thu, 24 Sep 2026 16:58:58 +0530
Message-ID: <20260924112858.51392-2-disgoel@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20260924112858.51392-1-disgoel@linux.ibm.com>
References: <20260924112858.51392-1-disgoel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 3Bxw0xrIA-h95owRbQHmxzh6xn5NO73Z
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA0NiBTYWx0ZWRfX225SVgVjIrxp
 DFNjMGv2q8OaIHhCx/VdnShJ60qJrNhS38V+qDGKNViPz/zgXeVmQSqsQwLv5F7vA5KlR9B4Psw
 Hr0JIg+/bK9IAbUA90aWCWhoU4oeTH8=
X-Authority-Analysis: v=2.4 cv=FLiOVOos c=1 sm=1 tr=0 ts=6ab5098a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=7llKXxQ-FI7bIpSzk20A:9
X-Proofpoint-GUID: uxi6LhNeVDz08Jwy3Vxefi60aVlTfDN2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA0NiBTYWx0ZWRfXwn1Cz45L8PKv
 +rrsv8xNBY7VejdiUkiQDWXV6KdnKeBfqBG7DpR27EVeDeDTUt4VMKFcFjpPdQUry0VFlEREd7C
 S0g+tU+wwYWkznl+JD5/CEVG6FqXnfLaqG7PBywxXUkll5mx2CObl6UPS6HENm99aRF5dBJQVi9
 l7mJDjKdj1NR3SxTP3bnz6RKVF59FXpRbVVI/WUycBuxXtR2f9xhUkDKMbYcapbg3GcdNMfPyMz
 Gu5P02QVEXdHcEtLPTA+rHCWfnAk4hkXYsw0RNGj4qXnzy7ykG7FuMGz67Y9HNAzKsW4tIjL266
 zkO2zPOjOWM/NmJbzggYHyL7UmS5FFls/iLHNe4ooJ/26cHXwrziZtO3E84Kwc3waGl2CsUieA4
 VL1rgj4beIj/2vRTOP7eGJZC5CzOMtgoi11H7FDiNNxZJLWdk+OKDI1X699N6t67tmBOZLiWgL0
 e31S9u67iFOZDA+crmA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 phishscore=0 spamscore=0 clxscore=1011
 suspectscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240046

When overlayfs layers are passed as detached mount file descriptors
(opened with open_tree(OPEN_TREE_CLONE)), ovl_parse_layer() uses d_path()
to record the layer's path for display in mountinfo.

d_path() walks up the mount tree to the process's filesystem root.  For
detached mounts this walk stops at the anonymous namespace root instead
of the real system root, producing a short incorrect path like "/l1"
instead of the full absolute path.

Export mnt_is_anon() from fs/namespace.c to detect detached mounts.  In
ovl_parse_layer(), use dentry_path_raw() for detached mounts instead of
d_path().  dentry_path_raw() walks the dentry chain independent of mount
namespace and returns the correct fs-relative path.  The path is
display-only; the actual layer_path used for mounting is always correct.

Also fix the set_layers_via_detached_mount_fds selftest: the mountinfo
check strings were copy-pasted from the regular (non-detached) test and
expected absolute /tmp/ paths, causing the test to always fail.

Fixes: a08557d19ef4 ("ovl: specify layers via file descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
---
 fs/namespace.c                                |  9 ++++++++
 fs/overlayfs/params.c                         | 14 ++++++++++-
 include/linux/mount.h                         |  1 +
 .../overlayfs/set_layers_via_fds.c            | 23 +++++++++++--------
 4 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ae5dc64f8b45..9feefa0a517d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -363,6 +363,15 @@ bool __mnt_is_readonly(const struct vfsmount *mnt)
 }
 EXPORT_SYMBOL_GPL(__mnt_is_readonly);
 
+bool mnt_is_anon(struct vfsmount *mnt)
+{
+	struct mount *m = real_mount(mnt);
+	struct mnt_namespace *ns = READ_ONCE(m->mnt_ns);
+
+	return !IS_ERR_OR_NULL(ns) && is_anon_ns(ns);
+}
+EXPORT_SYMBOL_GPL(mnt_is_anon);
+
 static inline void mnt_inc_writers(struct mount *mnt)
 {
 #ifdef CONFIG_SMP
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index c93fcaa45d4a..2758ff8426b7 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -477,7 +477,19 @@ static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
 		layer_path = param->file->f_path;
 		path_get(&layer_path);
 
-		layer_name = d_path(&layer_path, buf, PATH_MAX);
+		/*
+		 * For detached mounts (open_tree(OPEN_TREE_CLONE)), d_path()
+		 * resolves against the anonymous namespace root and returns a
+		 * short fs-relative path rather than a full system path.  Use
+		 * dentry_path_raw() instead, which gives the path relative to
+		 * the filesystem root regardless of mount namespace.  The name
+		 * is display-only; layer_path itself is always correct.
+		 */
+		if (mnt_is_anon(layer_path.mnt))
+			layer_name = dentry_path_raw(layer_path.dentry,
+						     buf, PATH_MAX);
+		else
+			layer_name = d_path(&layer_path, buf, PATH_MAX);
 		if (IS_ERR(layer_name))
 			return PTR_ERR(layer_name);
 
diff --git a/include/linux/mount.h b/include/linux/mount.h
index acfe7ef86a1b..51e9f228c9d1 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -78,6 +78,7 @@ extern void mnt_make_shortterm(struct vfsmount *mnt);
 extern struct vfsmount *mnt_clone_internal(const struct path *path);
 extern bool __mnt_is_readonly(const struct vfsmount *mnt);
 extern bool mnt_may_suid(struct vfsmount *mnt);
+extern bool mnt_is_anon(struct vfsmount *mnt);
 
 extern struct vfsmount *clone_private_mount(const struct path *path);
 int mnt_get_write_access(struct vfsmount *mnt);
diff --git a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
index 7a293544233d..12d930fe46be 100644
--- a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
+++ b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
@@ -686,23 +686,28 @@ TEST_F(set_layers_via_fds, set_layers_via_detached_mount_fds)
 	while (getline(&line, &len, f_mountinfo) != -1) {
 		char *haystack = line;
 
-		if (strstr(haystack, "workdir=/tmp/w"))
+		/*
+		 * Detached mount FDs are resolved via dentry_path_raw(),
+		 * which gives a path relative to the underlying fs root
+		 * (e.g. "/u/upper", "/l1") rather than a full system path.
+		 */
+		if (strstr(haystack, "upperdir=/u/upper"))
 			layers_found[0] = true;
-		if (strstr(haystack, "upperdir=/tmp/u"))
+		if (strstr(haystack, "workdir=/u/work"))
 			layers_found[1] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l1"))
+		if (strstr(haystack, "lowerdir+=/l1"))
 			layers_found[2] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l2"))
+		if (strstr(haystack, "lowerdir+=/l2"))
 			layers_found[3] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l3"))
+		if (strstr(haystack, "lowerdir+=/l3"))
 			layers_found[4] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l4"))
+		if (strstr(haystack, "lowerdir+=/l4"))
 			layers_found[5] = true;
-		if (strstr(haystack, "datadir+=/tmp/d1"))
+		if (strstr(haystack, "datadir+=/d1"))
 			layers_found[6] = true;
-		if (strstr(haystack, "datadir+=/tmp/d2"))
+		if (strstr(haystack, "datadir+=/d2"))
 			layers_found[7] = true;
-		if (strstr(haystack, "datadir+=/tmp/d3"))
+		if (strstr(haystack, "datadir+=/d3"))
 			layers_found[8] = true;
 	}
 	free(line);
-- 
2.45.1

