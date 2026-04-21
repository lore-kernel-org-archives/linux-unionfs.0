Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBEC276049
	for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2026 11:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776771474; cv=none; b=NADvYczp8BKkVsFzun/hyYcj9Vss4Rpc/L0bejzYzUS2qMTR2/UjixCA3JbwAW2rp/U6nKdOpCaOBIrazklBGOorn+Zn+eAb1y5Jui/9p0pFGX6D72WOTN65yiGbTBLb5HSaj8Z7jz/FE1Qtysq8Ii/ll+CBgVqKojzizpnS3ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776771474; c=relaxed/simple;
	bh=/exTN5wiUC2j5pqnUurj9cDv0IrG2xTfHt8VPW7n66o=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=ZmdU3Em0KG/Pfd4gsJ9Rjm8PKjHCl5INF9w89jxzk11HHwcshcEUGb8anbp6yAi8UFnGLshAXF2uu8KjJ0VxFg+HpgQsE08lS715mvOFNQRXyJtdifUzsfd36M1QyOH1x7fEMx1IpqrPUDkqw2i8DTxP9ieLSJwBDezhcYjX3Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EResvGfP; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EResvGfP"
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776771461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tr2GYwfict5w9aqZ8nyTIO+i6SQ/ei6r3dqDIg+s7Po=;
	b=EResvGfPRq5M8XMNs80B8oiLRxCnDcReCjYooDhXcxDSmP/UAG5LWYm4B9yplrm49EVeIr
	xDGSqhLpm/JGEmoi9AMfQma4VxWe3V2UNZSsoh2AAFEPjKv7chQa6MYgU2j+kU1Vnco81D
	E4plbm+z/hNWp23OW8IoMlqgJPbL2nw=
Date: Tue, 21 Apr 2026 11:37:39 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: sunliming@linux.dev
Message-ID: <954eb7a48488c6bc548e1a8a72070e743dae19dd@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] ovl: Fix possible NULL pointer dereference in
 ovl_destroy_inode
To: "Amir Goldstein" <amir73il@gmail.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, "sunliming" <sunliming@kylinos.cn>,
 "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <CAOQ4uxg8TdvtqE69cmizFh1OV-EBJYcJ9PMxDkYFXEPWZd_=JQ@mail.gmail.com>
References: <20260421092349.148002-1-sunliming@linux.dev>
 <CAOQ4uxg8TdvtqE69cmizFh1OV-EBJYcJ9PMxDkYFXEPWZd_=JQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

2026=E5=B9=B44=E6=9C=8821=E6=97=A5 17:45, "Amir Goldstein" <amir73il@gmai=
l.com mailto:amir73il@gmail.com?to=3D%22Amir%20Goldstein%22%20%3Camir73il=
%40gmail.com%3E > =E5=86=99=E5=88=B0:


>=20
>=20On Tue, Apr 21, 2026 at 11:24 AM <sunliming@linux.dev> wrote:
>=20
>=20>=20
>=20> From: sunliming <sunliming@kylinos.cn>
> >=20
>=20>  In the ovl_destroy_inode function, a variable reference oi->lowerd=
ata_redirect
> >  that might be NULL is directly freed. Add a non-null check, and only=
 free
> >  the space when it is not NULL.
> >=20
>=20Sunliming,
>=20
>=20This is nonsense.
> kfree() is not a dereference and kfree(NULL) is allowed.
>=20
>=20Please be more considerate of my time and the time of other
> volunteer maintainers and do not post patches that you do not
> understand yourself.
>=20
>=20Thanks,
> Amir.
>=20
I=20understand, I apologize for this patch, thank you.

> >=20
>=20> Signed-off-by: sunliming <sunliming@kylinos.cn>
> >  ---
> >  fs/overlayfs/super.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
>=20>  diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> >  index 60f0b7ceef0a..4b8b5fd4ab59 100644
> >  --- a/fs/overlayfs/super.c
> >  +++ b/fs/overlayfs/super.c
> >  @@ -218,7 +218,7 @@ static void ovl_destroy_inode(struct inode *inod=
e)
> >  ovl_stack_put(ovl_lowerstack(oi->oe), ovl_numlower(oi->oe));
> >  if (S_ISDIR(inode->i_mode))
> >  ovl_dir_cache_free(inode);
> >  - else
> >  + else if (oi->lowerdata_redirect)
> >  kfree(oi->lowerdata_redirect);
> >  }
> >=20
>=20>  --
> >  2.25.1
> >
>
