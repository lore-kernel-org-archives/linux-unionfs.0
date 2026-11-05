Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793877397;
	b=iZYuOaSrnX47Z53y+S2b3TFswJHKH5XWVVzuW20T5pHjlh/62B3ZUghtmoCbAZB0b0LS
	 Vc3wPFEnRUgbmrBV5V6+g5xPUcP+0w39d4Lug9K1dqP96Sg3rmmy2c6wUqchZ/d63UL2g
	 eWIfyFfMJv1gDVHwAymJCjwBBN0aWt55B/cfC7LvdO6w86Ps/bfPnbi7xFDMVwsuriUWM
	 tlhkzS+fyQld8uVtWU5xSmN0i6KC6t55W3aXXYdSi4FOETPM9Bh64DJIMkHZ7H5/Rz6BJ
	 Hk4vF4WDOsAmv9DvYkCFXVdrudjQw8ONkny4D814q8nm78cn01vv6MnVQv4S9aLflvA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793877397;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=mbuO71RAfzZg4eV/uh/nLbsBTf1bF5h60PMcEHEZE5o=;
	b=m9eyIcWymFZQYmGtSVZ+JkNfS8WuUtbiHXWDTWEjhVL2tejP4XcnJFQGi97UvYg6RJBU
	 2J3h7jZU8UKMFuaLuBV0+CoVZHnm9wAxbbwz/J8w8OVsz456qcruJZfKryBsiuQZLAmsz
	 9bpwyMEMzOk7HGonVTAcPT6dr+eDjta5dIuKBUhx0S+YF75jllSXndneoSURc6jTX+YzP
	 7cxWWSfLE4vao6CDQzJr7Rt6LwCny11lP5rOZCTLr8c28m1VRj2j6cWW3Ta/8ehTXzEzj
	 xhCIlD9xWAt++e+SWnNTwku/+qGUMA+ooek03yCLLJNJJPri1RhkRlTJQ/EwxGDEhQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JnrWOJm0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E75606A329
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Nov 2026 11:16:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40E75606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JnrWOJm0
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so2416441a12.1
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 03:16:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793877396; cv=none;
        d=google.com; s=arc-20260327;
        b=aBgALqhaPskiX6bLmn8huXsGBdblGkv/i0oqNV84ylLP7w/xiiZ3ajLv7s65es42P4
         pcclHfyRJXcUTvxLVApWfDxLd9QMTYW1uIimnZgsLBa99uFaX2WY2GUQgoXZ9K8cRkMM
         lSVO5XgewBxWhcZvhnMxn7n4klXNjuWJWTjEB11bLQgxEf2AEnKOhHUDYE3JiZwqO69+
         Ffqu7nzS77+v8pphLTF9oY72a/uAINO/r9MvdlToV0vmWFmNzIwinDw32uiu0dLcBbS2
         u+t6ECwZjDx4MatTz84j1TDDy1O/vndmasaLcrsgB9ZGZFgsiZ5dQMck6k5wAn4BMXQQ
         YTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mbuO71RAfzZg4eV/uh/nLbsBTf1bF5h60PMcEHEZE5o=;
        fh=5lkAU6Df3gXRFtC/r+awqQ1O8Oyi+XTCcM985NTL9cE=;
        b=MH+/RJwx09Tn6GB68pWcxR7D+Z6Cz8pjMpPQFGnOaG9m4XfBY/BQ4SFrcKbeVhj2oP
         UGiXP2OaGa0JxcwAIqf+d4NEWif7vP5EZZUFF5HxSXbsm3bqMTZSOYeagGalffQxsZwu
         I50sHLNI/E9BwQSPn1Bd/pFOAMfOi+uB7wkL4Q9BKhqP5lUqac2Kcp/5Wj/Z7OSKH2ZB
         AoRR0/qN9fieQLTOKWkbYYBagsjFnyy1LrMwIUbCkQ2ygyLia3s/0Fj40VNYmxI5UlC8
         CrpnTTZVKUTs6CBUGoOZkGdx/nWloHxD73s2VMm+mMRK4yFHK7BzPf5yoW9dPzzeDgdE
         y+FQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793877396; x=1794482196; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mbuO71RAfzZg4eV/uh/nLbsBTf1bF5h60PMcEHEZE5o=;
        b=JnrWOJm06ylNQjuznyd8sqofcdiseURgioYzHNPkK56kFeQBc+fp+psRX11elRJPEK
         jMNr3qRq3IfPex1/zda/0UOVMTgogLeykFQrVcjk8H16PVxgZVKi8W/cb7GW2BawEwdK
         BtAtd0vDi7SpE4WSnhSuE+uBuC+Agr8byE25I7FWTC1kqNUDGpt5VNxjfNi9QadpWASq
         14CkgmgfPo35WLEeYg82Oi24Gz88HYVXuzL3AL3avLLNzR30YCEsgU/LMo1obCFihjuy
         4QAzrNeCwK9Go34L+UnoNgtDa8F+FDQTHGWb/zzOKUFJ8V/U7A+MmltvnTVeglc+7lNo
         8WEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793877396; x=1794482196;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mbuO71RAfzZg4eV/uh/nLbsBTf1bF5h60PMcEHEZE5o=;
        b=sNTpl0utITnMBaWVXH/gxqHJ412T7BnkDmMQIV/iuEz67a8ynU547NsyWz1wtu1xPq
         Pq8Slfq+AJ9j1C8Gc9xW+TAghR3y7L9CxacnSS5jnNsfasXZXXFuuwPHwxyljsVcrekO
         Sm05CiasGEY5U0GHYhrfuWKuhcTxHlaSsOmALcfUrub5hlJv8WPQLOnVkCZgBaTA4N3o
         DP8jdcE9J29Q7VjxoZodMr1KkCZ0hRR7lDeX6pBuGB5nIRadOzMJi1t2+w1WpImS2Xk+
         o+Ut1s8uiCJ22b8HbFzS10Q6NqzT4Go1ALQiPzW+KRKsUx6kO1YpU46qu8levB5t/36z
         zWOA==
X-Forwarded-Encrypted: i=1; AKwUvBykV8q3pbvJ5V0kB7ius8AlIDoe1phLC7PFRdRf7A5S2pmFGOvy0wAp4isqdOwfZCB2UGzkkXpsW54zC9mE@vger.kernel.org
X-Gm-Message-State: APuU4Z+YwMIb5yNbmqpS5vtnJrim17J+txqsTI+xcAbJQGXJHNf3wqsP
	CtWNyi2tRMg+2k5UZfdmvjuUhBOgSLK488Dmas5SvrCBOBkPDp508o0B7009/9wsrszVY0hJHiz
	uGz/lvbAf+sC2MVu9s6wvKCpyv+T+EZY=
X-Gm-Gg: AYBFou2k68yx/jesoQteMYTDYLqwaTVfwuOynhMvpQfA2SBkN2Fbw8XbhnwVl63fzn1
	1kbC1ABazT2vjAl8vIJD9YoZ03LrqLxdQMTYLGV5Mj91jOarW2rB/RhFaJDEUUkylB3GLXIjlvx
	l+tquAQSTR+o0hrEM1wtlvkM8F+Q2EPu2iJEHwBIIgpZtiK3RehrtbUBLpftCf91kHfOoyW6vfv
	dTXAWRDte5LIvOhnC/TMluvxAYwJcPMa8CtS0gnfJ7wBOGz4x8wUTqvIHUNT6rIm3hm+9/X7anZ
	lfae3JJtAx8MEcCka35MHVvi1io/vsrDrIL2+GO4I4KIBqC5Owdqgwpp3WfkcDfqfr2mhbIzCtm
	s+PrHQ4n1VqdFC33wNzeC/6C2IYfeGb5O6B8OppMSeWYGFnJchUizAp6Ep6DUM9Tp0PS6Ig==
X-Received: by 2002:a05:6402:90c:b0:6b1:cd52:5798 with SMTP id
 4fb4d7f45d1cf-6b4d5fdf3a4mr14456258a12.42.1793877395601; Thu, 05 Nov 2026
 03:16:35 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
 <20261104-b4-ovl-containerized-sync-v3-2-8daa20144f53@toxicpanda.com>
In-Reply-To: <20261104-b4-ovl-containerized-sync-v3-2-8daa20144f53@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 5 Nov 2026 12:16:24 +0100
X-Gm-Features: AclHuK-spGnE8QR5SMxi-c64TQxC-LWK8IrBlPJQdILHTMjL8cI4wsf9q4-duS4
Message-ID: <CAOQ4uxirA3FC8gukL_o-SE5dgD8LFxQZotXGMiE62VpnOosj=A@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] ovl: setup overlayfs' private bdi
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chengguang Xu <charliecgxu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 9:45=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> w=
rote:
>
> From: Chengguang Xu <charliecgxu@tencent.com>
>
> Setup overlayfs' private bdi so that we can collect
> overlayfs' own dirty inodes.
>
> Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
> [josef: only for an overlay that tracks dirty inodes, add
>  ovl_tracks_dirty()]
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/overlayfs/overlayfs.h | 18 ++++++++++++++++++
>  fs/overlayfs/super.c     | 10 ++++++++++
>  2 files changed, 28 insertions(+)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 444e28c09145..0ef81c7a9701 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -7,6 +7,7 @@
>  #include <linux/kernel.h>
>  #include <linux/uuid.h>
>  #include <linux/fs.h>
> +#include <linux/backing-dev.h>
>  #include <linux/fsverity.h>
>  #include <linux/namei.h>
>  #include <linux/posix_acl.h>
> @@ -683,6 +684,23 @@ static inline bool ovl_should_sync_upper_fs(struct o=
vl_fs *ofs)
>                ofs->config.fsync_mode =3D=3D OVL_FSYNC_STRICT;
>  }
>
> +/*
> + * Does this overlay track the upper inodes that are modified through it=
, so
> + * that syncfs() and unmount only have to sync those?
> + *
> + * Only with fsync=3Drelaxed.  In the other modes the overlay never sync=
s, or it
> + * syncs the entire upper filesystem.  fsync=3Dauto does not count until=
 it has
> + * been resolved.  sync_filesystem() does not write any inodes of a file=
system
> + * that has no writeback, like tmpfs, and nothing ever clears their dirt=
y flags.
> + */
> +static inline bool ovl_tracks_dirty(struct ovl_fs *ofs)
> +{
> +       if (!ovl_upper_mnt(ofs) || ofs->config.fsync_mode !=3D OVL_FSYNC_=
RELAXED)
> +               return false;
> +
> +       return ovl_upper_mnt(ofs)->mnt_sb->s_bdi !=3D &noop_backing_dev_i=
nfo;
> +}
> +

I had concerns that this is not the exact opposite of ovl_should_sync_upper=
_fs()
and testing noop_backing_dev_info here is not optimal.

It is better to set the fsync mode correctly for noop_backing_dev_info
at mount time (non-upper ovl cannot have non default fsync mode already).

So I sent you v2 of my patch with my own version of ovl_tracks_dirty().

Other than that the series looks good to me but I am lacking familiarity wi=
th
writeback to be able to properly assess the vfs correctness.

I ran fstests on overlayfs nothing popped out, but it doesn't say much
on the implementation.

FYI overalyfs fstests supports {,_require}_scratch_shutdown{,_and_syncfs}
and there are 2 tests that make use of those overlay/078 overlay/087
maybe that's a start for some test that could exercise this code.

Thanks,
Amir.
