Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECA9C5517A
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 17:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55DD121D46
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 17:10:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZEtF2I18"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgKIRKB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 12:10:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730208AbgKIRKA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Nov 2020 12:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604941798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sgvyOmsJCi2NL0/JvQQbxqaKUCtNYpaCC5Du8FZSzlY=;
        b=ZEtF2I18kq6PQxvVUEXuELMRcBbEprff8mqN5gh6lgTo/O3ohXI5hcGlg4v/Mq89V8SeLL
        s4HIIlqaV3zAPmXKzYzNt9Uc2jCiUmAdOZMzdGCoV0V5/dA5kzCmTl8tiI+MlyDHRtUKXm
        mkY7UjTyvlvnujK/5b+8dOsmSe5ivBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-7LEHAWgMNhqAzHtogQkwAA-1; Mon, 09 Nov 2020 12:09:55 -0500
X-MC-Unique: 7LEHAWgMNhqAzHtogQkwAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC30B1899421;
        Mon,  9 Nov 2020 17:09:53 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-201.rdu2.redhat.com [10.10.115.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A914F60BF1;
        Mon,  9 Nov 2020 17:09:53 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 38D88222E35; Mon,  9 Nov 2020 12:09:53 -0500 (EST)
Date:   Mon, 9 Nov 2020 12:09:53 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Sargun Dhillon <sargun@sargun.me>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Daniel J Walsh <dwalsh@redhat.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip
 sync
Message-ID: <20201109170953.GE1479853@redhat.com>
References: <20200831181529.GA1193654@redhat.com>
 <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
 <20201106190325.GB1445528@redhat.com>
 <87o8kamfuo.fsf@redhat.com>
 <CAOQ4uxhyzw=fHokRuCDFwD7SUg14_i1W0HMp9AGD6UxC5t5+tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhyzw=fHokRuCDFwD7SUg14_i1W0HMp9AGD6UxC5t5+tQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Hi Amir,

Taking a step back and I am wondering what are the problems if we
remoung a volatile mount after system crash. I mean how it is different
from non-volatile mount after crash.

One difference which comes to my mind is that an application might have
done fsync and after remount it will expect changes to have made to
persistent storage and be available. With volatile mount sunch guarantee
can not be given.

Can we keep track if we skipped any sync/fsync or not. If not, we can delete
incomat directory on umount allowing next mount to succeed without any
user intervention.

This probably means that there needs to be a variant of umount() which
does not request sync and container tools need to do a umount without
request sync. Or may be the very fact container-tools/app mounted ovelay
"volatile" they already opted in to not sync over umount. So they can't
expect any guarantees of data hitting disk after umount.

IOW, is it ok to remove "incomapt" directory if application never did
an fsync. I don't know how common it is though because the problem we
faced was excessive amount of fsync. So keeping found of fsync might
not help at all.

Thanks
Vivek

