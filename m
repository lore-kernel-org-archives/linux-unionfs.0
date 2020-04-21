Return-Path: <SRS0=+UIx=6F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B10C54FCC
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Apr 2020 05:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0387F2071E
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Apr 2020 05:57:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fsUQ3UqE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgDUF5r (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 01:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbgDUF5q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Apr 2020 01:57:46 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456CBC061A0F
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Apr 2020 22:57:46 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id w6so7969829ilg.1
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Apr 2020 22:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rXZ+wdWSu7pHP5L+ZRaSPj3/1hzrN0zvo26LBjnEAUY=;
        b=fsUQ3UqEtXkKsSDU1H1JnJyySMQ/pOylgp78x6ztMjKRmrO8VTTXc8rWzY7G8R09L3
         CmwKainWFQx2Sh25D8FcsIvxKoDY2GR2UTrANKqpqV1v/wFU9jJiuGfJsfFzZwxuIMfH
         KUN4MH+OaKnwC3AuTyyTvXhA36RxXNX6ltE84/857A2AnHDiMCf05IQpVo6xzUwZeyJC
         bjW0ERbIPLldQtFrtV+WokWfeKV0b5wLCxYiT7cO+YpGc0cy1L5jv35RnWzeuSC7bshC
         NQliDB+NVdQJZQqqpVyFPlpOLFlqXQ2jruuY8Yu79QFd00yhOdPCM64A/KZIG0Ffgb/S
         FLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rXZ+wdWSu7pHP5L+ZRaSPj3/1hzrN0zvo26LBjnEAUY=;
        b=e7xw0idAj7kbVRWP56Wekno9az7PlueMN0HPxCM1V1lmSP33IwRTQl7pC2W0Zn+m/8
         g34aYMPBQ2D+eXYp+dtsGjA1CeRvbMKjr90aZf4nE1Kn/Z8mgCATjQaKlBiziKkDXIgY
         7fFnnG+jrkiqAMOCCHPf4YS/RByqPrt3CzmNyxEppOhIoP6hgEpzX+aJ6s48Y4xZvf7x
         KpbYotcWNiXs6Dq8x3W7wXr3aQegtxyDm9MMWt4W3b4YJSIr4H7dBfwkVZ0Y2kf15cBN
         EVHvzuY6Q2T4ZC6JUrG7djap7toxcSaMJareJmZDp3B4i/VYXJCYH0DZuLPTRtCPdHOv
         spLQ==
X-Gm-Message-State: AGi0Pubd/ug8dN8+pXXv+LduqNh4BG8nzrUz3jnKeuwxseWunSo866GD
        qCgF5nymRxm1YDSxznqE7Q3fBF4sK0qSOUUyZjAFc1FB
X-Google-Smtp-Source: APiQypIEF1LiOUsQMaAF94j+B2gM6JFWMTVmMvlzgtJqMWplZ9+pclwZe5a5h1GJGbyUQQHfAKPZhibL3UDGisGmRKo=
X-Received: by 2002:a92:7303:: with SMTP id o3mr19419207ilc.275.1587448665492;
 Mon, 20 Apr 2020 22:57:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200415120134.28154-1-amir73il@gmail.com> <20200415120134.28154-3-amir73il@gmail.com>
 <20200415153032.GC239514@redhat.com> <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
 <20200415194243.GE239514@redhat.com> <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
 <20200416125807.GB276932@redhat.com> <CAOQ4uxi=mT2JYGSXro5YW8gTE5256cxauBddYe2HXM=ZfZ=+ZA@mail.gmail.com>
 <CAOQ4uxjvtGLn=SvLXy3KU6uKbonBUznL==OjdVVjjB6sM=-mgg@mail.gmail.com> <20200420191453.GA21057@redhat.com>
In-Reply-To: <20200420191453.GA21057@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 21 Apr 2020 08:57:34 +0300
Message-ID: <CAOQ4uxjVU6gcQMmyMiBsVV73gik931-7QjAO9TCu+N2ik6109w@mail.gmail.com>
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Apr 20, 2020 at 10:15 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Sat, Apr 18, 2020 at 12:57:27PM +0300, Amir Goldstein wrote:
> > > > If I specify UNIONMOUNT_BASEDIR, then --samefs should be implied?
> > > >
> > >
> > > This might have made sense with the meaning of UNIONMOUNT_BASEDIR
> > > as it is in current posting, but with intended change, I suppose an empty
> > > UNIONMOUNT_LOWERDIR could mean --samefs.
> > > When both --samefs and UNIONMOUNT_LOWERDIR are specified, I'll
> > > throw a warning that UNIONMOUNT_LOWERDIR is ignored.
> > >
> >
> > Vivek,
> >
> > I updated the logic per some of your suggestions and push to:
> >   https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
> > The example of how xfstests uses it is at:
> >   https://github.com/amir73il/xfstests/commits/unionmount
> >
> > Since I am mostly interested in feedback on config interface, I'll just
> > paste the commit message here (same text is also in README).
> >
> > In short: if you set UNIONMOUNT_BASEDIR to virtiofs path and
> > execute run --ov, all layers will be created under that virtiofs path.
>
> This is nice. I tried following and it seems to work.
>
> UNIONMOUNT_BASEDIR=/mnt/virtiofs/overlayfs-tests
> UNIONMOUNT_MNTPOINT=/mnt/virtiofs/mnt
>
> Got a question though. If somebody specifies a BASEDIR, whey not
> automatically select mount point also inside that basedir. Is it because
> of existing structure where basedir and mnt directory are separate and
> defaults are different. Anway, I don't mind overlay mountpoint with
> a separate environment variable.
>

No reason. I think it's a good idea. I'll do it.

> >
> > Let me know if this works for you.
> > Thanks,
> > Amir.
> >
> > commit 8c2ac6e0cd9d4b01e421375e0b9c3703e774cd9f
> > Author: Amir Goldstein <amir73il@gmail.com>
> > Date:   Sun Apr 12 19:22:19 2020 +0300
> >
> >     Configure custom layers via environment variables
> >
> >     The following environment variables are supported:
> >
> >      UNIONMOUNT_BASEDIR  - parent dir of all samefs layers (default: /base)
> >      UNIONMOUNT_LOWERDIR - lower layer path for non samefs (default: /lower)
> >      UNIONMOUNT_MNTPOINT - mount point for executing tests (default: /mnt)
> >
> >     When user provides paths for base/lower dir, they should point at
> >     existing directories and their content will be deleted.
> >     When the default base/lower paths are used, tmpfs instances are created.
> >
> >     UNIONMOUNT_LOWERDIR is meaningless and will be ignored with --samefs.
> >     Empty UNIONMOUNT_LOWERDIR with non-empty UNIONMOUNT_BASEDIR imply --samefs,
>
> What happens if I specify both UNIONMOUNT_LOWERDIR as well as
> UNIONMOUNT_BASEDIR. Does that mean only upper and work will be setup in
> UNIONMOUNT_BASEDIR.
>

Yes, work and upper and with --ov=N also middle layers.

> >     unless user explicitly requested non samefs setup with maxfs=<M>.
>
> So if UNIONMOUNT_LOWERDIR is empty and I specify a UNIONMOUNT_BASEDIR and
> use maxfs=<M>. All layers will still come from under UNIONMOUNT_BASEDIR,
> right?

Yes, but note that while the *path* of all layers is under UNIONMOUNT_BASEDIR,
namely $UNIONMOUNT_BASEDIR/$N/{u,w}, some layers will use the basedir fs,
while others will have a tmpfs instance mounted at $UNIONMOUNT_BASEDIR/$N/.
M from maxfs=<M> determines the number of middle layers using tmpfs instances.

Now that I think about it, this setup should use $UNIONMOUNT_BASEDIR/lower
as lowerdir path and it uses /lower.
I'll need to fix that.

>
> What's most intuitive to me is this.
>
> - If user only specifies UNIONMOUNT_BASEDIR, all layers (lower, upper,
>   work and even mount point) comes from that directory.

OK.

>
> - If user specifies both UNIONMOUNT_LOWERDIR and UNIONMOUNT_BASEDIR, then
>   lower layer path comes from UNIONMOUNT_LOWERDIR and rest of the layers
>   come from UNIONMOUNT_BASEDIR.

DONE.

>
> - If user specifies UNIONMOUNT_MNTPOINT, it is used as overlay mount
>   point. Otherwise one is selected from UNIONMOUNT_BASEDIR if user
>   specified one. Otherwise "/mnt" is the default.
>

OK.

Thanks for valuable feedback,
Amir.
