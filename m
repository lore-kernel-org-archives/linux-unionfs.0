From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v4 1/3] common/rc: add scratch shutdown support for
 overlayfs
Date: Thu, 14 Dec 2017 23:02:48 +0800
Message-ID: <20171214150248.GI2749@eguan.usersys.redhat.com>
References: <1513261145-127502-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxi3BD8-RA9AU-VUa_yumXq=e=7a5o8843F3mcMaD-Vk2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752615AbdLNPCu (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 10:02:50 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi3BD8-RA9AU-VUa_yumXq=e=7a5o8843F3mcMaD-Vk2g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chengguang Xu <cgxu519@icloud.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Dec 14, 2017 at 04:46:21PM +0200, Amir Goldstein wrote:
> On Thu, Dec 14, 2017 at 4:19 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
> > check -overlay overrides SCRATCH_MNT variable to it's own,
> > so adjust target to underlying filesystem(OVL_BASE_SCRATCH_MNT)
> > when running shutdown on overlayfs.
> >
> > Introduce a helper _scratch_shutdown to mainly handle scratch
> > shutdown and convert godown to _scratch_shutdown to support
> > overlayfs running on below cases.
> 
> You should do this in 2 patches:
> 1. replace all open coded godown calls with _scratch_shutdown helper
> 2. Add overlay support to _scratch_shutdown helper.

The description is not clear enough, the updates are not for running
existing shutdown tests to run on overlay, but to avoid test failures
using the bare 'src/godown $SCRATCH_MNT' when _require_scratch_shutdown
accepts overlay to run. e.g.

+/root/xfstests/src/godown: error on xfsctl(GOINGDOWN) of "/mnt/scratch/ovl-mnt": Inappropriate ioctl for device

So I think it's proper to do all the required updates in one patch,
instead of introducing (intermediate) false failures, and fixing them in
a follow-up patch.

> 
> >
> > generic/043
> > generic/044
> > generic/045
> > generic/046
> > generic/047
> > generic/048
> > generic/051
> > generic/052
> > generic/054
> > generic/055
> > generic/392
> > generic/417
> > generic/461
> > generic/468
> 
> Really no need to specify these in change log. They already appear in diffstat.

Agreed.

> 
> >
> > In order to avoid overlayfs running on improper shutdown
> > cases, add _require_local_device $SCRATCH_DEV to below cases.
> 
> I don't understand.
> In all these tests, there is already _require_scratch_shutdown.
> Shouldn't that prevent overlay running improper shutdown?

generic/042 and generic/050 assume we're testing against a local device
(do mkfs or operate on $SCRATCH_DEV directly), so we need additional
check on $SCRATCH_DEV. Perhaps we need some comments in each test. But I
don't see why generic/388 requires a local device too, maybe I missed
something, that's why we need comments :)

Thanks,
Eryu
