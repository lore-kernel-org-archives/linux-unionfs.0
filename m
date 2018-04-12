From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH 01/35] vfs: clean up dedup
Date: Thu, 12 Apr 2018 19:24:00 +0200
Message-ID: <CAJfpegt18KcursBrY23vz8xKst=rbX-g2pU27-9yvfvqf39_Dg@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-2-mszeredi@redhat.com>
 <20180412162500.GA24728@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412162500.GA24728@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Apr 12, 2018 at 6:25 PM, Matthew Wilcox <willy@infradead.org> wrote:
> On Thu, Apr 12, 2018 at 05:07:52PM +0200, Miklos Szeredi wrote:
>> +ssize_t vfs_dedupe_file_range_one(struct file *src_file, u64 src_pos, u64 len,
>> +                           struct file *dst_file, u64 dst_pos)
>
> Why u64 instead of loff_t?

Peculiarity of f_op->dedupe_file_range().

I think a cleanup of copyfile/clone/dedupe interfaces would be good.
Perhaps merge them into one?  Or just merge copyfile/clone?  Even if
not merging it should make sense to make argument types and argument
order the same.

Thanks,
Miklos
