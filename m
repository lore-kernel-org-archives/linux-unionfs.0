From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 07/39] vfs: export vfs_ioctl() to modules
Date: Tue, 19 Jun 2018 16:04:41 +0200
Message-ID: <CAJfpegvxHs+MvC3N2Cbocp0UNrM47_GEUSV+mAx=8VVNDz7r_g@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-8-mszeredi@redhat.com>
 <20180604084904.GF11333@infradead.org> <20180610045657.GM30522@ZenIV.linux.org.uk>
 <CAJfpegtGtAR25qWgpNisvL8F51h3K6s44zkWBSVVbqecut6tBQ@mail.gmail.com> <20180611162412.GA7574@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180611162412.GA7574@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 11, 2018 at 6:24 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 11, 2018 at 09:19:01AM +0200, Miklos Szeredi wrote:
>> We don't.  Obviously need to make sure to only ever do ioctl's in
>> overlayfs that have a common definition across filesystems.  Not a lot
>> of those, luckily...
>
> Which are those?  If they are common and possibly called from kernel
> code they should probably be made into methods instead.

FS_IOC*

Haven't looked deeply.  For now overlayfs just implements
FS_IOC_{GET|SET}FLAGS because some of these flags are quite generic
and implementing them on the overlay is easy.

Yes, turning into a method makes sense.

Thanks,
Miklos
