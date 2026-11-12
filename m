Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794487418;
	b=30BGzWlVkvqbS0//RwVAt3lvKNx+T5EB5YDulKDF3O1YhfVSpYhxYiyfjsReaoszztxY
	 FeDdmgBWIjjblC+miB1/51Iph3V7Ve2WfJC5Gx80TRZpjtqbsozSL3NRQduvLXdubbBid
	 Bsp8mmHUzTShx8IhKPQIE1zcrGNobAxi+u3RAzGTWD44eKkCpQC3axGpxKLz9rlz2GSDg
	 gyiqtI8caRO/ZO7FP4SSmT842pC9bNTjJvHq4wb/AeL7T0VAipgkbRPhuSqtXrvI2yEhc
	 w0PWRAxBcVShZugmQPTsuiyO78wmZi7k3wMv2S0FnXSkCaRV93et06rnVVJmTYX4Nag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794487418;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xNoA4U11buox0TWTao1trLlkLV4o8ysypTPbXU9Mens=;
	b=pCtc65D/v4MEVxORnUjrXSEviX9nYxUa9kpuAIiSNUT4pTgChcrky50AQEot1OHSb8XD
	 ijW4uhSWjkMeML5c6J+EVbPQ6Y25GraH9KEhWPsolDfsjcYPGnCP0JPKymjVchQv6+VL0
	 AXYRztSboixxF0WVhWDiP3vF67+EsdvwXGbaqvfs4bQvoaLsD1ZoYLemMDFCz1OgZdPc5
	 lKKrONBXjeoHkC3PhTbgK52Gg9FvUf/86t8ha3WA01DEr/GqgbMgq79NPDdGBnJlf8OFU
	 59Gb1Xwki+7TWtMTEWioszyjK31Fha8nwdXOM4midg1jQup1Ibm9vUgr5b0WBNRzOoQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TjQxjVGz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454FF606A32A
	for <linux-unionfs@vger.kernel.org>; Thu, 12 Nov 2026 12:43:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 454FF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TjQxjVGz
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso9305884a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Nov 2026 04:43:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794487416; cv=none;
        d=google.com; s=arc-20260327;
        b=cQL8i1UTjR/ugDpq3xDyD2GqfeiW0xX6ykwQNtDLO9r+kIIbnvgGzBU/d6ts8tn/nt
         d0uZIPC9TsyAU2Xg2GeEn6zQPhAfs8k9Ewx+evJCEijIr5aPBtN2OU1KIDSINDNdDveX
         YSdoxbkUteq38DKV/ypPxZ1PmuTu9esgZSyJD/FB/VJVKNcDueBRO4lD/7jnLQWXlMDe
         gUc4e79rgMsuqbct60J4G+1J92SVN1PelKCVzxEvUiZ1NEPhwo2SgpBlyrMcaerdZ56r
         i9c5nHcNdkobZ1Voq5Lrh+t4vk0wDDiNhw+LADXlQadOdHtBTmxvXWb5uDJLhkVuwQcZ
         wBUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xNoA4U11buox0TWTao1trLlkLV4o8ysypTPbXU9Mens=;
        fh=PGFh+w0jkZcPG9JQ4UTETLqBzcDsF/T3l1fbL81px3s=;
        b=CrgIx1LcqRpb8Bi1CEcY+8LAQ9qNpf3BeC2gO7yJKE1ugzlz5E3G2KC1RQifcwnRvD
         mLM0m1i6Ctkquo9UxiClvEuqtpRmJ3fikVrcs3696RF6B4pLj+gY7hVj56CfNP3kb170
         rYVjSjWA39bv98fHtJhLyeulgk561W3CGGLLyrrhSdtbQdWNatqPwQbA2Hhl05Kk8DSy
         DcFQ0jMUoN430dzCElQPtRavuUlOUNEREad4ccl3ai+XM965zlxRtWaOfLCuTQeP5i2c
         4WADvDEPjRK0g2R+Dn9C9zA9FpqGftsuaeZhgl533vQfxH2sY7h4AnJ9PeDFV3et3ODF
         EZpg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487416; x=1795092216; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xNoA4U11buox0TWTao1trLlkLV4o8ysypTPbXU9Mens=;
        b=TjQxjVGzhjhqp7E4klkPZ09rq43BbDlb5NXakTXgPY+pq8WU5SKf9wb8drNVm1d3mR
         7tVDNuECgw2vtpiNqkv6zYqebFP3tRwUox605HC8u52Ru+m2rni2NyjaU5H20c3jAZq+
         W5EH0grs/+TIjdZCXBP+Od4yaUmEKbOu8kicmuOkXiZa5r/U69v1er4aKN8riWH72Pm5
         dxJxiel9dmDTiouSrXa5XGYJFp7LiuQUsUHSgz+GuFHfVbmejO5zhcF2oA5uhAKLIQgf
         7bbG00diVwtI4g73hreAHYvup/D9GOSWRDTta3z3JtldsTn61JYPuFeOU4CWw0jipnwV
         GUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487416; x=1795092216;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xNoA4U11buox0TWTao1trLlkLV4o8ysypTPbXU9Mens=;
        b=VJ0fugPckB9NWJQQv4veSVUkEp/8aHo5zkXfCQ2DSPSvhEaxJCOzGHGFyDkKpM7dBn
         5ViQSNMB06ZTIDRMsl4o87xIZtOoISMzKM3X0vEXHGoXPsTU0JSPHLx3VYyZFRyae26W
         IpWNBfsz4Bmj01Q1I10ml50y8ZnrNjRUkRDAFSbdvSpVGW9ctmYncyLJEYIVXBbaySVf
         SeEDpxRd3+AJGT+oHi4bGLFo0MvcCEyh42lgcLp1LL9jP58tX+x662ZiQLKB8v4JPZN0
         Bo+mm8P7YAPdp9h1xhKLECLlANKHlQrhWR8xytvSWZ0M1yrT8GPYgQ4FYYsASALms4WK
         KZ7Q==
X-Forwarded-Encrypted: i=1; AL+hErEexjZDbmCdKo6NNj45fSZRGkIaKVu/Zz9CkdeozBxN2pWod8MFtWD934gBW3fz9f71jnLNCjbWFUfl+SXM@vger.kernel.org
X-Gm-Message-State: APuU4Z8Y9v49VIFLi5rtrorHwYt382ra4JxrarMJ5Rdy4IZ6RuftbTCO
	MLZ26T36Y6kxDkHTSTctrVjT0P2LQoGf00QschbACUNLSR8Etj0iDHsCVm66cRDjLZHfIhdHEgJ
	pqw+VV79hnz5b9op8xQFGIIkEv7TOfxQ=
X-Gm-Gg: AYBFou0r3BYdduX/b/ycP3wv6D+HegeNNLmMcYvgIm7pi0tBQz/dRMbefjBM56/21iE
	8zrErOgpF9uAbMK6lpRB5LumVhQCtXYwP2Ac6m0XkrohD5GBhdy74SaFGyjzovPCOez2KdMGLwJ
	buVzix9E/3B27uKuZTrUO9eZIhmxd3X8tx2U+1vsGLcwMDQvID28rNTMOSj6AW33cpK4JyBldcL
	9h9PTNjE7Zz3ERAGRF2e+9ATGK8q+j+wbwgixsFihez8AZMtI6RS9By4tIFGb1/64wkA9cUAuGy
	dj5GcbEeYfXUftaGLvs5SvzPekUZPOme0Zy7riSHMFLfFwUwblvcD3J0zguh5WGcBlfR3anEsnc
	waA+a0M7PaebeFgnyQZxLcGYk6He6bhjGvycm7COZEM79ztVysMRUc0MI7iXrI3HvnmeiGw==
X-Received: by 2002:aa7:ccd0:0:b0:6b5:646d:be3b with SMTP id
 4fb4d7f45d1cf-6b7773fbcbdmr2868357a12.18.1794487416385; Thu, 12 Nov 2026
 04:43:36 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111224227.2496049-2-Jeremy.Jean@oss.cyber.gouv.fr> <20261111224227.2496049-4-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20261111224227.2496049-4-Jeremy.Jean@oss.cyber.gouv.fr>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 12 Nov 2026 13:43:25 +0100
X-Gm-Features: AclHuK-2WtHEqM4hrMJmIDeZ0fdZ5_X60kJZg_N-n2ESIxL3n3QN2L1Su0d0XGE
Message-ID: <CAOQ4uxg-EOfn5bpaiEwojAPvdR-HZqoefT2mqqkA1+e6AAZUHQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] selftests: overlayfs: reject different lower
 idmaps on same fs
To: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 11:43=E2=80=AFPM J=C3=A9r=C3=A9my Jean
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>
> Add an idmapped overlay test for two lower layers that share a backing
> superblock but use different idmaps. Check that mount creation fails
> with EINVAL.
>
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---

Applied with addition of index=3Don mount option.

Thanks,
Amir.

>  .../filesystems/overlayfs/idmapped_mounts.c   | 43 +++++++++++++++++++
>  1 file changed, 43 insertions(+)
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/idmapped_mount=
s.c b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
> index 44a75839f4ed..b496b279ce98 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
> +++ b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
> @@ -498,4 +498,47 @@ TEST_F(idmapped_overlay, nfs_export_handles)
>         EXPECT_EQ(close(ovl), 0);
>  }
>
> +/* Same-superblock lower layers must not use different idmaps. */
> +TEST_F(idmapped_overlay, reject_same_sb_mixed_idmaps)
> +{
> +       char lower1[PATH_MAX], lower2[PATH_MAX];
> +       char upper[PATH_MAX], work[PATH_MAX];
> +       int fd_lower1, fd_lower2, fsfd;
> +
> +       if (!ovl_supported())
> +               SKIP(return, "overlayfs not supported");
> +
> +       snprintf(lower1, sizeof(lower1), "%s/l", self->base);
> +       snprintf(lower2, sizeof(lower2), "%s/l2", self->base);
> +       snprintf(upper, sizeof(upper), "%s/u", self->base);
> +       snprintf(work, sizeof(work), "%s/w", self->base);
> +       ASSERT_EQ(mkdir(lower2, 0755), 0);
> +       ASSERT_EQ(chown(lower2, ID_HOST, ID_HOST), 0);
> +
> +       fd_lower1 =3D idmapped_layer_fd(lower1, ID_HOST, ID_NS, ID_RANGE)=
;
> +       ASSERT_GE(fd_lower1, 0);
> +       fd_lower2 =3D sys_open_tree(AT_FDCWD, lower2,
> +                                 OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
> +       ASSERT_GE(fd_lower2, 0);
> +       fsfd =3D sys_fsopen("overlay", 0);
> +       ASSERT_GE(fsfd, 0);
> +       ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_STRING,
> +                              "source", "test", 0), 0);
> +       ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_STRING,
> +                              "upperdir", upper, 0), 0);
> +       ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_STRING,
> +                              "workdir", work, 0), 0);
> +       ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_FD,
> +                              "lowerdir+", NULL, fd_lower1), 0);
> +       ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_FD,
> +                              "lowerdir+", NULL, fd_lower2), 0);
> +
> +       errno =3D 0;
> +       EXPECT_EQ(sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0),=
 -1);
> +       EXPECT_EQ(errno, EINVAL);
> +       EXPECT_EQ(close(fd_lower1), 0);
> +       EXPECT_EQ(close(fd_lower2), 0);
> +       EXPECT_EQ(close(fsfd), 0);
> +}
> +
>  TEST_HARNESS_MAIN
> --
> 2.47.3
>
