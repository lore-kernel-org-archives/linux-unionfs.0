Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180507174102.24086-25-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com> <20180507174102.24086-25-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 7 May 2018 21:21:42 +0300
Message-ID: <CAOQ4uxivnmtxa8o6=OUyyA3+xaxLSOjFvOmF7fuUirmbGEXd-w@mail.gmail.com>
Subject: Re: [PATCH v15 24/30] ovl: Set redirect on metacopy files upon rename
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Set redirect on metacopy files upon rename. This will help find data dentry
> in lower dirs.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Looks OK.

Thanks,
Amir.
