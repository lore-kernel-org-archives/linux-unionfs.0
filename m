From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/39] vfs: add path_open()
Date: Sun, 10 Jun 2018 05:36:17 +0100
Message-ID: <20180610043610.GK30522@ZenIV.linux.org.uk>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-5-mszeredi@redhat.com>
 <20180604084609.GC11333@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180604084609.GC11333@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 04, 2018 at 01:46:09AM -0700, Christoph Hellwig wrote:
> > +EXPORT_SYMBOL(path_open);
> 
> EXPORT_SYMBOL_GPL, please.

	No.

	If interface makes sense, export it.  If it doens't, don't.
Don't mix "it's a shit API, but we need it for some in-kernel module"
with "out-of-tree code should be GPL, especially if it uses this".
For non-trivial work I will, teeth gritting, accept that kind of
stuff.  For anything as trivial as this - fuck, no.

	In this particular case, it *is* a dubious API - AFAICS,
ovl_open_realfile() could just pass vfsmount/dentry from the right
layer to vfs_open().  We might or might not need path_open() for the
duration of the series (I hadn't looked into the PITA it would be
to reorder), but it really looks like it could disappear by the end
of it, along with the temporary export.
