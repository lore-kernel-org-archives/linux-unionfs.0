Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 687A6C4320A
	for <linux-unionfs@archiver.kernel.org>; Wed,  4 Aug 2021 03:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3646860F41
	for <linux-unionfs@archiver.kernel.org>; Wed,  4 Aug 2021 03:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhHDDob (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 3 Aug 2021 23:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234462AbhHDDoa (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Aug 2021 23:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB60A60EE9;
        Wed,  4 Aug 2021 03:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628048658;
        bh=CJp72H1Jw6eXHVOvMJLDrT8zGCAmXCAyWZrb3Ly9rf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TKNk/s7fC/q53Kh6l5t1gdHNXsGdx0iFvTzELqutT+N36wdVfUtFNeIkw7KI1H4Uv
         kFpnsTPk4NJaxgej3NvBgCBUC/R9nzxBDxfBjsbe6s7HfkaAKXZWQ8qAPM8L+Ic8o2
         3o8JH38BgiCuROEF908ZFgMNve8ifz/HM8j/oawvsyPjMl4NnHRW5pU+MdOD+laz6Q
         cPauZfKnHI64sTz38QZ8uNa5JNqXJ0VhF4xzJq3Yodi63QBn/Q9eoBNr9O1dq4zXPl
         g+020qI4rnDUObCQW7JZU7BJBbb5OngkQZ1raRb7FlqIl7A8slwtreBFAke+lXswNe
         FPIKoFuJcb+Dw==
Date:   Tue, 3 Aug 2021 20:44:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] overlay: add test for copy up of lower file attributes
Message-ID: <20210804034418.GD3601425@magnolia>
References: <20210722164634.394499-1-amir73il@gmail.com>
 <20210802230727.GC3601425@magnolia>
 <CAOQ4uxgC6R9rAEM8YfJ83SN2UN_Z9gKY3_CTdDaYayC7SoNe4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgC6R9rAEM8YfJ83SN2UN_Z9gKY3_CTdDaYayC7SoNe4Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 03, 2021 at 10:21:02AM +0300, Amir Goldstein wrote:
> On Tue, Aug 3, 2021 at 2:07 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Thu, Jul 22, 2021 at 07:46:34PM +0300, Amir Goldstein wrote:
> > > Overlayfs copies up a subset of lower file attributes since kernel
> > > commits:
> > > 173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
> > > 2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")
> > >
> > > This test verifies this functionality works correctly and that it
> > > survives power failure and/or mount cycle.
> >
> > Just out of curiosity -- is this supposed to succeed with a 5.14-rc4
> > kernel?
> 
> No. The documented fix commits are in linux-next.
> Looks like they are heading for 5.15-rc1.
> 
> > I noticed a massive regression with this week's fstests,
> > probably because something didn't get cleaned up properly:
> >
> > --- overlay/078.out
> > +++ overlay/078.out.bad
> > @@ -1,2 +1,17 @@
> >  QA output created by 078
> >  Silence is golden
> > +Before copy up: -------A-------------- /opt/ovl-mnt/testfile
> > +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> > +Before copy up: -------A-------------- /opt/ovl-mnt/testfile
> > +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> > +Before copy up: --S----A-------------- /opt/ovl-mnt/testfile
> > +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> > +Before copy up: --S----A-------------- /opt/ovl-mnt/testfile
> > +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> > +Before copy up: --S--a-A-------------- /opt/ovl-mnt/testfile
> > +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> > +Before copy up: --S--a-A-------------- /opt/ovl-mnt/testfile
> > +After  copy up: ---------------------- /opt/ovl-mnt/testfile
> > +rm: cannot remove '/opt/ovl-upper/testfile': Operation not permitted
> > +rm: cannot remove
> > '/opt/ovl-work/index/00fb2100812f1a30dc474847dbad5281308293ece9030e00020000000054816fd1':
> 
> I'm curious, are you running with non-default mount/config options
> on purpose? i.e. index=on or nfs_export=on?
> 
> > Operation not permitted
> > +Write unexpectedly returned 0 for file with attribute 'i'
> 
> Oops, sorry. The problem is even sooner than _cleanup().
> I hadn't noticed it because the head snippet of 078.out.bad was expected
> and I did not look past it.

./check -r ;)

> 
> >
> > and then the tests after it (e.g. generic/030) fail with:
> >
> > +mount: /opt/ovl-mnt: mount(2) system call failed: Stale file handle.
> > +mount failed
> > +(see /var/tmp/fstests/generic/030.full for details)
> >
> 
> And I hadn't noticed that because overlay/078 is the last test to reuse
> /opt/ovl-upper/ and kvm-xfstests zaps the base fs before every run.
> 
> Posted a fix.
> Sorry for the trouble.

I'll give it a spin overnight.

--D

> Thanks,
> Amir.
