From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/39] vfs: export vfs_ioctl() to modules
Date: Tue, 19 Jun 2018 07:24:21 -0700
Message-ID: <20180619142421.GA16151@infradead.org>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-8-mszeredi@redhat.com>
 <20180604084904.GF11333@infradead.org>
 <20180610045657.GM30522@ZenIV.linux.org.uk>
 <CAJfpegtGtAR25qWgpNisvL8F51h3K6s44zkWBSVVbqecut6tBQ@mail.gmail.com>
 <20180611162412.GA7574@infradead.org>
 <CAJfpegvxHs+MvC3N2Cbocp0UNrM47_GEUSV+mAx=8VVNDz7r_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegvxHs+MvC3N2Cbocp0UNrM47_GEUSV+mAx=8VVNDz7r_g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jun 19, 2018 at 04:04:41PM +0200, Miklos Szeredi wrote:
> FS_IOC*
> 
> Haven't looked deeply.  For now overlayfs just implements
> FS_IOC_{GET|SET}FLAGS because some of these flags are quite generic
> and implementing them on the overlay is easy.
> 
> Yes, turning into a method makes sense.

Do you want to do this or should I send a patch?
