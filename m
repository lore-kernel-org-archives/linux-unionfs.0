From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 02/23] ovl: ignore index mount option when no upper
 layer
Date: Thu, 4 Jan 2018 15:05:23 -0500
Message-ID: <20180104200523.GA2808@redhat.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-3-git-send-email-amir73il@gmail.com>
 <20180104184220.GA6313@redhat.com>
 <CAOQ4uxjzUkepnemWj-BOX4pwLvHGSk9mK4jabDG4MpK6EHV3PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753169AbeADUFY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 15:05:24 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjzUkepnemWj-BOX4pwLvHGSk9mK4jabDG4MpK6EHV3PA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 04, 2018 at 09:39:48PM +0200, Amir Goldstein wrote:
> On Thu, Jan 4, 2018 at 8:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Jan 04, 2018 at 06:39:57PM +0200, Amir Goldstein wrote:
> >> For non-upper overlay mount, the value of index mount option is moot.
> >> When mounter tries to set this mount options, emit a warning and leave
> >> the value at the default so it won't show up in /proc/mounts.
> >
> > I am curious, what should show in /proc/mounts. Current code seems to
> > print this only if it is different from default.
> >
> 
> I guess that is a common pattern for filesystems only show options
> that are different from default.
> 
> I think the logic is that one would try to reconstruct mounts from a
> snapshot of /proc/mounts, there is no reason to specify values that
> are default, because resulting mount will be the same.
> 
> > So if detfault is index=on, and user specifies index=off (with no upper),
> > it should still show in /proc/mounts?
> >
> 
> What this patch says is that index is not a relevant option with no upper,
> so basically specifying either index=on/off is wrong, but so does specifying
> workdir and the action that overlay takes is ignoring the wrong option.
> I realize the setting index to default (on) when there is no upper is
> a bit hacky, but I think we can live with that in order to keep the parsing
> code simple and storing only a boolean single state.

Ok, fair enough. Thanks

Vivek
