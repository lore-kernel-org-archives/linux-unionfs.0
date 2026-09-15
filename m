Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55C43EEAEA;
	Tue, 15 Sep 2026 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486582; cv=none; b=Pr7SjUSmGu+V3PmERd0AYb3yjUZQNxWB24LVnXskKw3yn1Y5OAC/IKVnxsiBFmIE9tQMp+9rhquHXEe2wXvM3jvStoRQmsj33Ii3V4kF2wyXnpnk34bdTbAGLpaNESIVCfJVGaz2fd40qtmV7qMOaJOrBzeqry3mGMZ39Bq6Utw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486582; c=relaxed/simple;
	bh=jmMrl2ynUp112f6yy7Zz7vxkblJ1F7JZ82+i73cw4mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4jfQtJdMOX8XHk9xFMLP3Lp3jo5+hnikH/bgSyErVxBNoubI+uJDJFj40HRcpB/2n1teI6jn6U2zvXWeoBjcUfCJhtoIwKSheJmWUqAeh3GSqzr8fCRU8M8nbp15fcmHaVc6sregYvGtMn4r3QKnD8OanslChRZrLIxsAK60pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=Vbwv3NuS; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=CpFy768F; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="Vbwv3NuS";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="CpFy768F"
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FF7AoQ625114;
	Tue, 15 Sep 2026 11:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=smtpout1; bh=+s8S2msFt/xA
	u6LeZCVAsMleI4hCwb/yp5QfLq0NvqM=; b=Vbwv3NuSYYfjegx0Mz1w1lTNzyGb
	rwyJpbZGa0shno1CmzwbhLP2p/8oempwXz+jTMmdbtIdwI8NmDDsaJBylyI46bwC
	IWs0lgWvIeoXQEOX2M4NxYuIoncStGycTIigI0g+ZJIcJfHlQTtViVjyPTPFhmV3
	pyPZ3lmz7zSx4licKfTR6aWBmUHFVNwrQgZ5//HDMhfI5xW8K0jKjyKNouMASSIC
	0+WQ/ZiWtF23c24TGJ8X/28X7W9Z0trWjW/Xcxmc6042aR6MDQqZUA79SRTrghM5
	w+IBErZwJzpME/GYz44P39FlZHURdqWl/qOY1Wy0LpvCe3kiOOUG2qGQJw==
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gn22gc5yk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 11:36:19 -0400 (EDT)
Received: from pps.filterd (m0144103.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FFX5E52279432;
	Tue, 15 Sep 2026 11:36:18 -0400
Received: from esapsmtpat04.us.dell.com (esapsmtpat04.us.dell.com [143.166.211.147])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gq6ksjp7y-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 11:36:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789486579; x=1821022579;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+s8S2msFt/xAu6LeZCVAsMleI4hCwb/yp5QfLq0NvqM=;
  b=CpFy768F2mKaZLiFS0bprjdFTU7KvAK4KQ6XW7Ve1fzFWqH4yucrSZu/
   ItHkhZpr6cWSjaHVavk3/yYnRFOt5VZBJ8VgL3G36FPn+xAjgNagJlvfn
   LxpwEmj0cSoVMZNNGc7Ijjvi4Ubj74rboMQ/HWpcxs9kjweCfiAv6wcGA
   eYDaFGtzbabHhkLbfeixfXv+Gqjouj5OwUgzOSBpzkwUqUcLdnLq4cOKw
   W18FstxdysT+y/Po1YnPjxJ0QPjJa++o+QwbYlwEQ7dk4UExN0X9XKzG/
   jIzx/UMn/X7Uw4LmIMmvEWz6EjqJIo/Wsh/oQf+TYrva+pVgqYn+OPoK9
   A==;
X-CSE-ConnectionGUID: aDq8IP3DSaakwj9SqR0i1A==
X-CSE-MsgGUID: WcflPtxcT92xh436XGX9Yg==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtpat04.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 15 Sep 2026 15:36:17 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 3/3] overlay/081: require uuid via _require_scratch_overlay_features
Date: Tue, 15 Sep 2026 15:36:07 +0000
Message-ID: <20260915153608.5197-4-prabhakar.pujeri@dell.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915153608.5197-1-prabhakar.pujeri@dell.com>
References: <20260915153608.5197-1-prabhakar.pujeri@dell.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_04,2026-09-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150227
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDIyNyBTYWx0ZWRfX4SO6sD2Q6yVZ
 yxiRE0r7vjYievzrpcHU561zhSCbAjNE5uqN6ywPbON/NqaTwP1rrQP3x2rRooPgg6lAzNdrnOl
 qw+i5yR7dPGO30kAIMsffV58ZnBhjj1Pfcq2iuzXMWIqIS3Vatwb6BRvz+k7TkUX74PRHWSx647
 dfSwd9pTaZy+1qR7ZC7qV02XQzYMAeJiPzDQedlggYyj/RkxInELrhjbF/K1/TmFhCMC4FIuVxG
 qtYi86ThC/cD4lQtpw+FPhRYmSVXxAAnFKf1QqScUl2twFErwoXx+JiULgQKL56S5feKB1wXNgt
 +4+WrECi9ccCUR8wYtW0flABfgVZ3fL/zXnf83bqvX++dUt5IdR25014uEs2D61Q8XL5sBEG1fU
 mwKtt8wVnXVtY+bnc5TtZtDTyIE24XqwG7HlqhHHSpHszXN14DUqkiRwoaI1q/ehlZl21LUllGt
 LHscqnwzPdmvZZAqfcA==
X-Proofpoint-GUID: MQwRUxQQfCravCNRwOIdsT7lxbwwCUuw
X-Proofpoint-ORIG-GUID: MQwRUxQQfCravCNRwOIdsT7lxbwwCUuw
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDIyNyBTYWx0ZWRfX/hVPCkSJnRl4
 3HMay2C+tKOlyxEhm6VB35SHMYPGOS1jxMsmaK5sba9L85VTpsvl46cQrwvsjSrFzH/aWryRJBY
 G7+PsMnIVbosy8N4DNlgnupBdmeVytM=
X-Authority-Analysis: v=2.4 cv=T+UZ3PKQ c=1 sm=1 tr=0 ts=6aa965f3 cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=xQoiRHjKKYbJmV+sD1MyuQ==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=2Lpba0WeoN7BYVdwMO11:22 a=iLNU1ar6AAAA:8
 a=9yejNmaYs_PoGxmwCHYA:9 a=hlJyneSgMmFPbskH-t2w:22
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150227

The ad-hoc check hid the mount output and treated any mount failure as
'overlayfs does not support uuid'.  Route the requirement through the
generalized helper instead: the probe mount still rejects on a pre-6.6
kernel with EINVAL, and the options check remains via mount options.

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
 tests/overlay/081 | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/081 b/tests/overlay/081
index 2270a047..bef54470 100755
--- a/tests/overlay/081
+++ b/tests/overlay/081
@@ -14,6 +14,11 @@ _begin_fstest auto quick
 . ./common/filter
 . ./common/attr
 
+# Unique fsid mount options (uuid=null/auto/on) were added in kernel
+# v6.6 and have no module parameter; the probe mount in this helper
+# _notrun's when the kernel is too old.
+_require_scratch_overlay_features uuid
+
 
 _scratch_mkfs >>$seqres.full 2>&1
 
@@ -36,8 +41,7 @@ lower_fsid=$(stat -f -c '%i' $lowerdir)
 	echo "lower fs and upper fs fsid differ"
 
 # Test legacy behavior - ovl fsid inherited from upper fs
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o uuid=null 2>/dev/null || \
-	_notrun "Overlayfs does not support unique fsid feature"
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o uuid=null
 
 # Lookup of test_dir marks upper root as "impure", so following (uuid=auto) mounts
 # will NOT behave as first time mount of a new overlayfs
-- 
2.55.0

