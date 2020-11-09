Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42390C2D0A3
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 20:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5863206D8
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 20:40:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UdZQOesQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgKIUkt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 15:40:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729658AbgKIUkt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Nov 2020 15:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604954447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=43YbDADgXG3x5bNgd1VMA0WngewCvBDd8ayNZwEp/sc=;
        b=UdZQOesQGVgZCJS2amJAT0gfpAjJ2wjNynPY8m1vCbvKr4H2Wglzv6ZDzb14TlfEBE3kEG
        jdThKC+tQlCDTCGw5xvbG8TDutN5t3ONr0qUTZnWEx5pd4sWOWIjFc9r8IhpdX8O5JGVUV
        xXnPtJc2jbSSXNAerQeWrNAZNDlkSRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-7ikFT3oePdCzMCscafj0oA-1; Mon, 09 Nov 2020 15:40:43 -0500
X-MC-Unique: 7ikFT3oePdCzMCscafj0oA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE28A801AC3;
        Mon,  9 Nov 2020 20:40:42 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-201.rdu2.redhat.com [10.10.115.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D0F85C1DA;
        Mon,  9 Nov 2020 20:40:42 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 19014220BCF; Mon,  9 Nov 2020 15:40:42 -0500 (EST)
Date:   Mon, 9 Nov 2020 15:40:42 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Daniel J Walsh <dwalsh@redhat.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip
 sync
Message-ID: <20201109204042.GH1479853@redhat.com>
References: <20200831181529.GA1193654@redhat.com>
 <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
 <20201106190325.GB1445528@redhat.com>
 <87o8kamfuo.fsf@redhat.com>
 <CAOQ4uxhyzw=fHokRuCDFwD7SUg14_i1W0HMp9AGD6UxC5t5+tQ@mail.gmail.com>
 <20201107115226.GA14082@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201107115226.GA14082@ircssh-2.c.rugged-nimbus-611.internal>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Nov 07, 2020 at 11:52:27AM +0000, Sargun Dhillon wrote:
> On Sat, Nov 07, 2020 at 11:35:04AM +0200, Amir Goldstein wrote:
> > On Fri, Nov 6, 2020 at 9:43 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > >
> > > Vivek Goyal <vgoyal@redhat.com> writes:
> > >
> > > > On Fri, Nov 06, 2020 at 09:58:39AM -0800, Sargun Dhillon wrote:
> > > >
> > > > [..]
> > > >> There is some slightly confusing behaviour here [I realize this
> > > >> behaviour is as intended]:
> > > >>
> > > >> (root) ~ # mount -t overlay -o
> > > >> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> > > >> none /mnt/foo
> > > >> (root) ~ # umount /mnt/foo
> > > >> (root) ~ # mount -t overlay -o
> > > >> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> > > >> none /mnt/foo
> > > >> mount: /mnt/foo: wrong fs type, bad option, bad superblock on none,
> > > >> missing codepage or helper program, or other error.
> > > >>
> > > >> From my understanding, the dirty flag should only be a problem if the
> > > >> existing overlayfs is unmounted uncleanly. Docker does
> > > >> this (mount, and re-mounts) during startup time because it writes some
> > > >> files to the overlayfs. I think that we should harden
> > > >> the volatile check slightly, and make it so that within the same boot,
> > > >> it's not a problem, and having to have the user clear
> > > >> the workdir every time is a pain. In addition, the semantics of the
> > > >> volatile patch itself do not appear to be such that they
> > > >> would break mounts during the same boot / mount of upperdir -- as
> > > >> overlayfs does not defer any writes in itself, and it's
> > > >> only that it's short-circuiting writes to the upperdir.
> > > >
> > > > umount does a sync normally and with "volatile" overlayfs skips that
> > > > sync. So a successful unmount does not mean that file got synced
> > > > to backing store. It is possible, after umount, system crashed
> > > > and after reboot, user tried to mount upper which is corrupted
> > > > now and overlay will not detect it.
> > > >
> We explicitly disable this in our infrastructure via a small kernel patch that 
> stubs out the sync behaviour. IIRC, it was added some time after 4.15, and when 
> we picked up the related overlayfs patch it caused a lot of machines to crash.
> 
> This was due to high container churn -- and other containers having a lot of 
> outstanding dirty pages at exit time. When we would teardown their mounts, 
> syncfs would get called [on the entire underlying device / fs], and that would 
> stall out all of the containers on the machine. We really do not want this 
> behaviour.
> 
> > > > You seem to be asking for an alternate option where we disable
> > > > fsync() but not syncfs. In that case sync on umount will still
> > > > be done. And that means a successful umount should mean upper
> > > > is fine and it could automatically remove incomapt dir upon
> > > > umount.
> > >
> > > could this be handled in user space?  It should still be possible to do
> > > the equivalent of:
> > >
> > > # sync -f /root/upperdir
> > > # rm -rf /root/workdir/incompat/volatile
> > >
> > 
> > FWIW, the sync -f command above is
> > 1. Not needed when re-mounting overlayfs as volatile
> > 2. Not enough when re-mounting overlayfs as non-volatile
> > 
> > In the latter case, a full sync (no -f) is required.
> > 
> > Handling this is userspace is the preferred option IMO,
> > but if there is an *appealing* reason to allow opportunistic
> > volatile overlayfs re-mount as long as the upperdir inode
> > is in cache (userspace can make sure of that), then
> > all I am saying is that it is possible and not terribly hard.
> > 
> > Thanks,
> > Amir.
> 
> 
> I think I have two approaches in mind that are viable. Both approaches rely on 
> adding a small amount of data (either via an xattr, or data in the file itself) 
> that allows us to ascertain whether or not the upperdir is okay to reuse, even 
> when it was mounted volatile:
> 
> 1. We introduce a guid to the superblock structure itself. I think that this 
> would actually be valuable independently from overlayfs in order to do things 
> like "my database restarted, should it do an integrity check, or is the same SB 
> mounted?" I started down the route of cooking up an ioctl for this, but I think 
> that this is killing a mosquito with a canon. Perhaps, this approach is the 
> right long-term approach, but I don't think it'll be easy to get through.
> 

> 2. I've started cooking up this patch a little bit more where we override 
> kill_sb. Specifically, we assign kill_sb on the upperdir / workdir to our own 
> killsb, and keep track of superblocks, and the errseq on the super block. We 
> then keep a list of tracked superblocks in memory, the last observed errseq, and 
> a guid. Upon mount of the overlayfs, we write the a key in that uniquely 
> identifies the sb + errseq. Upon remount, we check if the errseq, or if the sb 
> have changed. If so, we throw an error. Otherwise, we allow things to pass.
> 
> This approach has seen some usage in net[1].

So what happens if system crashed and you are booting back. You throw
away all the containers?

The mechanism you described above sounds like you want to detect writeback
errors during next mount and fail that mount (and possibly throw away
the container)?

If I start 5 containers and mount overlay with volatile and these
containers exit. Later say 4 new contaieners were started and some
error happened in writeback. Now if I restart any of the first
5 containers, they all will see the error, right? And they all
will fail to start. Is that what you are trying to achieve. Or I missed
the point completely.

Thanks
Vivek

