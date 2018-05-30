From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Thu, 31 May 2018 08:27:14 +1000
Message-ID: <20180530222714.GP23861@dastard>
References: <20180529132148.GC23785@veci.piliscsaba.redhat.com>
 <20180529135938.GA5631@infradead.org>
 <CAJfpeguJ+h5A4ALS3=actNH5UMSWF8Fgoo-RLbmfGuDf0tJicA@mail.gmail.com>
 <CAJfpegvCR4+j0t1dzM=Mvh05JBkz4R5A4Jp=USTtGBeWEL6dGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegvCR4+j0t1dzM=Mvh05JBkz4R5A4Jp=USTtGBeWEL6dGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, May 30, 2018 at 10:36:46AM +0200, Miklos Szeredi wrote:
> On Tue, May 29, 2018 at 4:12 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Tue, May 29, 2018 at 3:59 PM, Christoph Hellwig <hch@infradead.org> wrote:
> 
> >>>       vfs: export vfs_dedupe_file_range_one() to modules
> >>
> >> Please use EXPORT_SYMBOL_GPL for all these crazy low-level exports.
> 
> I'd argue with the "crazy" part.  This should have been the primary
> interface from the start.  The batched dedupe interface is the crazy
> one:
> 
>  - deduping is page size granularity at worst; performance would not
> be horrible even if we had to do one syscall per page
>  - vast majority of the time it will be file size granularity
> 
> Why was that batching invented in the first place?

No idea - the batching ioctl interface is what we inherited from the
btrfs ioctl years ago and there are several dedupe applications out
there that use it. That's why we pulled it up to the vfs rather than
invent a new one and have to wait years for apps to start using
it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
