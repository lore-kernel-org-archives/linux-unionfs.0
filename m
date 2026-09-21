Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589FE3B42EC;
	Mon, 21 Sep 2026 07:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.137.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975021; cv=none; b=hmV6xaor+e+ghsK+/vOd5/JK0ELNcfH5ZQK5Nnp1ZQH/9SidNxEAx96slp9VjYttW2D252L/UpJLV3jipGRvaUMDpDkF9zGLb3KHBy3fqE7OCd+F/4GpudReYzUl37P6h7ecXrhntnwAmhoqogHrBPPbPS+GEG94ElQZh+eZluo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975021; c=relaxed/simple;
	bh=Y5+egbtyVos1ApfOIeG4h2RnvLnV87NCUdwAIuPwEpc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ac3nJ19rJY3CZ2rojSkqqmexLf1MJiIvPajcqWzZgm2BC2RxlpDmOVw3XfXzmXdZ7m08PTzF2NRDIBUPZrD1BfNx6vZG5peGdy0Dx3IdP3JGGKuKJV16jGchqk90qGcoEYBRXzW81J9DDlKHLCj+mD9rLLIRi/citwUje55aLAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=vky9nmNe; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=K8HW7naZ; arc=none smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="vky9nmNe";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="K8HW7naZ"
Received: from pps.filterd (m0170394.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L79Hvo239330;
	Mon, 21 Sep 2026 03:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=smtpout1; bh=U8vY59JA/YYtEJKsExbkIFXq5nnt9KqDX7+/
	JwlYE4E=; b=vky9nmNeNpzdsGJRPwhDrA71C5drFEki7shFFLHQx/nxIIUSuwnK
	DAFa82O4QETOppuEHRDMgky3F4EaIPiCJW+rm2HM35D9SsyaSuFksIzbJvv48OKp
	tato57EGy5d2vXPeosxvQ/KTsR2LcClt3fuYolZriY2zIIOnLR9xZHcEffpseKR3
	veo9Zi2ANFtTg4I4zwbYOXhLq0N6RRUd3gAZwA0qhEipK38o4xBCkGr8TshPsC8/
	D2wM3ra6eB4DPjMWV7l3cJXt3tLLyIW4xIVy8yYvryutwmfzCNR9fT7w5z/YA8MG
	PvWKEdrOOprb7vxF1URkUdFyuj0JQZnxZA==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 4gsmxyd1q9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 03:16:58 -0400 (EDT)
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L78iaD2613475;
	Mon, 21 Sep 2026 03:16:57 -0400
Received: from esapsmtplv03.us.dell.com (esapsmtplv03.us.dell.com [143.166.203.148])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 4gty35rrf8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Mon, 21 Sep 2026 03:16:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789975017; x=1821511017;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=U8vY59JA/YYtEJKsExbkIFXq5nnt9KqDX7+/JwlYE4E=;
  b=K8HW7naZ0W0Tg8As2L3uULnErBhjUnSClbXMfhqVWajtHFCYZ3kqrD4p
   /oWCPP3hb9O5+XbiHd67npek4j6zhQzMo4VEtKBbmjcKQQPQC58hk4CbE
   4ifdWcMXopPcUUUn7TgdDS2pz1jib/Kax3uivw5oJHADsK/WyV2hBPxnl
   aB6+EWW4fkFJwhlivksd7QxLJ6rWo6E7i/89xAEnTM3iNd/8aLAVlodDa
   GXJR9pah3K+0ytda8iNT93LdzEFTeV/hD0fJNmBHs+fAEaGFiaL1hwqro
   csrRtIhGNtf/9mV+j/X9mseZNitPa7SIobRwySeIfQAk1V7FDjqZSR6Dz
   Q==;
X-CSE-ConnectionGUID: Am8HFbG8SwaXyptIO2ExMw==
X-CSE-MsgGUID: h5L+dz8/Rc2sBLMcqKbzhw==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtplv03.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 Sep 2026 07:16:55 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 0/3] overlay tests: generalize _check_overlay_feature for param-less mount options
Date: Mon, 21 Sep 2026 07:16:48 +0000
Message-ID: <20260921071651.25862-1-prabhakar.pujeri@dell.com>
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
 definitions=2026-09-21_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609210102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEwMSBTYWx0ZWRfXzQ4FLdvP8a37
 IyhSERejApGKNmQbrTIOLeRwzYPFN4uz0n5KC06PPTXA8HHI7V4hEx+y4I6dkZ7bF5olvMJNEpG
 3e529dytc28e4/PQw68j1nYce7+Ff6E/OpOYQA4H+hdkivl8XZpVoAtNxQXaQd6zEcDcHPdivgH
 3ZemY30uXrbYcK0K+BQrVaw+6VGWnG3AUqCJ2DWkGQQswyNEfSCNvfh79lHI8kICiseAX7P38De
 XiPW/B2iXRZGazTO6fQdBufyDoSduwNgYvvExWBouEMjmbnyUOTKNL28Q2uVrqSEymgC5EEaCi4
 zIj1t+JbKWwkopd7gUQrCQFXSg/yzLnbB7Uq1mJpxDnE+2Pvi+6Fi4J6tNGYpgpo3z3alfrqVcL
 x0Vf5R8WxFacM90SDecHKVjKFt86mRJRo4CemmbUEeBE++FVplfEM3/0IdjdtKKhNc4kR4T21gd
 ID6O5U1kuk3iyleFlLA==
X-Authority-Analysis: v=2.4 cv=M9jYuCws c=1 sm=1 tr=0 ts=6ab0d9ea cx=c_pps
 a=j0++y401J6f/BxNAf5EDow==:117 a=iGMIhCliR854E25UHWhNxg==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=gLxAKuEMs0EQMVFiDJnH:22 a=VwQbUJbxAAAA:8
 a=iLNU1ar6AAAA:8 a=9Ar1pYLYXZfDu7jisZkA:9 a=gbU3OgOOxF9bX48Letew:22
X-Proofpoint-GUID: __DGgAXGVvf4FP2Ye-ihLhlbtaZmE3gf
X-Proofpoint-ORIG-GUID: __DGgAXGVvf4FP2Ye-ihLhlbtaZmE3gf
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEwMSBTYWx0ZWRfX06XbXKOLQ27q
 x+VTHXyjIvVgVK0HZwyjfNNE5Kot5k54qsZu2sXlAs13XqrlNUYlrMjoLzAT7+sd8CfbE/S3ZpW
 4ir/S7WMvJOEQmoiXOhlrRSjhvFPPT0=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210101

The overlay tests that need param-less overlayfs mount options (uuid,
xino, verity) currently open-code their probes.  Generalize
_check_overlay_feature/_require_scratch_overlay_features once in
common/overlay (1/3), fold the six open-coded xino probes onto the
helper (2/3), and switch overlay/081's ad-hoc uuid=null probe to it
(3/3).

Changes in v2 (per Amir Goldstein's review of v1, all three patches
now carry his Reviewed-by):
- 1/3: drop fsync from the list of param-less mount options - it has
  no on/off values and cannot be validated with this helper; and
  replace the out-of-context comment in _require_scratch_overlay_
  features with a simple 'Validate that mount option can be enabled.'
- 3/3: trim the verbose comment - the v6.6 requirement is already
  documented in the test description.
- 2/3: no code change.

v1: https://lore.kernel.org/fstests/20260915153608.5197-1-prabhakar.pujeri@dell.com/
Suggested-by: Amir Goldstein (from the overlay/081 review thread)

Prabhakar Pujeri (3):
  common/overlay: let _check_overlay_feature handle param-less options
  tests/overlay: use _require_scratch_overlay_features for xino
  overlay/081: require uuid via _require_scratch_overlay_features

  common/overlay: let _check_overlay_feature handle param-less options
  tests/overlay: use _require_scratch_overlay_features for xino
  overlay/081: require uuid via _require_scratch_overlay_features

 common/overlay    | 16 ++++++++++------
 tests/overlay/041 |  6 ++----
 tests/overlay/043 |  6 ++----
 tests/overlay/044 |  6 ++----
 tests/overlay/067 |  4 ++--
 tests/overlay/070 |  7 ++-----
 tests/overlay/071 | 12 +++---------
 tests/overlay/081 |  5 +++--
 8 files changed, 26 insertions(+), 36 deletions(-)

-- 
2.55.0

