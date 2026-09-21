Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7E93B3BE5;
	Mon, 21 Sep 2026 07:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.137.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975027; cv=none; b=YDGSIPW/8dp1NDT94kM4zw9li6sefYPx8TAH7s2WFioZICDlIAMZkvoR5S4MdlgKks+S50qnakCPGvg7+yXVIfU1zg1/8TlXBDLM56Av/myYVQLvBudSk9qzDK3GYQM8aBoQmU4xrMljZar0sGcXfuHx+Redib/XDqPqzWjddbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975027; c=relaxed/simple;
	bh=F5xmqxlQhBuZbe1Cwpy76I4jQEEkQwxAy2fh76mGTks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxKGrZLPqnhDSOIrl2WTV3NW/vC8hsD6vzmQRsLydmmKXar6QWHWy1NQVUxHNqbL3I3BBwdTwfM6o5tDvcStxRwAYhiERdPuWi9pAQr9EH4t8I3g6SLcSWTV+pipPpMLjYSNmybe8T3uOnBzW4dAFNOlllCZQThVXB7pWigyiTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=sMWyp25B; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=Xbuxyice; arc=none smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="sMWyp25B";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="Xbuxyice"
Received: from pps.filterd (m0170397.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L79LZ5305286;
	Mon, 21 Sep 2026 03:17:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=smtpout1; bh=mbYhfkbgDK88
	dLmne9NqQgAtde/pAEwKMPMg2YhFjC4=; b=sMWyp25Bb+vk+u8BnhVpjLDJeuPE
	14nc5UCIZwMy34KGGAgUonvczeJsbXpYuaD2/FRLjXXKsz+ZWmnt+kcdv1AUgCRl
	2cuQtWk3E7F1EfrKqbWBboKR/ZnhNBc2Yer1Ne5A8S7tMYcrVkiqVHk+8NEHqbOQ
	HeM0BMsIc8dTADiXclNDM7psCbDTThr9P8rw0MbXFvYZrFD2JHFBFE4z2BtGxh28
	Ti1PHCP6RDez5wrd2ASP1r5ZBa/spW6qiLtEH62HvmtE0JiqpJOgl7JlrJOWKuYU
	HkAAAQ31z9Pz9B96u9Hak6owi+ChYhuK70SCaVr5K6OZVdhTcNcAGlRJVQ==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 4gskfn56r4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 03:17:04 -0400 (EDT)
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L78iaG2613475;
	Mon, 21 Sep 2026 03:17:04 -0400
Received: from esapsmtplv03.us.dell.com (esapsmtplv03.us.dell.com [143.166.203.148])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 4gty35rrf8-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Mon, 21 Sep 2026 03:17:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789975024; x=1821511024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mbYhfkbgDK88dLmne9NqQgAtde/pAEwKMPMg2YhFjC4=;
  b=Xbuxyice6mTWISYV2Browr3bkwynw7EdBRZustJmts9vUyZEZzzGHOzE
   YTi6Gf2nnlNqCsk2wkSnkv0pyhs7Hbw3UXTKwdML2ztCrFT26dGtWrF9q
   5wfYh57CN/5cuHawB0stO0wuN1LNhXqCyE60DbSBLWLTbOpI6keANL10f
   UFzOqAXr4IaYyN3XPSS1r8ZKeMG+qIJo6OzQ/eVX0oXXJZHdSPiLBSsY5
   x00xMeuvoRWrCl2hTBM6+Kd3Oa0ZdWbkiwZvozdFlwwKcjMSXON4xS9rm
   MWXrD8/v29ISWUf4XXZPwLggvRzDw/HnBkdeJHPcABznXDg2qjeYs6++x
   Q==;
X-CSE-ConnectionGUID: wPKI/alnQw++GQv0psNwSQ==
X-CSE-MsgGUID: xM6pto/nQw+KoPjyvL72Vg==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtplv03.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 Sep 2026 07:17:02 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 3/3] overlay/081: require uuid via _require_scratch_overlay_features
Date: Mon, 21 Sep 2026 07:16:51 +0000
Message-ID: <20260921071651.25862-4-prabhakar.pujeri@dell.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921071651.25862-1-prabhakar.pujeri@dell.com>
References: <20260921071651.25862-1-prabhakar.pujeri@dell.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609210102
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEwMSBTYWx0ZWRfX8j3RvySjLkc1
 /rfmwFnGSFrVKuQVOK8jgKiridb3AprgLNrr9T+ziM8jFNv4WZ7pwYxQp+Jrd6bkIhxm7SmMoQB
 PYcJFtNDQAnl8Rt61eG7FgFILYUVdRc=
X-Proofpoint-ORIG-GUID: W42PYEo7U3n7I3MyullFzwxJjU--KQWd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEwMSBTYWx0ZWRfX1u0p5lQguBKu
 R4p+weULkRPZTdTpHzavck3TQTQ6gs+YEd2kyneBJ4/OiB9J9YmboLb0hV47nMi4OspoqgjePlW
 llfC9INtfLfUguuooVhhJBE4tVtJFzAZs5ONaGavmJNWh3IlFkKNHJVAFoHzkEYL3LxtDzEiMk5
 B5OB3PxaEiJEvDQLs7OOTRTabInVahamovyPMYusBc3EiDpebF/EZdIMtMRZ8Q7H0F96NlcOz4b
 IiL6R+l90sXDvfFG98Mbo5BGbGdE+fkCKCgJp+IVFhloKjd2hIFM1phHCndv+xvWUd+0pO6ZP/5
 De1P3gkB3HnMmdo+lXspDTanJvQ8JebtjaVkvGZhJ7cU7DFaZFHCDER1y0vuA4VMm5YNWv8i4pa
 o1j8YoyPzY/1l6Q5XhP3edqrhEYuZmWyerOkgCdIWIL8HpGzDcJjCuZiofTdWq0rnYHIkgmRMbM
 4dch4OE458E2wpZ6HtQ==
X-Authority-Analysis: v=2.4 cv=LLzz05W9 c=1 sm=1 tr=0 ts=6ab0d9f1 cx=c_pps
 a=j0++y401J6f/BxNAf5EDow==:117 a=iGMIhCliR854E25UHWhNxg==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=U3ti1ie9CgboSd2qXsAw:22 a=pGLkceISAAAA:8
 a=iLNU1ar6AAAA:8 a=-cMShk4Sa_XXXRAYw6EA:9 a=gbU3OgOOxF9bX48Letew:22
X-Proofpoint-GUID: W42PYEo7U3n7I3MyullFzwxJjU--KQWd
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210101

The ad-hoc check hid the mount output and treated any mount failure as
'overlayfs does not support uuid'.  Route the requirement through the
generalized helper instead: the probe mount still rejects on a pre-6.6
kernel with EINVAL, and the options check remains via mount options.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
Changes in v2:
- Trim the verbose comment; the v6.6 requirement is already documented
  in the test description (Amir Goldstein).
- Add Amir's Reviewed-by.
 tests/overlay/081 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/081 b/tests/overlay/081
index 2270a047..9315125b 100755
--- a/tests/overlay/081
+++ b/tests/overlay/081
@@ -14,6 +14,8 @@ _begin_fstest auto quick
 . ./common/filter
 . ./common/attr
 
+_require_scratch_overlay_features uuid
+
 
 _scratch_mkfs >>$seqres.full 2>&1
 
@@ -36,8 +38,7 @@ lower_fsid=$(stat -f -c '%i' $lowerdir)
 	echo "lower fs and upper fs fsid differ"
 
 # Test legacy behavior - ovl fsid inherited from upper fs
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o uuid=null 2>/dev/null || \
-	_notrun "Overlayfs does not support unique fsid feature"
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o uuid=null
 
 # Lookup of test_dir marks upper root as "impure", so following (uuid=auto) mounts
 # will NOT behave as first time mount of a new overlayfs
-- 
2.55.0

