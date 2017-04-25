From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 04/11] ovl: store file handle of lower inode on copy up
Date: Tue, 25 Apr 2017 16:53:45 +0200
Message-ID: <CAJfpegt=mVd7kCB2CwX4TDbnaKcHdxMnEfD9eTMHx8ZRNQ0WyA@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com> <1493025256-27188-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1493025256-27188-5-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Apr 24, 2017 at 11:14 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Sometimes it is interesting to know if an upper file is pure
> upper or a copy up target, and if it is a copy up target, it
> may be interesting to find the copy up origin.
>
> This will be used to preserve lower inode numbers across copy up.
>
> Store the lower inode file handle in upper inode xattr overlay.fh
> on copy up to use it later for these cases.
>
> On failure to encode lower file handle, store an invalid 'null'
> handle, so we can always use the overlay.fh xattr to distignuish
> between a copy up and a pure upper inode.
>
> If lower fs does not support NFS export ops or if not all lower
> layers are on the same fs, don't try to encode a lower file handle
> and use the 'null' handle instead.

Decoding fh on wrong fs is going to result in "interesting"
posibilities, so I think we should be storing some kind of identifier
about the layer from the very start.

The trivial way to do that would be to encode the filesystem's UUID
into the stored fh.  Problem seems to be that only ext4 is setting
sb->s_uuid.  Probably not too hard to fix the others.

When decoding, trivial to check in the samefs case, but we'd need a
table for the uuid->layer lookup for the non-samefs case. But that can
wait, I'd be content with just having the infrastructure there and
just using it to verify the handle for now.

Thanks,
Miklos
