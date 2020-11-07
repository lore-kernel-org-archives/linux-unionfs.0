Return-Path: <SRS0=vXub=EN=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B8CC388F9
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Nov 2020 11:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC97206F4
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Nov 2020 11:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="DbTo/gcQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgKGLwd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 7 Nov 2020 06:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgKGLwc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 7 Nov 2020 06:52:32 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BE0C0613CF
        for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2020 03:52:30 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id e16so3616491ile.0
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2020 03:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L6RLtlSYRA3fR1+ZLbFzL1ms0IPHQbszc83cvxROnOA=;
        b=DbTo/gcQgyamNHKltNmPJ1znUybn5GtbW2k9RStfYDdKl8HBXIF0HXBznWjbeJihCB
         KUwRM+ZNLHJjZrsH1uzRu28keskx3dyErzJM0t0QRZE5Bpnfrv6cCOqzZ+2IqZX1Zbuz
         Jy8Y7OBUtKLq+YkbBbMj93qgGZ0kr7WyPa16c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=L6RLtlSYRA3fR1+ZLbFzL1ms0IPHQbszc83cvxROnOA=;
        b=e4Z1bA8PC1SanJ6McIaYyQDjryH2evR8afW4lzjK0YYIf23gKSBRid6Tw4eVs1Erbj
         3VYs9yb0oQDd9pLICoob/+uoaqYbqikeziaW3hByGbhSyW+icG8w0UGPGIHHLhnhWjW3
         WWSnifFOX/qbGlFYVvILk6/s8vp5lxH13zrH+2aM965nky+hPIuSDv+m5srN+0d/C5PH
         JDOx3xCO2SbC8OfoXzfrGu1dcSxk46Tt49MkmHZJUP1rwpiVoAuQZnaFRoQUKrKC9H1w
         Pg57vstqjriEPpOpsVp7QrB8VZ4TEKh2+8jlQorDFQoFe48R0kbGTkZWnSUXNE64WQek
         GBoQ==
X-Gm-Message-State: AOAM532h5sW0vIsqBzPuQoAfE+fHGET0Z25Vu1QCf+O0w8XjsMTZcUJZ
        MrNHSdJ9cMToAtUsiK65Zs/o0sHNf7PK4g==
X-Google-Smtp-Source: ABdhPJzVXUD7m33ubDXWUrnpJLGTJu+cMj1aCHz4OsA2st7kAn5RIzc22Ou7XjxbW67/pQsBEkZxXw==
X-Received: by 2002:a92:494c:: with SMTP id w73mr4568541ila.104.1604749949798;
        Sat, 07 Nov 2020 03:52:29 -0800 (PST)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id i14sm2534700iow.13.2020.11.07.03.52.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 07 Nov 2020 03:52:28 -0800 (PST)
Date:   Sat, 7 Nov 2020 11:52:27 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Daniel J Walsh <dwalsh@redhat.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip
 sync
Message-ID: <20201107115226.GA14082@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200831181529.GA1193654@redhat.com>
 <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
 <20201106190325.GB1445528@redhat.com>
 <87o8kamfuo.fsf@redhat.com>
 <CAOQ4uxhyzw=fHokRuCDFwD7SUg14_i1W0HMp9AGD6UxC5t5+tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhyzw=fHokRuCDFwD7SUg14_i1W0HMp9AGD6UxC5t5+tQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Nov 07, 2020 at 11:35:04AM +0200, Amir Goldstein wrote:
> On Fri, Nov 6, 2020 at 9:43 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> >
> > Vivek Goyal <vgoyal@redhat.com> writes:
> >
> > > On Fri, Nov 06, 2020 at 09:58:39AM -0800, Sargun Dhillon wrote:
> > >
> > > [..]
> > >> There is some slightly confusing behaviour here [I realize this
> > >> behaviour is as intended]:
> > >>
> > >> (root) ~ # mount -t overlay -o
> > >> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> > >> none /mnt/foo
> > >> (root) ~ # umount /mnt/foo
> > >> (root) ~ # mount -t overlay -o
> > >> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> > >> none /mnt/foo
> > >> mount: /mnt/foo: wrong fs type, bad option, bad superblock on none,
> > >> missing codepage or helper program, or other error.
> > >>
> > >> From my understanding, the dirty flag should only be a problem if the
> > >> existing overlayfs is unmounted uncleanly. Docker does
> > >> this (mount, and re-mounts) during startup time because it writes some
> > >> files to the overlayfs. I think that we should harden
> > >> the volatile check slightly, and make it so that within the same boot,
> > >> it's not a problem, and having to have the user clear
> > >> the workdir every time is a pain. In addition, the semantics of the
> > >> volatile patch itself do not appear to be such that they
> > >> would break mounts during the same boot / mount of upperdir -- as
> > >> overlayfs does not defer any writes in itself, and it's
> > >> only that it's short-circuiting writes to the upperdir.
> > >
> > > umount does a sync normally and with "volatile" overlayfs skips that
> > > sync. So a successful unmount does not mean that file got synced
> > > to backing store. It is possible, after umount, system crashed
> > > and after reboot, user tried to mount upper which is corrupted
> > > now and overlay will not detect it.
> > >
We explicitly disable this in our infrastructure via a small kernel patch that 
stubs out the sync behaviour. IIRC, it was added some time after 4.15, and when 
we picked up the related overlayfs patch it caused a lot of machines to crash.

This was due to high container churn -- and other containers having a lot of 
outstanding dirty pages at exit time. When we would teardown their mounts, 
syncfs would get called [on the entire underlying device / fs], and that would 
stall out all of the containers on the machine. We really do not want this 
behaviour.

> > > You seem to be asking for an alternate option where we disable
> > > fsync() but not syncfs. In that case sync on umount will still
> > > be done. And that means a successful umount should mean upper
> > > is fine and it could automatically remove incomapt dir upon
> > > umount.
> >
> > could this be handled in user space?  It should still be possible to do
> > the equivalent of:
> >
> > # sync -f /root/upperdir
> > # rm -rf /root/workdir/incompat/volatile
> >
> 
> FWIW, the sync -f command above is
> 1. Not needed when re-mounting overlayfs as volatile
> 2. Not enough when re-mounting overlayfs as non-volatile
> 
> In the latter case, a full sync (no -f) is required.
> 
> Handling this is userspace is the preferred option IMO,
> but if there is an *appealing* reason to allow opportunistic
> volatile overlayfs re-mount as long as the upperdir inode
> is in cache (userspace can make sure of that), then
> all I am saying is that it is possible and not terribly hard.
> 
> Thanks,
> Amir.


I think I have two approaches in mind that are viable. Both approaches rely on 
adding a small amount of data (either via an xattr, or data in the file itself) 
that allows us to ascertain whether or not the upperdir is okay to reuse, even 
when it was mounted volatile:

1. We introduce a guid to the superblock structure itself. I think that this 
would actually be valuable independently from overlayfs in order to do things 
like "my database restarted, should it do an integrity check, or is the same SB 
mounted?" I started down the route of cooking up an ioctl for this, but I think 
that this is killing a mosquito with a canon. Perhaps, this approach is the 
right long-term approach, but I don't think it'll be easy to get through.

2. I've started cooking up this patch a little bit more where we override 
kill_sb. Specifically, we assign kill_sb on the upperdir / workdir to our own 
killsb, and keep track of superblocks, and the errseq on the super block. We 
then keep a list of tracked superblocks in memory, the last observed errseq, and 
a guid. Upon mount of the overlayfs, we write the a key in that uniquely 
identifies the sb + errseq. Upon remount, we check if the errseq, or if the sb 
have changed. If so, we throw an error. Otherwise, we allow things to pass.

This approach has seen some usage in net[1].

[1]: https://elixir.bootlin.com/linux/v5.9.6/source/drivers/net/ipvlan/ipvlan_main.c#L80
