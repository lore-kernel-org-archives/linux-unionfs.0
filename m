From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 03/16] vfs: don't evict uninitialized inode
Date: Mon, 8 Oct 2018 15:23:27 +0200
Message-ID: <20181008132327.GD20703@kroah.com>
References: <20180729220317.GB30522@ZenIV.linux.org.uk>
 <20180729220453.13431-1-viro@ZenIV.linux.org.uk>
 <20180729220453.13431-3-viro@ZenIV.linux.org.uk>
 <CAOQ4uxgOLEpaZ=UwA_CG6CzYbsJBPV4unEV9D5mXrooLXO0+0w@mail.gmail.com>
 <CAOssrKfmR0beT4dXjg1dn6DBsPbmGBpS5xHpG9QtAAEgMWo_Xg@mail.gmail.com>
 <CAOQ4uxjHdtjc-aXHb-kxghAxU1oRbhEHmBVX5+=w8CgcnGBSGg@mail.gmail.com>
 <CAOQ4uxineYpxqZ11n_y_nWfZvuO1ttSqHFHtDVemkZGGc0tQYg@mail.gmail.com>
 <CAOssrKdx2F+Uz5V0VGc7uf1ajx861v1PN7X-JaP1srOqNNHt4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOssrKdx2F+Uz5V0VGc7uf1ajx861v1PN7X-JaP1srOqNNHt4g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Oct 08, 2018 at 08:41:13AM +0200, Miklos Szeredi wrote:
> On Fri, Aug 24, 2018 at 8:47 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> >> Miklos,
> >>
> >> Seeing that it wasn't fixed in 4.18..
> >>
> >> > I've nothing against applying "new primitive: discard_new_inode() now
> >> > + this patch, but if it is deemed too risky at this point, we could
> >> > just revert the buggy commit 80ea09a002bf ("vfs: factor out
> >> > inode_insert5()") and its dependencies.
> >> >
> >>
> >> Should we propose for stable the upstream commits:
> >> e950564b97fd vfs: don't evict uninitialized inode
> >> c2b6d621c4ff new primitive: discard_new_inode()
> >>
> >> Or should we go with the independent v1 patch:
> >> https://patchwork.kernel.org/patch/10511969/
> >>
> >
> > Greg,
> >
> > To fix a 4.18 overlayfs regression please apply the following
> > 3 upstream commits (in apply order):
> >
> > c2b6d621c4ff new primitive: discard_new_inode()
> > e950564b97fd vfs: don't evict uninitialized inode
> > 6faf05c2b2b4 ovl: set I_CREATING on inode being created
> 
> Is this fixed in 4.18.z yet?

Not yet, sorry, will try to get to that today...

greg k-h
