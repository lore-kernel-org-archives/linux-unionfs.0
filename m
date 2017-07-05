From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 7/7] overlay: test dropping nlink below zero
Date: Wed, 5 Jul 2017 19:29:10 +0800
Message-ID: <20170705112910.GU23360@eguan.usersys.redhat.com>
References: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
 <1499168434-23859-8-git-send-email-amir73il@gmail.com>
 <20170705100936.GS23360@eguan.usersys.redhat.com>
 <CAOQ4uxgG4x-ZJiewnAwJQiSg9kGYFKz+zfT4seSfy_eMf3RovA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbdGEL3M (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2017 07:29:12 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgG4x-ZJiewnAwJQiSg9kGYFKz+zfT4seSfy_eMf3RovA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Jul 05, 2017 at 02:17:41PM +0300, Amir Goldstein wrote:
> On Wed, Jul 5, 2017 at 1:09 PM, Eryu Guan <eguan@redhat.com> wrote:
> > On Tue, Jul 04, 2017 at 02:40:34PM +0300, Amir Goldstein wrote:
> >> nlink of overlay inode could be dropped indefinety by adding
> >> un-accounted lower hardlinks underneath a mounted overlay and
> >> trying to remove them.
> >
> > Sorry, I didn't quite follow the hardlink patches, could you please
> > describe what is "accounted/un-accounted" hardlinks and the expected
> > behavior in commit log? And what does "indefinety" mean? I couldn't find
> > it in dictionary.
> >
> 
> Try the typos dictionary ;) I meant indefinitely
> 
> I will try to explain better in change log, but here is the full story:
> 
> The simplest way to understand this test is this:
> Imagine that you have a tool (e.g. xfs_db) with which
> you can add hardlinks, without changing the value of nlink
> stored on-disk for the inode. This is exactly what this test does when
> it adds lower hardlinks underneath a mounted overlay.
> 
> Overlayfs assumes that the lower layer files are not modified
> underneath it and if they do, the documentation says:
> "Changes to the underlying filesystems while part of a mounted overlay
> filesystem are not allowed.  If the underlying filesystem is changed,
> the behavior of the overlay is undefined, though it will not result in
> a crash or deadlock."
> 
> As far as I know, this test cannot crash the kernel, but it does trigger
> the WARN_ON in drop_link() when nlink drops below zero, so it's not
> nice behavior and could possibly results in worse outcomes.

I understand now, thanks! Yeah, it's good to have these in commit log or
comments :)

Thanks,
Eryu
