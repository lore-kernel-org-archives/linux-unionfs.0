From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] vfs: make open_with_fake_path() not contribute to nr_files
Date: Thu, 19 Jul 2018 10:49:59 +0200
Message-ID: <CAJfpegvJOXo-e5swL5iNgiyGOQHT3viz86+NMAe1zvOC0Qwaig@mail.gmail.com>
References: <20180718154637.31878-1-mszeredi@redhat.com> <18289.1531987758@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18289.1531987758@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jul 19, 2018 at 10:09 AM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <mszeredi@redhat.com> wrote:
>
>> Stacking file operations in overlay will store an extra open file for each
>> overlay file opened.
>>
>> The overhead is just that of "struct file" which is about 256bytes, because
>> overlay already pins an extra dentry and inode when the file is open, which
>> add up to a much larger overhead.
>>
>> For fear of breaking working setups, don't start accounting the extra file.
>
> Sounds useful for cachefiles too, though Christoph Hellwig objected strongly
> last time I tried this, so you might want to check with him directly.

What the cachefiles use case would be?

Overlayfs wants the "shadow" file open only as long as the real file
is open.  Is the cachefiles case the same?

For overlays the real cost of pinned memory by open files  is already
sunk in the layered dentry references.  Which means overlayfs is
already pinning substantially more memory for an open file than other
fs (by about a factor of 2-3, due to pinned lower and/or upper
dentries and inodes).   If this was a problem in real life, then we'd
be already be in trouble.  The stacked open file patch only adds the
overhead of the actual struct file, which is small compared to the
multiple pinned dentry and inode structs.

Christoph already commented on a previous version of the patch and I
pointed out the above.

Thanks,
Miklos
