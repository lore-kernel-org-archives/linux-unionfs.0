Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C115826ED3E;
	Mon, 21 Sep 2026 07:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975022; cv=none; b=BsHqcl7N2AsuGbOKz6rKZLJARYbAgwzw2EvfMZ1e+NvN9qs70XalLj8l2VIgTKixHABikbPGi5cnTXCBJBJxm+2bODvoeF6FLprkDC0HwjRXZItDnwfUcOQjgq/cFjVnWfrN8eJURsbBFgZMgWvn9B2BS0KGO1v3YZtn+24y/t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975022; c=relaxed/simple;
	bh=RHn2RTkMPoHSqKJOyRMFnq6vKbUVivdz/qOs3/rfmoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgisgy+uHUK72dNoG5M03MVbWu6SKaEPUn1aQJVpVvrDMocayG1ZS3ikzexaY8KKgXeSEQx1SnY1DriWMHEaV+35wwpj2J+Vmn4favhBEnolA51297GOb+zFSvuE0gcqY8f//LEuAYh/Q/KaKRr8ibin91TKtx5XZN+hPjB82cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=N4Lz4rqX; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=Hu8lfw3m; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="N4Lz4rqX";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="Hu8lfw3m"
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L79EtF189980;
	Mon, 21 Sep 2026 03:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=smtpout1; bh=Bqn05Y2ORI7p
	PbC31ZcyE4TVVjxR3h0F01zX7WoMuKo=; b=N4Lz4rqXM3JEkfBVFQrnxZYD6oOe
	iv+0qsNw5+zm79IiWvZv7r8jr+YxM+kESxcAvrXptiDd3c60pYvCKyNr2Cb1ijDx
	Yk2M3yVrLeoewa9g+3wDdw+05pTS0NxoBCG4il1HlrWydJ97VgIy2SfCcIzuKG+y
	YC5/S6cxlwsrjemk30ukKQ2m9sL3fFfyNbfRXkIQabzJAR9szmTv3obgDPmB+wX+
	Hgyw8RXVCsRx2bJyI1bYSuHCIcOwoXCxvXo8RDgjsuqC5NL+qb5y7ZjABbQYMCDj
	/COmqMiOHFg8jL094IMeaOofN/Tn1vUZcp0pNXEBJ6bax35ZTKhtZpOqhQ==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gsnj65006-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 03:16:59 -0400 (EDT)
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L78iaE2613475;
	Mon, 21 Sep 2026 03:16:59 -0400
Received: from esapsmtplv03.us.dell.com (esapsmtplv03.us.dell.com [143.166.203.148])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 4gty35rrf8-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Mon, 21 Sep 2026 03:16:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789975019; x=1821511019;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bqn05Y2ORI7pPbC31ZcyE4TVVjxR3h0F01zX7WoMuKo=;
  b=Hu8lfw3mFzaCKRR8nYAqxkV00zTP7DaJpU9IGTo+47wFEwi/nT8AMpOT
   Kl+DkMPpOy9OTocFkoly5WRWOI8WCabTxCe9R0j++SmoK8qd6zl2qbKYC
   WEWUu6xbp2fROLm9wf9mUSAefSMAzWyiflkZY2v518Vx77KjIaMwTLOZc
   GJyhV0qxwUp/uC577bnilGX+alFWUXqMUM8fMVRqzcGz9/RKAEehNhRpf
   sps9uH1SlCwVjBZQwm2D5JKgiINnkKL3rUczykpqQet0e31p8EyBGyqc7
   vV7yRkkcflyC7YZDF5OFZvKP274uyyiunBcq37laZ9Kq/iJprQGcfQulI
   A==;
X-CSE-ConnectionGUID: aFkVd4u3QcysZzAyZ8QoCA==
X-CSE-MsgGUID: qvWfV/I9Sn2v9KZXyhOVTg==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtplv03.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 Sep 2026 07:16:57 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 1/3] common/overlay: let _check_overlay_feature handle param-less options
Date: Mon, 21 Sep 2026 07:16:49 +0000
Message-ID: <20260921071651.25862-2-prabhakar.pujeri@dell.com>
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
X-Proofpoint-ORIG-GUID: nR8gV6znk7v5hF0AXOxYgDCM4gwFvlo_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEwMSBTYWx0ZWRfX444XitPgv4Ou
 a3Ebojjk8jiqasu+T6G4NxsRPA6YJl+Q3s9ttP4FBaBVunHRBBWHaO95WC1aP/y+Dx768FD3mdM
 LidaeU5NtT+okg4LvFyH+8YHmVvpw2U=
X-Proofpoint-GUID: nR8gV6znk7v5hF0AXOxYgDCM4gwFvlo_
X-Authority-Analysis: v=2.4 cv=aoknmiZV c=1 sm=1 tr=0 ts=6ab0d9eb cx=c_pps
 a=j0++y401J6f/BxNAf5EDow==:117 a=iGMIhCliR854E25UHWhNxg==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=m3zZTHMLHbwB7Lmtoed2:22 a=pGLkceISAAAA:8
 a=iLNU1ar6AAAA:8 a=m6CvIFb5P7bHGLyLtIoA:9 a=gbU3OgOOxF9bX48Letew:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEwMSBTYWx0ZWRfX3WA53QkAmfV8
 Hu6mLfThKxkkoeaDwkopBBLj+hFGVTxBI3eC4j3L/e6N5gRUT0GsTMceFTZ5MhMJiGHfLwrl9rS
 Uf05SqWhxg14EV2MQ2awD4tp14hSdNdNvou4hDk9DkqjBjSBBxXrisbALqFZ26F3NaYVtYyrUaN
 ias2kpzcwx1pCUx2oTLuOJrr5dLxFRhmIM5rs4YZxvmEPnjSTuv7/bAJPsbCNyQD/jU1DXA8Aq0
 pn3dXyURnvsxZg1/HCS+w8QxWvpHMBIuJMqKlebqFItgVKWlxiFKxRQ58RO3XCJTgdszs1tGHW4
 XoIcV9A7m0774OU1yHKC1cXpw1g4EfQ39Nh5GCU5v9O6BHLVVkhbvWZ6jTpma3W5hRY9EeZ6Djp
 9atnCv2vgNzgWT9ikWLNuapujIoyDSPj8+Smq1E3abt9fgu+4ELi40pGWfnWb0nhGvkhZqI5pgW
 LiYNPvyeZ+sihA+jhFQ==
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0
 spamscore=0 adultscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210101

overlayfs mount options like uuid, xino and verity have no on/off
module parameter of the same name, so _get_fs_module_param returns
nothing for them and _require_scratch_overlay_features notruns before
the probe mount is even tried.

Per Amir's suggestion on the overlay/081 review thread, a missing
parameter for such options means 'defaults off' rather than
'unsupported': generalize _check_overlay_feature to treat a missing or
non-boolean parameter as default N, and drop the parameter existence
pre-check from _require_scratch_overlay_features.  Support is then
validated by the probe mount itself - a too-old kernel that does not
know the option rejects it with EINVAL and the require notruns as
before.

This lets tests require param-less options uniformly, e.g.
_require_scratch_overlay_features xino / uuid.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
Changes in v2 (per Amir Goldstein's review):
- Drop fsync from the list of param-less mount options; it has no
  on/off values and cannot be validated with this helper.
- Replace the out-of-context _require_scratch_overlay_features comment
  with a simple 'Validate that mount option can be enabled.'
- Add Amir's Reviewed-by.
 common/overlay | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/common/overlay b/common/overlay
index d32f3219..b9a13c88 100644
--- a/common/overlay
+++ b/common/overlay
@@ -172,8 +172,15 @@ _check_overlay_feature()
 	# parameter (the system default) and per mount by mount
 	# option ${feature}=[on|off].
 	local default=`_get_fs_module_param ${feature}`
-	[ "$default" = Y ] || [ "$default" = N ] || \
-		_notrun "feature '${feature}' not supported by ${FSTYP}"
+	if [ "$default" != Y ] && [ "$default" != N ]; then
+		# Some mount options (e.g. uuid, xino, verity) have no
+		# on/off module parameter of the same name.  For those,
+		# a missing (or non-boolean) parameter means that the
+		# feature defaults to off rather than that it is
+		# unsupported.  Unsupported options are rejected by the
+		# probe mount in _require_scratch_overlay_features.
+		default=N
+	fi
 
 	# Check options to be sure. For example, Overlayfs will fallback to
 	# index=off if underlying fs does not support file handles.
@@ -192,10 +199,7 @@ _require_scratch_overlay_features()
 	local opts="rw"
 
 	for feature in ${features[*]}; do
-		# If the module parameter does not exist then there is no
-		# point in checking the mount option.
-		_get_fs_module_param ${feature} > /dev/null 2>&1 || \
-			_notrun "feature '${feature}' not supported by overlay"
+		# Validate that mount option can be enabled.
 		opts+=",${feature}=on"
 	done
 
-- 
2.55.0

