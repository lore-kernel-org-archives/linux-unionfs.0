Return-Path: <jlayton@kernel.org>
Message-ID: <2f6dbf1777ae4b9870c077b8a34c79bf8ed8a554.camel@kernel.org>
Subject: Re: [PATCH] locks: print unsigned ino in /proc/locks
From: Jeff Layton <jlayton@kernel.org>
Date: Sun, 22 Dec 2019 20:17:44 -0500
In-Reply-To: <20191222184528.32687-1-amir73il@gmail.com>
References: <20191222184528.32687-1-amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, 2019-12-22 at 20:45 +0200, Amir Goldstein wrote:
> An ino is unsigned so export it as such in /proc/locks.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Hi Jeff,
> 
> Ran into this while writing tests to verify i_ino == d_ino == st_ino on
> overlayfs. In some configurations (xino=on) overlayfs sets MSB on i_ino,
> so /proc/locks reports negative ino values.
> 
> BTW, the requirement for (i_ino == d_ino) came from nfsd v3 readdirplus.
> 
> Thanks,
> Amir.
> 
>  fs/locks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 6970f55daf54..44b6da032842 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -2853,7 +2853,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
>  	}
>  	if (inode) {
>  		/* userspace relies on this representation of dev_t */
> -		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
> +		seq_printf(f, "%d %02x:%02x:%lu ", fl_pid,
>  				MAJOR(inode->i_sb->s_dev),
>  				MINOR(inode->i_sb->s_dev), inode->i_ino);
>  	} else {

My that is an old bug! I think that goes back to early v2.x days, if not
v1.x. I'll queue it up, and maybe we can get this in for v5.6.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>
