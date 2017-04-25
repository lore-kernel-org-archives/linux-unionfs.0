From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 00/11] overlayfs constant inode numbers
Date: Tue, 25 Apr 2017 09:53:51 -0400
Message-ID: <20170425135351.GE11500@redhat.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <20170425121620.GB11500@redhat.com>
 <CAOQ4uxhvx1OqYgDb9g4G4_YTA_e-coSAyg2H09+zpDOkBzJYag@mail.gmail.com>
 <20170425125223.GC11500@redhat.com>
 <CAOQ4uxgrnTp_qi6HL+hrQF=xP6zrnOtDyq312UHQPSYp9-3x6w@mail.gmail.com>
 <20170425132908.GD11500@redhat.com>
 <CAOQ4uxhu8PbYEabX3Zwt_e030Dkmrxx1dftdVxXx_e+ipZfwVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59222 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1430928AbdDYNx6 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Apr 2017 09:53:58 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhu8PbYEabX3Zwt_e030Dkmrxx1dftdVxXx_e+ipZfwVg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>

On Tue, Apr 25, 2017 at 04:49:00PM +0300, Amir Goldstein wrote:
> On Tue, Apr 25, 2017 at 4:29 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Apr 25, 2017 at 04:23:28PM +0300, Amir Goldstein wrote:
> >> On Tue, Apr 25, 2017 at 3:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Tue, Apr 25, 2017 at 03:41:56PM +0300, Amir Goldstein wrote:
> >> >> On Tue, Apr 25, 2017 at 3:16 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> >> > On Mon, Apr 24, 2017 at 12:14:05PM +0300, Amir Goldstein wrote:
> >> >> >> Miklos,
> >> >> >>
> >> >> >> Following your comments on the 'stable inodes' series from last week,
> >> >> >> this series fixes constant inode numbers for stat(2) with any layer
> >> >> >> configuration.
> >> >> >>
> >> >> >> For the case of all *lower* layers on same fs that supports NFS export,
> >> >> >> redirect by file handle will be used to optimize the lookup of the copy
> >> >> >> up origin of non-dir inode.
> >> >> >
> >> >> > I was trying to run unionmount-testsuite (original from dhowells) and I
> >> >> > disabled layer check. Looks like empty directory rename test fails.
> >> >> >
> >> >> > ***
> >> >> > *** ./run --ov --ts=0 rename-empty-dir
> >> >> > ***
> >> >> > TEST rename-empty-dir.py:10: Rename empty dir and rename back
> >> >> >  ./run --rename /mnt/a/empty100 /mnt/a/no_dir100
> >> >> >  /mnt/a/empty100: Unexpected error: Invalid cross-device link
> >> >> >
> >> >>
> >> >> Strange... I can't find code in recent times when this used to work
> >> >> It certainly doesn't look like it should work with kernel v4.10
> >> >> and redirect_dir=off.
> >> >> I couldn't the point of regression by looking at the change log.
> >> >> You'd need to bisect to find the regression patch.
> >> >>
> >> >> Are you not compiling kernel with redirect_dir?
> >> >> CONFIG_OVERLAY_FS_REDIRECT_DIR=y
> >> >
> >> > I noticed that I am running with REDIRECT_DIR=n.
> >> >
> >> > I also re-ran the tests without your patches and test is still broken. So
> >> > it is not due to your current patch series.
> >> >
> >> > It has been long time since I ran these tests. I suspect that we might
> >> > have changed this behavior during redirect directory patches.
> >> >
> >> > So question is, is this a regression or expected behavior. That is with
> >> > REDIRECT_DIR=n, renames of empty directory will be denied too.
> >> >
> >>
> >> It must be a regression, although I can't think why anyone would care.
> >> If one really cares about renaming lower empty directories, why not enable
> >> REDIRECT_DIR?
> >
> > I will enable it now. I just had an old config and ran into this.
> >
> > But this does raise the question unionmount-testsuite need to be
> > maintained somewhere so that it acts as a baseline to figure out if
> > new patches broke some existing tests.
> >
> > I can go by the tree you are maintaining but currently that's broken too
> > with REDIRECT_DIR=n.
> >
> 
> Right.
> I have given some though about what's the best way to handle this.
> Probably need a test flag --noredirect. I'll add this to my TODO...
> 
> BTW, I try to keep the branch overlayfs-devel uptodate for testing
> latest features. It could be rebased, but I'll make an effort not to.
> If there is a need for a more stable non-rewindable branch, let me know.

I think would be good if you maintain "master" branch of your tree up
to date and hopefully that's stable so that later git pull does not talk
about conflicts. We can then use your tree for setting a baseline and
detecting regressions.

CCing Dave Howells, in case he is interested in continuing to update his
tree as overlayfs kernel development takes place.

Vivek
