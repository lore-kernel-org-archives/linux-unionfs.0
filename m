Return-Path: <SRS0=JwOv=5T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9F7C43331
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 12:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CAFD20737
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 12:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqfPpRJ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgDCMWi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 08:22:38 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:37441 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgDCMWh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Apr 2020 08:22:37 -0400
Received: by mail-il1-f195.google.com with SMTP id a6so7027890ilr.4
        for <linux-unionfs@vger.kernel.org>; Fri, 03 Apr 2020 05:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jdCjOUpVKml8cexpt1fEMuHOcbSU65fsh92HPjb/GqE=;
        b=jqfPpRJ4Q09waAQ0a/1Pd3Wn13zRY347Fk5/uk7M9BGgZaZumDv4tNp+a7qDDBr0qL
         yc5CnIFDfu29RBOSokGcSAzFgUypdDi6WC/D7TO9kVlR2CyJ9DApvYvcKaysZ76/o/m1
         zP/gOpgDPsSKhTUAL/4IIsZZKog08azz+5jiJE6cszcDoFFcAkYWtBa9n98LcP91OESv
         OyTk8oWxTugA7R1tmwrGyIUdpbeoMz4AbdtxSPofVlEbuJ+Ik/sYmbSQC1K0WtGSRpoL
         dXWNCax/DMnEHficL5cXSEh5Fgk1GKcfBzHbm2iyMWiqmKOLXPX1jd7hDwgijlGm8yBk
         Rh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jdCjOUpVKml8cexpt1fEMuHOcbSU65fsh92HPjb/GqE=;
        b=rl0BpVVULoNI/tjzcFvvrmoA8BjRPc2CGIEJccltmpwVCqIdYUP2mr6E7F9E1y6qd6
         bbYFRjgeX/U13yfu6AnRmaj6p/DMexF8Qu6wELaPTKMC0g+ABv/opMq3um4KLrYbEg/t
         IW9rQ8L8qc5kpKlb0ooRrJR7ig43WrR5c1+UecNz/VLmhpuSdNHOFyJGqAhO/ove4K07
         UrkMavk3hscC8WkrGlGtt8ZUCFnEHO7Fm3Jl+UfWB/a3rkAF7yeP+A7D+Lxh7r1aP9n2
         wjXAAIvL7+HCby3mfRw3AkQGaib1KNYv9q5LtTm79cA0t0iW4WWTaHIGHMRSvGp4K6RV
         ZkKg==
X-Gm-Message-State: AGi0PubgePb5juc4Fv4LXLtIiqmV9TUjLYuJjiBoy/lv7OE2Do192kBe
        iHw622k8cWAVxp6fTwf2VQXspiJez30ww+RbvMEQ3g==
X-Google-Smtp-Source: APiQypKfflHNe3JTSlg7oWarsQ6fJyZkvrZBl6GcYtmEOynmpK9WhYzSQC2qKoHaTmjsOLRq05WEWS2ZGJhwokSqrCE=
X-Received: by 2002:a05:6e02:68a:: with SMTP id o10mr8625453ils.72.1585916555208;
 Fri, 03 Apr 2020 05:22:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200402085808.17695-1-cgxu519@mykernel.net> <CAOQ4uxhwNpz-83xeTmDBvP7WtL=OXvjLH_gnUQ548PKj7=rvtw@mail.gmail.com>
 <1713ec320e1.f990d9b035470.9003463355312118650@mykernel.net> <CAOQ4uxjVAFAtWaN=Jgvvc93nrT6a-864YwoZKPwx__+VWV7ivQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjVAFAtWaN=Jgvvc93nrT6a-864YwoZKPwx__+VWV7ivQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 3 Apr 2020 15:22:24 +0300
Message-ID: <CAOQ4uxgOJiy5+RixqzW-XLnggPmF8DxjSkoczzkgYDoy=6wgzA@mail.gmail.com>
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

On Fri, Apr 3, 2020 at 11:15 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Apr 3, 2020 at 9:38 AM Chengguang Xu <cgxu519@mykernel.net> wrote=
:
> >
> >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-04-03 10:46:52 Amir G=
oldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
> >  > On Thu, Apr 2, 2020 at 11:58 AM Chengguang Xu <cgxu519@mykernel.net>=
 wrote:
> >  > >
> >  > > Sharing inode with different whiteout files for saving
> >  > > inode and speeding up delete opration.
> >  > >
> >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> >  > > ---
> >  > >
> >  > > Hi Miklos, Amir
> >  > >
> >  > > This is another inode sharing approach for whiteout files compare
> >  > > to Tao's previous patch. I didn't receive feedback from Tao for
> >  > > further update and this new approach seems more simple and reliabl=
e.
> >  > > Could you have a look at this patch?
> >  > >
> >  >
> >  > I like the simplification, but there are some parts of Tao's patch y=
ou
> >  > removed without understanding they need to be restored.
> >  >
> >  > The main think you missed is that it is not safe to protect ofs->whi=
teout
> >  > with i_mutex on workdir, because workdir in ovl_whiteout() can be
> >  > one of 2 directories.
> >  > This is the point were the discussion on V3 got derailed.
> >  >
> >  > I will try to work on a patch unifying index/work dirs to solve this
> >  > problem, so you won't need to change anything in your patch,
> >  > but it will depend on this prerequisite.
> >  > As alternative, if you do not wish to wait for my patch,
> >  > please see the check for (workdir =3D=3D ofs->workdir) in Tao's patc=
h.
> >  >
> >
> > Hi Amir,
> >
> > Thanks for your review, the check is quite simple so I will add the che=
ck in V2
> > and we can remove it after your patch get merged. I will also fix all  =
nits below
> > in V2.
> >
>
> FYI, pushed my patches to https://github.com/amir73il/linux/commits/ovl-w=
orkdir
> still debugging some issue related to nfs export, but I don't expect your=
 patch
> will need to be merged before that.
> Feel free to test with my patches.
>

Pushed a fix. You may proceed to v3 based on this branch.

Thanks,
Amir.
