Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E22DC3526B
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Dec 2020 22:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29ECB23B98
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Dec 2020 22:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgLRWz6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgLRWz5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 18 Dec 2020 17:55:57 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5688DC0617B0
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Dec 2020 14:55:17 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id j16so4007520edr.0
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Dec 2020 14:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tgmr6g8d+8NKSfy2Ajc0NMGFuN4E7GphvE93Fo9mAPY=;
        b=Jdkd2AVnGkjt3wcXyIdqZzWSZw/3iZScPqmgcIpUrothFVEZNnGRpIztf9oS4z3EGc
         ESdQW8kOVY/j9yXw+FLdLpppZK+/cJSHp1GbKDbq1262Gscy7lMSHtzTeFYEcKO0MA+I
         +jhG5lQ3Cub22QRmMubNyA1EIgRhC9ptcs408zgvy90VyNfR/7SOWvHONolCXTWZXMyI
         PvChg6UAprBb3KfnJH1rpFRK8UJhzE7YN2v0ZLY42rbnaZYyirXUJAG5H1U2sGB6ie7v
         7ucJsZ/OGiZJ3AyR6w5ayGV9bFmcVBQ19YN4hfrK8dkPM4zoQ/5eEAXnxZ8fCWJ2zMmh
         hBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tgmr6g8d+8NKSfy2Ajc0NMGFuN4E7GphvE93Fo9mAPY=;
        b=mQk4Ug8YF0NPePCLZe3NCyBZxuB6m3R0ft/g+POtof/T4ngX7frJqStvNtljyzWOA2
         e0zxsK0LdzfSrOX123KwC3+4FSkR9/2I8ZPB8RUtEvSSjyvWX90TSIlLCAWyc62TjM8/
         1a1UIZWNmhSxeY5IFqFWFKZ90vCQyozvQ4uVweJEH96yUA0ZkhFx24UxnaSCTxgqo4eV
         39dmP5wJmdFERBmYGhUMRY6X1NzU1xwP0l5d2KHcUwxABhfQL68DLAD8og3CtZ6JqGip
         wauIB0/X4hTcNmDFwMKRnipUT9KinXOVs0pqbAvBqG4u+qhN9ITmxW2Rd4nMf/cu+Uzv
         w4mA==
X-Gm-Message-State: AOAM531lCQFAjQiCH2swEM9hb9Nt+HNI8eSWCIlavcLXzvq5gbMawgbF
        ruI1xzibuT+Qi1cGauvJzpMwC+VNVIx6yH44IdKRG92srQ==
X-Google-Smtp-Source: ABdhPJzC3ovan2Qy7ExEpP6AZ2jnjIsdBvCDQzdLQPNvWcspSItVhRVedKhl7jLw5vnCPQy2zfpqsY6I8sicMsMZjbM=
X-Received: by 2002:aa7:c0d6:: with SMTP id j22mr6632916edp.31.1608332114844;
 Fri, 18 Dec 2020 14:55:14 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
 <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
 <CAOQ4uxgsFnkUqnXYyMNdZU=s_Wq18fdbr0ZhepNLMYh9MfPe9w@mail.gmail.com>
 <CAOQxz3wUvi_O7hzNrN8oTGfnFz-PiVr3Z6nG1ZXLFjpnH4q81g@mail.gmail.com>
 <CAOQxz3zGaKnJCUe7DuegOqbbPAvNj8hTFA6_LsGEPTMXwUpn6g@mail.gmail.com>
 <CAOQ4uxifSf-q1fXC_zxOpqR8GDX8sr2CWPsXrJ6e0YSrfB6v8Q@mail.gmail.com>
 <CAOQxz3xZWCdF=7AZ=N0ajcN8FVjzU2sS_SpxzwRFyHGvwc7dZA@mail.gmail.com>
 <CAOQ4uxjmUY+N6sBoD-d2MN4eehPCcWzBXTHkDqAcCVtkpbG2kw@mail.gmail.com>
 <CAOQxz3y8N6ny23iA1Fe0L4M1gR=FHP5xANZXquu4NSLoucorKw@mail.gmail.com>
 <CAOQ4uxg++DkgcO9K6wkSn0p6QvvkwK0nvxBzSpNE6RdaCH3aQg@mail.gmail.com>
 <CAOQxz3wbqnUxSL-Ks=7USUZU1+04Uvqi-FnTZFGRL9uqQvvNfA@mail.gmail.com>
 <CAOQxz3xNWoj5Az-0JAk1Ay3T_QyE1bso7pxC_7n=hV3B5PBK0w@mail.gmail.com>
 <CAOQ4uxjw5AroFpYBkGExiAfHir4OyABk023RQK_s6TPQ5aTJCw@mail.gmail.com> <CAOQxz3xz88=u8hb4UbbDcH55xLSmzrq+XUEeNqmaOkP_6DNCYg@mail.gmail.com>
In-Reply-To: <CAOQxz3xz88=u8hb4UbbDcH55xLSmzrq+XUEeNqmaOkP_6DNCYg@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 18 Dec 2020 17:55:03 -0500
Message-ID: <CAHC9VhQ-xCJtNaOx1oYRNgsLVQKg+tm3i=8j-7v6hdh4Ty=-pQ@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Michael Labriola <michael.d.labriola@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        LSM List <linux-security-module@vger.kernel.org>,
        Jonathan Lebon <jlebon@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Dec 18, 2020 at 3:50 PM Michael Labriola
<michael.d.labriola@gmail.com> wrote:
> On Fri, Dec 18, 2020 at 2:02 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > On Fri, Dec 18, 2020 at 1:47 AM Michael Labriola
> > <michael.d.labriola@gmail.com> wrote:
> > >
> > > On Thu, Dec 17, 2020 at 4:56 PM Michael Labriola
> > > <michael.d.labriola@gmail.com> wrote:
> > > >
> > > > On Thu, Dec 17, 2020 at 3:25 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > On Thu, Dec 17, 2020 at 9:46 PM Michael Labriola
> > > > > <michael.d.labriola@gmail.com> wrote:
> > > > > >
> > > > > > On Thu, Dec 17, 2020 at 1:07 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > >
> > > > > > > On Thu, Dec 17, 2020 at 6:22 PM Michael Labriola
> > > > > > *snip*
> > > > > > > > On Thu, Dec 17, 2020 at 7:00 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > > > Thanks, Amir.  I didn't have CONFIG_DYNAMIC_DEBUG enabled, so
> > > > > > >
> > > > > > > I honestly don't expect to find much in the existing overlay debug prints
> > > > > > > but you never know..
> > > > > > > I suspect you will have to add debug prints to find the problem.
> > > > > >
> > > > > > Ok, here goes.  I had to setup a new virtual machine that doesn't use
> > > > > > overlayfs for its root filesystem because turning on dynamic debug
> > > > > > gave way too much output for a nice controlled test.  It's exhibiting
> > > > > > the same behavior as my previous tests (5.8 good, 5.9 bad).  The is
> > > > > > with a freshly compiled 5.9.15 w/ CONFIG_OVERLAY_FS_XINO_AUTO turned
> > > > > > off and CONFIG_DYNAMIC_DEBUG turned on.  Here's what we get:
> > > > > >
> > > > > >  echo "file fs/overlayfs/*  +p" > /sys/kernel/debug/dynamic_debug/control
> > > > > >  mount borky2.sqsh t
> > > > > >  mount -t tmpfs tmp tt
> > > > > >  mkdir -p tt/upper/{upper,work}
> > > > > >  mount -t overlay -o \
> > > > > >     lowerdir=t,upperdir=tt/upper/upper,workdir=tt/upper/work blarg ttt
> > > > > > [  164.505193] overlayfs: mkdir(work/work, 040000) = 0
> > > > > > [  164.505204] overlayfs: tmpfile(work/work, 0100000) = 0
> > > > > > [  164.505209] overlayfs: create(work/#3, 0100000) = 0
> > > > > > [  164.505210] overlayfs: rename(work/#3, work/#4, 0x4)
> > > > > > [  164.505216] overlayfs: unlink(work/#3) = 0
> > > > > > [  164.505217] overlayfs: unlink(work/#4) = 0
> > > > > > [  164.505221] overlayfs: setxattr(work/work,
> > > > > > "trusted.overlay.opaque", "0", 1, 0x0) = 0
> > > > > >
> > > > > >  touch ttt/FOO
> > > > > > touch: cannot touch 'ttt/FOO': No data available
> > > > > > [  191.919498] overlayfs: setxattr(upper/upper,
> > > > > > "trusted.overlay.impure", "y", 1, 0x0) = 0
> > > > > > [  191.919523] overlayfs: tmpfile(work/work, 0100644) = 0
> > > > > > [  191.919788] overlayfs: tmpfile(work/work, 0100644) = 0
> > > > > >
> > > > > > That give you any hints?  I'll start reading through the overlayfs
> > > > > > code.  I've never actually looked at it, so I'll be planting printk
> > > > > > calls at random.  ;-)
> > > > >
> > > > > We have seen that open("FOO", O_WRONLY) fails
> > > > > We know that FOO is lower at that time so that brings us to
> > > > >
> > > > > ovl_open
> > > > >   ovl_maybe_copy_up
> > > > >     ovl_copy_up_flags
> > > > >       ovl_copy_up_one
> > > > >         ovl_do_copy_up
> > > > >           ovl_set_impure
> > > > > [  191.919498] overlayfs: setxattr(upper/upper,
> > > > > "trusted.overlay.impure", "y", 1, 0x0) = 0
> > > > >           ovl_copy_up_tmpfile
> > > > >             ovl_do_tmpfile
> > > > > [  191.919523] overlayfs: tmpfile(work/work, 0100644) = 0
> > > > >             ovl_copy_up_inode
> > > > > This must be were we fail and likely in:
> > > > >               ovl_copy_xattr
> > > > >                  vfs_getxattr
> > > > > which can return -ENODATA, but it is not expected because the
> > > > > xattrs returned by vfs_listxattr should exist...
> > > > >
> > > > > So first guess would be to add a debug print for xattr 'name'
> > > > > and return value of vfs_getxattr().
> > > >
> > > > Ok, here we go.  I've added a bunch of printks all over the place.
> > > > Here's what we've got.  Things are unchanged during mount.  Trying to
> > > > touch FOO now gives me this:
> > > >
> > > > [  114.365444] ovl_open: start
> > > > [  114.365450] ovl_maybe_copy_up: start
> > > > [  114.365452] ovl_maybe_copy_up: need copy up
> > > > [  114.365454] ovl_maybe_copy_up: ovl_want_write succeeded
> > > > [  114.365459] ovl_copy_up_one: calling ovl_do_copy_up()
> > > > [  114.365460] ovl_do_copy_up: start
> > > > [  114.365462] ovl_do_copy_up: impure
> > > > [  114.365464] ovl_set_impure: start
> > > > [  114.365484] overlayfs: setxattr(upper/upper,
> > > > "trusted.overlay.impure", "y", 1, 0x0) = 0
> > > > [  114.365486] ovl_copy_up_tmpfile: start
> > > > [  114.365507] overlayfs: tmpfile(work/work, 0100644) = 0
> > > > [  114.365510] ovl_copy_up_inode: start
> > > > [  114.365511] ovl_copy_up_inode: ISREG && !metacopy
> > > > [  114.365625] ovl_copy_xattr: start
> > > > [  114.365630] ovl_copy_xattr: vfs_listxattr() returned 17
> > > > [  114.365632] ovl_copy_xattr: buf allocated good
> > > > [  114.365634] ovl_copy_xattr: vfs_listxattr() returned 17
> > > > [  114.365636] ovl_copy_xattr: slen=17
> > > > [  114.365638] ovl_copy_xattr: name='security.selinux'
> > >
> > > SELinux?  now that's not suspicious at all...
> > >
> > > > [  114.365643] ovl_copy_xattr: vfs_getxattr returned size=-61
> > > > [  114.365644] ovl_copy_xattr: cleaning up
> > > > [  114.365647] ovl_copy_up_inode: ovl_copy_xattr error=-61
> > > > [  114.365649] ovl_copy_up_one: error=-61
> > > > [  114.365651] ovl_copy_up_one: calling ovl_copy_up_end()
> > > > [  114.365653] ovl_copy_up_flags: ovl_copy_up_one error=-61
> > > > [  114.365655] ovl_maybe_copy_up: ovl_copy_up_flags error=-61
> > > > [  114.365658] ovl_open: ovl_maybe_copy_up error=-61
> > > > [  114.365728] ovl_copy_up_one: calling ovl_do_copy_up()
> > > > [  114.365730] ovl_do_copy_up: start
> > > > [  114.365731] ovl_do_copy_up: impure
> > > > [  114.365733] ovl_set_impure: start
> > > > [  114.365735] ovl_copy_up_tmpfile: start
> > > > [  114.365748] overlayfs: tmpfile(work/work, 0100644) = 0
> > > > [  114.365750] ovl_copy_up_inode: start
> > > > [  114.365752] ovl_copy_up_inode: ISREG && !metacopy
> > > > [  114.365770] ovl_copy_xattr: start
> > > > [  114.365773] ovl_copy_xattr: vfs_listxattr() returned 17
> > > > [  114.365774] ovl_copy_xattr: buf allocated good
> > > > [  114.365776] ovl_copy_xattr: vfs_listxattr() returned 17
> > > > [  114.365778] ovl_copy_xattr: slen=17
> > > > [  114.365780] ovl_copy_xattr: name='security.selinux'
> > > > [  114.365784] ovl_copy_xattr: vfs_getxattr returned size=-61
> > > > [  114.365785] ovl_copy_xattr: cleaning up
> > > > [  114.365787] ovl_copy_up_inode: ovl_copy_xattr error=-61
> > > > [  114.365789] ovl_copy_up_one: error=-61
> > > > [  114.365790] ovl_copy_up_one: calling ovl_copy_up_end()
> > > > [  114.365792] ovl_copy_up_flags: ovl_copy_up_one error=-61
> > > >
> > > *snip*
> > >
> > > So, the selinux stuff made me raise an eyebrow...  I've got selinux
> > > enabled in my kernel so that it's there if I boot up a RHEL box with
> > > this kernel.  But I'm using Ubuntu right now, and the rest of SELinux
> > > is not installed/enabled.  There shouldn't be any selinux labels in
> > > the files I slurped up into my squashfs image, so there shouldn't be
> > > any in the squashfs, so of course that won't work.
> > >
> > > I tried compiling CONFIG_SELINUX=n and guess what, it works now.  So
> > > that's at least a work-around for me.
> > >
> > > So, for whatever reason, between 5.8 and 5.9, having CONFIG_SELINUX=y
> > > but no security labels on the filesystem became a problem?  Is this
> > > something that needs to get fixed in overlayfs?  Or do you think it's
> > > a deeper problem that needs fixing elsewhere?
> > >
> >
> > It's both :)
> >
> > Attached two patches that should each fix the issue independently,
> > but we need to apply both. I only tested that they build.
> > Please verify that each applied individually solves the problem.
> >
> > The selinux- patch fixes an selinux regression introduced in kernel v5.9
> > the regression is manifested in your test case but goes beyond overlayfs.
> >
> > The ovl- patch is a workaround for the selinux regression, but it is also
> > a micro optimization that doesn't hurt, so worth applying it anyway.
>
> Ok, as expected, both patches independently fix the problem for me on
> my 5.9 kernel.  FYI, applying the ovl patch failed initially
> because ovl_is_private_xattr() grew an extra argument in 5.10.
>
> Woohoo!  Thanks, Amir!

Hi Amir, thanks for the patches but would you mind sending them to the
list not as attachments so we can review/comment/merge like we
normally do?

-- 
paul moore
www.paul-moore.com
