Return-Path: <SRS0=HYNE=EL=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00ED7C55179
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Nov 2020 14:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB0E72074B
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Nov 2020 14:05:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pi3wusOU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbgKEOFi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730461AbgKEOFh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 5 Nov 2020 09:05:37 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6150C0613CF
        for <linux-unionfs@vger.kernel.org>; Thu,  5 Nov 2020 06:05:37 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id m9so1878948iox.10
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2020 06:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K3v0jywkhevY1xgc8XOTk2JmralHU/tX6Jc0rhS29I8=;
        b=Pi3wusOUvyZTQ1sIan/+D03wcMleUzf0obPPFxn8hv24PHiEjrm5hdnnNzgZ3zf8Hp
         8PalLDjzI1Zd7XQM73922M3XABQTu/uhEfcWPFNtumNCwtd1mPPzBFJk59+AY2qD/nzo
         BbikEVp3TPv1ph6BkKTg5Cz+mIZ4QcT/0ojuk8S/pLBacNTvARZ/+rTJgxhrsZ7aQ+Lh
         vd5uJcJEC8qs129sESH3NrHBY/QUXCyxQC2MBb2NDsRdJcVzeve/eNIjUjvOnGUQ/4MI
         UqHXK6tNE46SbNFScgqe9KqEiHzDv4OqVDKfzD58ja75cwtRXOLAD5JTFEfUQZxM452+
         ELoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K3v0jywkhevY1xgc8XOTk2JmralHU/tX6Jc0rhS29I8=;
        b=FRplyFNL3m5VsIiDVdBinTS4jxIs6iQABqeMiNDHZ1WTtNNX5naucMlfBjfygojY3x
         g8Ybgq+sPwuYln5ZuB0aLOPvNxb/Km5ga5rjLb//3MpVZjOQIdSNmfkbpTqPbqqU04BA
         wTiOKvNJMu3PtAXkfiwVbZ7rJ3XjgbPc4EDdUDI7n+vA2p1wsp9aaMHikPyqASKnzyZd
         M9JApRqgKiG/NIl7eFj60vK/1YhLEQM/6M5oBOg77CLdYAcQfCpGBHQp7WYDEA3Ba45f
         cTuDBn2gUwP9o2CQnmKyBqNTmoH+om+tg+3Xc0Khy9YlEVHgtxc3wGeksZtt2Y+XaIcv
         bqHg==
X-Gm-Message-State: AOAM533OWJLIfjedjVheu42zpqoRr4AsN7EVobAdcLnqR2Vm0vUp0ifA
        x1XIP4+UdBhOAnivxAK/JTq+AawWM3f1KEJcwbGDV1cXviQ=
X-Google-Smtp-Source: ABdhPJxkvL0AV9A2y4l9dMCL047vhEmVuPqfb1RQoeUaekY4jERHttF5TSD6TIIAGAReUVqrKPF+uzG0m7urnkjUZ+I=
X-Received: by 2002:a6b:5809:: with SMTP id m9mr1788697iob.186.1604585137035;
 Thu, 05 Nov 2020 06:05:37 -0800 (PST)
MIME-Version: 1.0
References: <17596177926.d559c8b77834.5766617584799741474@mykernel.net>
 <CAOQ4uxgpmC_B_uWpnMXDrv9BOQ-rsMxyRTc+qC3dT72sqR8ndg@mail.gmail.com>
 <17597c5dc4e.fb084b178911.1848736071974456771@mykernel.net>
 <CAJfpegu-rqL4-jn9o0+OSj2x+hKS8mLB6GswhL17Ruhb3WuMKg@mail.gmail.com> <1759833fcec.11bebc5a09074.619089384538905286@mykernel.net>
In-Reply-To: <1759833fcec.11bebc5a09074.619089384538905286@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 5 Nov 2020 16:05:26 +0200
Message-ID: <CAOQ4uxiGy5iGqMczJqX70UGCP3CNyuqh3KiQWOG9TKj5Hqms-Q@mail.gmail.com>
Subject: Re: a question about opening file
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs <linux-unionfs@vger.kernel.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Nov 5, 2020 at 1:39 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-11-05 17:57:15 Miklos S=
zeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
>  > On Thu, Nov 5, 2020 at 10:38 AM Chengguang Xu <cgxu519@mykernel.net> w=
rote:
>  > >
>  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-11-05 16:07:26 Ami=
r Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > >  > On Thu, Nov 5, 2020 at 6:39 AM Chengguang Xu <cgxu519@mykernel.ne=
t> wrote:
>  > >  > >
>  > >  > > Hello,
>  > >  > >
>  > >  > > I have a question about opening file of underlying filesystem i=
n overlayfs,
>  > >  > >
>  > >  > > why we use overlayfs' path(vfsmount/dentry) struct for underlyi=
ng fs' file
>  > >  > >
>  > >  > > in ovl_open_realfile()?  Is it by design?
>  > >  >
>  > >  > Sure. open_with_fake_path() is only used by overlayfs.
>  > >  >
>  > >  > IIRC, one of the reasons was to display the user expected path in
>  > >  > /proc/<pid>/maps.
>  > >  > There may have been other reasons.
>  > >  >
>  > >
>  > > So if we do the mmap with overlayfs'  own page cache, then we don't =
have to
>  > > use pseudo path for the reason above, right?
>  > >
>  > > Actually, the background is I'm trying to implement overlayfs' page =
cache for
>  > > fixing mmap rorw issue. The reason why asking this is I need to open=
 a writeback
>  > > file which is used for syncing dirty data from overlayfs' own page c=
ache to upper inode.
>  > > However, if I use the pseudo path just like current opening behavior=
, the writeback
>  > > file will hold a reference of vfsmount of overlayfs and it will caus=
e umount fail with -EBUSY.
>  > > So I want to open a writeback file with correct underlying path stru=
ct but not sure if
>  > > there is any unexpected side effect. Any suggestion?
>  >
>  > Should be no issue with plain dentry_open() for that purpose.  In fact
>  > it would be really good to get rid of all that d_real*() mess
>  > completely, but that seems some ways off.
>  >
>  > Did you find the prototype we did with Amir a couple of years back?  I
>  > can only find bits and pieces in my mailbox...
>  >
>
> I searched in overlayfs mail list but unfortunately didn't  get useful in=
fo.
> Seems Amir has a git tree for aops prototype but I'm not sure if that is =
the
> prototype you mentioned.
>
> https://github.com/amir73il/linux/commits/ovl-aops-wip
>
> Hi Amir,
>
> Do you know the prototype that Miklos mentioned above? Is that the
> code in your ovl-aops-wip git tree?
>

Yes it is.
The discussion over that branch and remaining TODO is on this thread [1].

CCing Ritesh who also expressed intention to start beating this
branch into shape.

If you go over the code/emails and still feel lost, I think it is best to h=
ave
a video call.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/CAJfpegsyA4SjmtAEpkMoKsvgmW0CiEwW=
EAbU7v3yJztLKmC0Eg@mail.gmail.com/
