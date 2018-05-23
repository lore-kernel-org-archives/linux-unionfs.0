Return-Path: <vgoyal@redhat.com>
Date: Wed, 23 May 2018 16:00:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 00/30] overlayfs: Delayed copy up of data
Message-ID: <20180523200040.GA3726@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <20180508134230.GC3501@redhat.com>
 <CAOQ4uxhF-tij6y7Dd=+-aj1KWZh1ZWXx94imKy-CG_YKrUpFtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhF-tij6y7Dd=+-aj1KWZh1ZWXx94imKy-CG_YKrUpFtA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 08, 2018 at 05:16:54PM +0300, Amir Goldstein wrote:
> On Tue, May 8, 2018 at 4:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, May 07, 2018 at 01:40:32PM -0400, Vivek Goyal wrote:
> >> Hi,
> >>
> >> This is V15 of overlayfs metadata only copy-up feature. These patches I
> >> have rebased on top of Miklos overlayfs-next tree's branch overlayfs-rorw.
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw
> >>
> >> Patches are also available here.
> >>
> >> https://github.com/rhvgoyal/linux/commits/metacopy-v15
> >>
> >> I have run unionmount-testsuite and "./check -overlay -g quick" and that
> >> works. Only 4 overlay tests fail, which fail on vanilla kernel too.
> >>
> >
> > Hi Amir,
> >
> > I have taken care of your review comments and pushed new patches at
> > "metcopy-next" branch.
> >
> > https://github.com/rhvgoyal/linux/commits/metacopy-next
> 
> Looks good.

Given all the work w.r.t fixing races and making use of ovl_get_inode()
in ovl_instantiate(), I have rebased my patches on top of Amir's ovl-fixes
branch and pushed it to "metacopy-next-ovl-fixes" branch.

https://github.com/rhvgoyal/linux/commits/metacopy-next-ovl-fixes

With usage of ovl_get_inode() in ovl_instantiate(), I realized that I
should not have to call ovl_set_upperdata() now explicitly as
ovl_get_inode() will take care of that anyway. So I dropped it. Also
dropped similar call from export.c as it felt redundant.

I might do another posting of patches once all the ovl_get_inode()
related cleanup gets merged and shows up in Miklos's tree.

Thanks
Vivek
