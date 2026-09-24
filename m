Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D073D477E58;
	Thu, 24 Sep 2026 11:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249376; cv=none; b=NqIlXsxeT38cTDH4eIv7hXXuiejRNyxtSfuDvAv5HM18c1xSxPMqtxkYf42gA/2KH5HEZG/aWLhAdly3SVxVzQ4gaIxjYqof25HqgLmqf9/S9mZOQnMmdWqUiFJkzBQoncNDHutsK0UAg2l/70z+kEcZSi+fEoYYMDwOM9NGwtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249376; c=relaxed/simple;
	bh=OSNij3Gy/PEwEHuor3pQr5cnCpHEyAlF6oBQ+m1a6R4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fevy3avzL5NKdxEjSGrpyctcty+bxOUkhYEx5PMfOlotyaPw5E4JAuA6xfJQZr1ZWr1VFphu8SuHbGDpAUVztetT50XK/acIWpEuZUC7en3yRCkT2bp0Axqex5POCq5b0uRJaYVe+NXF7hGJOz+3b1dqMUq0E7T049G94GBAFEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YaXb2q0+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YaXb2q0+"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5bYU8160023;
	Thu, 24 Sep 2026 11:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=bj6fJz3vv0i9EgBQBXlFwvRjDk3TaxctBdtEAChV6
	Yw=; b=YaXb2q0+oayiIrOAYXBjvdFpYfmyiF5Hc9QVrhmQPYBSI9ixWR5NGow43
	Mm65f6x+7B1B2KUNRkp2PUy45gzsxcsLACS5/uHBGtFHig7y4s04UXxerM+3/uxZ
	KUxkaQk/Zu4Fei3s/KCCiD8aVWTdqOjhG8VoSbvpu/SO3Q+6NKWjrOpWXNYDgxP6
	nqkQzjWqpiT3akzQbTUazl24Rzj4ZhvW5VyVenNVsuW1zIilXyQCcLzZQPE5M0VX
	n9Pap4RE1UvXoOsqEe/5mJDvzS86PDJ3JKOrBuvWps3UFa5cK1Ie3ULiLfdPPwMn
	08O6pgkUW9eHUeEnm1W/0Bw3zSG8g==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskgqqvrs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 11:29:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68OAIQ1t1554955;
	Thu, 24 Sep 2026 11:29:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvb8jwetm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 11:29:08 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68OBT6J839256358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Sep 2026 11:29:06 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C3002004D;
	Thu, 24 Sep 2026 11:29:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DE2520043;
	Thu, 24 Sep 2026 11:29:04 +0000 (GMT)
Received: from macbookpro.bl1-in.ibm.com (unknown [9.123.4.160])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 24 Sep 2026 11:29:04 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        shuah@kernel.org, linux-unionfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Disha Goel <disgoel@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ovl: fix mount setup failing when override_creds drops CAP_SYS_ADMIN
Date: Thu, 24 Sep 2026 16:58:57 +0530
Message-ID: <20260924112858.51392-1-disgoel@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=G+OJgNk5 c=1 sm=1 tr=0 ts=6ab50985 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=l8F_COdeiNbdnb7lkW0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA0NiBTYWx0ZWRfX+Xxvkqi+jHkD
 sTnMTwhReEKR9ZjUad9j1/24ewOlpy6+voDWnlbB7fv8OXE8/E78sYM6TNSMrbeewuVXm+F0wsA
 P9SrVVLdhJq1XwngKOL7BInf4Q9vzvs3waNwdZGW02V5Q9vIxcV/nYF+rxNP65T0x/1GarGWE01
 hieEoFtVUpWfhS5OvVWI2HulDNpqPIQjVPWTzsZlHkyKf2z406vFYWPWVyFwOFwHr55ZSKJ7+ce
 YZM1jxFjXHm81HhR6EIkCnWg7Lcdy9etdHZY5wmssdX68h7DdCECtXhXrzlo1Ar2I2ARRQ/Qv7S
 w4ORaq4ZKr+mlYp8JQAoUoAo8hMJQeLphtjoEYIXGgPmdD6gGWvfrhIb3+pbSDwPTUstG0HvBIk
 ZnnjTS4Hjln/uDuL6+3F/Ks5KE5ahZwinaisAL1BeDCspI6slx7UCzfz+js18uoaWHcBEoEdl2U
 UY6R++LYlOL+aojhj5w==
X-Proofpoint-ORIG-GUID: OyqnHgROl3cA-RcydddRci9G5R2lKxWB
X-Proofpoint-GUID: 8dTP5fY38y81V1fHLVpC5WXJUaInBj0V
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA0NiBTYWx0ZWRfXx+DM1i/56qsd
 cyWl4B9ZBfHwz5mfSdzoQfxoGTpj3bit4okt1gfUEAv9g/GtfkWhV9Kd7F4+QPiBV0VwsCViDvm
 pWJHbF0LDo1C8+Q2238HVzs1ljbBra4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 clxscore=1011 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240046

When a process drops CAP_SYS_ADMIN and calls fsconfig(FSCONFIG_SET_FLAG,
"override_creds"), overlayfs saves those restricted credentials in
ofs->creator_cred.  ovl_fill_super() then wrapped the entire mount setup
in with_ovl_creds(), switching to those restricted credentials for the
duration.

Mount setup calls clone_private_mount(), which checks CAP_SYS_ADMIN
against current credentials.  With restricted credentials active, this
check fails with -EPERM and the mount fails even though the calling
process is fully privileged.

Mount setup is a one-time privileged operation and must run under the
caller's credentials.  with_ovl_creds() belongs only in post-mount I/O
paths.  Remove it from ovl_fill_super().

Fixes: 539a0879de47 ("ovl: allow to specify override credentials")
Cc: stable@vger.kernel.org
Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
---
 fs/overlayfs/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bd0a3f9039d2..29f9489b8242 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1557,8 +1557,12 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 			goto out_err;
 	}
 
-	with_ovl_creds(sb)
-		err = ovl_fill_super_creds(fc, sb);
+	/*
+	 * Mount setup must run under the caller's credentials, not
+	 * creator_cred: clone_private_mount() requires CAP_SYS_ADMIN,
+	 * which override_creds may have dropped.
+	 */
+	err = ovl_fill_super_creds(fc, sb);
 
 out_err:
 	if (err) {
-- 
2.45.1

