Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352D1C433E1
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 13:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F5882078D
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 13:20:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="jBXyBPt2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgHXNUk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 09:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgHXNUi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 09:20:38 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A080C061573
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 06:20:37 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b2so8016902edw.5
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 06:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eD1e/54ptJ5d/SK8gBaFa/rAl77Le3KPhmZicDzRNvE=;
        b=jBXyBPt20mIm3n5vBeSukFS0gVpPPXwGd4nt9LNquUOYQ3SEY7zd6sHJUrNLM2w+Qj
         JXieh3s29DMyXyt9TYlIgw7hP/6Ity/AMpqpehHRPkU4NyLrAY/zhBhdcqJF5vbBl723
         M/dIjIWk29v05mf5wCEKJaRQa65R2TpEaywJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eD1e/54ptJ5d/SK8gBaFa/rAl77Le3KPhmZicDzRNvE=;
        b=hbMA6I/iH4+gVMl+K7ZF7rLjw9N5ZFljaM/DHwZuy3xKQ+9AMut0xAbBnxpVrT9ppn
         i8H2lUNnI7UnanGkGbCfFzxDQwuSKlWXSctRohIwb+PcBSivWNE0r4DQdLYCoN9Oormi
         z8umReg/il07YVKmNgxy7mVr/6FDyEJMCEoml9Pxy5a3X7Zs2qDuRvpfhcSxKyYSfhgo
         eiMyrPLpWbhaaQlc9uucvPCu3sxISOh1w47Oy84xpa4dBBwwPeubyYvn0I/vuyHtvpuc
         Ri5Az7D8qKtzjSTiG+AE5TpOfhPx+SU0WfpNM9DCOjXqTb1iiABtZDYOT6/bfDMmUPf/
         Lxlw==
X-Gm-Message-State: AOAM531X/js9+2x6f9G7Z/yGLep/skZrQPRfbsYA5sxqguhRUK8wLR0y
        M6y1g2L7bMMQINYERHbHDrArE34GIbiZwcVL4cafNCus2L97sbk5
X-Google-Smtp-Source: ABdhPJz7TLYB6ZpSpMmrYtjqOpZpG2OKWb7zm9RMl8KddhQXzbzE/PAIX9r8HISySMuSyfq/lJgIAfyMVaYgdRysVPM=
X-Received: by 2002:aa7:d5d0:: with SMTP id d16mr5232243eds.212.1598275236016;
 Mon, 24 Aug 2020 06:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200722175024.GA608248@redhat.com> <87h7svyqsd.fsf@redhat.com>
 <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
 <87a6yknugp.fsf@redhat.com> <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
 <874kosnqnn.fsf@redhat.com>
In-Reply-To: <874kosnqnn.fsf@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 24 Aug 2020 15:20:20 +0200
Message-ID: <CAJfpegvaUz_M0jtibOk=a6Cx=U9JBnOcVSmF2xM9cyVmCz8CFg@mail.gmail.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip sync
To:     Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 24, 2020 at 3:02 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> Amir Goldstein <amir73il@gmail.com> writes:
>
> > On Mon, Aug 24, 2020 at 2:39 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> >>
> >> Hi Amir,
> >>
> >> Amir Goldstein <amir73il@gmail.com> writes:
> >>
> >> > On Mon, Aug 24, 2020 at 11:15 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> >>
> >> >> On Sat, Aug 22, 2020 at 11:27 AM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> >> >> >
> >> >> > Vivek Goyal <vgoyal@redhat.com> writes:
> >> >> >
> >> >> > > Container folks are complaining that dnf/yum issues too many sync while
> >> >> > > installing packages and this slows down the image build. Build
> >> >> > > requirement is such that they don't care if a node goes down while
> >> >> > > build was still going on. In that case, they will simply throw away
> >> >> > > unfinished layer and start new build. So they don't care about syncing
> >> >> > > intermediate state to the disk and hence don't want to pay the price
> >> >> > > associated with sync.
> >> >> > >
> >> >>
> >> >> [...]
> >> >>
> >> >> > Ping.
> >> >> >
> >> >> > Is there anything holding this patch?
> >> >>
> >> >> Not sure what happened with protection against mounting a volatile
> >> >> overlay twice, I don't see that in the patch.
> >> >
> >> > Do you mean protection only for new kernels or old kernels as well?
> >> >
> >> > The latter can be achieved by using $workdir/volatile/ as upperdir
> >> > instead of $upperdir.
> >> > Or maybe even use $workdir/work/incompat/volatile/upper, so if older
> >> > kernel tries to re-use that $workdir, it will fail to mount rw with error:
> >> >
> >> >   overlayfs: cleanup of 'incompat/volatile' failed (-39)
> >> >
> >> > If we agree to that, then upperdir= should not be provided at all when
> >> > specifying "volatile".
> >>
> >> in this case, what does a program need to do to remount the overlay more
> >> than once?  Is it enough to just delete a file?
> >>
> >
> > Do you mean re-mount while forgetting all changes to previous "volatile"
> > mount?
>
> no, without forgetting them.
> The original idea was to have a way to disable any sync operation in the
> overlay file system and let the upper layers handle it.  IOW, mount
> volatile overlay+umount overlay+syncfs upper dir must still be
> considered safe.
> If we want to make it safer and disallow remounting the same
> workdir+upperdir by default when "volatile" is used, that is fine; but I
> think there should still be a way to say "I know what I am doing, just
> remount it".

Indeed.  "Volatile" doesn't mean you can't use the data, just that the
data may be lost completely in case of a crash (tmpfs analogue).

Maybe just stick

  $(workdir)/work/incompat/volatile/donotremove

in there to prevent misuse.

Thanks,
Miklos
