From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 5/7] overlay: test concurrent copy up of lower
 hardlinks
Date: Wed, 12 Jul 2017 11:17:47 +0800
Message-ID: <20170712031747.GQ29475@eguan.usersys.redhat.com>
References: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
 <1499168434-23859-6-git-send-email-amir73il@gmail.com>
 <20170705095902.GR23360@eguan.usersys.redhat.com>
 <CAOQ4uxjLCGZ3hHfkZzgZiHctC1x6s_EF7J1g0-zjXYCOzqoHwQ@mail.gmail.com>
 <CAOQ4uxjYVevw=bTsONHT=FHMkoapqOcmwL+nj4R6Y3T6Dhmneg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751270AbdGLDRt (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 23:17:49 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjYVevw=bTsONHT=FHMkoapqOcmwL+nj4R6Y3T6Dhmneg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Tue, Jul 11, 2017 at 11:23:50PM +0300, Amir Goldstein wrote:
> On Wed, Jul 5, 2017 at 1:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Wed, Jul 5, 2017 at 12:59 PM, Eryu Guan <eguan@redhat.com> wrote:
> >> On Tue, Jul 04, 2017 at 02:40:32PM +0300, Amir Goldstein wrote:
> >>> Two tasks make a modification concurrently on two hardlinks of a large
> >>> lower inode.  The copy up should be triggered by one of the tasks and the
> >>> other should be waiting for copy up to complete.  Both copy up targets
> >>> should end up being upper hardlinks and both metadata changes should be
> >>> visible in both hardlinks.
> >>>
> >>> With kernel <= v4.12, hardlinks are broken on copy up, meaning that copy up
> >>
> >> So this will be fixed in 4.13-rc1 kernel?
> >
> > It is fixed on current overlayfs-next branch. Yes.
> >
> 
> Eryu,
> 
> I realize that my answer was not accurate.
> These tests do pass with current overlayfs-next branch, but
> only with non default kernel config CONFIG_OVERLAY_FS_INDEX=y.

Thanks for the heads-up!

> 
> This may be the right way to test, meaning that default kernel
> config reports failed tests related to hardlinks which are really broken
> on copy up with default kernel config.

So these hardlink tests are still valid tests and the failures should be
fixed eventually, even for OVERLAY_FS_INDEX=n kernels? If so, I think we
can just keep the tests unchanged, just like all other tests that are
targeting un-fixed bugs. Then the only issue is the commit log is not so
accurate.

Otherwise, I prefer your opt-in way, making these tests _notrun
(assmuing they're not valid tests for this kernel config).

Thanks,
Eryu

> 
> Another way to go at it is having these tests
> "_require_fs_module_param index" (CONFIG_OVERLAY_FS_INDEX
> sets the default of this parameter) and then opt-in to indexing in the test
> using the index=on mount option.
> 
> This way, those test will notrun on old kernels and pass
> on new kernels regardless of the kernel config option.
> Then they will be testing that "hardlinks are not broken IF
> admin opts-in for indexing".
> 
> I wonder which of the test methodologies you prefer.
> If you like the second one better I can send a patch to make those
> tests depend on and opt-in for indexing.
> 
> Thanks,
> Amir.
