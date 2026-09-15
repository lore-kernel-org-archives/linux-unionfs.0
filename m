Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C60415B60;
	Tue, 15 Sep 2026 16:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789490674; cv=none; b=N79JSLrn9YTiIkDXFGfLpZnQLwSJk1KhkK9lzYBTXH5zA6lQP9O/Z9zggImxPDBH8Tqi6Yjr6t5O8VRoKNx+u7+/ca/SbD++dbPoTwPhQIr/Xs+fkyAydM0O8KmBi+xBedo1Q8Kqqv2njD1F58Mmw9ilnyyY/x4r7aCFVaZN97E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789490674; c=relaxed/simple;
	bh=cyZbHAUWM7KDcyZfNdNEZ5jRfh1aR2gD/Lg3eL1i7BM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LLiAc1ZgcMyHMAEID4i10vdoqvWbouEBRdsZZIteZWfbaXsibgrVSIyOSESThLe7KEHPW3WX8BjKZ8I0x0RVgdrCDAI2EmMGjOZYbdznSkqkucarpvCQiB8YlFWUa5t0cRG61xy5sJD3ZnYQ1kOX7Mpj50Yv/Wukqb5C8RYXXCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=HW66NxeM; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=FJ1Kp9P1; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="HW66NxeM";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="FJ1Kp9P1"
Received: from pps.filterd (m0170390.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FD1ePI2980031;
	Tue, 15 Sep 2026 10:17:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=smtpout1; bh=988TgQoS7paHUwcJekFHCNErcojXHWon2mhW
	c/T1nOs=; b=HW66NxeMMOKLPd5KSj41xxqzT5JRlY/l3kvALTtJjZ1HciDCoJsO
	Nzx3dAuyeasH9HJMRVT3pd6OenIRfsOexZ9XdYUg/TyMjDjm7PVlEaClpBBlQJ8w
	nLOAEaya6QaiZwNDP98QNfRtjfo5QmwavGwQgU/JJ52Zu6+uzctRgAq7lQn0OTf1
	jHG0v4cQ0W3GvBtDjGPLL38QwP+Xz8pXgUZPM/mwK9h5/7jyszjECGQ6NsrVZn2h
	l8fP0z2JLJVoPFmTGmUnr+8mLhCiTD2162XGXSTietWhHop42Zg15+nDPkuWqlSq
	PgATC064aV1Cz0DZCmmmcqun2yxoaaAaqQ==
Received: from mx0a-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gn1sy3rkn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 10:17:54 -0400 (EDT)
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FDxS9C3661268;
	Tue, 15 Sep 2026 10:17:54 -0400
Received: from esapsmtpat02.us.dell.com (esapsmtpat02.us.dell.com [143.166.211.150])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gq4m0k5v9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 10:17:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789481874; x=1821017874;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=988TgQoS7paHUwcJekFHCNErcojXHWon2mhWc/T1nOs=;
  b=FJ1Kp9P1yR2NPgq8xCh0ssGvjYNSvYMBUA+lk3TU6Gjf5M7FwC2TP2Gy
   QotfsPU4s/CZ9NBQ/GlkKkuX31mbcXIlg6j9VtmdAuzSMcRtlhOhe7jqX
   w63lDMcm15pRBZOH2+hap0/LKgJCbpV1ATNKflTKLKG8kxCJbAeMHii6d
   lZunEEGAnqBALEbFYznzZCftY5e6tZr1lvM/fjo6ooLIXkMrbb6zIAUHS
   DDpEIOVQNINTNJxuDQ5N9Xev2nRZdKUmbEOIPCkeF/zArUIGzDE/i2hqN
   1BMOrembSZrkzpk/z7/I0qvhfpeAidIqr3eURDGwMlYYrhDZR4+T1iW/q
   w==;
X-CSE-ConnectionGUID: 7YLh5tLUSvWO+o0wcNw0JQ==
X-CSE-MsgGUID: xdf7yzi3SBi1NpfElWHKPQ==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtpat02.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 15 Sep 2026 14:17:49 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
        Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>, Anand Jain <asj@kernel.org>,
        Filipe Manana <fdmanana@suse.com>, quwenruo.btrfs@gmx.com,
        linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v3 0/6] xfstests: add missing _require_scratch checks
Date: Tue, 15 Sep 2026 14:17:39 +0000
Message-ID: <20260915141745.4299-1-prabhakar.pujeri@dell.com>
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
 definitions=2026-09-15_04,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150207
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDIwOCBTYWx0ZWRfXy2izKdu5663A
 PaJ9TiQUkj+z2GnspR2/rL10538Ru59IM0hEzOUZ6NdosseGUx4VTSy/WfSvieOoeZP4Ds1H9SL
 XQnF/LrPxCJ+N1oQ3K6Px+AT3+Ujxug=
X-Authority-Analysis: v=2.4 cv=FtyQbGrq c=1 sm=1 tr=0 ts=6aa95392 cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=i8a7nF7jFa3EbZrjgrQYpA==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=sEWawkeXllE7TocFc0N_:22 a=VwQbUJbxAAAA:8
 a=iLNU1ar6AAAA:8 a=EjSTBG_SgHjXaJ5rYncA:9 a=hlJyneSgMmFPbskH-t2w:22
X-Proofpoint-GUID: SAmdIxzceeLNuBvbBfLcobUJw-PdDxxP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDIwOCBTYWx0ZWRfXxSwF33Gsva9k
 RadiwCJX5KOOjvFr+Fulx9U7GBNDtdhZCTAj6ryD/BLLkhb1B4ke9GsG2hipGIvPwvyYczv73gS
 ldvOLxMOKYPQzwJxgt2ZLRPi7uaPY1e4ci4i2gJ/d5VePqR5q6cAIeU6qyTOd8xyrpN6x/D6dMF
 ifp4ye/MqxMWawDmpkA7Ac5f6mfMbAxohIHhkhtg+ut9lhy3tK3BhUeU/YLdg5oG+FXIFP/Inis
 hKyqV1niTU1OT64XwcRm1rcDHHXdObbGJVxm3h5kdBOhg3FvWQPBdX9R5p937usCCrpXgSvIQtt
 ibU82I7bN52J9Npz73w94AQGrmgeKIZqc+DtX6jB9yHvzgBqOJyLfHCj6OAaRAmkLZsI73EqEo7
 JpcUCw455fK7Iw1RKhsixIy9RJ1Pxy+2OJXpBMJBM/ulHo4rxj69zznEjKbv3xK02ZzOkb8rMqA
 1r72ehE5aB2IYT94uAQ==
X-Proofpoint-ORIG-GUID: SAmdIxzceeLNuBvbBfLcobUJw-PdDxxP
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150208

Fully consolidated resend of all remaining _require_scratch fixes, as
requested by Zorro on the v2 cover.

All of these patches add a single missing _require_scratch check; with
the exception of btrfs/333 (which places it at the top of
_require_btrfs_iouring_encoded_read(), per Qu Wenruo's earlier review)
they are plain one-line adds directly after the resource checks.  No
other changes.

v3:
- Merge ALL six single-line fixes into one series, per Zorro's request
  of 2026-09-03 on the v2 cover letter.
- Add Johannes Thumshirn's R-b for btrfs/273 and Chao Yu's R-b for
  f2fs/015,016 (both since v2).
- No code changes; patch contents are identical to the v2/v3 versions
  previously posted individually.

v2 pieces (this and the three it pulls forward) for reference:
- [PATCH v2 0/3] https://lore.kernel.org/fstests/20260903035344.752-1-prabhakar.pujeri@dell.com/
- btrfs/333 v3 https://lore.kernel.org/fstests/20260831104200.2269-1-prabhakar.pujeri@dell.com/ (v1; v3 was posted but is not archived)
- btrfs/273 v2 https://lore.kernel.org/fstests/20260902050145.2439-1-prabhakar.pujeri@dell.com/ (v1; v2 was posted but is not archived)
- overlay/081 v2 https://lore.kernel.org/fstests/20260901132438.759-1-prabhakar.pujeri@dell.com/

Reviewed-bys carried (per the individual threads):
- Darrick J. Wong: generic/590,735 and generic/795
- Zorro Lang + Chao Yu: f2fs/015,016
- Qu Wenruo: btrfs/333 (v3) and btrfs/273 (v2)
- Johannes Thumshirn: btrfs/273 (v2, second R-b)
- Amir Goldstein: overlay/081 (as Acked/Reviewed on v1; kept)

Prabhakar Pujeri (6):
  generic/590,735: add missing _require_scratch check
  generic/795: add missing _require_scratch check
  f2fs/015,016: add missing _require_scratch checks
  btrfs/333: require scratch before checking encoded reads
  btrfs/273: add missing _require_scratch check
  overlay/081: add missing _require_scratch check

 common/btrfs      | 1 +
 tests/btrfs/273   | 1 +
 tests/f2fs/015    | 1 +
 tests/f2fs/016    | 1 +
 tests/generic/590 | 1 +
 tests/generic/735 | 1 +
 tests/generic/795 | 2 ++
 tests/overlay/081 | 1 +
 8 files changed, 9 insertions(+)

Base: upstream master a370dcbed43563f0462801e889e0eceb93c7cfad
-- 
2.55.0

