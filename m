Return-Path: <SRS0=6c+a=5X=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE03C2BABC
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Apr 2020 09:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60077206C0
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Apr 2020 09:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnbVrqmP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgDGJTP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 05:19:15 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40751 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgDGJTO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Apr 2020 05:19:14 -0400
Received: by mail-io1-f67.google.com with SMTP id s15so2631695ioj.7
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Apr 2020 02:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S/2FzHbl869GNrTyNbuN4N4aFh5HoRe75p9ZSHkHe4E=;
        b=cnbVrqmPLbdgSIappiUm/ei7b6KzA55rdsdUpzFicwVC2BKjq9+QoomVZWDL8WyLva
         ZBo9Lxp7E3PlC79Yin0PbD18jviIgK2gx+rDGFnFfLZNIDUyhZx9KsVplTBR5cDJPWCJ
         PLNRgzV6n1JTz3WizVW6gwtu4uR5dbQ1wR1fP22x2URw4WIYXJqrABuFt89NFWe7ExaI
         kLGzSWAYoc2WF3fAreq/CDMshNV6S+ak/w3Y5bFQOxuPQxdr5RJiXeVqYP8sDQWy+h1K
         Xm1Mqa/VoIGAoquapIPHfShSbaGmLy0fvN7Cp6rpDmzAyie8Y35K8GEKVsZ1xm+dCPwd
         jcQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S/2FzHbl869GNrTyNbuN4N4aFh5HoRe75p9ZSHkHe4E=;
        b=lvIJOUrp6CyqQtcXGrxyAZyd4BU4203WyUHg78mI14Z5rfVkbCX8rEoe1OpfUlVLxK
         fFF+lGPPALUzVRd+3aL0W6hSWBNYK3MR5UJENVCoaZ4p2XQPxbrYIyyGXgyaxMe5XrZW
         nViVlPJ0JnhU/M9EJ7Q76xH9i8Clbnld6m+JpW3M7GKDC1ln5GjJX7tVRrD1DW15KSkP
         rPEx/pLP1EES1DfCRLBS+earAbEXJHDOQkvZevrfjOJDzn29y8V59COLK4gNM2OBvXDL
         kROcIl3K/0f7beciBt2atI+HdOtAmzzUxaHGO2FGddrf/CER8MZbJu2V2Y/JSIEXtpiJ
         mdSA==
X-Gm-Message-State: AGi0Pub1MafGRef/onGULIzvE09W4CyLwlBwP0R5pkevwNYXyY+vS2WT
        Ehm+yps0AWFrZE/YY4FoL2+taTiD/exFRoeaPGU=
X-Google-Smtp-Source: APiQypI/Z2KOGglCCBrk+qc++u/BJL4iap7FGQZg80GEMJfBE2SJxHkZX6kC+J8lExZ4+k+8mh6Oz4Dk1oB7Eye3qDQ=
X-Received: by 2002:a6b:f413:: with SMTP id i19mr1180479iog.203.1586251154307;
 Tue, 07 Apr 2020 02:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200403064444.31062-1-cgxu519@mykernel.net> <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
 <17153e5b537.c827c90942921.7568518513045332175@mykernel.net>
In-Reply-To: <17153e5b537.c827c90942921.7568518513045332175@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 7 Apr 2020 12:19:03 +0300
Message-ID: <CAOQ4uxiHwQ4_rGLZeKS8VwP84YoUDZcju76KeYugt+SOAKVGKQ@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: sharing inode with different whiteout files
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 7, 2020 at 12:08 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-04-03 17:18:06 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Fri, Apr 3, 2020 at 9:45 AM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
>  > >
>  > > Sharing inode with different whiteout files for saving
>  > > inode and speeding up delete operation.
>  > >
>  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  >
>  > A few more nits.
>  > Please wait with v3 until I fix my patches, so you can test in top of
>  > them.
>  > Please run the overlay xfstests to test your patch.
>  >
>  > I suspect this part of test overlay/031 will fail and will need to fix
>  > the test to expect at most single whiteout 'residue' in work dir:
>  >
>  > # try to remove test dir from overlay dir, trigger ovl_remove_and_whit=
eout,
>  > # it will not clean up the dir and lead to residue.
>  > rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
>  > ls $workdir/work
>
> It seems no effect to current test case, I passed all test cases in overl=
ay dir
> except nfs_export and mmap related cases.
>

mmap test fails in baseline.
did nfs_export tests fail with my recent branch (c1fe7dcb3db8)?
because I had a bug that caused nfs_export tests to fail.


...

>  > > +                       return whiteout;
>  > > +               }
>  > > +
>  > > +               dget(whiteout);
>  > > +               ofs->whiteout =3D whiteout;
>  >
>  > Shorter:
>  >                ofs->whiteout =3D dget(whiteout);
>  >
>
> Here, we don't need to grab the dentry again, I think we have already got
> the reference in lookup.
>

True.

Thanks,
Amir.
