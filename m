Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D164B4A498F;
	Tue, 15 Sep 2026 15:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.137.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486578; cv=none; b=QzYxiFkOlk3tTCvXX5xUIZ0wpqK7mMGyKO9nmm480u0LnDocP8FOFIMl9mWkhrZ01mIGWjBHwlpfOIldHLX2DAUBpzlBYXPkFDs0faogdsD7oKwH+S1YAjZ5nAzhKpiOA8bUB+qHpD01cYGuRDgYhXKnpGTCIgEzZBfpMfhRKxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486578; c=relaxed/simple;
	bh=1mB+0+aHX8d8RTEKwa8n/f1l9HGEOFn2qx2EwKSaJnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP4zphqoMHaNY+Pw2v3DycCPjOoDNVXqxwWvdgT5mHjMc2OCsuQ+l76+ymyv1FNQJV+I3mqjTazcGbHwFW4mlN3MnbWHfCt98cnuruy47Jrhl3/a+FWFkX7fOupDBxt0hX718V41osL3V2vS4rKvT3zCgsHHaJKk2w1r1bgJTMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=QMbuCuZE; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=Yv01VbIk; arc=none smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="QMbuCuZE";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="Yv01VbIk"
Received: from pps.filterd (m0170397.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FF7BaX895524;
	Tue, 15 Sep 2026 11:36:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=smtpout1; bh=0U0MNhC2kR5V
	/5x1prgTStTR3D8ESBuI7sX6CY9hWWY=; b=QMbuCuZEUTJLoMC+NcKFk9R1g+uk
	0xAVSiz5xecKQXWShboD1h8JT4lINcPW9xr4xRLtJR7Xul+UMSDG2dN7sVSVO22P
	z+QjKstB0eNP48sucGQ9opf3KS+Odt1E7B3TPv/dJLKhfSjMUprLPEGi7pUuHGi6
	08bmcRr54si1HmAgHe3a6Xag046PSg71tENPQvlWz4opUm+gnmnvpjD4RIRdl0cy
	dEz4P83OsVGzvQJ4W+zjWm9dNECxwVY0VJnlBUk3sVWstP16J8yCXNIsGm8Z6eoJ
	7qvNS3w3+hp5VndslxGeGz8OjuO4eaouDy/EtxhEY4ffCHAvBL38ONST8w==
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 4gmytp4e2u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 11:36:15 -0400 (EDT)
Received: from pps.filterd (m0144103.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FFX5E22279432;
	Tue, 15 Sep 2026 11:36:15 -0400
Received: from esapsmtpat04.us.dell.com (esapsmtpat04.us.dell.com [143.166.211.147])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gq6ksjp7y-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 11:36:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789486575; x=1821022575;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0U0MNhC2kR5V/5x1prgTStTR3D8ESBuI7sX6CY9hWWY=;
  b=Yv01VbIkhzi+sbCi2fiIdgx0FaP9Z17qVDrxzbv3ufcP3FtZFeKV2tvJ
   QIMqg4C5/vGoZJyQ9S8jvVt4NubWEc/IfGRAYCOAoYEgklylficTylndu
   WOh3SdISyQnqIlmy1lUgScxaRnfM5HY1JxFO/tfbHSpzHfJXy1g5PnGkj
   n6KCdU1Saf/YnLt4VcQ7sC/94ENMG6zXOpKdegwIuNTjWCGfweb9R05YY
   uoia0PpIXrEl0FJ1hCaBYL59k3tZ64sx5B6D7goNEKI3s7TsWtCG6BmsY
   2Mvje2jXyQX2iVEFVNBYyPAR+uRmEdBPCZAyzpErJdDfLkKZYhLgMw6Fp
   g==;
X-CSE-ConnectionGUID: vgI/7es4T7ueKk2fM9HqSg==
X-CSE-MsgGUID: YyADaxc7SjqkFokwhVLUlw==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtpat04.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 15 Sep 2026 15:36:13 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 1/3] common/overlay: let _check_overlay_feature handle param-less options
Date: Tue, 15 Sep 2026 15:36:05 +0000
Message-ID: <20260915153608.5197-2-prabhakar.pujeri@dell.com>
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
X-Authority-Analysis: v=2.4 cv=UoH2pOwB c=1 sm=1 tr=0 ts=6aa965ef cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=xQoiRHjKKYbJmV+sD1MyuQ==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=U3ti1ie9CgboSd2qXsAw:22 a=pGLkceISAAAA:8
 a=iLNU1ar6AAAA:8 a=m6CvIFb5P7bHGLyLtIoA:9 a=hlJyneSgMmFPbskH-t2w:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDIyNyBTYWx0ZWRfX1Vc69VFcXGzc
 BNndwO8iyPlE0zoLcr6f1Dyvh2X66LXnR/IxTzQxhqsOMuy0+UWe/OO+hVz5TRSAQOG0MV0G8Ly
 hT7jJhT+JGha57uM/3B/Cv9T6OOm8Kg=
X-Proofpoint-GUID: YlgOH-zeZYT95PTFDrkk29u8sadgCMh3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDIyNyBTYWx0ZWRfX+pzH08REQ33n
 2NPj7xzZQNPTmTq6LHCHW0ARZiG4Fk56AVjHArBC+pEEQmNqQaWBFzqXNXmbJbuEQSG/eXc8/Og
 ZpBr4wBsKBj4yRvN/Jb/UTn725W95QT2DiuvFjakxk9ve4OpZdTeCnKAH8C/Nnv1uNuf/BaRFcD
 AKBDUTPotz651yWurc9iRKmzjPmPKFNjzsHpngr1OdqC3kn+L+kaFoMcGdtRf5szTh8lifZQZwk
 aJ8nGlbug25yGLELYntKJrKtqibaSuOjzY7zIlWYV+GpRXdiJc+jTvyXD3Tzp4qXJt1JJ0FQCSk
 9JwCImu4zM2OmvK+JFP0hBf/wYepNT6QQ1M2V+b2GR/M4NQ0QH17guH8afNckRJkL4bTU/I8jYM
 m1jxMy83msWli4jE+s1ZxkDcyGJvmgE6Q00pLgEhFh5gODyLtNHvWMLxzQuyCiytv/7C3Dw0yi3
 9cp16fdtGwOuWaZpW+g==
X-Proofpoint-ORIG-GUID: YlgOH-zeZYT95PTFDrkk29u8sadgCMh3
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150227

overlayfs mount options like uuid, xino, verity and fsync have no
on/off module parameter of the same name, so _get_fs_module_param
returns nothing for them and _require_scratch_overlay_features notruns
before the probe mount is even tried.

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
Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
 common/overlay | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/common/overlay b/common/overlay
index d32f3219..89413933 100644
--- a/common/overlay
+++ b/common/overlay
@@ -172,8 +172,15 @@ _check_overlay_feature()
 	# parameter (the system default) and per mount by mount
 	# option ${feature}=[on|off].
 	local default=`_get_fs_module_param ${feature}`
-	[ "$default" = Y ] || [ "$default" = N ] || \
-		_notrun "feature '${feature}' not supported by ${FSTYP}"
+	if [ "$default" != Y ] && [ "$default" != N ]; then
+		# Some mount options (e.g. uuid, xino, verity, fsync)
+		# have no on/off module parameter of the same name.
+		# For those, a missing (or non-boolean) parameter means
+		# that the feature defaults to off rather than that it
+		# is unsupported.  Unsupported options are rejected by
+		# the probe mount in _require_scratch_overlay_features.
+		default=N
+	fi
 
 	# Check options to be sure. For example, Overlayfs will fallback to
 	# index=off if underlying fs does not support file handles.
@@ -192,10 +199,10 @@ _require_scratch_overlay_features()
 	local opts="rw"
 
 	for feature in ${features[*]}; do
-		# If the module parameter does not exist then there is no
-		# point in checking the mount option.
-		_get_fs_module_param ${feature} > /dev/null 2>&1 || \
-			_notrun "feature '${feature}' not supported by overlay"
+		# Some mount options (e.g. uuid, xino, verity, fsync)
+		# have no on/off module parameter of the same name.
+		# For those the probe mount below is what validates
+		# support, so a missing parameter is fine.
 		opts+=",${feature}=on"
 	done
 
-- 
2.55.0

