From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 07/39] vfs: export vfs_ioctl() to modules
Date: Tue, 19 Jun 2018 15:54:51 +0100
Message-ID: <20180619145451.GQ30522@ZenIV.linux.org.uk>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-8-mszeredi@redhat.com>
 <20180604084904.GF11333@infradead.org>
 <20180610045657.GM30522@ZenIV.linux.org.uk>
 <CAJfpegtGtAR25qWgpNisvL8F51h3K6s44zkWBSVVbqecut6tBQ@mail.gmail.com>
 <20180611162412.GA7574@infradead.org>
 <CAJfpegvxHs+MvC3N2Cbocp0UNrM47_GEUSV+mAx=8VVNDz7r_g@mail.gmail.com>
 <20180619142421.GA16151@infradead.org>
 <CAJfpegt7QYa1SD=uJ84RE9qLbJLMCW+viV=FN_TJJjCK4BERLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegt7QYa1SD=uJ84RE9qLbJLMCW+viV=FN_TJJjCK4BERLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jun 19, 2018 at 04:34:33PM +0200, Miklos Szeredi wrote:
> On Tue, Jun 19, 2018 at 4:24 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Tue, Jun 19, 2018 at 04:04:41PM +0200, Miklos Szeredi wrote:
> >> FS_IOC*
> >>
> >> Haven't looked deeply.  For now overlayfs just implements
> >> FS_IOC_{GET|SET}FLAGS because some of these flags are quite generic
> >> and implementing them on the overlay is easy.
> >>
> >> Yes, turning into a method makes sense.
> >
> > Do you want to do this or should I send a patch?
> 
> Do it.  You are much more familiar with regular fs that implement
> these ioctls.  Untangling overlap between FS_IOC_...FLAGS and
> FS_IOC_...XATTR looks "interesting".

Suggestion: have that go through ->setattr(); that's what
ATTR_ATTR_FLAG was supposed to be for, IIRC.
