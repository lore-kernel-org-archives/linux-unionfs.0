Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190608135717.8472-1-amir73il@gmail.com> <20190608135717.8472-2-amir73il@gmail.com>
 <1560343899.4578.9.camel@linux.ibm.com> <CAOQ4uxhooVwtHcDCr4hu+ovzKGUdWfQ+3F3nbgK3HXgV+fUK9w@mail.gmail.com>
 <20190612152927.GE16331@fieldses.org>
In-Reply-To: <20190612152927.GE16331@fieldses.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 12 Jun 2019 18:35:39 +0300
Message-ID: <CAOQ4uxgbzF_e7Z4zQbNp0B51Bh1hjw3c3p=QMk4bFWjOuAjQLA@mail.gmail.com>
Subject: Re: [PATCH 1/2] vfs: replace i_readcount with a biased i_count
Content-Type: text/plain; charset="UTF-8"
To: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@poochiereds.net>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jun 12, 2019 at 6:29 PM J . Bruce Fields <bfields@fieldses.org> wrote:
>
> On Wed, Jun 12, 2019 at 06:09:59PM +0300, Amir Goldstein wrote:
> > But if I am following Miklos' suggestion to make i_count 64bit, inode
> > struct size is going to grow for 32bit arch when  CONFIG_IMA is not
> > defined, so to reduce impact, I will keep i_readcount as a separate
> > member and let it be defined also when BITS_PER_LONG == 64
> > and implement inode_is_open_rdonly() using d_count and i_count
> > when i_readcount is not defined.
>
> How bad would it be just to let the inode be a little bigger?  How big
> is it already on 32 bit architectures?  How much does this change e.g.
> how many inodes you can cache per megabyte?
>

It's hard to answer how tiny changes like this impact users with different
configs, especially to IoT ones, so I do not like increasing size of inode
unconditionally, but I will go with:
-#ifdef CONFIG_IMA
+#if defined(CONFIG_IMA) || defined(CONFIG_FILE_LOCKING)
        atomic_t                i_readcount; /* struct files open RO */
 #endif

So IoT guys can have an option to keep inode size the same
and not let the locks code worry about it.

OK?

Thanks,
Amir.
