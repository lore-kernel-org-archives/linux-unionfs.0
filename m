MIME-Version: 1.0
In-Reply-To: <1537887462-35160-1-git-send-email-weiyongjun1@huawei.com>
References: <1537887462-35160-1-git-send-email-weiyongjun1@huawei.com>
Date: Mon, 1 Oct 2018 11:26:50 +0200
Message-ID: <CAJfpegtgQhu4Vdz81onOZ32XE_zgUwHvy73eeQ+bRV-5vJhdnQ@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: make symbol 'ovl_aops' static
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Sep 25, 2018 at 4:57 PM, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> Fixes the following sparse warning:
>
> fs/overlayfs/inode.c:507:39: warning:
>  symbol 'ovl_aops' was not declared. Should it be static?
>
> Fixes: 5b910bd615ba ("ovl: fix GPF in swapfile_activate of file from overlayfs over xfs")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.

Thanks,
Miklos
