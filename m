From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH V2] ovl: Pass ovl_get_nlink() parameters in right order
Date: Tue, 28 Nov 2017 09:18:28 -0500
Message-ID: <20171128141828.GA4101@redhat.com>
References: <20171127184613.GB22007@redhat.com>
 <20171127212612.GD22007@redhat.com>
 <CAOQ4uxhMyc3xcRHvbOq6W3KM2gzuUFKej7+p9NwO-XW1CMPpcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751977AbdK1OS3 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 09:18:29 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhMyc3xcRHvbOq6W3KM2gzuUFKej7+p9NwO-XW1CMPpcw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Nov 28, 2017 at 02:58:00PM +0200, Amir Goldstein wrote:
> On Mon, Nov 27, 2017 at 11:26 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, Nov 27, 2017 at 01:46:13PM -0500, Vivek Goyal wrote:
> >> Right now we seem to be passing index as "lowerdentry" and origin.dentry
> >> as "upperdentry". IIUC, we should pass these parameters in reversed order
> >> and this looks like a bug.
> >>
> >
> > Hi,
> >
> > Don't merge this patch yet. I think this breaks overlay/042 and does not
> > cleanup orphan index. Trying to debug it.
> >
> 
> Vivek,
> 
> The problem is with the test, not with your patch.
> I copied sanity check at end of test to verify that orphan index is cleaned
> on mount from test overlay/034, but there is a subtle difference between
> the 2 tests - with overlay/034 lower is hardlink from the start and therefore
> indexed from the first copy up and nlink accounted from the first copy up.
> with overlay/042, lower is not a hardlink to begin with, so the first copy up
> (at upper path /0) is a non-indexed broken hardlink, which is covering
> the lower /0 path that later becomes a hardlink.
> 
> At the end of test overlay/042, index is NOT cleaned because the
> accounted nlink is not 0, it is 1, because from the index perspective,
> it does not know that the upper path at /0 is covered by a non-indexed
> copy up.
> 
> The whole purpose of the trusted.overlay.nlink accounting is to account
> for the not-yet-copied-up lower hardlinks, so the index with the new data
> is not unlinked after unlinking all current upper hardlinks.
> 
> I wrote a new test to demonstrate this use case and demonstrate the
> implications the bug that you found has on end users:
> https://github.com/amir73il/xfstests/blob/overlayfs-devel/tests/overlay/047
> 
> I will fix test overlay/042.
> Thanks for reporting this breakage.

Hi Amir,

Thanks for the explanation. Good that it is a test issue and not patch
issue. I will repost the patch as V3. In last version, I forgot to cc
stable list.

Vivek
