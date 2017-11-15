From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/4] ovl: introduce incompatible index feature
Date: Wed, 15 Nov 2017 09:34:42 -0500
Message-ID: <20171115143442.GB13895@redhat.com>
References: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
 <1508839381-24750-2-git-send-email-amir73il@gmail.com>
 <20171110135757.GA16917@redhat.com>
 <CAOQ4uxgw-xOG8m=qLk0gZwq8PF=BSp51nMO2y38FpEAYWznG6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756208AbdKOOen (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Nov 2017 09:34:43 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgw-xOG8m=qLk0gZwq8PF=BSp51nMO2y38FpEAYWznG6g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Nov 10, 2017 at 04:46:53PM +0200, Amir Goldstein wrote:
> On Fri, Nov 10, 2017 at 3:57 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Oct 24, 2017 at 01:02:58PM +0300, Amir Goldstein wrote:
> >> Introduce a new config option OVERLAY_FS_INDEX_INCOMPAT.
> >>
> >> If this config option is enabled then inodes index is declared
> >> an incompatible feature and kernel will refuse to mount an overlay
> >> with inodes index off when a non-empty index directory exists.
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> >>  fs/overlayfs/Kconfig     |  8 ++++++++
> >>  fs/overlayfs/dir.c       | 30 ++++++++++++++++++++++++++++++
> >>  fs/overlayfs/overlayfs.h |  3 ++-
> >>  fs/overlayfs/super.c     | 24 +++++++++++++++++++++++-
> >>  4 files changed, 63 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> >> index cbfc196e5dc5..e5e6dec7d177 100644
> >> --- a/fs/overlayfs/Kconfig
> >> +++ b/fs/overlayfs/Kconfig
> >> @@ -43,3 +43,11 @@ config OVERLAY_FS_INDEX
> >>         outcomes.  However, mounting the same overlay with an old kernel
> >>         read-write and then mounting it again with a new kernel, will have
> >>         unexpected results.
> >> +
> >> +config OVERLAY_FS_INDEX_INCOMPAT
> >> +     bool "Overlayfs: support incompatible index feature"
> >> +     depends on OVERLAY_FS_INDEX
> >> +     help
> >> +       If this config option is enabled then inodes index is declared an
> >> +       incompatible feature and kernel will refuse to mount an overlay with
> >> +       inodes index off when a non-empty index directory exists.
> >
> > Hi Amir,
> >
> > I don't know much about the issues you have faced. So I have few very
> > basic questions.
> >
> > So the problem you are trying to fix is that if somebody mounted overlay
> > with index=on and later they try to mount it with index=off.
> >
> > What problems happen if we allow that? If its a problem, why not always
> > disallow that instead of making it an option. IOW, is there a use case
> > where we will still let user mount later with index=off.
> >
> 
> So I have no current issue with going back from index=on, but I would like
> to start adding incompatible features (like index=all), but in order to add
> the concept of incompatible feature, first user will need to opt-in in compile
> time to "overlayfs v2 format" which supports the feature checks.
> opting-in to format v2 means that user knows he cannot (*) go backwards
> to kernel that doesn't support v2 format and mount v2 format overlayfs.
> 
> Actually, the user can go backwards, but he will need to manually remove
> workdir and indexdir in order to "degrade" overlayfs to v1 before mount.
> 
> I guess config option could have been
> OVERLAY_FS_INCOMAT_V2

So this does not protect against user downgrading to older kernel and
then mount with index=off.

Vivek
