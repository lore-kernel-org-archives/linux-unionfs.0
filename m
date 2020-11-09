Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FD9C5517A
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 17:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EDA22222B
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 17:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JsstFVQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731370AbgKIRUU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 12:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730768AbgKIRUU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Nov 2020 12:20:20 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66627C0613CF
        for <linux-unionfs@vger.kernel.org>; Mon,  9 Nov 2020 09:20:20 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id r12so10605143iot.4
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Nov 2020 09:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aVDrHJVddLyqx9LAMmUCBHBdfPTNkW1QMfGLE8kbU0A=;
        b=JsstFVQ0RTz057biZ80IEja/AWiEn2xbf8pQLaMNMRkslasptKda6oDQoxFBv8omF1
         SEMhvXTJGBaahIQ9QN+aTPHlHm32FriDvPSna7MOo6SeR/4LBMLHTcQhcb3ejh2YYsdZ
         DntnsEC3hZVClz0B+cRj8BE7M2BD3C21kWOmO/7FV8WPh/k0H+Ya9Z3awJEm320qbpTw
         xNqJMUyCdKp5iHHXf/mJfOOuU5JrSaEXrQ5zOSTrfrSFsP98ZNtfvOpgNmkjiZwcOSm4
         Tx/4DxQ+vHTTRIa/SFZCCpZfHlHP35F2xDKneAKvI7LPPgkot+nzVfAvl9ZqU+UAGdKJ
         Y7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aVDrHJVddLyqx9LAMmUCBHBdfPTNkW1QMfGLE8kbU0A=;
        b=PucW6GXoX3qE+vXm7DCPK/END93gjZZFuJFVn8O3vVJ/UyuKH7bNYIpbn2LOpgJGK+
         8W2S8A658PlDqT/kTK/GkSDH0JthxEe3po1VA7ihHQgjCVMXjgDvVU15Mv0c0BrHGzcP
         7gHSUpXR9nZrDsbdsDNYovnTpEa3wM4Ek4B7RgjEBEaeYDljwykZrlfMuqqu1zABoH9H
         TeAz9ehmRAiBnmsyNHie7S7XwzXq3SBJNUODZCWsbplGiYbvsP7cBcwq9a/6qpou21SY
         0qBECLALgjfCGi4xlBwP49LcMt4Vx3eHdSeGLgIoAEHYKCBtO1r4a7fqo1Y7uveXLP6L
         oEVA==
X-Gm-Message-State: AOAM533axjNs52LAfPF3bRED7MOIPuSTHrYDFNtedmhJMnslqOMoyAup
        gWZMtHnTczuAFtZQt/ibSIfjD8lV99Mc3JMnknjtpVhn
X-Google-Smtp-Source: ABdhPJw9ZeZnP4AR0U0bunUWujw38evAEQaOlQdZwGJQNzHHK/dLdyncgyb/Hj28XLNDbK1MgaVUTF/vpUQ59kf3cOo=
X-Received: by 2002:a05:6602:5de:: with SMTP id w30mr7095675iox.64.1604942419677;
 Mon, 09 Nov 2020 09:20:19 -0800 (PST)
MIME-Version: 1.0
References: <20200831181529.GA1193654@redhat.com> <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
 <20201106190325.GB1445528@redhat.com> <87o8kamfuo.fsf@redhat.com>
 <CAOQ4uxhyzw=fHokRuCDFwD7SUg14_i1W0HMp9AGD6UxC5t5+tQ@mail.gmail.com> <20201109170953.GE1479853@redhat.com>
In-Reply-To: <20201109170953.GE1479853@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 9 Nov 2020 19:20:07 +0200
Message-ID: <CAOQ4uxhKr+j5jFyEC2gJX8E8M19mQ3CqdTYaPZOvDQ9c0qLEzw@mail.gmail.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Sargun Dhillon <sargun@sargun.me>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Daniel J Walsh <dwalsh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Nov 9, 2020 at 7:09 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
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
>
> Hi Amir,
>
> Taking a step back and I am wondering what are the problems if we
> remoung a volatile mount after system crash. I mean how it is different
> from non-volatile mount after crash.
>
> One difference which comes to my mind is that an application might have
> done fsync and after remount it will expect changes to have made to
> persistent storage and be available. With volatile mount sunch guarantee
> can not be given.
>
> Can we keep track if we skipped any sync/fsync or not. If not, we can delete
> incomat directory on umount allowing next mount to succeed without any
> user intervention.
>
> This probably means that there needs to be a variant of umount() which
> does not request sync and container tools need to do a umount without
> request sync. Or may be the very fact container-tools/app mounted ovelay
> "volatile" they already opted in to not sync over umount. So they can't
> expect any guarantees of data hitting disk after umount.
>
> IOW, is it ok to remove "incomapt" directory if application never did
> an fsync. I don't know how common it is though because the problem we
> faced was excessive amount of fsync. So keeping found of fsync might
> not help at all.
>

Lots of applications do fsync of course.
Also copy up does fsync before moving the upper file into place.
Without this fsync (in volatile mode) upper files could very well be
corrupted even if applications never wrote to them anything and
never did fsync.

So is there a good reason to defer creation of incompat dir until
the first copy up or fsync? I don't think so.

Thanks,
Vivek
