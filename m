Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD584AD4C9;
	Tue, 15 Sep 2026 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486577; cv=none; b=sfLFd8jzlqcZ9jJinE6ZUFa0SI38HrNVwmMw8X4AqI3pkHWKntrCUq462idyQnCtV05swsQILTp8uVtBH1EVHpmPmy6y+YGFa5E6OlUOuK6dzzYZCuKayObAef3uJzz4LO8f2jP4nXSv+ktYbQ7Rje6I2q/GFO3sihGgE0ZBROg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486577; c=relaxed/simple;
	bh=rkuJlhsObiXf004MibF6zw2S2An48d9wAl7zoqFG5zE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aKqDMf6wxl2yVAEJ7RHWhF5DcS703vagMEL1a9bcLM4cVYosDMgoKbD0adIB0rEBXYPvuLqqxqhJhFWdjc/Tm5vc49RZfYpAQ9/9HQ4S7x0yNnAmI+ueYJb8f4NUXF3pDH5DsLTP2JlrewvHyXY7WKEswzUwl0F4CbZtdH2g3A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=eWNTUR3X; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=LYY/Puni; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="eWNTUR3X";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="LYY/Puni"
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FF75Sv624878;
	Tue, 15 Sep 2026 11:36:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=smtpout1; bh=i1WXBfN/jq5GJ1UmvQT2YV2zBQ6yQNw0Bnqd
	j2YALGI=; b=eWNTUR3XUaEYpFeWmw228LGuZTmlIbkcl6yo7oymu1BtZ1rq89cx
	VZqJmst1p4FFtXc5TPXP0jfvgqzc/Rxnp2DkuE/KndrrGB3qJA8H96ksd0w375u7
	J0RNqQBsaGHLpHli67xHRAhafk5UEJaxS36waDFBugVO0GGG0VSStWTtnYux5IST
	+rxcfog5qUWcofxXGPKKWYsiU7p03prLj+QD4Zzs2AZm9eCDp9ZOZH4kTIi4eYph
	X//8uXwcbxZax45d4mCCn1qOqLFE8eQqeEuOhyvId9f9qujaHwi+aWCHZAnc5JSv
	P5uWsz2f9CrUADCcEoQy+KKKweKzJd+/FA==
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gn22gc5xx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 11:36:14 -0400 (EDT)
Received: from pps.filterd (m0144103.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FFX5E02279432;
	Tue, 15 Sep 2026 11:36:13 -0400
Received: from esapsmtpat04.us.dell.com (esapsmtpat04.us.dell.com [143.166.211.147])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gq6ksjp7y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 11:36:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789486573; x=1821022573;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i1WXBfN/jq5GJ1UmvQT2YV2zBQ6yQNw0Bnqdj2YALGI=;
  b=LYY/PunihHrFVyMgq73VztiOVUV5fmBxAXN7RhoZ3VEGRv53hy3zAcUX
   2VgMxHHHzxAxxgMElrbM9rbvPdnEfg3qJor/4MuNIg06QjmHZDei3GcFo
   FAnE/OEiH8iDuzDrrnwwlU5Gact8++rfoHwndvB6JAHzzDBOD8/p4tJ3j
   l/Qwh5dfJwEM/xLTufhkk1ahSX6OoiAQRR1OtkNST4TsgyH8Zs/gTc4Z0
   o98LhOAtFcKTZXFxwFACs3kvMNvIsPyfaf8qf5QGZeUd2ErStz24J/h3B
   sFYlcrLZReRZfCdO/b1Wtd8vRZeNq5sCAfg7TAl0dhu9qM/SM8rhW7BMF
   g==;
X-CSE-ConnectionGUID: 0UGjMVorQLWGO/Oc4YPQGg==
X-CSE-MsgGUID: fnDT13vfRomBHolKYBmcdg==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtpat04.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 15 Sep 2026 15:36:11 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 0/3] overlay tests: generalize _check_overlay_feature for param-less mount options
Date: Tue, 15 Sep 2026 15:36:04 +0000
Message-ID: <20260915153608.5197-1-prabhakar.pujeri@dell.com>
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
 definitions=2026-09-15_04,2026-09-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150227
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDIyNyBTYWx0ZWRfX/Dr37M/CFGrq
 XOyN2fYt49tQWwJ/i9h/WvTTMwx4yfbDCeFo/07rsRoYgVRS7p0Qi4uF0Cv6oatI/npte4cx/Ak
 aIlTsn/xWk4Nzgwdk2vhTtSmBAAYHyBpPZbjt3Pj7xBYYZnOe8bcpYirGEJIIY6dOQ5uwjjiF9z
 nFiqcDda2d5ldo3o8gbF20NOecgdmkG5zZ6FI/1qdmm7k439zdCU7KrX5u9A8FguGCrh2X5soJ+
 xCX9wmCcXtpFwqaUz8pRBsoW1FMliBquk6cdg6pb7ioxDDdecI5ww005DJWnS3SvO+2S/YzE3fV
 xFHqgWrqpiF/LKXEWJtwciTrEdYpMJAgea4l8Ogc9DujuMPcxfoyff9tL7B9aDBTEjTYyHVmCaU
 eTvFLm9P3lQvWOVr/sNT+5KZYEKYyZDHsAlNnFFvIE72F24TZOzmbyheS1IsP/s0mvA4QmYn2ii
 Qh0CM854Y0wIp5gMgaw==
X-Proofpoint-GUID: UNrmjHPEl5T87tYfATAUCJqfRFVLPykY
X-Proofpoint-ORIG-GUID: UNrmjHPEl5T87tYfATAUCJqfRFVLPykY
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDIyNyBTYWx0ZWRfXzrttAON5nRun
 MehLpmbXgJtwMAFm0Lu4bvLJ10XKheMyCP2kTSWpf2fzRrfN73hYU8nHHd0BVrvNzw2ZKRxNZQY
 k0bYHCXtN+bj7xSDQtGseboW2gRceaY=
X-Authority-Analysis: v=2.4 cv=T+UZ3PKQ c=1 sm=1 tr=0 ts=6aa965ee cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=xQoiRHjKKYbJmV+sD1MyuQ==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=2Lpba0WeoN7BYVdwMO11:22 a=VwQbUJbxAAAA:8
 a=iLNU1ar6AAAA:8 a=zJpZ7D4x8l0pMBFkNQ8A:9 a=hlJyneSgMmFPbskH-t2w:22
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150227

Followup on the RFC from 2026-09-02:
https://lore.kernel.org/fstests/20260902113536.6573-1-prabhakar.pujeri@dell.com/
Amir answered the same day: "The patch would be welcome".

This series exchanges six open-coded xino capability probes plus 081's
ad-hoc uuid probe for _require_scratch_overlay_features, made possible
by a small generalization of _check_overlay_feature for mount options
that have no on/off module parameter of the same name (uuid, xino,
verity, fsync, ...).

01 teaches the helper: for such options, a missing parameter means
   "defaults off" rather than "unsupported" (per Amir's sketch);
   support is then validated by the probe mount itself, which a kernel
   without the option rejects with EINVAL.
02 folds the six xino tests (overlay/041, 043, 044, 067, 070, 071) onto
   the generalized helper, deleting the open-coded mount+grep probes.
03 switches overlay/081's ad-hoc uuid=null probe to
   _require_scratch_overlay_features uuid; the remaining mounts in the
   test keep their current options and legacy uuid behavior is
   unchanged.

Behavior note: on kernels with overlayfs support for these options,
_require_scratch_overlay_features previously notran'd for xino/uuid
(because /sys/module/overlay/parameters/{uuid,xino} does not exist);
after this change the probe mount carries the check, and such kernels
pass as long as the mount options are accepted.

Prabhakar Pujeri (3):
  common/overlay: let _check_overlay_feature handle param-less options
  tests/overlay: use _require_scratch_overlay_features for xino
  overlay/081: require uuid via _require_scratch_overlay_features

 common/overlay    | 19 +++++++++++++------
 tests/overlay/041 |  6 ++----
 tests/overlay/043 |  6 ++----
 tests/overlay/044 |  6 ++----
 tests/overlay/067 |  4 ++--
 tests/overlay/070 |  7 ++-----
 tests/overlay/071 | 12 +++---------
 tests/overlay/081 |  8 ++++++--
 8 files changed, 32 insertions(+), 36 deletions(-)

-- 
2.55.0
