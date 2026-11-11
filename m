Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794372637;
	b=C1VzsqcrsgoPKnhFFY941tmesAwDWbzsFTo/XfG/ldQmLu1G53j3eyonpy8Ur1pXOgod
	 R2v9IjeQSz9t82ucF+9aJJu+bf0HSKXXNeFtApWS4OpcFZdadpPvVVN4VW8FbADlOMuu+
	 W4TPu37yO4ord589ACXj1IcbLDDXov4e/ztRGpYZb3ksfxzW8CKyTnNaQnHBVziXquhOE
	 R9S1WXPmz3AsAtWyamF7JtxNUAsqYwemj3XroD2i8OT9gU79ByPyabXfEjnRmKHoXh4nP
	 JWMNlE4lkP/7tWrh/ZE4HaQCYJ4RZ6scFmyR6lhha70M3ILI6wAnLH1QHB/mjdAP4JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794372637;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=2z6RcZw+0FfmTvfxA7IX1opzEG1e0lSubruCi28CNaU=;
	b=FKQQJa5I51wqPgg3egOfMgos9ZrbmtKPX8yGY8ZQmjPbdqmv4p4lNrh5J0fjAEyNSLbF
	 yB6Sv9yHG2HBuUod8mIBppwf6nsxqF6SaB9U48IG04tX24D2zruj0oOfu7NcFPWolNk3y
	 ZxKxk4hT2Qtj8s6UHAGF7IajIehnXiO5YPjBHwPlQ+BYpWKNLQwbtS/ezDfuemf+7YjDa
	 4y+z0a5koP9FhFr1vZ011rnCaj1zxgPv/015SD4Xo0S0MO5EO/N2yuPYGBHYl8j+brdIJ
	 uD20lOIXDlQy3t3ZcGvA+8HOtAHCR7+qC19alg4YT/1kE2Ac2LI5+UGlN4tlgA17hhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=A4pcxok0;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06245606A320
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 04:50:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06245606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=A4pcxok0
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261111045028epoutp0338d3af7da57c059a0b6772d737c456a0~m5GXxX-kG0485304853epoutp03V
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 04:50:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261111045028epoutp0338d3af7da57c059a0b6772d737c456a0~m5GXxX-kG0485304853epoutp03V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794372628;
	bh=2z6RcZw+0FfmTvfxA7IX1opzEG1e0lSubruCi28CNaU=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=A4pcxok0BGKbCEtgBaA+AKid2yaTFMI/ViICSeKRvq4d1clKrNHxTjWJ2MqKwCth5
	 qrf6rZ3mZtLicuClvuo6obGs3/lbieWczlq7OoXJIyLz6w4Xq1zjtLR6tcQHcN2FC4
	 9BEVl5MqvENgSgZFNx9u7LkczcT+G8wyrhEJPu9Q=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261111045027epcas2p325b3ab664a77cb2058b12dcc3a79ea93~m5GXPutme3085130851epcas2p3O;
	Wed, 11 Nov 2026 04:50:27 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.210]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jPWKv1yV6z2SSKg; Wed, 11 Nov
	2026 04:50:27 +0000 (GMT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE: [PATCH] ovl: skip stale entries in impure dir iteration
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Daejun Park <daejun7.park@samsung.com>, Miklos Szeredi
	<miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
CC: Hungyu Lin <dennylin0707@gmail.com>, "linux-unionfs@vger.kernel.org"
	<linux-unionfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261110-ovl-impure-stale-v1-1-1a4c2039e89d@samsung.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261111045026epcms2p63d9818fa6ad5600eff4f74deca4a6e7a@epcms2p6>
Date: Wed, 11 Nov 2026 13:50:26 +0900
X-CMS-MailID: 20261111045026epcms2p63d9818fa6ad5600eff4f74deca4a6e7a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261110080419epcas2p24eb47374d80929645076c4d81f512c62
References: <20261110-ovl-impure-stale-v1-1-1a4c2039e89d@samsung.com>
	<CGME20261110080419epcas2p24eb47374d80929645076c4d81f512c62@epcms2p6>

Your mail below did not reach my mailbox, so I could not reply to it
directly.

https://lore.kernel.org/all/CAOQ4uxgxYZqE=rv5ZYrbyB0cYi_qS-bv_4UCbDwGJoMGg1iNhQ@mail.gmail.com/

On Tue, Nov 10, 2026 at 04:28:32PM +0100, Amir Goldstein wrote:
> I am sorry, but this is way too complex to deal with a problem which
> is not important enough IMO.
>
> POSIX does not define the exact behavior of readdir of a directory
> being changed in this way and I don't think that the current behavior
> of ext or overlayfs+ext4 is a gross violation of POSIX or that it could
> break applications.
>
> I would be happy to be proven otherwise.

Thanks for the review. I'll drop this patch.

I looked for a program that breaks on the stale d_ino and did not find
one. Of the d_ino users I read (find -inum, gnulib fts, glibc getcwd(),
nfsd READDIRPLUS), none does anything wrong with an entry whose file
is already gone.

Best regards,
Daejun
