From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] vfs: make open_with_fake_path() not contribute to nr_files
Date: Thu, 19 Jul 2018 09:09:18 +0100
Message-ID: <18289.1531987758@warthog.procyon.org.uk>
References: <20180718154637.31878-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718154637.31878-1-mszeredi@redhat.com>
Content-ID: <18288.1531987758.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> wrote:

> Stacking file operations in overlay will store an extra open file for each
> overlay file opened.
> 
> The overhead is just that of "struct file" which is about 256bytes, because
> overlay already pins an extra dentry and inode when the file is open, which
> add up to a much larger overhead.
> 
> For fear of breaking working setups, don't start accounting the extra file.

Sounds useful for cachefiles too, though Christoph Hellwig objected strongly
last time I tried this, so you might want to check with him directly.

David
