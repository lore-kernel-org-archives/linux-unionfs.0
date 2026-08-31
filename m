Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1E1352032;
	Mon, 31 Aug 2026 10:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788172923; cv=none; b=dyqVb3KZ7FA/k/ZGYPfS5KM1pIyQI+rQGr9QrQ9AJzlwvE/eNe9pm9mqwDQwMZQOTeT6QZMMuMABeQi4hG/+X1vYm6Z5qYnPLZ8Jm0a/+qhV46l3JFeJ/qfY/N/pGuiJHXK1DEkEytXr9VU16pAebH89uv8U+D9wWxRnIC/Gedc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788172923; c=relaxed/simple;
	bh=biG4tuVaVme28ivO62VsAA91axklyoUIA3+z1VgN7e0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h5pOYT0Fpc9bEcOgSJ7em/hLlOM1zgXZ4SBEORxp6I16QBNapobMXJqBiTh4SioB1smmGrFxOUgoHmK54SFeZ8Wa0XTfY3umviPlmcRPoSyenD/X5I0byaMvmNsZ9EJ3RDw/U9+QZSoNLhDNBzdez+bEu2VP5UOpRPZdyNHvsoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=TCW63Qgy; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=chMMqsSa; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="TCW63Qgy";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="chMMqsSa"
Received: from pps.filterd (m0170390.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V7xCOj1070549;
	Mon, 31 Aug 2026 06:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=smtpout1; bh=zPo6yZ59DC0vHL0rWRlduX1wLxaA8YY0uMne
	MpBJVS4=; b=TCW63Qgy2SgT0PfO5/J2LFek7VO/IF07c8LsLjlHOjkgbNHbQZNc
	v1sHHIcsER3JdLkYXWjV5Qt1fnw/0opMLyJC8EHzH+BglVJHjIXYUKcPH0EGzn5/
	MkKDaiGoeJyqqUZMG+fp0H2PeizOyHkCiJ7ny3wPVlK3uPTX960O0oyHwFYi3t7y
	SOGKVAlV9xhHHa6aXJpGfXT/b7l0Ftz2rLXGadJPFd5itn5AQq1NQXmpz9ODDqiP
	HukknJR9SBTu9xDixJEL9EcdlvIss/LQTYdURgdeVSh9pNrNd53F+kQBpwjiH7lo
	BmiFZWFkaZnkicmZPbg4r60WKbYNIxN5xQ==
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gbtfwdf27-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 06:42:01 -0400 (EDT)
Received: from pps.filterd (m0144102.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V8PdCi2742967;
	Mon, 31 Aug 2026 06:42:00 -0400
Received: from esapsmtplv07.us.dell.com (esapsmtplv07.us.dell.com [143.166.203.154])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gd63g9dpw-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Mon, 31 Aug 2026 06:42:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1788172920; x=1819708920;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zPo6yZ59DC0vHL0rWRlduX1wLxaA8YY0uMneMpBJVS4=;
  b=chMMqsSaX1bLBsXCsz+5rI9NpFc6rXRdZHlbCY2/BhSnh1KJx9CglrE1
   /AA06P0+ACmKr21ytOhUyZZ1TPfKJh19s0NuzAODd2o/lULDWYBE/3Zw8
   zwIkn1XoJBUMQPX3BlpUbbwdUNsmP+cpha6izzEjVuu/kdWaNGPHxAByu
   RNF8ANPejxkdKd+Du9kMOwOXQ1sFL2y221j+3qQPpoIvt7dWcQwHtLPcg
   xfe3DKBeCZ/R1tb8Vux2QGLkyqnBzXlTyyMKWE/JIgrDm7NrTk07+VvLE
   ltR4EzOnoD7YYIaQowErvw6li4TKo+oSeHgNEe17ajU28vQvegBnQS6vN
   w==;
X-CSE-ConnectionGUID: mT/iJs/YS9C/WljRyNu9WQ==
X-CSE-MsgGUID: +XIdgUeQRcSx2z7XuWc7vQ==
X-LoopCount0: from 10.94.8.206
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.8.206])
  by esapsmtplv07.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 31 Aug 2026 10:41:57 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] overlay/081: add missing _require_scratch_nocheck check
Date: Mon, 31 Aug 2026 10:41:54 +0000
Message-ID: <20260831104154.2256-1-prabhakar.pujeri@dell.com>
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
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310091
X-Authority-Analysis: v=2.4 cv=BdToFLt2 c=1 sm=1 tr=0 ts=6a955a79 cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=FlBIjDbFArVVlnHZBJJA7g==:17
 a=Sv0fKeRqtYgA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=sEWawkeXllE7TocFc0N_:22 a=iLNU1ar6AAAA:8
 a=jOwvOZWArAZ5x76Gcs0A:9 a=hlJyneSgMmFPbskH-t2w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA5MiBTYWx0ZWRfX9Pl0LnBZs3nT
 63sLIwYWkYhhpEbp4rqORXlcLnevu7TnTZVNPjmtJw6ngiahucwEsQC9qXylNmHc2YzRszGFzno
 ElAoRSXZ+a8HC9RtEL385HOlweyjPesK/A1okHEi/SCzTdc2CL/A/FVn7QFQdvMI5Hf1KoTWPOe
 9PoUJYdoj98bVeZ0wvixj5FYmeeD65QVx8KtGBv+mJxqtlQ/ys2/1Xt/k70wlJ0GQPHRlqv5QGU
 jOCorVF8G/3nMkERV5osRbfMLpToSFUork50FXPn9phSLMd2mz4h/+TSk7JFtPcyvmKJ4D4WMgy
 +oGn2mK8dtLhGbibKmBWJ6Ey3XxhaycfxyGRTsRfqJh/eylIhsiY0jCEGIcqtXRI16o04fF4+Vx
 0Nof5HWtzltGWCyDMP0lcfAGzENxOmi7MuwWCgwtuqIqxerK81v8ACmYm8eSBDncQlFhdjFvmvs
 y1V3f9cJxMpNDv8CJLA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA5MiBTYWx0ZWRfX+e0SyqAISZfd
 eu0oIo4e/06F3aa1k7OIWGnFLHY1hIvWw5n/bTytwn4mZato7m7wkmXAsse/+vkkejDNVgbZp0E
 j++BbBrJLO54jVptxUrPkd5DDaBDgwI=
X-Proofpoint-GUID: QH3B06ak2HVLFNPucLzlT2Ag8L1B1oXz
X-Proofpoint-ORIG-GUID: QH3B06ak2HVLFNPucLzlT2Ag8L1B1oXz
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 phishscore=0 spamscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310092

The test runs _scratch_mkfs without first requiring a scratch device, so
it fails messily instead of skipping when no scratch device is
configured.  Use _require_scratch_nocheck like the neighbouring tests
overlay/079 and overlay/080, as the test mounts overlay on the base
scratch fs.

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
 tests/overlay/081 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/overlay/081 b/tests/overlay/081
index 2270a04..a13b785 100755
--- a/tests/overlay/081
+++ b/tests/overlay/081
@@ -14,6 +14,9 @@ _begin_fstest auto quick
 . ./common/filter
 . ./common/attr
 
+# We use non-default scratch underlying overlay dirs, we need to check
+# them explicitly after test.
+_require_scratch_nocheck
 
 _scratch_mkfs >>$seqres.full 2>&1
 
-- 
2.55.0

