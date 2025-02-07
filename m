Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B79338385;
	Fri,  7 Feb 2025 07:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738912422; cv=none; b=BHCf0N52Fm1Fw4HU8MDy0Ol/o+NFD1mg3vGQvlWtVkUBsBjfJlBQHInD5YzdBsx/PZ6stP/r6htibdlcPG6YdRKveWNsFlXsUddKXbl+qgST/vP9oU4WQu2uIgvH7bDGANHKHTIYvPWVEdoT52u/vsKponmGLKWSoTY4X6FwHfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738912422; c=relaxed/simple;
	bh=xxVgXHiMhwNP0eVYaANZcBTpiQrEeHtbdNpeP2OJ67Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A5rYG9WeDuuZIoHypuNAsNcBzpE1s5yackd8M8LNLNAnE9C/RRze+jw9MX74e2OczjQVc292XI9KUwy0A76DnMlg7N8gBom9/US05AnkfASx5ixzLbzbaUEIPaWPFafN/zk16SL/YsDfoh3qs4gRennm3TAs/Jw9z6DZiru5xd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5176POxI014337;
	Fri, 7 Feb 2025 07:13:35 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 44hak8ebhh-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 07 Feb 2025 07:13:35 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Thu, 6 Feb 2025 23:13:34 -0800
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Thu, 6 Feb 2025 23:13:32 -0800
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com>
CC: <amir73il@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-unionfs@vger.kernel.org>, <miklos@szeredi.hu>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH] fs: prevent access to ns if it is not mounted
Date: Fri, 7 Feb 2025 15:13:31 +0800
Message-ID: <20250207071331.550952-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <67a4b9e8.050a0220.d6d27.0000.GAE@google.com>
References: <67a4b9e8.050a0220.d6d27.0000.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ecXHf6EH c=1 sm=1 tr=0 ts=67a5b29f cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=mBFNkg7MoRF0wqN7:21 a=T2h4t0Lz3GQA:10 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=m8C4TbhgitY_sglkjtcA:9
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: gPIaf6M_Go-IGKh52WEN-WagHuCsCJI0
X-Proofpoint-GUID: gPIaf6M_Go-IGKh52WEN-WagHuCsCJI0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-07_03,2025-02-07_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 malwarescore=0 mlxlogscore=419 priorityscore=1501
 impostorscore=0 clxscore=1011 lowpriorityscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2501170000
 definitions=main-2502070054

syzbot reported a null ptr deref in clone_private_mount. [1]

The mnt_ns member should be accessed after confirming that it has been mounted.

[1]
KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
CPU: 0 UID: 0 PID: 5834 Comm: syz-executor772 Not tainted 6.14.0-rc1-next-20250206-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:is_anon_ns fs/mount.h:159 [inline]
RIP: 0010:clone_private_mount+0x184/0x3e0 fs/namespace.c:2425
Code: 89 d8 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc 48 83 c3 48 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 4d 89 fc 74 08 48 89 df e8 db dd e4 ff 48 8b 1b 31 ff
RSP: 0018:ffffc90003e2f958 EFLAGS: 00010206
RAX: 0000000000000009 RBX: 0000000000000048 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff888032eb2710
RBP: 0000000000000000 R08: ffffffff8ea81ca7 R09: 1ffffffff1d50394
R10: dffffc0000000000 R11: fffffbfff1d50395 R12: ffff888032eb2700
R13: ffff888032eb2720 R14: 1ffff11006b34091 R15: ffff8880359a0488
FS:  0000555584629380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 00000000786c2000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ovl_get_layers fs/overlayfs/super.c:1061 [inline]
 ovl_get_lowerstack fs/overlayfs/super.c:1156 [inline]
 ovl_fill_super+0x1a24/0x3560 fs/overlayfs/super.c:1404
 vfs_get_super fs/super.c:1280 [inline]
 get_tree_nodev+0xb7/0x140 fs/super.c:1299
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3659
 do_mount fs/namespace.c:3999 [inline]
 __do_sys_mount fs/namespace.c:4210 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4187
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported-by: syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=62dfea789a2cedac1298
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1314f11ed961..8e2ff3dbab58 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2421,6 +2421,9 @@ struct vfsmount *clone_private_mount(const struct path *path)
 		if (!check_mnt(old_mnt))
 			return ERR_PTR(-EINVAL);
 	} else {
+		if (!is_mounted(&old_mnt->mnt))
+			return ERR_PTR(-EINVAL);
+
 		/* Make sure this isn't something purely kernel internal. */
 		if (!is_anon_ns(old_mnt->mnt_ns))
 			return ERR_PTR(-EINVAL);
-- 
2.43.0

