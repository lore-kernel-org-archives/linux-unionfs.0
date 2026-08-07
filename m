Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0989F39183A
	for <linux-unionfs@vger.kernel.org>; Fri,  7 Aug 2026 07:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086355; cv=none; b=atCHXNeQTZLOsKauZ7Y/RMcNZWeqtyCWU3MP3Ws6c8xpi7iJDZbPeEothnlvZFnub/cEQKUjC2RInI39ZblZ0MhC77jf98GBOFjQX7KVdcWwONRmVZ4Fh7LMOVMMYJwOxzhgzCKCjei7ORqlZrlH37Uh6uSTUbuweGNyldMnWI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086355; c=relaxed/simple;
	bh=0BSwFZg9jiOOf7YFllMbZ9tdQprZENRwTtd4sYc6ERE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=NxvdpIIGGYx+OvVQOEUO+VvbKlqFAX4jqKxCLscqktL/s3lNLk8RzulVvD4NJGhuIsam9HTGpNqioQeMNiStQLYM1wyPpGtiCZcQ4CV1vRPqMZangtkrQ6xk0f4wTvV25r09UfZyArnnE3IjcS8lNXuJNNJUgwEfXxXE/aYmG18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bWfqsmLt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XsRAds/I; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bWfqsmLt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XsRAds/I"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770H1Aq3252457
	for <linux-unionfs@vger.kernel.org>; Fri, 7 Aug 2026 07:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=guyea8cIujPgoSwckRlogS
	1AkJcoAzrtOivJuLB5mfs=; b=bWfqsmLtQqi+E59YlwG6r9YmtB0e1emD61jJad
	vQg2DjGs/mlc2moe9T7G1i28cbTvX6yEf1gd964mUzQi2qOlORGN4OFHk4nn+T5V
	YfMV+nhGldm+KoMLd1IfC28eJ7eCj1nCb0Oq19DvWJR4HvIq/pT5/OU040bTdz17
	/Oh8KwogyjekH3wnBk+vA7w0w4PuKJecYPcwJqiQi5icLgFqUeWuU8CZHE7D7vvt
	7sGcW9bp5PVAw1i+VW5zlez+daP9TCLlsht0kil5ft/110Sm4g8EvTOARIu0x5JK
	t83AJ5IiGrXPy9Vsx147FGo1FxUBVAtgdsh3m1LNb6w5ekIQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvy6k2r4n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-unionfs@vger.kernel.org>; Fri, 07 Aug 2026 07:05:49 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e667368f0so4891590a91.2
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Aug 2026 00:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786086348; x=1786691148; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=guyea8cIujPgoSwckRlogS1AkJcoAzrtOivJuLB5mfs=;
        b=XsRAds/Ical4c/SJLriy6FxOVOVQdPXHV/M9Oit67APhIbpujaESf8iIa+nM55dmKN
         +lfSDUMMLtaTmsyhe2t1flndzUahfqcnbBIuVPF217M0zQQDmVp4jSKjYeiSOiZZLxrY
         J9WCgAF2fsXyCPs1DPW4DdCfwvMIDbOIDTTv4u8t0gckpdZnnVshA2+W2DToeZj0SflX
         mLRtSRDg57aGhEdlJqy70F0H8d2IKh/3GZB16CzcQY4/0CNFyEsTixEfFgx5i3Tmv4jP
         QuocEA0N93X6uZEnF8ZsKxZB0u2dDG6wbtBngNpV8kX/NW968X8dShDYRJYuApYuSDVY
         LDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786086348; x=1786691148;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=guyea8cIujPgoSwckRlogS1AkJcoAzrtOivJuLB5mfs=;
        b=SZOCFybNBklZL3yfYe8CaB8T9Z5O3F45MgTBF86FCGRtNAKUmyKnqdBmfNO9WdWbBS
         eYVyvijxB5sfrnHDRJHXnKlKAJGn+mMtLsKa3vT2u6QvBoqcrT3qup69/41H/p4I2PAm
         uZuE2DWTERecz/PJ0EwWpHqVf7ONt7QBjQq/qLfQjeQbq0a+beLWoooVRS/9znj/1RFY
         nBWntU8kBS//B8tdYfhqQ9jRTxb0DOUlPDO0S5o/DM9pFbm1nsbiNc0HC7fiIoDp6Hv6
         4VYoZ9FDV/aM8GiStf+YvwSZz3DYbTg15sMtpHyd3QfNiF3vg+kErkJnTgUDkdfkBGg3
         kXaQ==
X-Forwarded-Encrypted: i=1; AHgh+RqaezbMgNoj+5gPKsBbyg3ASdVtqI91yym+5l0kUoT0jyg5E5Vln6VyHzoLGyw3v2JS5Zp8IixS5EwXJfKb@vger.kernel.org
X-Gm-Message-State: AOJu0YySf9/VcziO9hZ+g7Yi6QD/EWh0whJbalnS5LeNtdQwvIvUDOn/
	fKofEjfzr2Z0PtBQXKtjI7ywrHM9gTAk0KhpNqr4MxDmgXGKz3GtqBKWpVvqNKvr+FJ4TU3P5Bq
	xFoqtt4J9LXTEsNgaC+jl7Yp3Tj4g/5Iw9P4RlHVBuTWenPFfUXti6aD96Yc1gpRaYtfy
X-Gm-Gg: AR+sD11SGycN5GVVSBrWs6uTntjv1Pr9U5g37AEoUviFn8X0oi9WaUoFdnNdKJl09Dx
	707SKXkJ5wDejBuI4e+mZSrzk/vlyWYxvn6kyXBWhGEkZstZwGRYi92k3h673eFwHQN79UfOvhh
	1JUlNig0QUnqPwOLKsy4W14N/2TQ/JRFZ4lOeEf98WuPLPnSEgnLBtW6tjr0ZAGk+AWotx2yDk0
	1zJU9I7nG14AH3VPi7JHxUB/dSHrAkoeYYW5gaIqBfdYuVK9A7mGI6WpXK8BT07PBz0PkBzEqv3
	Ezzoh79KgQ9dWhvUij72TAyYOp/0nngTPdEP791a+rK6MqhnkYTK1wY/GqqLB97Fjb1rFJfUwfZ
	iQJyg1GOOlSkhg1PjUe7+DGK8kIxaM5tSr94cvl9ectzUhIJ/wzKwjBtbcPjAVJPdr++WRSTL4P
	8To4n6IIe/idUu+NWhj55sh05SyBBoVg==
X-Received: by 2002:a17:90b:28cf:b0:381:11eb:d78e with SMTP id 98e67ed59e1d1-3903c5d321dmr20548534a91.14.1786086347899;
        Fri, 07 Aug 2026 00:05:47 -0700 (PDT)
X-Received: by 2002:a17:90b:28cf:b0:381:11eb:d78e with SMTP id 98e67ed59e1d1-3903c5d321dmr20548476a91.14.1786086347450;
        Fri, 07 Aug 2026 00:05:47 -0700 (PDT)
Received: from hu-varada-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bebdf796sm3815914eec.22.2026.08.07.00.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 00:05:47 -0700 (PDT)
From: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
Date: Fri, 07 Aug 2026 12:35:25 +0530
Subject: [PATCH] ovl: fix NULL pointer dereference in ovl_i_path_real()
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-kasan-v1-1-50da6e58cc20@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIALSDdWoC/y3MQQqDMBCF4auEWXcgCjHWq4iLNI46FKPNpEUQ7
 96gLv/H49tBKDIJNGqHSD8WXkKO4qHATy6MhNznhlKXla51hW8nLqB56sJ6O9i+NpC/a6SBt9N
 pu6sjfb6ZS9cILyeEfplnTo0KtCW8SQPdcfwB92UN3IgAAAA=
X-Change-ID: 20260806-kasan-59017c7f7d85
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=RpX16imK c=1 sm=1 tr=0 ts=6a7583cd cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=ZzjbTN-_bFd17bKXsZsA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: w-twlBLfzJyycGBoktHYIGqxy6n51Ezh
X-Proofpoint-GUID: w-twlBLfzJyycGBoktHYIGqxy6n51Ezh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA1MSBTYWx0ZWRfX+r1HMZjrHvRF
 gP7JNDofT3sCAWrYAtnwLPBHdto9RndgTZZDgxEILO1cw8Aeey0UaxYn6GiKq8BC+HrseQWUmYP
 Pqz1673GMP2hjmbwfyy0Ialw5D+JTa+O90DxWMETAVzp21Lrrw7hLFuvn0K3ta0VjU7FBWYCbl4
 h6roVcufbVnK0stFg1R4GMfURjNa7Tu5BbQIskShlJJABchCUc+A6yUR+9dAEeR3Sb3Ip0TgKoJ
 9XJco53WHLkaznAAwDtRdBpj2jZJfV05HvwXke7bZ5e69IwCXnH69amJXRAlBAuVOpKkG+ywBda
 ySLGz18QQ2VgAXEeFjC7vhgOsbzlTx3QHhdQm86+BxRqImBOMnXtSWbFulYoc1hyadLvwguzxCI
 ffQ3txNGN0J4E1nTZNDFEO70KbhE0Gj0MbOIWG1yZ5VdXCiwHTbXuZGQLs39QwdMQNBsm6u3p6z
 z5p727XQUIfrzVHjwuw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA1MSBTYWx0ZWRfXzcROBSk6Js4s
 dEIY1U4aLA8hJSm9qWUqpi8VF1/CoanEMg6l2NYuVZTPI95oU+AS6i6PjtQcQvLB9hLA1azQvqr
 yoMUjqiaEhq4Iqro/FDnsOeZIXDqpT8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1011 impostorscore=0
 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608070051

KASAN reported a NULL pointer dereference in ovl_permission() when it
called mnt_idmap(realpath.mnt):

	BUG: KASAN: null-ptr-deref in ovl_permission+0x150/0x190
	Read of size 8 at addr 0000000000000018

ovl_i_path_real() can return a path with a valid dentry but a NULL mnt.
This happens when the inode has an upper dentry, but ovl_upper_mnt()
returns NULL, for example on an overlay without an upper layer. The caller
then dereferences realpath.mnt and crashes.

Also avoid dereferencing lowerpath when it is NULL.

Fix this by checking lowerpath before using it, and by clearing
path->dentry when no upper mount is available. This makes ovl_i_path_real()
return NULL and lets callers use their existing error handling path.

Call trace:
	 ...
	 __kasan_check_read+0x1c/0x24
	 ovl_permission+0x150/0x190
	 inode_permission+0x7c/0x204
	 may_open+0x84/0x14c
	 path_openat+0xdf0/0xf60
	 do_filp_open+0xbc/0x148
	 do_sys_openat2+0x268/0x2bc
	 do_sys_open+0xd4/0x108

Signed-off-by: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
---
 fs/overlayfs/util.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index b41f4788e4f0..ec423e16cbbd 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -380,10 +380,16 @@ struct inode *ovl_i_path_real(struct inode *inode, struct path *path)
 
 	path->dentry = ovl_i_dentry_upper(inode);
 	if (!path->dentry) {
-		path->dentry = lowerpath->dentry;
-		path->mnt = lowerpath->layer->mnt;
+		if (lowerpath) {
+			path->dentry = lowerpath->dentry;
+			path->mnt = lowerpath->layer->mnt;
+		} else {
+			path->mnt = NULL;
+		}
 	} else {
 		path->mnt = ovl_upper_mnt(OVL_FS(inode->i_sb));
+		if (unlikely(!path->mnt))
+			path->dentry = NULL;
 	}
 
 	return path->dentry ? d_inode_rcu(path->dentry) : NULL;

---
base-commit: b19e11d4f1fc76a3bfcd153e8eeb4e67f6b9f645
change-id: 20260806-kasan-59017c7f7d85

Best regards,
-- 
Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>

