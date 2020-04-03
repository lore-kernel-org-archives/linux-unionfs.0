Return-Path: <SRS0=JwOv=5T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE32C43331
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 08:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEF7C2080C
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 08:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QgSmPUlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390493AbgDCIPf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 04:15:35 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:42357 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390498AbgDCIPf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Apr 2020 04:15:35 -0400
Received: by mail-il1-f194.google.com with SMTP id f16so6385071ilj.9
        for <linux-unionfs@vger.kernel.org>; Fri, 03 Apr 2020 01:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GBD2KaiKWt/Qfg8W5RlOMl/qIH4EgIqqjtR9AaROU8k=;
        b=QgSmPUlxFBl1vS5MNMCc5PRgsGa0zf9QUvpt1TVGxNn/Eti0ZGkyPBA/hx2p/aGN+f
         nrOmsdubdADhGm3ClAYM9yXaqrisJZbJRMeBmxXUZDx5RaSH+33CYP5h1WBVh355dGbh
         aPRdBOpxv331GfwAEKDm4kz/h17DNAe/QIhmUdeJpVMWmDcVkBnAZIJ28g933wKR5l7j
         LtzH9axvqe+G5V9vW0yRITACq1tCihiRd2WManXZUhP5EUGvSc0qqLe45FxjEDuQXn2y
         0G0tRX9q8pZXQALDT/u6chIZyOcEvY2JpvI0yYfqoykuIKwlYOO8G1lDoWAkkuGzOin2
         wBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GBD2KaiKWt/Qfg8W5RlOMl/qIH4EgIqqjtR9AaROU8k=;
        b=jT2VPtBp62wlMdo6Ffd6hb0aCbYICt3bqOA5pwwCvcdtdG55dcdBR6fql54F3Pl3vK
         zUe4eyaF+HuidHOGA9GATmdXp1F2ehHOFTp2aR1wUQMPufYPXEz6QVYfRy72LkHP1Csj
         0z7WhPR5XmLlu8Xpj7G2Fh1upf+52YTsId1lirj1n68D+ObkCEjRtVh4gKS7YDjENI58
         aVfKRoCAgDaJ/AnIgDb5/SAe3yzZjXzv54MgBVuc7ashR2Zs5sJv/hxsYaNkWQJwNPDl
         Aa+fIjspsnqi1mz5ONZeMgdtt+pJuFVd0v6p/ThgE0O8eis/fmCy9E0beVaJMUQGmRtU
         jlNQ==
X-Gm-Message-State: AGi0PuZGM0dzUsr2aH61H7lhWcbOWKN9VDG8ogCUoTtHvTFgtIdaURmD
        DTrHUwNAqwpDhFV3NL01T+7MhtsSGAPXbfdzgaj6dKtO
X-Google-Smtp-Source: APiQypKldxJwNp2N4WpB+PomA//+EKna2+oq6vKpMTAuwfcaKbRlDvJ+SkMBOgRFmoo8XxS+uy+aja+LDgH7ETBRnU0=
X-Received: by 2002:a92:bb9d:: with SMTP id x29mr7660513ilk.137.1585901732203;
 Fri, 03 Apr 2020 01:15:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200402085808.17695-1-cgxu519@mykernel.net> <CAOQ4uxhwNpz-83xeTmDBvP7WtL=OXvjLH_gnUQ548PKj7=rvtw@mail.gmail.com>
 <1713ec320e1.f990d9b035470.9003463355312118650@mykernel.net>
In-Reply-To: <1713ec320e1.f990d9b035470.9003463355312118650@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 3 Apr 2020 11:15:20 +0300
Message-ID: <CAOQ4uxjVAFAtWaN=Jgvvc93nrT6a-864YwoZKPwx__+VWV7ivQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: sharing inode with different whiteout files
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 3, 2020 at 9:38 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-04-03 10:46:52 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Thu, Apr 2, 2020 at 11:58 AM Chengguang Xu <cgxu519@mykernel.net> w=
rote:
>  > >
>  > > Sharing inode with different whiteout files for saving
>  > > inode and speeding up delete opration.
>  > >
>  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > > ---
>  > >
>  > > Hi Miklos, Amir
>  > >
>  > > This is another inode sharing approach for whiteout files compare
>  > > to Tao's previous patch. I didn't receive feedback from Tao for
>  > > further update and this new approach seems more simple and reliable.
>  > > Could you have a look at this patch?
>  > >
>  >
>  > I like the simplification, but there are some parts of Tao's patch you
>  > removed without understanding they need to be restored.
>  >
>  > The main think you missed is that it is not safe to protect ofs->white=
out
>  > with i_mutex on workdir, because workdir in ovl_whiteout() can be
>  > one of 2 directories.
>  > This is the point were the discussion on V3 got derailed.
>  >
>  > I will try to work on a patch unifying index/work dirs to solve this
>  > problem, so you won't need to change anything in your patch,
>  > but it will depend on this prerequisite.
>  > As alternative, if you do not wish to wait for my patch,
>  > please see the check for (workdir =3D=3D ofs->workdir) in Tao's patch.
>  >
>
> Hi Amir,
>
> Thanks for your review, the check is quite simple so I will add the check=
 in V2
> and we can remove it after your patch get merged. I will also fix all  ni=
ts below
> in V2.
>

FYI, pushed my patches to https://github.com/amir73il/linux/commits/ovl-wor=
kdir
still debugging some issue related to nfs export, but I don't expect your p=
atch
will need to be merged before that.
Feel free to test with my patches.

Thanks,
Amir.
