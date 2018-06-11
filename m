From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/39] vfs: export vfs_ioctl() to modules
Date: Mon, 11 Jun 2018 09:24:12 -0700
Message-ID: <20180611162412.GA7574@infradead.org>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-8-mszeredi@redhat.com>
 <20180604084904.GF11333@infradead.org>
 <20180610045657.GM30522@ZenIV.linux.org.uk>
 <CAJfpegtGtAR25qWgpNisvL8F51h3K6s44zkWBSVVbqecut6tBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegtGtAR25qWgpNisvL8F51h3K6s44zkWBSVVbqecut6tBQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 11, 2018 at 09:19:01AM +0200, Miklos Szeredi wrote:
> We don't.  Obviously need to make sure to only ever do ioctl's in
> overlayfs that have a common definition across filesystems.  Not a lot
> of those, luckily...

Which are those?  If they are common and possibly called from kernel
code they should probably be made into methods instead.
