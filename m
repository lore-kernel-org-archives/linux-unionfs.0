From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 15/35] ovl: add ovl_fsync()
Date: Tue, 8 May 2018 08:14:52 +0300
Message-ID: <CAOQ4uxhFzFFpF+ghACKTzzU_UrrJ3_+U6LwCOVXhgUyGe6=fVQ@mail.gmail.com>
References: <20180507083807.28792-1-mszeredi@redhat.com> <20180507083807.28792-16-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507083807.28792-16-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, May 7, 2018 at 11:37 AM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> Implement stacked fsync().
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/file.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index a7af56861aa5..419aa3f9967b 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -233,10 +233,30 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>         return ret;
>  }
>
> +static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
> +{
> +       struct fd real;
> +       const struct cred *old_cred;
> +       int ret;
> +

Don't sync non-upper. same as ovl_dir_fsync()

Thanks,
Amir.
