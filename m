Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF65438014;
	Tue,  1 Sep 2026 13:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.137.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788269093; cv=none; b=JkPd+EgDpNHS045mqN3vORDenLXVWWJ+l+Ch7k1FkGUUxeXa9Nq/3LR6K4sgB2jDZ7LYkjgyTd0y+gKywyWoFJJuF6F2YzUAxufDZn/iXuv5GgPqlliUSQDF6qfPh7fqb1Yh87yOPOsuRFvQ7FvziU4f4c00h2NczT4stCelauM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788269093; c=relaxed/simple;
	bh=xdZNdbVi+h47vGlliB0yEb3OJwUf21wxbbPccVrSVLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cec1HIrhHm32pMEb6V9BlxnNfaIe8EZcVWD+wRdRt9fc3k2XkMgkO6ZFXlhPmp+omPTZMP0kUP+rTXzIaze+uqIGRwvYtAucw691/1aQbegf3otQfDEFKq2xwP1GpxR9GMUo4P31OUoop2t2VyOGk+3CDZ9asAmeM9bC8qZEiq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=VmvcYBU9; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=k3au6ZkA; arc=none smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="VmvcYBU9";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="k3au6ZkA"
Received: from pps.filterd (m0170398.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681DN25b1980169;
	Tue, 1 Sep 2026 09:24:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=smtpout1; bh=FcRhtIym0NpYPAe6eAEZanzaw3jFg51z3gpc
	EQgc2rg=; b=VmvcYBU9ta7O08qea23/EGCjr7YSIk8H/8kqytWSkSqTHHOALjyU
	6kMeEIN+mFPywu5oMO+XjKY4wgLGYQtW5+qlpmOrsqMMq+2Eb3PtQFCTtcYLCTU1
	NH48LJp1ErsjCC+wHv/JmC6+5zDaXGBLrl+fDBfdk6jn1kGwPdwA5KNPhqczpFLO
	N/vQmhUDAiXTJGWqISD2FTS3uPbxdk5PmeotgPJYociHWZtIhNLN2mRUHr+zLOqt
	Tv2j/gwGTWF7pJnc7MLnigQ1D4f9Q8Mki96pYXVepmk06UdUeVDgH9EZz4LXmLgx
	wcPYCWNCxahOk+V0wZU7VuzHtkGfDPwWig==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 4gbtn53uaf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 09:24:44 -0400 (EDT)
Received: from pps.filterd (m0142699.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681DGilw3547693;
	Tue, 1 Sep 2026 09:24:43 -0400
Received: from esapsmtplv04.us.dell.com (esapsmtplv04.us.dell.com [143.166.203.152])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 4gdu4gbvkc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 09:24:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1788269083; x=1819805083;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FcRhtIym0NpYPAe6eAEZanzaw3jFg51z3gpcEQgc2rg=;
  b=k3au6ZkAPjzAsVXuXgt4SXW+0g+4ybrg+Gct6+ABJ2IC6s+JiYa/es73
   rcEqcXqYlOi8HzKWiSPazHQC6IIw9aIlt/kU0mr7+8RZZ5Y0KsZsjEYNc
   nrvqr30aIH4Z/1GpP2EUmpqZXbcUgvaGfCjZzFAhk2l9P8QXZc0D24R6P
   U0cOwKHsMjDWQPs7pmftLKP19Sr/vr4Dles7d6gwdxfEUzsxW+Cqfafzh
   D1Hcz4XUwBItQ82ReijKtcvxLa6iRNy51lWxdEEykflh4NEWRv5XDY9X/
   rju5YXQKOQhBzZy3kJOQs6jgLwGdOC9zjmnjvHAOJTRq4+2Zcww0bA5SK
   Q==;
X-CSE-ConnectionGUID: ngpyk2NfQNe6Mc2sz31gig==
X-CSE-MsgGUID: T4d2EtJXT0eG9byRC3a2kw==
X-LoopCount0: from 10.94.8.206
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.8.206])
  by esapsmtplv04.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 01 Sep 2026 13:24:41 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2] overlay/081: add missing _require_scratch check
Date: Tue,  1 Sep 2026 13:24:38 +0000
Message-ID: <20260901132438.759-1-prabhakar.pujeri@dell.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-09-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010117
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDExOSBTYWx0ZWRfXyi7uw9DrReRa
 d7SLOyaGegI5QJABD6dbkuSuVjdbT4MZVi/75bPixDrAjgCcLwBbEdePEFon8VW6YTDNkCAMY/M
 ZCTfCCSC3T6QSO4X9LgU40GKUnl3ykM=
X-Proofpoint-ORIG-GUID: bjB1hlG-fjmDoYqCIhBvBmzSKBum2ess
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDExOSBTYWx0ZWRfX/KIN0xlbJcX+
 qVHRc3B7DPbqGcFqCsV6zqv1rMRJNLnx2SecwOhiucvfrzIue1QAYV+2QvpaXoaBm9f/jQHYp3O
 nANZocGWNaE2kcyqWzzQbWI4qfyUeADP8HHQ9eGK8qKS14+Ny7M39eEjGkV7WqpuSoJG4yOj/jZ
 76AAH5pCD6shayzF9vtBUKyGjQoySrdaJC2SHJHsLF/w0R6SUzwRElKy8HHwH5fL33Vr9sf3UIB
 shlgjt3mPWVJmWtgfDfenRNA3Bf0cJgS6gHw7DBYl4oTl7JLZx4lMSOzrzp18/6nC+3yZXkPs3I
 Ghxkmddj/OTa5IE58oS0AkB+v6aXuojxSfZzmloP6nbNs8E+JrFtkM5rey+fLtR4qjjgiFBEirq
 9UlV/0du3AVjS4gIr/sSVvYzKgQSFqYrriNyJBocnzu58P4wnd7wfCubfvKfNBJLw8gBflylDBs
 QRymkGtZsPHjC90fsCw==
X-Authority-Analysis: v=2.4 cv=FMIrAeos c=1 sm=1 tr=0 ts=6a96d21c cx=c_pps
 a=j0++y401J6f/BxNAf5EDow==:117 a=XtseytAk/c9oG0Kwoj6KRQ==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=vUAfKriDyi6VqHAKCLgX:22 a=VwQbUJbxAAAA:8
 a=iLNU1ar6AAAA:8 a=pGLkceISAAAA:8 a=agzMk0wusT9Gg33094gA:9
 a=gbU3OgOOxF9bX48Letew:22
X-Proofpoint-GUID: bjB1hlG-fjmDoYqCIhBvBmzSKBum2ess
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010119

The test runs _scratch_mkfs without first requiring a scratch device, so it fails messily instead of skipping when no scratch device is configured.  Add _require_scratch so the test skips cleanly when no scratch device is present.

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
Changes in v2:
- Use _require_scratch instead of _require_scratch_nocheck and drop the
  comment copied from overlay/079/080, which does not apply to this test.
  Add Amir's Reviewed-by.
v1: https://lore.kernel.org/fstests/20260831104154.2256-1-prabhakar.pujeri@dell.com/

 tests/overlay/081 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/overlay/081 b/tests/overlay/081
index 2270a04..e0ab558 100755
--- a/tests/overlay/081
+++ b/tests/overlay/081
@@ -14,6 +14,7 @@ _begin_fstest auto quick
 . ./common/filter
 . ./common/attr
 
+_require_scratch
 
 _scratch_mkfs >>$seqres.full 2>&1
 
-- 
2.55.0

