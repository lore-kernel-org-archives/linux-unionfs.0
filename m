From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 27/39] ovl: obsolete "check_copy_up" module option
Date: Tue, 29 May 2018 18:13:35 +0300
Message-ID: <CAOQ4uxgbj0x+zMn47PiF819+kFE9Byos-KVGiGp7Mp=Gc0N8Wg@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-28-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-28-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 5:43 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> This was provided for debugging the ro/rw inconsistecy.  The inconsitency
> is now gone so this option is obsolete.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/copy_up.c | 30 +++++++-----------------------
>  1 file changed, 7 insertions(+), 23 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index ddaddb4ce4c3..e675e8349e71 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -25,35 +25,20 @@
>
>  #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
>
> -static bool __read_mostly ovl_check_copy_up;
> -module_param_named(check_copy_up, ovl_check_copy_up, bool,
> -                  S_IWUSR | S_IRUGO);
> -MODULE_PARM_DESC(ovl_check_copy_up,
> -                "Warn on copy-up when causing process also has a R/O fd open");
> -
> -static int ovl_check_fd(const void *data, struct file *f, unsigned int fd)
> +static int ovl_ccup_set(const char *buf, const struct kernel_param *param)
>  {
> -       const struct dentry *dentry = data;
> -
> -       if (file_inode(f) == d_inode(dentry))
> -               pr_warn_ratelimited("overlayfs: Warning: Copying up %pD, but open R/O on fd %u which will cease to be coherent [pid=%d %s]\n",
> -                                   f, fd, current->pid, current->comm);
> +       WARN(1, "overlayfs: \"check_copy_up\" module option is obsolete\n");

I was under the impression that user controlled input should not be generating
WARNings... did you mean pr_warm?

Thanks,
Amir.
