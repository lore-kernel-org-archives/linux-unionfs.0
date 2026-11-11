Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794372665;
	b=xbzlZv/YvdbYaxiUTUCgl0Zn+oxqC9khWntEiAtgHSb5hMYKHaNrVntZblW/OR2+jcn5
	 V/ckW2kKOAGBkW8FBSS34N39qcQ+36B595ZcSOHluhabzWBbBXPx+ryFr9jtCBldgilei
	 /RPFudmJmMF1OwtTvoJgtIOZF5z7BtuV4l6yMpUz7coq6+iAu1zOBko3djrV4uT9NHTRL
	 XiBJxiaYZEC/wbq/M4rAS1cpldoeg3k66PjuVO7TmfmxPBYJuoTLFa4okeMiQ3x2hoABs
	 umy2XtzFXHukvKyHElqoEsbgDyw9J5immDC6sjdbPpiERC8WtREOw3yiTliqra0oPSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794372665;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=gh+NftpSqHgfZZ/G5//YTCUgo/7r9ac0BfabcTGSh/0=;
	b=5UTjjMO27aFSkOCpxf/hWTFWiFyyxTfeaAp0FiDKrcho0c/hJdOmwoETn3sBtIoVVy0e
	 c10cVfymyPYEL+5bnwR19q1IzFR+3GL77gva1adODZ2Ntk7fPT6lEhyRhmydnnZQHqLnV
	 5K1s1JFhGpiPRnLpvxoU1oaPrdTWgpdjWKfBFKc4csCP5qkelp5ocSLCdEUKIvWqIjHKp
	 Mkya4yIOMlrMyP0Rroy3h4gRj5pwmPKvNRhM1x6B82vb2P+jaED5ARCcSXiAcFak2u5ta
	 9OwLfXpocIE8dWi845D1sM/y10YFtic4iTkFfkv004kXw39rjNdKTLh39Y9euPD4B5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=CVIUGPlk;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0A0606A336
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 04:51:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB0A0606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=CVIUGPlk
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261111045103epoutp03234bc5fd068dc9a4ef6e248bb033d3f1~m5G4dba6c0496004960epoutp03f
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 04:51:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261111045103epoutp03234bc5fd068dc9a4ef6e248bb033d3f1~m5G4dba6c0496004960epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794372663;
	bh=gh+NftpSqHgfZZ/G5//YTCUgo/7r9ac0BfabcTGSh/0=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=CVIUGPlk9EUEbEHl2kiOVdulKJLe2RgZ0AZdFJst5Mpq9gydjNXLpaNZBDMxTwRA9
	 UOY/7XoGl1mqDweNtLWLB5RDdX9yoEL1WObpXMm6MpgcDGRnanwCCSI3bYhDr3Xvo1
	 KViqRZ40dhBBrpM2nPTOMWYAAqhuN0CGbmOjSEec=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261111045102epcas2p1b71cc6e9fba61bc89699db8efb11129f~m5G37_zDP2721727217epcas2p1C;
	Wed, 11 Nov 2026 04:51:02 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.210]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jPWLZ18Bzz6B9m7; Wed, 11 Nov
	2026 04:51:02 +0000 (GMT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE: [PATCH] overlay/077: check a stale entry in an impure dir on
 any hash seed
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Daejun Park <daejun7.park@samsung.com>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>
CC: Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Hungyu Lin <dennylin0707@gmail.com>,
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261110-ovl077-stale-next-v1-1-948a5a434ae2@samsung.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261111045101epcms2p442a57243edc0297369214e5d89d43d5e@epcms2p4>
Date: Wed, 11 Nov 2026 13:51:01 +0900
X-CMS-MailID: 20261111045101epcms2p442a57243edc0297369214e5d89d43d5e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261110080502epcas2p31a01ccf5c32fd27f361a2364db9c3d87
References: <20261110-ovl077-stale-next-v1-1-948a5a434ae2@samsung.com>
	<CGME20261110080502epcas2p31a01ccf5c32fd27f361a2364db9c3d87@epcms2p4>

Your mail below did not reach my mailbox, so I could not reply to it
directly.

https://lore.kernel.org/all/CAOQ4uxgxzee1dqLcYHPWFhkcAxP_WRrJn5DiiL9mB0ZjC83vbQ@mail.gmail.com/

On Tue, Nov 10, 2026 at 04:33:50PM +0100, Amir Goldstein wrote:
> For the problem of spurious test failure, I suggest to relax the expectation
> for the first entry in the buffer or to fix ext4 to avoid emitting the stale
> entry.

Thanks. v2 will relax the expectation in t_dir_offset2: the d_ino of
the unlinked file's entry is not checked when it is the first entry of
the first getdents call after the unlink.

Best regards,
Daejun
