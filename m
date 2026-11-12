Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794486630;
	b=1QF3+BUyyaXxNr42DAUGsLNORManS6XPEk4wXddvxwfIuLTUenGk2b5goSjCnU214rF5
	 Qy8gTQmAS9rhQMMRQr9Uxiy3pWlY6HEH7ZoBbl7eIFQUFvkr+Wn7/exloVEgqfFo0hJyp
	 ZWwX1mUgk2kYdBY1afrwrjSfOiciekr+cmThgYqZ7O0hEW+CU6KgtoBnDDmqSLmyzbqmq
	 4NBec1UOV4Ih5Awg9j//CAknuFGwxnnXMV9Ln6q9Ho4UF1hdilGNdnIhUOtc36R1a3SoP
	 KEyQxgCbCznSwyOK7uZPPp7oooQ54vRRc+oEGksEda5bUtnZll9QnnJKbA1Lm0wypqg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794486630;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Scxxr3QZh8rDu03xKq9Qg0FPWQFgGwpm1Y1nnFDFd+w=;
	b=JPJRzVy63AFiC/HmoJW3SXylW9X7ZjNMbzm0NYUYGey02X1wJ24FldTPsfYfzhJbFdKW
	 t5Y14jgm2p17DCD4T0bk7ViVsqKGuF87nmwWXXBtVK0j8rvMczE4T5Bl4/WDG0NeRSA35
	 f5zeOEZPuGyT1UQQtWYqLGFnfTeAd1xJEPaO8e3qtVxTAbT1+dFFlh1/hg1oT4tV9sLGR
	 59PRHavbNrNUFIH66NefE8+AeaVkYNqc3nVoBzYQb7Z/bjeBOSjl2ywxWoXCG9D0aw80e
	 E0bddMcxlO6fe/nNI/G5COOlsvoE1YUgxOjZWmLcahPixMvCv2AtEo+/NS5lR4HMaqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gSborAVm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09B6606A337
	for <linux-unionfs@vger.kernel.org>; Thu, 12 Nov 2026 12:30:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C09B6606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gSborAVm
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so39307815e9.1
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Nov 2026 04:30:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794486628; cv=none;
        d=google.com; s=arc-20260327;
        b=Nao+roSqqnfJOJI0wXq8qOsxD4mwLoT5sHDEZ1ijttUSMbz4Gnt8wFi2kVcRouN6tH
         ufWZRYkT0sFg7fAShXR4zluzx1q+nAZ931roR0kuYCEcEOqdmns1Pnt7oPM0ClB0jgmT
         eZOb8Ctkm1/Td5r035rJhOUzi0k7sz35h3IJD2raGkQ2eHjVdSlx0SqSOcc1WfdDqdMk
         Vz66eQVs1iVxvkkSZm+hKXPavvvDOUrpkMWRQEt/cNJuxMqbdLezoeBtUmQMPF4/3BLz
         5LtcVO+3wY+ReghxydQdmaWs7B9wSGvJePdYhahBXnvDdGpCbOqxIXD2OMrif6zFNrQU
         8Lww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Scxxr3QZh8rDu03xKq9Qg0FPWQFgGwpm1Y1nnFDFd+w=;
        fh=ONwzfI+GANI7e1Ugi43BwvONnfquQtQ8Su/f3WVdfeU=;
        b=NaWCBOTGP0j/cyAl31FY3hm58EytSHuXR90lFF3jCutME1W8ENDHAjXy+TsbMWzcz1
         0KPGbnX7gG3M69TMt1ax26m9XlGxJMtLPKAl08g6zkYnug85rtIsUYLM5nu9gxfR6HLI
         jepZ2S9Lkn71trxFgRi3kVVWTnIZrvcJv9B3rC4Hrm69KrVMqrMTGeLHzCGNE0bYBFVr
         KzC/Zr5ONlK3I+R/8iDTdsG4OgN5bE/V/bOWtSXlVa5n5JtPQ08YQQyW0LHp53lYne2R
         9Q80u80A1FX7xUgept1ghnpfOZwFLHFdi0xV4bg4t38bem3V0o6vVhU7tX8/u7BQfUWL
         9mGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794486628; x=1795091428; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Scxxr3QZh8rDu03xKq9Qg0FPWQFgGwpm1Y1nnFDFd+w=;
        b=gSborAVmkkKT9hNmcAK8PcnqOV4wFyarCBbkcBPTiAhT82LtpYRmAG3zz0qKqzme87
         j59viw6UAwG7ijwgyq3xQ8vUVz8+fAVyuOy0QoYHCSZrEzlhFBampRpSs/D8ifp9KFA8
         xkTXJiA9yxczIH5p8TIWcuUsesXNa5yZRO7yAFbTHPrRVBjU08Coa6Puy8E1KY4t3l9R
         kzHQVMSKAu5WP/FX8zjFikyyqwIuaKEMt2t4xjfnSnlQtbmuoAtlJjRfdSbtyxEiUwcO
         mbs+bqfl5cOlPYwNQC6/9nhw2By5N+2/HNDpXPG/eyg8wdg6YYEdGio06FRavL9JDdCe
         rzhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794486628; x=1795091428;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Scxxr3QZh8rDu03xKq9Qg0FPWQFgGwpm1Y1nnFDFd+w=;
        b=lA/h4aTrFYYtpMgNlGtAgBbZLHz8T27Ts2XzIX/zw/2NTGjkrvb2idf4pEkXoYzJ1v
         WgIRlA0LwwSP508M+djV2bBgACzi5d6XiHpd+ySD8wZ0Qaaeq6ypzG6W+iWCw9LdSkty
         FR4jC489pp8HZGTYYNl1455nHqd7pm9TwUTAzZM2uAdm/45wc2pwK7FNigBa2fxl4tQ0
         ilSbyYo0YGmyTHBhW+YHynr1njb4+Lrti0Ysc3SdLbPj1lCt2kp05ijd9Xf9Ns9hEqYW
         78sV1/beK6ikFCHNKikvVeYhCzogU2D/GUszkZ9xr6fWODZHPlicXGtxflJB2EyR85X4
         E3pA==
X-Forwarded-Encrypted: i=1; AL+hErEwpOaEiIBeNopFlE4gQupAEYyPoNn5cK1LXb6t+2CtNSezFvFlpyHhywVGkp2uQBictwR2x42fxLH0h2n1@vger.kernel.org
X-Gm-Message-State: APuU4Z/ooQ3U3k/PsN1VNsiLyHrHWIMYfFUHUzjbbhWS2sQADJqRbOuq
	ID6FZcPahFdM15toQ19twtWpFyCU+7X+pud32smD35l+Xc9R6TS7S4PADPf20U0Rpxx+AVvTqMd
	oPBYsxti5QvkQSY8jSWJDQsMMl08Q3Eg=
X-Gm-Gg: AYBFou3s62BbqWG5gO4iu1c6/ae3k2NtXmOUALWIP5a6WGAJ1Mlu1lM1XcMZVvkx5DG
	yO17/NqWKeig02ojhhSvt0qrgumi9KdN10AZ7oO4QOy3YQs0IAQJE8IuI9rcOONuDDFqNOwUZXc
	0YhxyKuTAqNdjnaPWUKaUFy23bOa/JIdlFDRexBIp22Rtv1pybMQq93i4a8Khznjjf1gjP061qM
	HzHA3ew1dW/l9I0tsT9onhXTNdfiVQSFkXKlhaWhAHdxghGu7WpTdJ2oAD01UV/DcZQYwo0K5hi
	KERfROf8bwH+whbiaq5obWQqP0RaYzqua22G29cP3uZwxGe7nwhfPQUHVKahjhjxW5EOV0GLUJh
	O4VbcxPk8EgmCfRl/t86DJAi+X2R0VR7LhbZsgQIXtwxi6Ireo34i8j2PvgWYAVDP+s3h0tHWta
	UVH5dZkP6SN14NFyQ=
X-Received: by 2002:a05:600c:46cd:b0:4a7:a5db:a93e with SMTP id
 5b1f17b1804b1-4ba0931c26emr98068605e9.4.1794486627822; Thu, 12 Nov 2026
 04:30:27 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111224227.2496049-2-Jeremy.Jean@oss.cyber.gouv.fr> <20261111224227.2496049-3-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20261111224227.2496049-3-Jeremy.Jean@oss.cyber.gouv.fr>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 12 Nov 2026 13:30:16 +0100
X-Gm-Features: AclHuK-PALtUIojkOvbIjpvKnSsZMgTvb-UczhCsAjfiBo_uVoM0-bxZwzKBT3s
Message-ID: <CAOQ4uxgZag+6MrkJsCXucUBWDaKWptkoZOStZ6Ns4+17Lw+=hQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ovl: reject different lower idmaps on the same fs
To: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 11:43=E2=80=AFPM J=C3=A9r=C3=A9my Jean
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>
> Overlay file handles identify a backing filesystem, but not the lower
> mount used to decode it. If lower layers share a superblock and use
> different idmaps, a handle can decode through the wrong layer.
>
> Record the first idmap on a private lower clone for each backing
> filesystem. Fail if another clone has a different idmap. Comparing
> the private clones prevents mount_setattr() from changing the checked
> state. Distinct idmap objects are treated as ambiguous.

I got a bit concerned from regressions, when lower layers have idmap
from same userns, but not the same idmap objects, becauses I have
no idea how different runtimes setup overlayfs.

To reduce the risk, I took a conservative interpretations of Chritian's
"just fail the mount" [1] so we just fail the mount if index/nfs_export
are requested and leave a way out for the poor user.

[1] https://lore.kernel.org/all/20260925-server-hager-riskieren-06116eded21=
3@brauner/

Applied with some changes below...

Thanks,
Amir.

>
> Fixes: bc70682a497c ("ovl: support idmapped layers")
> Cc: stable@vger.kernel.org
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  fs/overlayfs/ovl_entry.h |  2 ++
>  fs/overlayfs/super.c     | 15 +++++++++++++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index ac07e8769f9b..5b2f1b930daa 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -24,6 +24,8 @@ struct ovl_config {
>  struct ovl_sb {
>         struct super_block *sb;
>         dev_t pseudo_dev;
> +       /* Idmap of the first lower layer on this fs */
> +       const struct mnt_idmap *lower_idmap;
>         /* Unusable (conflicting) uuid */
>         bool bad_uuid;
>         /* Used as a lower layer (but maybe also as upper) */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 8bc970748b96..40eb8428a718 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1141,6 +1141,21 @@ static int ovl_get_layers(struct super_block *sb, =
struct ovl_fs *ofs,
>                         return err;
>                 }
>
> +               if (i < nr_merged_lower) {
> +                       const struct mnt_idmap *idmap =3D mnt_idmap(mnt);
> +                       struct ovl_sb *fs =3D &ofs->fs[fsid];
> +
> +                       if (!fs->lower_idmap)
> +                               fs->lower_idmap =3D idmap;
> +                       if (fs->lower_idmap !=3D idmap) {
> +                               pr_err("lower layer '%pd2' conflicts with=
 idmap of another layer on the same fs\n",
> +                                      l->path.dentry);


                /*
                 * Lower file handles identify the lower fs, but not the la=
yer,
                 * so with different idmaps on the same lower fs, index and
                 * nfs_export may decode a file handle through a layer with=
 the
                 * wrong idmap.  Following copy up origin without index is =
only
                 * used for st_ino, which does not depend on the idmap.
                 */
                if (i < nr_merged_lower &&
                    (ofs->config.index || ofs->config.nfs_export)) {
                        const struct mnt_idmap *idmap =3D mnt_idmap(mnt);
                        struct ovl_sb *fs =3D &ofs->fs[fsid];

                        if (!fs->lower_idmap) {
                                fs->lower_idmap =3D idmap;
                        } else if (fs->lower_idmap !=3D idmap) {
                                pr_err("lower layer '%pd2' conflicts
with idmap of another lower layer on the same fs, mount with '-o
index=3Doff,nfs_export=3Doff' to override.\n",
                                       l->path.dentry);

> +                               iput(trap);
> +                               kern_unmount(mnt);
> +                               return -EINVAL;
> +                       }
> +               }
> +
>                 /*
>                  * Make lower layers R/O.  That way fchmod/fchown on lowe=
r file
>                  * will fail instead of modifying lower fs.
> --
> 2.47.3
>
