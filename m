Return-Path: <vgoyal@redhat.com>
Date: Fri, 1 Jun 2018 08:38:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH V3] xfstest: overlay: Add tests for overlay metadata only
 copy up feature
Message-ID: <20180601123804.GA3259@redhat.com>
References: <20180529194108.GB13363@redhat.com>
 <CAOQ4uxgjbK=XHy0E0n94KoLhkxEbNU-YFz05mHYaiQTuXPmiRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgjbK=XHy0E0n94KoLhkxEbNU-YFz05mHYaiQTuXPmiRQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <guaneryu@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jun 01, 2018 at 11:34:38AM +0300, Amir Goldstein wrote:

[..]
> > +# File size on lower
> > +lowername="lowerfile"
> > +lowerlink="lowerfile-link"
> > +lowerdata="lower"
> > +lowerblocks="32"
> > +lowersize=$(( $lowerblocks * 512 ))
> > +
> 
> Although the test passes now on ext4/xfs, my comment remains -
> it makes no sense for this test to calculate expected nr of blocks
> instead of using actual lower file blocks.
> 
> While fallocate $size guaranties that resulting file size is $size
> you cannot say the same about $blocks. There is no guarantie
> that file systems will use $size / 512 blocks to store size$.
> file systems can and do allocate more blocks for e.g. xattr and
> other file metadata. There is really no reason for this test to
> make the assumption about $blocks however probable it may be.

Ok. So instead of making assumptions about number of blocks, instead,
create a file of pre-determined size, and then query the number of
blocks from lower and use that as expected blocks from overlay mount?

Will make that change. Thanks.

Vivek
