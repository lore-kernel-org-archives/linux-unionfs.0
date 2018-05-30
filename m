From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Wed, 30 May 2018 10:36:46 +0200
Message-ID: <CAJfpegvCR4+j0t1dzM=Mvh05JBkz4R5A4Jp=USTtGBeWEL6dGQ@mail.gmail.com>
References: <20180529132148.GC23785@veci.piliscsaba.redhat.com>
 <20180529135938.GA5631@infradead.org> <CAJfpeguJ+h5A4ALS3=actNH5UMSWF8Fgoo-RLbmfGuDf0tJicA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpeguJ+h5A4ALS3=actNH5UMSWF8Fgoo-RLbmfGuDf0tJicA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 4:12 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, May 29, 2018 at 3:59 PM, Christoph Hellwig <hch@infradead.org> wrote:

>>>       vfs: export vfs_dedupe_file_range_one() to modules
>>
>> Please use EXPORT_SYMBOL_GPL for all these crazy low-level exports.

I'd argue with the "crazy" part.  This should have been the primary
interface from the start.  The batched dedupe interface is the crazy
one:

 - deduping is page size granularity at worst; performance would not
be horrible even if we had to do one syscall per page
 - vast majority of the time it will be file size granularity

Why was that batching invented in the first place?

Thanks,
Miklos
