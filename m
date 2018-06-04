From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 05/39] vfs: optionally don't account file in nr_files
Date: Mon, 4 Jun 2018 10:57:13 +0200
Message-ID: <CAJfpegvRWUBRUNidw7QjVL1NfaoR9O80QUW3SrTevp8isWBtpA@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-6-mszeredi@redhat.com>
 <20180604084739.GD11333@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180604084739.GD11333@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 4, 2018 at 10:47 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, May 29, 2018 at 04:43:05PM +0200, Miklos Szeredi wrote:
>> Stacking file operations in overlay will store an extra open file for each
>> overlay file opened.
>>
>> The overhead is just that of "struct file" which is about 256bytes, because
>> overlay already pins an extra dentry and inode when the file is open, which
>> add up to a much larger overhead.
>
> But that overhead is exactly what nr_files accounts for, so this looks
> bogus to me.

According to comment above  files_maxfiles_init() one open file uses
roughly 1k, which is the total from struct file + pinned dentry +
pinned inode.  The actual struct file is just a quarter of that.

So while overlayfs does currently pin almost 2k per file and,
according to that calculation should already be using two nr_file
slots, it isn't.  And switching to using two slots means current
setups might well have regressions due to that.

I'm not against switching to two slots, but it's something that would
need to come with backward compatibility guarantees (e.g. explicitly
enabled with boot option, or whatever) and I don't think it's worth
the trouble.

Maintaining the two versions  of overlayfs (with and without stacked
fops) also makes little sense.

Thanks,
Miklos
