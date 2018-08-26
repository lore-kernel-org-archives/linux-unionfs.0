MIME-Version: 1.0
In-Reply-To: <1535300717-26686-7-git-send-email-amir73il@gmail.com>
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
	<1535300717-26686-7-git-send-email-amir73il@gmail.com>
Date: Sun, 26 Aug 2018 21:34:18 +0200
Message-ID: <CAJfpegv50HELSZuwt9gGjgSyB+4aPbiTncc-yBNqUVgTLNHaXw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] vfs: fix sync_file_range syscall on an overlayfs file
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Aug 26, 2018 at 6:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> For an overlayfs file/inode, page io is operating on the real underlying
> file, so sync_file_range() should operate on the real underlying file
> mapping to take affect.

The man page tells us that this syscall basically gives no guarantees
at all and shouldn't be used in portable programs.

So, I'd just let the non-functionality be for now.   If someone
complains of a regression (unlikely) we can look into it.

Thanks,
Miklos
