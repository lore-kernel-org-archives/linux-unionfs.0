Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DE83B2FE7;
	Tue, 15 Sep 2026 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481892; cv=none; b=GSv0zlR2PF1HgWSulJmBN39VFqoUZziwYSWfl3jg+82OvbkU9d07jSVDg9YbaqRSY0kcoGciZ2Zio2qCowiSG2vphJoGwKPtnJ5joj1zwLMaUZbY2mWpbqoSxbRjdhoJaFEJE1mZD7vWo3JiY1hoZc/isnAtHaEs1koeg+QpACc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481892; c=relaxed/simple;
	bh=tpw9o1tUiGl1+b3oHWRYWHKZU4T/6sFdJUL5kml/tgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hn9Vr2v49jEvDNtBx5C6Z0iFSQoXh1EJsPQbscyfAFLOSy8/tIIEvw8bsvuQ0tYUP+RU7mpAYtxutw13Os7X1Nl7lMkz+UPOEZAo3Kd/jV2ICAe7Fd0YiHm158BSsmyJNBng1MJorRmOJFTjiSo+75vcP0FhYNj4Btz9cTS97Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=O+kxNSN9; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=G+5jYOhU; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="O+kxNSN9";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="G+5jYOhU"
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FD1gNB348373;
	Tue, 15 Sep 2026 10:18:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=smtpout1; bh=1Y5uLuHbvkr4
	SqV71BKmxpl3bPndo3AQjBlrxzlGCvg=; b=O+kxNSN9mZGrIiGydcpeAzjx6voN
	n+HPDPuus7desfyaVBP2AJmuUx4gpsa+diHhqiOngt6/qpQh1M0DVM+4K7vqG98R
	1tj02vJ4MecJBZ3WFtScKFMYhehUeVs+X43UYyYTbHkH5N4VKElcKMqlUQN4KrtA
	q9gP4W6r18CI9AF89jJOgXGpeot8iT3aJ3OpyAmUPyp7QBCeVyt3KZyxa98CnROm
	MOBv0c8zGY0dUFcTQhoHZCnOHvi6CHvO0+ZZ2mJdLJAXDb962UQ2S8D+4rG/3bfd
	0ThYxBjig/5ZPPZjme/9c251gfmv3cnx3vwyhYZzdgzIXlhRJN8KhZRZXg==
Received: from mx0a-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gn22gbq3w-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 10:18:09 -0400 (EDT)
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FDxS9J3661268;
	Tue, 15 Sep 2026 10:18:09 -0400
Received: from esapsmtpat02.us.dell.com (esapsmtpat02.us.dell.com [143.166.211.150])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gq4m0k5v9-7
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 10:18:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789481889; x=1821017889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Y5uLuHbvkr4SqV71BKmxpl3bPndo3AQjBlrxzlGCvg=;
  b=G+5jYOhUTbIT2g5c6L+P/8BnLiXY4+jeCrNgERonj/aNxv4nmPU9pglQ
   hWs4Qe/niFp8u2omGn3HOVUAl6fJkffendGcmfTZs57JD469LTABiDDjQ
   dxxoz+05m/zMf7qsASEV8Y4ERPb05xS/XaGOLvmdajT8W7gvww5j8jaQm
   NAeKNz5OXubKJbI9ni0+HYaqRFl/qgERvRe+7WFweQGhiR2w66icoaVtf
   nxdbzuRORxZDe2Msupijk5Vt15P6kpj6u5T3R2DRdkrloWoUyk5kfWY9L
   MHLlPpvP5LhFlrW0PWk6o9K66dT0x6wuyFQj0IWm+5W1SsaLml584Gwqr
   Q==;
X-CSE-ConnectionGUID: zDki0ufwTIapZUHl2UG4gQ==
X-CSE-MsgGUID: ENOW+7CDQ42Bw7MH+EaRgA==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtpat02.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 15 Sep 2026 14:18:07 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v3 6/6] overlay/081: add missing _require_scratch check
Date: Tue, 15 Sep 2026 14:17:45 +0000
Message-ID: <20260915141745.4299-7-prabhakar.pujeri@dell.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915141745.4299-1-prabhakar.pujeri@dell.com>
References: <20260915141745.4299-1-prabhakar.pujeri@dell.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_04,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150207
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDIwOCBTYWx0ZWRfX5JIICuZS0Von
 /UYNYOmcPIefsekR9Yil2RF6DSXM95H1jdSCjuaXrdWVRXCLSFZj0axqdq8WE8dTLPEmISdpPhL
 ExN3JoF6KyMvAJ21BKsmVU1oXpNYK7PoJEqRirNTqCQV8+vnE/gE0SVkF/YjuMMULPdbmfPxtLJ
 /rTztEFKTj6ydJP0NwXENKZjnHh6NNbLY25gh5tqGMbyzNC2HizE84JJFDEeD4jEDSXRolDlfbG
 7UooOdI65FA+WT3NHtY+jKmXO/2TSbmNovzp18UVHHFH6/8xAwS6v11DkS+8OdSci7uwn8nB+gM
 soaWwbvxhs6OrJL57GY+IW9yMX8DhRhf+7ftnwiZMWOPCWXp53W+OEBsgKRBrPUlFGyaje/MknT
 WHnq/4yFX4Rst1athRz3ylNdtevCjq/JA31snUGRLbsk0SwmadxMiV/WSPA+e0jKKCaMcdYM6Wv
 4Bc+ODwtZbNqIVknv9w==
X-Proofpoint-GUID: k9UC33b3dSfqxPHoOFbk9SCB7o40PtEw
X-Proofpoint-ORIG-GUID: k9UC33b3dSfqxPHoOFbk9SCB7o40PtEw
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDIwOCBTYWx0ZWRfXxtjp9I3kFGRO
 YxwkIM8/zmmZAa9xU2+51YyvP52PAlR/5tRBFJUYVCCwva0qhjYApC0acvqp+EtMBRiUCcmgGTW
 LkUzdSRfoF2xpu4mj7jpLg/OSrbjZqk=
X-Authority-Analysis: v=2.4 cv=T+UZ3PKQ c=1 sm=1 tr=0 ts=6aa953a2 cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=i8a7nF7jFa3EbZrjgrQYpA==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=2Lpba0WeoN7BYVdwMO11:22 a=iLNU1ar6AAAA:8
 a=pGLkceISAAAA:8 a=agzMk0wusT9Gg33094gA:9 a=hlJyneSgMmFPbskH-t2w:22
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150208

The test runs _scratch_mkfs without first requiring a scratch device, so it fails messily instead of skipping when no scratch device is configured.  Add _require_scratch so the test skips cleanly when no scratch device is present.

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/081 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/overlay/081 b/tests/overlay/081
index 2270a047..e0ab558b 100755
--- a/tests/overlay/081
+++ b/tests/overlay/081
@@ -14,6 +14,7 @@ _begin_fstest auto quick
 . ./common/filter
 . ./common/attr
 
+_require_scratch
 
 _scratch_mkfs >>$seqres.full 2>&1
 
-- 
2.55.0

