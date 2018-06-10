From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 05/39] vfs: optionally don't account file in nr_files
Date: Sun, 10 Jun 2018 05:41:07 +0100
Message-ID: <20180610044050.GL30522@ZenIV.linux.org.uk>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-6-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-6-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:43:05PM +0200, Miklos Szeredi wrote:
> +++ b/fs/open.c
> @@ -732,8 +732,8 @@ static int do_dentry_open(struct file *f,
>  	static const struct file_operations empty_fops = {};
>  	int error;
>  
> -	f->f_mode = OPEN_FMODE(f->f_flags) | FMODE_LSEEK |
> -				FMODE_PREAD | FMODE_PWRITE;
> +	f->f_mode = (f->f_mode & FMODE_NOACCOUNT) | OPEN_FMODE(f->f_flags) |
> +		FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;

Why bother with this complexity?  I mean, why not simply
	f->f_mode |= OPEN_FMODE(f->f_flags) | FMODE_LSEEK |
				FMODE_PREAD | FMODE_PWRITE;

and be done with that...

> @@ -743,7 +743,7 @@ static int do_dentry_open(struct file *f,
>  	f->f_wb_err = filemap_sample_wb_err(f->f_mapping);
>  
>  	if (unlikely(f->f_flags & O_PATH)) {
> -		f->f_mode = FMODE_PATH;
> +		f->f_mode = (f->f_mode & FMODE_NOACCOUNT) | FMODE_PATH;

That makes no sense at all.  What would ever pass O_PATH opens
from "noaccount" call site?
