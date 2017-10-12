From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/4] overlay: use default overlay mount options
 _overlay_mount_dirs()
Date: Thu, 12 Oct 2017 14:08:08 +0800
Message-ID: <20171012060808.GZ10593@eguan.usersys.redhat.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
 <1506495852-7295-3-git-send-email-amir73il@gmail.com>
 <CAOQ4uxhr+1g0Pa8-UPTfG2k-ebU1aCygsXfwmFjjgrpf-gFq2Q@mail.gmail.com>
 <20170927080549.GM8034@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750758AbdJLGIK (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2017 02:08:10 -0400
Content-Disposition: inline
In-Reply-To: <20170927080549.GM8034@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Sep 27, 2017 at 04:05:49PM +0800, Eryu Guan wrote:
> On Wed, Sep 27, 2017 at 10:50:46AM +0300, Amir Goldstein wrote:
> > On Wed, Sep 27, 2017 at 10:04 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > > Tests that use _overlay_mount_dirs() should also use the
> > > default overlay mount options.
> > 
> > Vivek, Eryu,
> > 
> > I should make a disclaimer here: I did not test with SELINUX_MOUNT_OPTIONS
> > because I have no SELinux in my test setup.
> > 
> > Specifically, I am concerned that tests that compose "special" overlay mounts,
> > like tmpfs mounts and stacked overlay mounts (overlay/029) may not play well
> > with SELINUX_MOUNT_OPTIONS applied to the special mounts.
> > I am less concerned about the tests that were converted to use
> > _overlay_scratch_mount_dirs() helper.
> > 
> > Can either of you run a -g overlay/quick test with this series and valid
> > SELINUX_MOUNT_OPTIONS?
> 
> Sure, I'll do the testings anyway, and I have selinux enabled on my test
> vms.

I just finished a '-g auto' run with OVERLAY_MOUNT_OPTIONS="-o index=on"
and selinux enabled, and the results look fine, all failures are known
issues. Thanks for the work!

Eryu
